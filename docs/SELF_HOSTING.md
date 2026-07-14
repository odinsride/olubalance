# Self-Hosting olubalance

Run olubalance on your own hardware with Docker Compose. The stack is four containers —
the Rails web app, a Sidekiq worker (background + scheduled jobs), PostgreSQL, and Redis —
plus optional MinIO for S3-style object storage.

## Requirements

- Docker + the Docker Compose plugin (`docker compose`).
- The published image, pulled from GitHub Container Registry: `ghcr.io/olumentary/olubalance`.
  This is a **private** package, so the host must be authenticated to pull it (see below).

## Quick start

```bash
# 1. Get the compose files
git clone https://github.com/olumentary/olubalance.git
cd olubalance

# 2. Create your environment file
cp .env.sample .env

# 3. Generate secrets and set the required values in .env
openssl rand -hex 64   # paste into SECRET_KEY_BASE
#   Generate the three ActiveRecord encryption keys — run this three times,
#   pasting one value into each ACTIVE_RECORD_ENCRYPTION_* var in .env:
openssl rand -hex 32
#   also set: OLUBALANCE_DATABASE_PASSWORD, ADMIN_EMAIL, ADMIN_PASSWORD, APP_HOST

# 4. Authenticate to ghcr (private image) and start
echo $GHCR_PAT | docker login ghcr.io -u <your-github-username> --password-stdin
docker compose up -d
```

`GHCR_PAT` is a GitHub personal access token with the `read:packages` scope. A
**classic** token with that scope is simplest; a **fine-grained** token also works but
must additionally be granted access to the `olumentary` org's packages. If `docker
compose pull` / `up` fails with `denied` or `unauthorized`, the login didn't take or the
token lacks `read:packages` — re-run the `docker login` above and confirm the scope.

> Prefer `db:encryption:init`? `docker compose run --rm --no-deps web ./bin/rails
> db:encryption:init` prints a YAML block; map its `primary_key`, `deterministic_key`,
> and `key_derivation_salt` to the three `ACTIVE_RECORD_ENCRYPTION_*` vars respectively.

Then open `http://<host>:3000` and sign in with the `ADMIN_EMAIL` / `ADMIN_PASSWORD`
you set. Create any additional users from the admin UI at `/admin` — self-hosted
instances have public sign-up disabled, and admin-created users are auto-confirmed (with
`SELF_HOST_SKIP_CONFIRMATION=true`), so no email server or CAPTCHA setup is required to
add users.

## How it works

- **Database**: PostgreSQL 17 in the `db` container; data persists on the host at
  `$OLUBALANCE_DATA_DIR/postgres` (bind-mounted to `/var/lib/postgresql/data`).
  On first boot the web container runs `db:prepare` (loads the schema, including the
  `pg_trgm` extension and the `transaction_balances` view) and then `self_host:bootstrap_admin`.
- **Background jobs**: the `worker` container runs Sidekiq. Two scheduled jobs
  (monthly interest sweep, data-export cleanup) load automatically via sidekiq-cron.
  Redis backs the job queue, the Rails cache, and ActionCable.
- **Users**: public sign-up is disabled. The first admin is created from `ADMIN_*` env
  vars; that admin creates everyone else at `/admin`. With `SELF_HOST_SKIP_CONFIRMATION=true`,
  new users are auto-confirmed so no SMTP server is required.

## Data directories

All persisted state lives on the host under `OLUBALANCE_DATA_DIR` (default `./data`,
relative to `docker-compose.yml`), as plain bind-mounted directories rather than named
Docker volumes — easy to locate, back up, or point at a different disk/NAS path:

```
$OLUBALANCE_DATA_DIR/
├── postgres/   # PostgreSQL data files (all financial data)
├── redis/      # job queue / cron state (not critical; safe to recreate)
└── storage/    # uploaded attachments — only used when STORAGE_SERVICE=local
```

