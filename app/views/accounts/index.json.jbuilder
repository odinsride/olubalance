# frozen_string_literal: true

json.array! @accounts, partial: 'accounts/account', as: :account
