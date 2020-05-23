Rails.application.routes.draw do
  root "welcome#welcome"

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  get '/signup', to: "registrations#new"
  post '/signup', to: "registrations#create"

  get 'login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  get "help", to: "more_infos#help"

  resources :games, param: :slug do
    member do
      put :create_players
      get :play
      get :reset_words_status
      get :result
      get :restart
    end
  end

  put "update_words", to: "words#update_words"
  put "broadcast_score_table", to: "games#broadcast_score_table"
end
