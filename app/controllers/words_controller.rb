class WordsController < ApplicationController
  def update_words
    words = ActiveSupport::JSON.decode(params[:words])
    game = GameManager.new(slug: params[:game_slug]).game

    turn = game.round
    game.words.where(word: words).each do |word|
      word.update_attributes(hide: true)
      word.send("user_id_#{turn}=", params[:player_id])
      word.save
    end

    render json: { words: "Words Updated!" }
  end
end
