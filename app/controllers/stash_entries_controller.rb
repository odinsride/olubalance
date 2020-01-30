# frozen_string_literal: true

class StashEntriesController < ApplicationController
  before_action :find_stash

  # GET /stashes
  def index
    @stash_entries = @stash.stash_entries.decorate
  end

  # GET /stashes/new
  def new
    @stash_entry = @stash.stash_entry.build.decorate
  end

  # POST /stashes
  def create
    @stash_entry = @stash.stash_entries.build(stash_entry_params).decorate

    if @stash_entry.save
      redirect_to account_stashes_path, notice: 'Stash entry was successfully created.'
    else
      render :new
    end
  end

  # # PATCH/PUT /stashes/1
  # def update
  #   if @stash.update(stash_params)
  #     redirect_to account_stashes_path, notice: 'Stash was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # # DELETE /stashes/1
  # def destroy
  #   @stash.destroy
  #   redirect_to account_stashes_url, notice: 'Stash was successfully destroyed.'
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def find_stash
    @stash = @stashes.find(params[:stash_id]).decorate
    respond_to do |format|
      format.html
    end
  end

  # Only allow a trusted parameter "white list" through.
  def stash_entry_params
    params.require(:stash_entry).permit(:amount, :description, :stash_entry_date)
  end
end
