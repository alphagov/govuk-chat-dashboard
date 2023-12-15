Rails.application.routes.draw do
  get "written/index"
  get "explore/index"
  devise_for :users
  resources :answers, only: %i[index show]
  root to: "home#index"
end
