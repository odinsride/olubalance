# frozen_string_literal: true

module TransactionsHelper
  include Pagy::Frontend

  def column_css(column_name)
    return "has-text-white sortable sort-selected" if column_name.to_s == @order_by

    "has-text-white sortable"
  end

  def arrow(column_name)
    return if column_name.to_s != @order_by

    @direction == "desc" ? "fa-sort-down" : "fa-sort-up"
  end

  def direction
    @direction == "asc" ? "desc" : "asc"
  end

  def pagy_get_params(params)
    params.merge query: @query, order_by: @order_by, direction: @direction
  end

end
