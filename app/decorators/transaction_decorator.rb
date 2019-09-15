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

  def amount_decorated
    amount.negative? ? number_to_currency(amount.abs) : number_to_currency(amount)
  end

  def amount_color
    amount.negative? ? 'has-text-danger' : 'has-text-success'
  end

  def running_balance_display
    number_to_currency(running_balance)
  end

  def trx_date_decorated
    transaction.pending ? 'PENDING' : trx_date_formatted
  end

  def trx_date_formatted
    trx_date.in_time_zone(current_user.timezone).strftime('%m/%d/%Y')
  end

  def trx_date_form_value
    trx_date.present? ? trx_date_formatted : Time.current.strftime('%m/%d/%Y')
  end
end
