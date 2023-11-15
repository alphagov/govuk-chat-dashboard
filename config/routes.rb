Rails.application.routes.draw do
  get 'written/index'
  get 'explore/index'
  devise_for :users
  resources :tags
  resources :feedbacks
  resources :chats
  resources :answers
  root to: "home#index"
end
