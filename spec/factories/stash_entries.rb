FactoryBot.define do
  factory :stash_entry do
    stash_entry_date { Date.today }
    description { "Stash funded" }
    amount { "100.00" }
  end
end
