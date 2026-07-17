# frozen_string_literal: true

class DataImportJob < ApplicationJob
  queue_as :default

  def perform(data_import_id)
    di = DataImport.find(data_import_id)
    di.update!(status: :processing, progress: 0, step: "Preparing", error_message: nil)

    tempfile = Tempfile.new([ "olubalance-import", ".zip" ])
    tempfile.binmode
    di.archive.download { |chunk| tempfile.write(chunk) }
    tempfile.flush

    restorer = DataImport::Restorer.new(user: di.user, zip_path: tempfile.path, data_import: di)
    restorer.call

    di.update!(status: :complete, progress: 100, step: "Done")
    # A successful import no longer needs the (potentially multi-GB) upload —
    # purge it. Failed/cancelled imports keep it so the user can reprocess
    # without re-uploading.
    di.archive.purge_later
  rescue DataImport::Restorer::Cancelled => e
    di&.update_columns(status: "cancelled", step: "Cancelled", error_message: e.message.to_s.first(1000))
    # Swallowed: cancellation is a user action, not a job failure — no retry.
  rescue => e
    # Swallowed (not re-raised): the record already carries the failure, and
    # re-raising would trigger Sidekiq's default 25 retries, each re-downloading
    # the archive. The user reprocesses explicitly instead.
    di&.update_columns(status: "failed", error_message: e.message.to_s.first(1000))
    Rails.logger.error("DataImportJob failed for ##{data_import_id}: #{e.class}: #{e.message}")
  ensure
    # Flush the in-memory import log to the record on every path (success,
    # failure, cancel) — it's accumulated outside the DB transaction so it
    # survives a rollback.
    di&.update_column(:log, restorer.log_text) if defined?(restorer) && restorer
    tempfile&.close
    tempfile&.unlink rescue nil
  end
end
