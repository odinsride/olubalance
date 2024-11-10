# frozen_string_literal: true

class Accounts::AccountListComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(accounts:)
    @accounts = accounts
  end
end
