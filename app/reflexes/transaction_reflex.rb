# frozen_string_literal: true

# Reflex for Transactions to allow various functionality in the transaction list
class TransactionReflex < ApplicationReflex
  def search
    session[:query] = element[:value].strip
  end

  def search_reset
    session[:query] = ''
  end

  def order
    session[:order_by] = element.dataset['column-name']
    session[:direction] = element.dataset['direction']
  end

  def paginate
    session[:page] = element.dataset[:page].to_i
  end
end
