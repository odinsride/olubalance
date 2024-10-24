# frozen_string_literal: true

module TransactionsHelper
  include Pagy::Frontend

  def sort_link(column:, label:)
    direction = column == session['filters']['column'] ? next_direction : 'asc'
    link_to(account_transactions_path(column: column, direction: direction), class: 'has-text-white sortable', data: { turbo_action: 'replace'}) do
      ('<span class="sortable-column-name">' + label + '</span>').html_safe
    end
  end

  def next_direction
    session['filters']['direction'] == 'asc' ? 'desc' : 'asc'
  end

  def sort_indicator
    icon = session['filters']['direction'] == 'asc' ? 'fa-sort-up' : 'fa-sort-down'
    ('<span class="icon is-small" style="display: inline-table">' +
      '<i class="fas ' + icon + '"></i>' +
    '</span>').html_safe
  end

  def sort_indicator_default
    ('<span class="icon is-small" style="display: inline-table">' +
      '<i class="fas fa-sort"></i>' +
    '</span>').html_safe
  end

  def show_sort_indicator_for(column)
    return sort_indicator if session['filters']['column'] == column

    sort_indicator_default
  end
end
