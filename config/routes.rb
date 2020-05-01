Rails.application.routes.draw do
  root "welcome#welcome"

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
    end
  end

  put "update_words", to: "words#update_words"
end
