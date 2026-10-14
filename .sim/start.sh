#!/usr/bin/env bash
cd "$(dirname "$0")/.."
VENV="${VENV:-/Users/satyamdave/Desktop/simulation-labs-targets/oscar-venv}"
export PYTHONPATH="$PWD/src"
exec "$VENV/bin/python" sandbox/manage.py runserver --noreload "127.0.0.1:${PORT:-8000}"
