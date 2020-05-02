class GamesController < ApplicationController

  def new
    @game = Game.new(user_id: current_user.id)
  end

  def create
    @game = Game.new(game_params)
    respond_to do |format|
      if @game.save
        format.html { redirect_to game_path(@game.slug) }
      else
        flash[:notice] = @game.errors.messages
        format.html { render :new }
      end
    end
  end

  def show
    @game = Game
            .includes(:user)
            .joins(:user)
            .includes(:users)
            .left_joins(:users)
            .includes(:words)
            .left_joins(:words)
            .find_by(slug: params[:slug])

    user_words
    @game.word_count.times { @game.words.build } if @user_words.empty?
  end

  def play
    @game = Game
            .includes(:user)
            .joins(:user)
            .includes(:users)
            .left_joins(:users)
            .includes(:words)
            .left_joins(:words)
            .find_by(slug: params[:slug])
  end

  def reset_words_status
    @game = Game.find_by(slug: params[:slug])

    case @game.round
    when "turn_1"
      @game.round = "turn_2"
    when "turn_2"
      @game.round = "turn_3"
    when "turn_3"
      @game.state = "finished"
    end
    @game.save

    @game.words.update_all(hide: false) unless @game.state == "finished"

    if @game.round == "turn_3" && @game.state == "finished"
      redirect_to result_game_path(@game.slug)
    else
      redirect_to play_game_path(@game.slug)
    end
  end

  def update
    @game = Game.find_by(slug: params[:slug])
    respond_to do |format|
      if @game.update(update_params)
        format.html { redirect_to game_path(@game.slug) }
      else
        user_words
        flash[:notice] = @game.errors.messages
        format.html { render :show }
      end
    end
  end

  def create_players
    @game = Game.find_by(slug: params[:slug])
    respond_to do |format|
      if @game.update(player_params)
        format.html { redirect_to game_path(@game.slug) }
      else
        user_words
        flash[:notice] = @game.errors.messages
        format.html { render :show }
      end
    end
  end

  def restart
    @game = Game.find_by(slug: params[:slug])
    @game.update(state: :started)
    redirect_to game_path(@game.slug)
  end

  def result
    @game = Game
           .includes(:user)
           .joins(:user)
           .includes(:users)
           .left_joins(:users)
           .includes(:words)
           .left_joins(:words)
           .find_by(slug: params[:slug])

    @turns_data = []

    @game.users.map do |player|
      p player.name
      turn_data_hash = {}
      turn_data_hash[:player] = player
      turn_data_hash[:score_turn_1] = @game.words.where(user_id_turn_1: player.id).count
      turn_data_hash[:score_turn_2] = @game.words.where(user_id_turn_2: player.id).count
      turn_data_hash[:score_turn_3] = @game.words.where(user_id_turn_3: player.id).count
      turn_data_hash[:total_score] = turn_data_hash[:score_turn_1] + turn_data_hash[:score_turn_2] + turn_data_hash[:score_turn_3]
      @turns_data << turn_data_hash
    end

    @turns_data.sort_by! { |hsh| hsh[:total_score] }.reverse!
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count, :word_count, :user_id, :round)
  end

  def update_params
    params.require(:game).permit(words_attributes: %i[id user_id game_id word hide])
  end

  def player_params
    params.require(:game).permit(game_players_attributes: %i[id user_id game_id _destroy])
  end

  def user_words
    @user_words ||= @game.words.where(user_id: current_user.id, game_id: @game.id)
  end
end
