class WordsController < ApplicationController
  def update_words
    words = ActiveSupport::JSON.decode(params[:words])
    Word.where(word: words).update_all(hide: true)

    render json: { words: "Words Updated!" }
  end
end
