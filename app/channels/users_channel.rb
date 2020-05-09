class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{params[:id]}"
  end
end
