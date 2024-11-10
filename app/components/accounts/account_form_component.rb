# frozen_string_literal: true

class Accounts::AccountFormComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(account:)
    @account = account
  end

  def button_text
    @account.id.present? ? 'Update' : 'Create'
  end
end
