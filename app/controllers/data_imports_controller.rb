# frozen_string_literal: true

require "sidekiq/api"

class DataImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_import

  # Re-run the import against the already-uploaded archive (no re-upload).
  def reprocess
    unless @data_import.reprocessable?
      return respond_action("This import can't be reprocessed right now.", alert: true)
    end

    @data_import.update!(
      status: :pending,
      progress: 0,
      step: "Queued",
      error_message: nil,
      log: nil,
      cancel_requested: false
    )
    job = DataImportJob.perform_later(@data_import.id)
    @data_import.update_column(:job_id, job.provider_job_id)

    respond_action("Import re-queued.")
  end

  # Cooperative cancel: flag the record so a running restore rolls back between
  # phases, and best-effort remove the job from the queue if it hasn't started.
  def cancel
    unless @data_import.in_flight?
      return respond_action("This import is not running.", alert: true)
    end

    @data_import.update!(cancel_requested: true)

    if @data_import.pending?
      remove_queued_job(@data_import.job_id)
      @data_import.update!(status: :cancelled, step: "Cancelled")
      respond_action("Import cancelled.")
    else
      # Already processing — the restorer will notice the flag and roll back.
      respond_action("Cancelling — the import will stop shortly.")
    end
  end

  # Purge the uploaded archive and delete the record.
  def destroy
    if @data_import.in_flight?
      return respond_action("Stop the import before deleting its file.", alert: true)
    end

    @data_import.archive.purge if @data_import.archive.attached?
    @data_import.destroy
    @data_import = nil

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "data_import_status",
          partial: "data_transfers/import_frame",
          locals: { data_import: current_user.data_imports.recent.first, src: status_data_transfer_path }
        )
      end
      format.html { redirect_to data_transfer_path, notice: "Import file removed." }
    end
  end

  private

  def set_data_import
    @data_import = current_user.data_imports.find(params[:id])
  end

  # Renders the import frame back into the page and sets a flash. Shared by the
  # reprocess/cancel turbo_stream responses.
  def respond_action(message, alert: false)
    flash.now[alert ? :alert : :notice] = message
    respond_to do |format|
      format.turbo_stream # renders app/views/data_imports/<action>.turbo_stream.erb
      format.html { redirect_to data_transfer_path, (alert ? :alert : :notice) => message }
    end
  end

  # Best-effort removal of a not-yet-started job from the default Sidekiq queue.
  def remove_queued_job(jid)
    return if jid.blank?

    Sidekiq::Queue.new("default").find_job(jid)&.delete
  rescue => e
    Rails.logger.warn("DataImportsController: could not remove queued job #{jid}: #{e.message}")
  end
end
