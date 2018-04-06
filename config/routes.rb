Rails.application.routes.draw do
  get 'static_pages/releasenotes'

  devise_for :users
  resources :accounts do
  	resources :transactions
  end
  
  authenticated do
  	root to: "accounts#index"
  end

  root to: "static_pages#home"
end
