# frozen_string_literal: true

class DataImport < ApplicationRecord
  belongs_to :user
  has_one_attached :archive

  enum :status, {
    pending: "pending",
    processing: "processing",
    complete: "complete",
    failed: "failed",
    cancelled: "cancelled"
  }

  scope :recent, -> { order(created_at: :desc) }
  scope :in_flight, -> { where(status: %w[pending processing]) }

  # True while the import is queued or running.
  def in_flight?
    pending? || processing?
  end

  # True while a fresh import can be started/reprocessed from this record.
  def reprocessable?
    archive.attached? && !in_flight?
  end
end
