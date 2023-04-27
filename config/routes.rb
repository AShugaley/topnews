Rails.application.routes.draw do
  devise_for :users
  root to: 'stories#index'

  resources :stories, only: [:index] do
    member do
      post :upvote
    end
  end

  get 'upvoted_stories', to: 'stories#upvoted', as: :upvoted_stories
  resources :users, only: [:show]
end
