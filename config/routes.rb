Rails.application.routes.draw do
  devise_for :users
  resources :tags
  resources :feedbacks
  resources :chats
  root to: "home#index"
end
