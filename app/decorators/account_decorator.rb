# frozen_string_literal: true

class AccountDecorator < Draper::Decorator
  decorates_finders
  decorates_association :user
  delegate_all
  include Draper::LazyHelpers

  def account_name
    last_four.present? ? name + ' ( ... ' + last_four.to_s + ')' : name
  end

  def last_four_display
    last_four.present? ? 'xx' + last_four.to_s : nil
  end

  def current_balance_display
    number_to_currency(current_balance)
  end

  def updated_at_display
    updated_at.in_time_zone(current_user.timezone).strftime('%b %d, %Y @ %I:%M %p %Z')
  end

  def balance_class
    if current_balance >= 0
      'text-muted'
    else
      'red-text'
    end
  end

  def noaccounts_partial
    render partial: 'noaccounts', locals: { description: NO_ACCOUNT_DESC } if @accounts.empty?
  end
end
