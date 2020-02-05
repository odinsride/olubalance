FactoryBot.define do
  factory :stash_entry do
    stash_action { "add" }
    stash_entry_date { Date.today }
    amount { "50.00" }
  end
end
