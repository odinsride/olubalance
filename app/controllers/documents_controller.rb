# frozen_string_literal: true

class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account
  before_action :find_document, only: %i[edit update show destroy]

  # Index action to render all documents
  def index
    @documents = @account.documents.desc

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @documents }
    end
  end

  # New action for creating documents
  def new
    @document = @account.documents.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @document }
    end
  end

  # Create action saves the document into database
  def create
    @document = @account.documents.build(document_params)

    if @document.save
      redirect_to account_documents_path, notice: 'Document was successfully created.'
    else
      render action: 'new'
    end
  end

  # Edit action retrieves the document and renders the edit page
  def edit
  end

  # Update action updates the document with the new information
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to account_documents_path, notice: 'Document was successfully updated.' }
        format.xml { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml { render xml: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # The destroy action removes the document permanently from the database
  def destroy
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(account_documents_url) }
      format.xml { head :ok }
    end
  end

  private

  def document_params
    params.require(:document) \
          .permit(:document_date, :document_type, :file, :file_file_name)
  end

  def find_account
    @account = current_user.accounts.find(params[:account_id])
    respond_to do |format|
      if !@account.active?
        format.html { redirect_to accounts_inactive_path, notice: 'Account is inactive' }
      else
        format.html
      end
    end
  end

  def find_document
    @document = @account.documents.find(params[:id])
  end
end
