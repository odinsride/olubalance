# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = []
accounts = []
transactions = []
trx_type = %w[debit credit]

users << User.create!(
  email: 'john@gmail.com',
  password: 'topsecret',
  password_confirmation: 'topsecret',
  first_name: 'John',
  last_name: 'Smith',
  timezone: 'Eastern Time (US & Canada)'
)

# 3.times do
#   users << User.create(
#     email: Faker::Internet.unique.free_email,
#     password: 'topsecret',
#     password_confirmation: 'topsecret',
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     timezone: 'Eastern Time (US & Canada)'
#   )
# end

Account.create!(
  name: Faker::Bank.unique.name.titlecase,
  last_four: Faker::Number.number(digits: 4).to_i,
  starting_balance: 3000.00,
  user_id: 1
)

5.times do
  t = Transaction.create!(
        trx_date: Faker::Date.between(from: 10.days.from_now, to: 15.days.from_now),
        description: Faker::Name.name,
        amount: Faker::Number.between(from: 0.01, to: 150.00).to_f.round(2),
        trx_type: trx_type.sample,
        account_id: 1
      )
  t.attachment.attach(io: File.open('app/assets/images/logo.png'), filename: 'logo.png')
end

1000.times do
  Transaction.create!(
    trx_date: Faker::Date.forward(days: 10),
    description: Faker::Name.name,
    amount: Faker::Number.between(from: 0.01, to: 150.00).to_f.round(2),
    trx_type: trx_type.sample,
    account_id: 1
  )
end

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