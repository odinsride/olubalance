# frozen_string_literal: true

module TransactionsHelper
  include Pagy::Frontend

  def column_css(column_name)
    return 'has-text-white sortable sort-selected' if column_name.to_s == @order_by

    'has-text-white sortable'
  end

  def arrow(column_name)
    return 'fa-sort' if column_name.to_s != @order_by

    @direction == 'desc' ? 'fa-sort-down' : 'fa-sort-up'
  end

  def direction
    @direction == 'asc' ? 'desc' : 'asc'
  end

  def sort_link(column:, label:)
    direction = column == params[:column] ? next_direction : 'asc'
    link_to(account_transactions_path(column: column, direction: direction), class: column_css(column), data: { turbo_action: 'replace'}) do
      ('<span class="sortable-column-name">' + label + '</span>').html_safe
    end
  end

  def next_direction
    params[:direction] == 'asc' ? 'desc' : 'asc'
  end

  # def pagy_massage_params(params)
  #   params.merge query: @query, order_by: @order_by, direction: @direction
  # end

  def prev_page
    @pagy.prev || 1
  end

  def next_page
    @pagy.next || @pagy.last
  end
end
