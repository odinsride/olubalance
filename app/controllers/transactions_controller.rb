class TransactionsController < ApplicationController
	before_action :find_account
	before_action :find_transaction, only: [:edit, :update, :show, :destroy]

	# Index action to render all transactions
	def index
		@transactions = account.transactions
	end

	# New action for creating transaction
	def new
		@transaction = account.transactions.build

		respond_to do |format|
	      format.html # new.html.erb
	      format.xml  { render :xml => @transaction }
	    end
	end

	# Create action saves the trasaction into database
	def create
		@transaction = account.transactions.create(transaction_params)

		respond_to do |format|
			if @transaction.save
				format.html { redirect_to([@transaction.account, @transaction], :notice => 'Transaction was successfully created.'
        		format.xml  { render :xml => @transaction, :status => :created, :location => [@transaction.account, @transaction] }
			else
				format.html { render :action => "new" }
        		format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
			end
		end
	end

	# Edit action retrieves the transaction and renders the edit page
	def edit
		@transaction = account.transactions.find(params[:id])
	end

	  # Update action updates the transaction with the new information
	def update
		if @transaction.update_attributes(transaction_params)
		  flash[:notice] = "Successfully updated transaction!"
		  redirect_to transaction_path(@transaction)
		else
		  flash[:alert] = "Error updating transaction!"
		  render :edit
		end
	end

	# The show action renders the individual transaction after retrieving the the id
	def show
	end

	# The destroy action removes the transaction permanently from the database
	def destroy
		if @transaction.destroy
		  flash[:notice] = "Successfully deleted transaction!"
		  redirect_to transactions_path
		else
		  flash[:alert] = "Error updating transaction!"
		end
	end

	private

	def transaction_params
		params.require(:transaction).permit(:trx_date, :description, :amount)
	end

	def find_transaction
		@transaction = Transaction.find(params[:id])
	end

	def find_account
		@account = Account.find(params[:account_id])
	end
end
