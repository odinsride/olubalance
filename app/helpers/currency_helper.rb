# frozen_string_literal: true

module CurrencyHelper
  # convert decimal to currency
  def currency(number)
    number_to_currency(number, unit: '$', separator: '.', delimiter: ',')
  end

  # display a number with 2 decimal places
  def decimal(number)
    number_with_precision(number, precision: 2)
  end

  # convert transaction amount to absolute value
  def currency_abs(number)
    currency(number.abs)
  end

  # return red or green class name based on amount
  def currency_color(number)
    number.negative? ? 'text-danger-700' : 'text-accent-600'
  end
end
