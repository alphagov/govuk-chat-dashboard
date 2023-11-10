Rails.application.routes.draw do
  get 'answers/show'
  get 'written/index'
  get 'explore/index'
  devise_for :users
  resources :tags
  resources :feedbacks
  resources :chats
  root to: "home#index"
end
