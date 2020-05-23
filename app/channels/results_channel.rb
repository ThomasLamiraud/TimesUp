class ResultsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_#{params[:slug]}"
  end
end
