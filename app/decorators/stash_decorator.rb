# frozen_string_literal: true

class StashDecorator < ApplicationDecorator
  decorates_finders
  delegate_all
  include Draper::LazyHelpers

  def balance_display
    number_to_currency(balance)
  end

  def goal_display
    number_to_currency(goal)
  end
end
