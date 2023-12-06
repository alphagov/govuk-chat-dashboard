Rails.application.routes.draw do
  get 'written/index'
  get 'explore/index'
  devise_for :users
  resources :tags, except: [:new, :edit], defaults: { format: :json }
  resources :feedbacks, only: [:create]
  resources :chats, only: [:create]
  resources :answers, only: [:index, :show]
  root to: "home#index"
end
