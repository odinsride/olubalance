# frozen_string_literal: true

class TransactionDecorator < ApplicationDecorator
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

  def amount_form
    amount.present? ? number_with_precision(amount.abs, precision: 2) : nil
  end

  def amount_color
    amount.negative? ? 'has-text-danger' : 'has-text-success'
  end

  # Used to specify default value of Transaction type on form
  def trx_type_credit_form
    amount.present? ? amount.positive? : false
  end

  def trx_type_debit_form
    amount.present? ? amount.negative? : false
  end
  ###

  def memo_decorated
    memo? ? memo : '- None -'
  end

  def filename_size
    attachment.attached? ? attachment.filename.to_s + ' (' + number_to_human_size(attachment.byte_size).to_s + ')' : nil
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

  def created_at_decorated
    created_at.in_time_zone(current_user.timezone).strftime('%b %d, %Y @ %I:%M %p %Z')
  end
end
