# frozen_string_literal: true

# Records money added and removed from a stash
class StashEntry < ApplicationRecord
  belongs_to :stash

  validates :stash_entry_date, presence: true
  validates :description, presence: true
  validates :amount, presence: true,
                     numericality: { greater_than_or_equal_to: 0 }
end
