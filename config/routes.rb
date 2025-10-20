Rails.application.routes.draw do
  devise_for :users
  root to: 'stories#index'

  resources :stories, only: [:index] do
    member do
      post :upvote
      post :downvote
    end
  end

  get 'upvoted_stories', to: 'stories#upvoted', as: :upvoted_stories
  post 'refresh_stories', to: 'stories#refresh', as: :refresh_stories
  resources :users, only: [:show]
end
