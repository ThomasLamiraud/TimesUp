class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def welcome
    @user_games = Game.where(user_id: current_user.id) if current_user
  end
end
