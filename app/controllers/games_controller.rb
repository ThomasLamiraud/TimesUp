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

    @user_words = current_user.words.where(game_id: @game.id)
  end

  def update
    @game = Game.find_by(slug: params[:slug])
    respond_to do |format|
      if @game.update(update_params)
        format.html { redirect_to game_path(@game.slug) }
      else
        @user_words = current_user.words.where(game_id: @game.id)
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
        @user_words = current_user.words.where(game_id: @game.id)
        flash[:notice] = @game.errors.messages
        format.html { render :show }
      end
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count, :word_count, :user_id)
  end

  def update_params
    params.require(:game).permit(words_attributes: %i[id user_id game_id word])
  end

  def player_params
    params.require(:game).permit(game_players_attributes: %i[id user_id game_id _destroy])
  end
end
