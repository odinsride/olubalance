# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get 'accounts/inactive' => 'accounts#inactive'

  resources :accounts do
    resources :transactions
    resources :stashes do
      member do
        get :add_to_stash
      end
    end

    member do
      get :deactivate
      get :activate
    end
  end

  authenticated do
    root to: 'accounts#index', as: :authenticated_root
  end

  root to: 'static_pages#home'
end
