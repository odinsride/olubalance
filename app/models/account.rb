class Account < ApplicationRecord
	has_many :transactions, dependent: :destroy
end
