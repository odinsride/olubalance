# frozen_string_literal: true

class TransactionDecorator < Draper::Decorator
  decorates_finders
  decorates_association :transaction_balance
  delegate_all
  include Draper::LazyHelpers

  def debit
    amount.negative? ? number_to_currency(amount.abs) : '&nbsp;'.html_safe
  end

  def credit
    amount.positive? ? number_to_currency(amount) : '&nbsp;'.html_safe
  end

  def amount_color
    amount.negative? ? 'has-text-danger' : 'has-text-success'
  end

  def running_balance_display
    number_to_currency(running_balance)
  end
end
