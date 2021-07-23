# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  get 'accounts/inactive' => 'accounts#inactive'
  get 'accounts/summary' => 'summary#index'

  resources :accounts, except: %i[show] do
    resources :transactions
    resources :stashes do
      scope except: %i[index show edit update destroy] do
        resources :stash_entries
      end
    end

    member do
      get :deactivate
      get :activate
    end
  end

  resources :transfers, only: %i[create]

  authenticated do
    root to: 'accounts#index', as: :authenticated_root
  end

  root to: 'static_pages#home'
end
