FactoryBot.define do
  factory :stash_entry do
    stash_action { "add" }
    stash_entry_date { Date.today }
    amount { "50.00" }
    association :stash_entry

    trait :remove_from_stash do
      stash_action { "remove" }
    end    
  end
end
