# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[show edit update destroy activate deactivate transfer]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_user.accounts.where(active: true).order('created_at ASC')
    @accounts = @accounts.decorate
  end

  def inactive
    @inactiveaccounts = current_user.accounts.where(active: false).order('created_at ASC')
    @inactiveaccounts = @inactiveaccounts.decorate
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = current_user.accounts.build.decorate
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = current_user.accounts.build(account_params).decorate

    if @account.save
      redirect_to accounts_path, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    redirect_to accounts_url, notice: 'Account was successfully deleted.'
  end

  # Sets account active field to false
  def deactivate
    @account.active = false

    if @account.save
      redirect_to accounts_path, notice: 'Account was deactivated.'
    else
      render :show
    end
  end

  # Sets account active field to true
  def activate
    @account.active = true

    if @account.save
      redirect_to accounts_path, notice: 'Account was activated.'
    else
      render :show
    end
  end

  # Transfer to another account - creates appropriate transaction records for each account
  def transfer
    puts 'Source Account ' + @account.name
    puts 'Target Account '
    puts 'Amount         '

    redirect_to account_transactions_path(@account), notice: 'Transfer successful.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = current_user.accounts.find(params[:id]).decorate
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:name, :starting_balance, :current_balance, :last_four, :active, :user_id)
  end
end
