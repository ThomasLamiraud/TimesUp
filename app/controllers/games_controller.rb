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
    @game = Game.find_by(slug: params[:slug])
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count, :word_count, :user_id)
  end
end
