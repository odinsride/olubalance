class TransactionsController < ApplicationController
	before_action :find_transaction, only: [:edit, :update, :show, :destroy]

	# Index action to render all transactions
	def index
		@transactions = Transaction.all
	end

	# New action for creating transaction
	def new
		@transaction = Transaction.new
	end

	# Create action saves the trasaction into database
	def create
		@transaction = Transaction.new(transaction_params)
		if @transaction.save(transaction_params)
			flash[:notice] = "Successfully created transaction!"
			redirect_to transaction_path(@transaction)
		else
			flash[:alert] = "Error creating new transaction!"
			render :new
		end
	end

	# Edit action retrieves the transaction and renders the edit page
	def edit
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
end
