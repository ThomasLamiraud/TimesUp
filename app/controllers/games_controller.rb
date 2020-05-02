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
    @game = game_manager.game
    user_words
    @game.word_count.times { @game.words.build } if @user_words.empty?
  end

  def play
    @game = game_manager.game
  end

  def reset_words_status
    game_manager.update_turn

    game = game_manager.game
    game.words.update_all(hide: false) unless game.state == "finished"

    redirect_to result_game_path(game.slug)
  end

  def update
    @game = game_manager.game
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
    @game = game_manager.game
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
    game_manager.restart_game
    redirect_to game_path(game_manager.game.slug)
  end

  def result
    @game = game_manager.game
    @turns_data = game_manager.turns_data
  end

  def update_score
    ActionCable.server.broadcast "game_#{params[:slug]}", turns_data: game_manager.turns_data
    head :ok
  end

  private

  def game_manager
    @game_manager ||= GameManager.new(slug: params[:slug])
  end

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
