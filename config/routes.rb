Rails.application.routes.draw do
  devise_for :users
  resources :accounts do
  	resources :transactions
  end
  
  root to: "accounts#index"

end
