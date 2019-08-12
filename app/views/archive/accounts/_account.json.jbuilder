# frozen_string_literal: true

json.extract! account, :id, :name, :starting_balance, :current_balance, :created_at, :updated_at
json.url account_url(account, format: :json)
