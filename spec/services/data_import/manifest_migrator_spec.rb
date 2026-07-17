# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataImport::ManifestMigrator do
  it "returns a current-version manifest unchanged" do
    manifest = {
      "version" => DataExport::Builder::MANIFEST_VERSION,
      "records" => { "transactions" => [ { "id" => 1 } ] }
    }

    result = described_class.new(manifest).call

    expect(result["version"]).to eq(DataExport::Builder::MANIFEST_VERSION)
    expect(result["records"]["transactions"]).to eq([ { "id" => 1 } ])
  end

  context "with future migration steps registered" do
    before do
      stub_const("DataExport::Builder::MANIFEST_VERSION", 3)
      stub_const("DataImport::ManifestMigrator::STEPS", {
        1 => ->(m) { m["trail"] << "1->2"; m },
        2 => ->(m) { m["trail"] << "2->3"; m }
      })
    end

    it "applies steps in order from v1 up to the current version" do
      result = described_class.new({ "version" => 1, "trail" => [] }).call

      expect(result["trail"]).to eq([ "1->2", "2->3" ])
      expect(result["version"]).to eq(3)
    end

    it "starts from the manifest's own version" do
      result = described_class.new({ "version" => 2, "trail" => [] }).call

      expect(result["trail"]).to eq([ "2->3" ])
      expect(result["version"]).to eq(3)
    end
  end
end
