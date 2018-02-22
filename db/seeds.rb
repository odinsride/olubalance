# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create(name: 'PNC', starting_balance: 5000, current_balance: 5000, user_id: 1)
Account.create(name: 'Chase', starting_balance: 1500, current_balance: 1500, user_id: 1)

Transaction.create(trx_date: 1.days.ago, description: 'DLM', amount: 132.72, account_id: 1)
Transaction.create(trx_date: 2.days.ago, description: 'American Express payment', amount: 100.00, account_id: 1)
Transaction.create(trx_date: 3.days.ago, description: 'Mortgage', amount: 1237.81, account_id: 1)
Transaction.create(trx_date: 4.days.ago, description: 'Time Warner', amount: 50.01, account_id: 1)
Transaction.create(trx_date: 5.days.ago, description: 'Meijer', amount: 22.38, account_id: 1)
Transaction.create(trx_date: 6.days.ago, description: 'Car Payment', amount: 411.00, account_id: 1)

Transaction.create(trx_date: 11.days.ago, description: 'Amazon', amount: 50.40, account_id: 2)
Transaction.create(trx_date: 4.days.ago, description: 'Capital One', amount: 18.83, account_id: 2)
Transaction.create(trx_date: 8.days.ago, description: 'Whole Foods', amount: 48.99, account_id: 2)
Transaction.create(trx_date: 10.days.ago, description: 'Golden Lamb', amount: 55.16, account_id: 2)
Transaction.create(trx_date: 3.days.ago, description: 'BP Gas', amount: 32.44, account_id: 2)
Transaction.create(trx_date: 2.days.ago, description: 'Sheetz', amount: 37.12, account_id: 2)
Transaction.create(trx_date: 1.days.ago, description: 'Corner Store', amount: 10.00, account_id: 2)