Compose creates these directories automatically on first `up` if they don't exist. The
`postgres` and `redis` official images run as root initially and fix ownership of their
data directory themselves, but the `web`/`worker` containers run as a **non-root user
(uid 1000)** — if you pre-create `storage/` yourself (e.g. to seed it or set permissions
ahead of time), make sure it's writable by uid 1000:

```bash
mkdir -p data/storage
chown -R 1000:1000 data/storage
```

To relocate data (e.g. to a NAS mount or a different disk on unraid), set
`OLUBALANCE_DATA_DIR=/absolute/path` in `.env` before the first `docker compose up -d`,
or stop the stack, move the directory tree, update `.env`, and start it again.

## Storage (attachments)

By default attachments (receipts, data export/import archives) are stored on **local disk**
in `$OLUBALANCE_DATA_DIR/storage`, bind-mounted into both the `web` and `worker` containers
(`STORAGE_SERVICE=local`). This is the simplest option — just back up that directory.

To use S3-compatible object storage instead (e.g. the bundled MinIO service or a remote
bucket), uncomment the `minio` service in `docker-compose.yml`, set `STORAGE_SERVICE=linode`
in `.env`, and fill in the `LINODE_*` vars (`LINODE_ENDPOINT=http://minio:9000`). Create the
bucket before uploading.

## TLS / HTTPS

Defaults are HTTP-friendly for LAN use (`FORCE_SSL=false`, `ASSUME_SSL=false`). If you put
the app behind a TLS-terminating reverse proxy (Nginx Proxy Manager, Traefik, Caddy), set
both `FORCE_SSL=true` and `ASSUME_SSL=true` in `.env` so secure cookies and HTTPS redirects
behave correctly.

## Email (optional)

Without SMTP, admin-created users still work (auto-confirmed) but password-reset and summary
emails won't send. To enable email, set the `MAILER_*` vars in `.env`.

## Running on unraid

Use the **Compose Manager** plugin (Docker Compose), not the unraid app store:

1. Add your ghcr credentials so unraid can pull the private image: in unraid's Docker
   settings, add a registry login with **Registry URL** `ghcr.io`, **Username** your
   GitHub username, and **Password** a PAT that has the `read:packages` scope. If pulls
   fail with `denied`/`unauthorized`, the PAT is missing that scope (or, for fine-grained
   tokens, access to the `olumentary` org's packages).
2. Create a new compose stack and paste the contents of `docker-compose.yml`.
3. Provide the `.env` contents alongside the stack (Compose Manager supports a per-stack
   env file). Set `OLUBALANCE_DATA_DIR` to an appdata path, e.g.
   `/mnt/user/appdata/olubalance`, so persisted data lands under unraid's normal
   appdata share instead of `./data` next to the compose file.
4. Bring the stack up. Browse to `http://<unraid-ip>:3000`.

## Backups

Persist and back up the directories under `$OLUBALANCE_DATA_DIR` (see
[Data directories](#data-directories)):

- `postgres/` — the PostgreSQL database (all financial data).
- `storage/` — uploaded attachments (only when `STORAGE_SERVICE=local`).
- `redis/` — job/cron state (not critical; can be recreated).

Also back up your **`.env` file**, and treat the three `ACTIVE_RECORD_ENCRYPTION_*` keys as
irreplaceable: they decrypt sensitive columns (2FA secrets). If they're lost or changed,
that encrypted data can no longer be read.

For a portable database dump (the `db` container already ships `pg_dump`):

```bash
# Back up
docker compose exec db pg_dump -U "$OLUBALANCE_DATABASE_USERNAME" \
  olubalance_production > olubalance-$(date +%F).sql

# Restore into a fresh stack (db must be up, database empty)
cat olubalance-YYYY-MM-DD.sql | docker compose exec -T db \
  psql -U "$OLUBALANCE_DATABASE_USERNAME" -d olubalance_production
```

## Upgrading

```bash
docker compose pull
docker compose up -d
```

The web container re-runs `db:prepare` on boot, applying any new migrations idempotently.
Pin a specific version with `OLUBALANCE_IMAGE=ghcr.io/olumentary/olubalance:1.13.2` in `.env`
if you prefer controlled upgrades over `:latest`.
