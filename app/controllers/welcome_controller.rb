class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def welcome
    if current_user
      @admin_games = Game
                     .where(user_id: current_user.id)
                     .order(created_at: :desc)


      @player_games = current_user
                        .games.not_finished
                        .order(created_at: :desc)
    else
      @admin_games = []
      @player_games = []
    end
  end
end
