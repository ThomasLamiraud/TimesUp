class WordsController < ApplicationController
  def update_words
    words = ActiveSupport::JSON.decode(params[:words])
    game = Game
           .includes(:user)
           .joins(:user)
           .includes(:users)
           .left_joins(:users)
           .includes(:words)
           .left_joins(:words)
           .find_by(slug: params[:game_slug])

    turn = game.round
    game.words.where(word: words).each do |word|
      word.update_attributes(hide: true)
      word.send("user_id_#{turn}=", params[:player_id])
      word.save
    end

    render json: { words: "Words Updated!" }
  end
end
