class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(user_params)
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to login_path, flash.now[:notice] =  { name: ["doesn't exist"] }
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
