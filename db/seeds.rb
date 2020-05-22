# Objects
users = []
accounts = []
transactions = []

# Seed Lists
trx_type = %w[debit credit]
emails = %w[
  john@gmail.com 
  john2@gmail.com 
  john3@gmail.com
]
account_names = %w[
  Chase 
  PNC 
  Wells\ Fargo 
  BB&T 
  TD\ Bank 
  Capital\ One 
  Bank\ of\ America
]
trx_debit_desc = %w[
  Electric\ Payment
  Gas\ Payment
  Rent
  Mortgage
  Shell
  BP
  Kroger
  Transfer\ to\ Savings
  Gym\ Membership
  Mobile\ Phone\ Payment
  McDonalds
  Subway
  Oil\ Change
  Internet\ Payment
  Car\ Payment
  Food\ Lion
  Movie\ Theater
  Starbucks
  Sunoco
]

trx_credit_desc = %w[
  Paycheck
  Refund
  Transfer\ from\ Savings
]

# Create 3 test accounts
emails.each do |email|
  users << User.create!(
    email: email,
    password: 'topsecret',
    password_confirmation: 'topsecret',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    timezone: 'Eastern Time (US & Canada)'
  )
end

# Create 5 accounts for each user
users.each do |user|
  selected_accounts = []
    
  5.times do

    # Ensure that an account name isn't repeated (unique constraint per user)
    account_name = (account_names - selected_accounts).sample
    selected_accounts << account_name

    account = Account.create!(
      name: account_name,
      last_four: Faker::Number.number(digits: 4).to_i,
      starting_balance: Faker::Number.between(from: 1500.00, to: 20000.00).to_f.round(2),
      user: user
    )

    accounts << account

    # Set the starting balance transaction date to be the first transaction
    t = account.transactions.first
    t.trx_date = 91.days.ago.to_s
    t.save(validate: false)
  end
end

# Create Transactions
accounts.each do |account|
  # Create 100 debit transactions for each Account
  100.times do
    Transaction.create!(
      trx_date: Faker::Date.backward(days: 90),
      description: trx_debit_desc.sample,
      amount: Faker::Number.between(from: 5.00, to: 450.00).to_f.round(2),
      trx_type: 'debit',
      account: account
    )
  end

  # Create 10 credit transactions for each Account
  10.times do
    Transaction.create!(
      trx_date: Faker::Date.backward(days: 90),
      description: trx_credit_desc.sample,
      amount: Faker::Number.between(from: 500.00, to: 2000.00).to_f.round(2),
      trx_type: 'credit',
      account: account
    )
  end

  # Create 2 transactions with attachments for each Account
  2.times do
    t = Transaction.create!(
          trx_date: Faker::Date.backward(days: 1),
          description: trx_debit_desc.sample,
          amount: Faker::Number.between(from: 5.00, to: 500.00).to_f.round(2),
          trx_type: 'debit',
          account: account
        )
    t.attachment.attach(io: File.open('app/assets/images/logo.png'), filename: 'logo.png')
  end

  2.times do
    Transaction.create!(
      trx_date: Faker::Date.backward(days: 15),
      description: trx_debit_desc.sample,
      amount: Faker::Number.between(from: 5.00, to: 100.00).to_f.round(2),
      trx_type: 'debit',
      pending: true,
      account: account
    )
  end
end

# Account.create!(
#   name: Faker::Bank.unique.name.titlecase,
#   last_four: Faker::Number.number(digits: 4).to_i,
#   starting_balance: 3000.00,
#   user_id: 1
# )

# 5.times do
#   t = Transaction.create!(
#         trx_date: Faker::Date.between(from: 10.days.from_now, to: 15.days.from_now),
#         description: Faker::Name.name,
#         amount: Faker::Number.between(from: 0.01, to: 150.00).to_f.round(2),
#         trx_type: trx_type.sample,
#         account_id: 1
#       )
#   t.attachment.attach(io: File.open('app/assets/images/logo.png'), filename: 'logo.png')
# end

# 1000.times do
#   Transaction.create!(
#     trx_date: Faker::Date.forward(days: 10),
#     description: Faker::Name.name,
#     amount: Faker::Number.between(from: 0.01, to: 150.00).to_f.round(2),
#     trx_type: trx_type.sample,
#     account_id: 1
#   )
# end

# 5.times do
#   v = Transaction.create!(
#         trx_date: Faker::Date.between(from: 10.days.from_now, to: 15.days.from_now),
#         description: Faker::Name.name,
#         amount: Faker::Number.between(from: 0.01, to: 150.00).to_f.round(2),
#         trx_type: trx_type.sample,
#         account_id: 1
#       )
#   v.attachment.attach(io: File.open('app/assets/images/logo.png'), filename: 'logo.png')
# end

# 20.times do
#   accounts << Account.create!(
#     name: Faker::Bank.unique.name.titlecase,
#     last_four: Faker::Number.number(digits: 4).to_i,
#     starting_balance: Faker::Number.between(from: 1500.00, to: 9000.00).to_f.round(2),
#     user: users.sample
#   )
# end

# 2000.times do
#   transactions << Transaction.create!(
#     trx_date: Faker::Date.forward(days: 30),
#     description: Faker::Name.name,
#     amount: Faker::Number.between(from: 0.01, to: 250.00).to_f.round(2),
#     trx_type: trx_type.sample,
#     account: accounts.sample
#   )
# end