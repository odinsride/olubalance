FactoryBot.define do
  factory :stash do
    name { "Test Stash" }
    description { "Test Factory for Stashes" }
    goal { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    balance { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    association :account
  end
end
