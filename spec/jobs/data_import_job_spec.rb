# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataImportJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user, :confirmed) }
  let(:di)   { create(:data_import, user: user, status: :pending) }

  before do
    di.archive.attach(io: StringIO.new("zipbytes"), filename: "import.zip", content_type: "application/zip")
  end

  context "on success" do
    let(:restorer) { instance_double(DataImport::Restorer, call: nil, log_text: "Done (100%)") }

    before { allow(DataImport::Restorer).to receive(:new).and_return(restorer) }

    it "marks complete, records the log, and purges the archive" do
      perform_enqueued_jobs { described_class.perform_now(di.id) }

      di.reload
      expect(di).to be_complete
      expect(di.progress).to eq(100)
      expect(di.log).to include("Done")
      expect(di.archive).not_to be_attached
    end
  end

  context "when the restore fails" do
    let(:restorer) { instance_double(DataImport::Restorer, log_text: "") }

    before do
      allow(DataImport::Restorer).to receive(:new).and_return(restorer)
      allow(restorer).to receive(:call).and_raise(StandardError, "boom")
    end

    it "marks failed without re-raising (no Sidekiq retry) and keeps the archive" do
      expect { described_class.perform_now(di.id) }.not_to raise_error

      di.reload
      expect(di).to be_failed
      expect(di.error_message).to include("boom")
      expect(di.archive).to be_attached
    end
  end

  context "when cancelled mid-run" do
    let(:restorer) { instance_double(DataImport::Restorer, log_text: "") }

    before do
      allow(DataImport::Restorer).to receive(:new).and_return(restorer)
      allow(restorer).to receive(:call).and_raise(DataImport::Restorer::Cancelled, "Import cancelled by user")
    end

    it "marks cancelled without re-raising and keeps the archive" do
      expect { described_class.perform_now(di.id) }.not_to raise_error

      di.reload
      expect(di).to be_cancelled
      expect(di.archive).to be_attached
    end
  end
end
