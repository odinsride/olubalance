class Summary
  def initialize(accounts)
    @accounts = accounts
  end

  def accounts_checking
    @accounts.where(account_type: :checking)
  end

  def accounts_savings
    @accounts.where(account_type: :savings)
  end

  def accounts_credit
    @accounts.where(account_type: :credit)
  end

  def checking_total
    accounts_checking.sum(&:current_balance)
  end

  def savings_total
    accounts_savings.sum(&:current_balance)
  end

  def credit_total
    accounts_credit.sum(&:current_balance)
  end

  def credit_limit_total
    accounts_credit.sum(&:credit_limit)
  end

  def credit_utilization_total
    ((credit_total.abs / credit_limit_total) * 100).round(2)
  end
end
