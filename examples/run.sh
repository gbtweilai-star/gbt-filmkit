#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_filmkit info
PYTHONPATH=src python -m gbt_filmkit check --payload '{}'
PYTHONPATH=src python -m gbt_filmkit run   --payload '{}'
