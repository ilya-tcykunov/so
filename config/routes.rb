Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :questions do
    resources :answers
  end

  concern :commentable do
    resources :comments
  end

  resources :questions, :answers, concerns: :commentable

  resources :votings, only: :create
  # post 'votings/up', to: 'votings#up', as: :votings_up
  # post 'votings/down', to: 'votings#down', as: :votings_down

  root 'questions#index'
end