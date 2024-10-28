FactoryBot.define do
  factory :stash_entry do
    stash_action { "add" }
    stash_entry_date { Date.today }
    amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :stash

    trait :remove do
      stash_action { "remove" }
    end    
  end
end
