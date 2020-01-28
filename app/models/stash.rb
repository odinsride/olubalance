# frozen_string_literal: true

# Stashes can be used to set money aside within an account
class Stash < ApplicationRecord
  belongs_to :account

  validates :name, presence: true,
                   length: { maximum: 50, minimum: 2 },
                   uniqueness: { scope: :account_id }

  validates :goal, presence: true,
                   numericality: { greater_than_or_equal_to: 0 }

  attr_accessor :amount
end
