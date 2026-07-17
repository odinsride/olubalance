# frozen_string_literal: true

require "rails_helper"

# End-to-end proof of the import path the direct-upload UI drives: the browser
# uploads the file and hands the controller an ActiveStorage *signed_id* (not
# raw multipart bytes). This spec builds a real archive carrying a legacy
# Paperclip column, attaches it by signed_id exactly as the JS does, runs the
# job inline, and asserts the data lands — i.e. the reported crash is gone.
RSpec.describe "Import via direct-upload signed_id", type: :request do
  include ActiveJob::TestHelper

  let(:source) { create(:user, :confirmed) }
  let(:importer) { create(:user, :confirmed) }

  def legacy_archive_signed_id_for(user)
    export = create(:data_export, user: user)
    tempfile = DataExport::Builder.new(user: user, data_export: export).call
    tempfile.rewind
    path = "#{Dir.mktmpdir}/export.zip"
    File.binwrite(path, tempfile.read)
    tempfile.close

    # Inject the legacy column that broke production imports.
    manifest = nil
    Zip::File.open(path) do |zip|
      manifest = JSON.parse(zip.find_entry("manifest.json").get_input_stream.read)
    end
    manifest["records"]["transactions"].each { |t| t["attachment_file_name"] = "legacy.jpg" }
    Zip::File.open(path) do |zip|
      zip.get_output_stream("manifest.json") { |o| o.write(JSON.generate(manifest)) }
    end

    blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open(path, "rb"), filename: "export.zip", content_type: "application/zip"
    )
    blob.signed_id
  end

  it "restores the data and marks the import complete" do
    account = create(:account, user: source, name: "Main Checking")
    create(:transaction, :non_pending, account: account, description: "Coffee", amount: BigDecimal("4.50"))
    signed_id = legacy_archive_signed_id_for(source)

    sign_in importer

    perform_enqueued_jobs do
      post import_data_transfer_path, params: { confirm_email: importer.email, archive: signed_id }
    end

    di = importer.data_imports.order(:created_at).last
    expect(di).to be_complete
    expect(importer.accounts.pluck(:name)).to include("Main Checking")
    expect(Transaction.joins(:account).where(accounts: { user_id: importer.id })
                      .find_by(description: "Coffee")).to be_present
    # successful import purges the (potentially huge) uploaded archive
    expect(di.reload.archive).not_to be_attached
  end
end
