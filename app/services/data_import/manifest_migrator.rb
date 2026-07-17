# frozen_string_literal: true

# Reopens the DataImport model class as a namespace for the manifest migrator.
# Must be `class` (not `module`) — DataImport is an ActiveRecord class.
class DataImport
  # Upgrades a parsed export manifest from whatever version it was written at up
  # to the current DataExport::Builder::MANIFEST_VERSION, so that archives made
  # by older releases import cleanly into newer ones.
  #
  # Most schema changes need NOTHING here: additive columns that are nullable or
  # carry a DB default are handled automatically (insert_all! omits absent keys
  # and Postgres fills the default), and removed columns are dropped by the
  # Restorer's `columns_only`. This migrator exists for the changes those two
  # mechanisms can't cover — column renames/splits, a new NOT NULL column with
  # no DB default, repurposing a column's meaning, or a change to the
  # `attachments` / `category_ref` descriptor shape.
  #
  # See docs/DATA_TRANSFER_COMPAT.md for the full compatibility contract.
  class ManifestMigrator
    # Ordered registry: STEPS[n] upgrades a version-n manifest to version n+1.
    # Steps run in sequence from the manifest's version up to the current one.
    #
    # There are no steps today (current version is 1). When you bump
    # DataExport::Builder::MANIFEST_VERSION, add the matching step here. Example:
    #
    #   STEPS = {
    #     # v1 -> v2: `memo` was split out of `description`.
    #     1 => lambda do |manifest|
    #       manifest["records"]["transactions"].each do |t|
    #         t["memo"] = t.delete("legacy_note") if t.key?("legacy_note")
    #       end
    #       manifest
    #     end,
    #   }.freeze
    STEPS = {}.freeze

    def initialize(manifest)
      @manifest = manifest
    end

    # Returns the manifest normalized to the current MANIFEST_VERSION. Mutates
    # and restamps `version` as each step is applied.
    def call
      version = @manifest["version"].to_i
      target  = DataExport::Builder::MANIFEST_VERSION

      while version < target
        step = STEPS[version]
        @manifest = step.call(@manifest) if step
        version += 1
        @manifest["version"] = version
      end

      @manifest
    end
  end
end
