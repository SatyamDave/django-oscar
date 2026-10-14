#!/usr/bin/env bash
# Build the sandbox data (db, media, search index, assets, SAVE10 voucher) in this checkout.
# Usage: VENV=/path/to/venv .sim/setup.sh
set -euo pipefail
cd "$(dirname "$0")/.."
VENV="${VENV:-/Users/satyamdave/Desktop/simulation-labs-targets/oscar-venv}"
PY="$VENV/bin/python"
export PYTHONPATH="$PWD/src"
M="$PY sandbox/manage.py"

if [ ! -d src/oscar/static ]; then
  npm install --silent
  npm run build
  rm -rf node_modules
fi
rm -rf sandbox/db.sqlite sandbox/public sandbox/whoosh_index
$M migrate -v0
$M loaddata sandbox/fixtures/auth.json
$M loaddata sandbox/fixtures/child_products.json
$M oscar_import_catalogue sandbox/fixtures/*.csv
$M oscar_import_catalogue_images sandbox/fixtures/images.tar.gz
$M oscar_populate_countries --initial-only
$M loaddata sandbox/fixtures/pages.json sandbox/fixtures/ranges.json sandbox/fixtures/offers.json
$M loaddata sandbox/fixtures/orders.json
$M clear_index --noinput
$M update_index catalogue
$M shell < .sim/create_voucher.py
