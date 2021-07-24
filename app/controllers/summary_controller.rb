class SummaryController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts.where(active: true).order('created_at ASC')

    @accounts_checking = @accounts.where(account_type: :checking)
    @accounts_savings = @accounts.where(account_type: :savings)
    @accounts_credit = @accounts.where(account_type: :credit)

    @checking_total = @accounts_checking.sum(:current_balance)
    @savings_total = @accounts_savings.sum(:current_balance)

    @credit_total = @accounts_credit.sum(:current_balance)
    @credit_limit_total = @accounts_credit.sum(:credit_limit)
    @credit_utilization_total = ((@credit_total.abs / @credit_limit_total) * 100).round(2)

    @accounts_checking = @accounts_checking.decorate
    @accounts_savings = @accounts_savings.decorate
    @accounts_credit = @accounts_credit.decorate
    @accounts = @accounts.decorate


  end
end
