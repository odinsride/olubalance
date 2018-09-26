class TransactionsController < ApplicationController
	before_action :authenticate_user!
	before_action :find_account
	before_action :find_transaction, only: [:edit, :update, :show, :destroy]

	# Index action to render all transactions
	def index
		@transactions = @account.transactions.with_balance.desc.paginate(page: params[:page], per_page: 12)
		@custom_paginate_renderer = custom_paginate_renderer

		respond_to do |format|
    		format.html # index.html.erb
      		format.xml  { render :xml => @transactions }
    	end
	end

	# New action for creating transaction
	def new
		@transaction = @account.transactions.build

		respond_to do |format|
	      format.html # new.html.erb
	      format.xml  { render :xml => @transaction }
	    end
	end

	# Create action saves the trasaction into database
	def create
		@transaction = @account.transactions.build(transaction_params)

		respond_to do |format|
			if @transaction.save
				format.html { redirect_to account_transactions_path, :notice => 'Transaction was successfully created.' }
        		format.xml  { render :xml => @transaction, :status => :created, :location => [@transaction.account, @transaction] }
			else
				format.html { render :action => "new" }
        		format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
			end
		end
	end

	# Edit action retrieves the transaction and renders the edit page
	def edit
	end

	  # Update action updates the transaction with the new information
	def update
	    respond_to do |format|
			if @transaction.update_attributes(transaction_params)
			  	format.html { redirect_to account_transactions_path, :notice => 'Transaction was successfully updated.' }
        		format.xml  { head :ok }
			else
			  	format.html { render :action => "edit" }
        		format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
			end
		end
	end

	# The show action renders the individual transaction after retrieving the the id
	def show
		respond_to do |format|
	    	format.html # show.html.erb
	      	format.xml  { render :xml => @transaction }
	    end
	end

	# The destroy action removes the transaction permanently from the database
	def destroy
		@transaction.destroy

		respond_to do |format|
			format.html { redirect_to(account_transactions_url) }
      		format.xml  { head :ok }
		end
	end

	private

	def transaction_params
		params.require(:transaction).permit(:trx_date, :description, :amount, :trx_type, :memo, :attachment, :attachment_file_name)
	end

	def find_account
		@account = current_user.accounts.find(params[:account_id])
		respond_to do |format|
			if !@account.active?
				format.html { redirect_to accounts_inactive_path, :notice => 'Account is inactive' }
			else
				format.html
			end
		end
	end

	def find_transaction
		@transaction = @account.transactions.find(params[:id])
	end
end
