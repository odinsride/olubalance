# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  get 'accounts/inactive' => 'accounts#inactive'

  resources :accounts do
    resources :transactions
    resources :stashes do
      scope except: %i[index show edit update destroy] do
        resources :stash_entries
      end
    end

    member do
      get :deactivate
      get :activate
      get :transfer
    end
  end

  authenticated do
    root to: 'accounts#index', as: :authenticated_root
  end

  root to: 'static_pages#home'
end
