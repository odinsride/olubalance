# frozen_string_literal: true

class StashEntryDecorator < ApplicationDecorator
  decorates_finders
  delegate_all
  include Draper::LazyHelpers

  def stash_action_capitalize
    stash_action.capitalize
  end

  def amount_decorated
    amount.negative? ? number_to_currency(amount.abs) : number_to_currency(amount)
  end

  def amount_color
    amount.negative? ? "has-text-danger" : "has-text-success"
  end

  def stash_entry_date_formatted
    stash_entry_date.in_time_zone(current_user.timezone).strftime("%m/%d/%Y")
  end

  def form_title
    if stash_action == "add"
      "Add to " + stash.name + " Stash"
    else
      "Remove from " + stash.name + " Stash"
    end
  end
end
