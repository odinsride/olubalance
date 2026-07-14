# GitHub Actions Setup

This directory contains the GitHub Actions workflows for CI, staging deployment, and self-hosting image publication.

## Workflow: Test and Deploy to Staging (`.github/workflows/test-and-deploy.yml`)

1. **Trigger**: Runs only on **pushes to `develop`**. It does *not* run on pull requests or other branches.
2. **`test` job**: Boots a `postgres:17` service container, sets up Ruby 3.4.8 (`bundler-cache: true`) and Node 24 (`cache: yarn`), installs `libpq-dev`, runs `bundle install` + `yarn install`, builds assets (`yarn build:css`, `yarn build`), runs `bundle exec rails db:reset` against the test DB, then `bundle exec rspec`.
3. **`deploy` job**: Runs only `if: github.ref == 'refs/heads/develop' && github.event_name == 'push'`, and only after `test` succeeds (`needs: test`). Deploys to the Dokku staging server via `dokku/github-action@v1.0.0`.
4. Both jobs run under the `stage` GitHub Environment — secrets below must be set on that environment (or at the repo level if the environment doesn't override them).

### Required secrets (`stage` environment)

| Secret | Used by | Purpose |
| --- | --- | --- |
| `SECRET_KEY_BASE` | `test` job | Rails secret key base for the test environment (this app uses Figaro for app secrets, not Rails credentials, so there is no `RAILS_MASTER_KEY` secret here). |
| `DOKKU_GIT_REMOTE_URL` | `deploy` job | Git remote URL for the Dokku app (e.g. `ssh://dokku@<host>/<app-name>`). |
| `DOKKU_SSH_PRIVATE_KEY` | `deploy` job | SSH private key authorized on the Dokku server for deployment. |
| `DOKKU_SSH_HOST_KEY` | `deploy` job | Host key(s) for the Dokku server, used to populate `known_hosts` (get via `ssh-keyscan -H <host>`). |

### Setting up GitHub secrets

1. Go to the GitHub repository → Settings → Environments → `stage` (create it if it doesn't exist).
2. Add each secret above under that environment's secrets.
3. Repository Settings → Secrets and variables → Actions can also hold repo-level secrets, but anything referenced above should live on the `stage` environment so it's scoped to staging deploys.

### Workflow behavior

- **Pull requests**: no workflow runs at all (no CI on PRs currently).
- **Pushes to `develop`**: runs tests, and if they pass, deploys to Dokku staging.
- **Other branches**: no action taken.

### Troubleshooting

**Tests failing**
- Check that `SECRET_KEY_BASE` is set on the `stage` environment.
- Verify the Postgres service container is healthy (health check: `pg_isready`, 5 retries).
- Check `bundle exec rails db:reset` output — schema is loaded from `db/structure.sql`, not `schema.rb`.

**Deployment failing**
- Verify `DOKKU_GIT_REMOTE_URL`, `DOKKU_SSH_PRIVATE_KEY`, and `DOKKU_SSH_HOST_KEY` are correctly set.
- Confirm the target Dokku app exists and the SSH key is authorized on the server.
- The `deploy` job only runs after `test` passes — a red `test` job means `deploy` never fires.

## Workflow: Build and publish self-hosting image (`.github/workflows/build-image.yml`)

1. **Trigger**: runs on pushes of version tags matching `v*` (e.g. `v1.13.2`), or manually via `workflow_dispatch`.
2. Builds the Dockerfile at the repo root with Docker Buildx (`linux/amd64` only) and pushes to **GitHub Container Registry** (`ghcr.io/${{ github.repository }}`, i.e. `ghcr.io/olumentary/olubalance`).
3. Auth is via the built-in `GITHUB_TOKEN` (`packages: write` permission) — no extra secrets required.
4. Tags are derived by `docker/metadata-action`:
   - `type=semver,pattern={{version}}` — full version, e.g. `1.13.2`
   - `type=semver,pattern={{major}}.{{minor}}` — e.g. `1.13`
   - `type=sha` — commit SHA
   - `latest` — only applied when the trigger was a `v*` tag push (not on manual `workflow_dispatch` runs without a tag)
5. Uses GitHub Actions cache (`cache-from`/`cache-to: type=gha`) to speed up repeated builds.
6. This image is what `docker-compose.yml` and self-hosted deployments pull by default (`OLUBALANCE_IMAGE`, see `docs/SELF_HOSTING.md`) — cutting a `vX.Y.Z` tag is what ships a new self-hosting release.

### Troubleshooting

- **Push denied / auth failure**: confirm the workflow's `packages: write` permission hasn't been overridden by a stricter repo-level default (Settings → Actions → General → Workflow permissions).
- **Image not picked up by self-hosters**: only tag pushes produce the `latest` tag; a manual `workflow_dispatch` run without a corresponding tag only publishes the `sha`-tagged image.
