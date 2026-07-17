# frozen_string_literal: true

require "rails_helper"

# Guards the promise that an export produced by an OLDER release keeps importing
# into this (newer) one. See docs/DATA_TRANSFER_COMPAT.md.
RSpec.describe "DataImport backward compatibility", type: :service do
  let(:source) { create(:user, :confirmed) }
  let(:target) { create(:user, :confirmed) }

  # Packages a manifest hash + {zip_path => bytes} attachment map into a zip,
  # mirroring what DataExport::Builder writes.
  def build_zip(manifest, attachments = {})
    path = "#{Dir.mktmpdir}/archive.zip"
    Zip::OutputStream.open(path) do |zip|
      zip.put_next_entry("manifest.json")
      zip.write(JSON.generate(manifest))
      attachments.each do |zip_path, bytes|
        zip.put_next_entry(zip_path)
        zip.write(bytes)
      end
    end
    path
  end

  def export_manifest_and_attachments(user)
    export = create(:data_export, user: user)
    tempfile = DataExport::Builder.new(user: user, data_export: export).call
    tempfile.rewind
    path = "#{Dir.mktmpdir}/export.zip"
    File.binwrite(path, tempfile.read)
    tempfile.close

    manifest = nil
    attachments = {}
    Zip::File.open(path) do |zip|
      zip.each do |entry|
        if entry.name == "manifest.json"
          manifest = JSON.parse(entry.get_input_stream.read)
        else
          attachments[entry.name] = entry.get_input_stream.read
        end
      end
    end
    [ manifest, attachments ]
  end

  it "imports an export that predates now-defaulted columns (keys simply absent)" do
    account = create(:account, user: source, name: "Main Checking", starting_balance: BigDecimal("100"))
    create(:transaction, :non_pending, account: account, description: "Coffee", amount: BigDecimal("4.50"))

    manifest, attachments = export_manifest_and_attachments(source)

    # Simulate an archive written before `accounts.active` / `transactions.locked`
    # existed: the keys are missing entirely from every record.
    manifest["records"]["accounts"].each { |a| a.delete("active") }
    manifest["records"]["transactions"].each { |t| t.delete("locked") }

    zip = build_zip(manifest, attachments)

    expect {
      DataImport::Restorer.new(user: target, zip_path: zip).call
    }.not_to raise_error

    new_account = target.accounts.find_by(name: "Main Checking")
    expect(new_account.active).to be true # DB default applied for the absent column

    new_txn = Transaction.joins(:account).where(accounts: { user_id: target.id })
                         .find_by(description: "Coffee")
    expect(new_txn.locked).to be false # DB default applied for the absent column
  end

  it "imports a frozen v1 export fixture into the current schema" do
    dir = Rails.root.join("spec/fixtures/data_transfer/v1")
    manifest = JSON.parse(File.read(dir.join("manifest.json")))

    attachments = {}
    Dir.glob(dir.join("attachments/**/*")).each do |file|
      next unless File.file?(file)
      rel = Pathname.new(file).relative_path_from(dir).to_s
      attachments[rel] = File.binread(file)
    end

    zip = build_zip(manifest, attachments)

    expect {
      DataImport::Restorer.new(user: target, zip_path: zip).call
    }.not_to raise_error

    expect(target.accounts.pluck(:name)).to include("Fixture Checking")

    new_txn = Transaction.joins(:account).where(accounts: { user_id: target.id })
                         .find_by(description: "Fixture Coffee")
    expect(new_txn).to be_present
    expect(new_txn.attachments.count).to eq(1)
    expect(new_txn.attachments.first.download).to eq("fixture-receipt-bytes")
  end
end
