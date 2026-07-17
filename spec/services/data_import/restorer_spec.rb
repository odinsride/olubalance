# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataImport::Restorer, type: :service do
  let(:source) { create(:user, :confirmed) }
  let(:target) { create(:user, :confirmed) }

  def build_zip_for(user)
    export = create(:data_export, user: user)
    tempfile = DataExport::Builder.new(user: user, data_export: export).call
    tempfile.rewind
    path = "#{Dir.mktmpdir}/export.zip"
    File.binwrite(path, tempfile.read)
    tempfile.close
    path
  end

  # Rewrites manifest.json inside the zip, yielding each transaction record so
  # the test can mutate it (e.g. inject legacy columns that a real production
  # export would carry but the current schema has dropped).
  def rewrite_transactions(zip_path)
    manifest = nil
    Zip::File.open(zip_path) do |zip|
      manifest = JSON.parse(zip.find_entry("manifest.json").get_input_stream.read)
    end
    manifest["records"]["transactions"].each { |t| yield t }
    Zip::File.open(zip_path) do |zip|
      zip.get_output_stream("manifest.json") { |o| o.write(JSON.generate(manifest)) }
    end
  end

  # Rewrites manifest.json, yielding the whole manifest hash for mutation.
  def rewrite_manifest(zip_path)
    manifest = nil
    Zip::File.open(zip_path) do |zip|
      manifest = JSON.parse(zip.find_entry("manifest.json").get_input_stream.read)
    end
    yield manifest
    Zip::File.open(zip_path) do |zip|
      zip.get_output_stream("manifest.json") { |o| o.write(JSON.generate(manifest)) }
    end
  end

  it "rejects an archive created by a newer app version" do
    create(:account, user: source, name: "Main")
    zip_path = build_zip_for(source)
    rewrite_manifest(zip_path) { |m| m["version"] = DataExport::Builder::MANIFEST_VERSION + 1 }

    expect {
      described_class.new(user: target, zip_path: zip_path).call
    }.to raise_error(described_class::InvalidManifestError, /newer version/)
  end

  it "accepts an archive at the current supported version" do
    create(:account, user: source, name: "Main")
    zip_path = build_zip_for(source)

    expect {
      described_class.new(user: target, zip_path: zip_path).call
    }.not_to raise_error
    expect(target.accounts.pluck(:name)).to eq([ "Main" ])
  end

  it "ignores legacy Paperclip columns that no longer exist on Transaction" do
    account = create(:account, user: source, name: "Main")
    src_txn = create(:transaction, :non_pending, account: account,
                                                  description: "Coffee", amount: BigDecimal("4.50"))

    zip_path = build_zip_for(source)
    rewrite_transactions(zip_path) do |t|
      t["attachment_file_name"]    = "old_receipt.jpg"
      t["attachment_content_type"] = "image/jpeg"
      t["attachment_file_size"]    = 1234
      t["attachment_updated_at"]   = "2020-01-01T00:00:00Z"
    end

    expect {
      described_class.new(user: target, zip_path: zip_path).call
    }.not_to raise_error

    new_txn = Transaction.joins(:account)
                         .where(accounts: { user_id: target.id })
                         .find_by(description: "Coffee")
    expect(new_txn).to be_present
    expect(new_txn.amount).to eq(src_txn.reload.amount)
  end

  it "aborts and rolls back when cancellation is requested, leaving existing data intact" do
    create(:account, user: source, name: "Fresh Account", starting_balance: BigDecimal("100"))
    zip_path = build_zip_for(source)

    # target has pre-existing data that a normal import would wipe
    existing = create(:account, user: target, name: "Keep Me")

    data_import = create(:data_import, user: target, cancel_requested: true)

    expect {
      described_class.new(user: target, zip_path: zip_path, data_import: data_import).call
    }.to raise_error(described_class::Cancelled)

    # the wipe never happened — the cancel fired before "Deleting existing data"
    expect(Account.where(id: existing.id)).to exist
    expect(target.accounts.pluck(:name)).to eq([ "Keep Me" ])
  end
end
