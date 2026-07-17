# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DataImports management", type: :request do
  include ActiveJob::TestHelper

  let(:user) { create(:user, :confirmed) }

  before { sign_in user }

  def with_archive(data_import)
    data_import.archive.attach(io: StringIO.new("zip"), filename: "import.zip", content_type: "application/zip")
    data_import
  end

  def turbo_headers
    { "Accept" => "text/vnd.turbo-stream.html" }
  end

  describe "POST /data_imports/:id/reprocess" do
    it "re-enqueues the job for a failed import with an attached archive" do
      di = with_archive(create(:data_import, :failed, user: user))

      expect {
        post reprocess_data_import_path(di), headers: turbo_headers
      }.to have_enqueued_job(DataImportJob)

      expect(di.reload).to be_pending
      expect(di.error_message).to be_nil
    end

    it "refuses to reprocess while an import is in flight" do
      di = with_archive(create(:data_import, user: user, status: :processing))

      expect {
        post reprocess_data_import_path(di), headers: turbo_headers
      }.not_to have_enqueued_job(DataImportJob)

      expect(di.reload).to be_processing
    end

    it "returns 404 for another user's import" do
      other = with_archive(create(:data_import, :failed, user: create(:user, :confirmed)))

      post reprocess_data_import_path(other), headers: turbo_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /data_imports/:id/cancel" do
    it "flags a processing import for cooperative cancellation" do
      di = with_archive(create(:data_import, user: user, status: :processing))

      post cancel_data_import_path(di), headers: turbo_headers

      expect(di.reload.cancel_requested).to be true
    end

    it "cancels a pending import immediately" do
      di = with_archive(create(:data_import, user: user, status: :pending))

      post cancel_data_import_path(di), headers: turbo_headers

      expect(di.reload).to be_cancelled
    end
  end

  describe "DELETE /data_imports/:id" do
    it "purges the archive and destroys a failed import" do
      di = with_archive(create(:data_import, :failed, user: user))

      expect {
        delete data_import_path(di), headers: turbo_headers
      }.to change { DataImport.where(id: di.id).count }.from(1).to(0)
    end

    it "refuses to delete while in flight" do
      di = with_archive(create(:data_import, user: user, status: :processing))

      delete data_import_path(di), headers: turbo_headers

      expect(DataImport.where(id: di.id)).to exist
    end

    it "returns 404 for another user's import" do
      other = with_archive(create(:data_import, :failed, user: create(:user, :confirmed)))

      delete data_import_path(other), headers: turbo_headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
