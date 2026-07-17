# Data transfer: import/export compatibility contract

Export/import is a critical feature. An archive produced by an **older** release
must keep importing cleanly into a **newer** release. This document is the
contract every future schema change must follow to preserve that guarantee.

## How it works

- **Export** (`app/services/data_export/builder.rb`) writes a `manifest.json`
  stamped with `MANIFEST_VERSION` and serializes every DB column of each record
  verbatim (`record.attributes.as_json`), plus attachment descriptors.
- **Import** (`app/services/data_import/restorer.rb`):
  1. `read_manifest!` accepts any version in
     `MIN_SUPPORTED_VERSION..MANIFEST_VERSION`. A **newer** archive is rejected
     ("update the app before importing"); a too-old one is rejected too.
  2. `DataImport::ManifestMigrator` upgrades the parsed manifest from its
     version up to the current one.
  3. Rows are inserted with `insert_all!`. Each row is first passed through
     `columns_only(model, row)`, which drops any key that isn't a real column.

`MANIFEST_VERSION` lives in `DataExport::Builder` and is the single source of
truth for both sides.

## What is safe automatically (no version bump)

- **Add a column** — as long as it is **nullable** or has a **DB-level
  default**. `insert_all!` omits keys absent from an old row hash, so Postgres
  fills the default. (A model/application default is NOT enough — `insert_all!`
  bypasses Active Record defaults and callbacks.)
- **Remove a column** — old archives still carry it; `columns_only` drops it.
- **Add a new table / record type** — old manifests simply omit it, and the
  restorer only imports record types it knows about.

## What requires a `ManifestMigrator` step + a `MANIFEST_VERSION` bump

- Adding a **`NOT NULL` column with no DB default**.
- **Renaming or splitting** a column.
- **Repurposing** an existing column's meaning.
- Changing the shape of the `attachments` or `category_ref` descriptors.

To do it:
1. Bump `MANIFEST_VERSION` in `DataExport::Builder`.
2. Add the matching step to `DataImport::ManifestMigrator::STEPS`
   (`STEPS[old_version] = ->(manifest){ … }`), which rewrites old manifests into
   the new shape.

## The guardrail

`spec/services/data_import/backward_compatibility_spec.rb` imports a frozen
version-1 fixture and a real export with a column stripped out. If a schema
change breaks old imports, these specs fail — that's the signal to add a DB
default or a migrator step before shipping.
