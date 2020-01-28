# frozen_string_literal: true

# Stashes can be used to set money aside within an account
class Stash < ApplicationRecord
  belongs_to :account
  has_many :stash_entries

  validates :name, presence: true,
                   length: { maximum: 50, minimum: 2 },
                   uniqueness: { scope: :account_id }

  validates :goal, presence: true,
                   numericality: { greater_than_or_equal_to: 0 }

end
