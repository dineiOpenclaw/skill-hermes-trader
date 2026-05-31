#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <relative-skill-path>" >&2
  echo "Example: $0 tradingview" >&2
  exit 1
fi

PROFILE_SKILLS="${PROFILE_SKILLS:-$HOME/../skills}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_REL="$1"
SRC="$PROFILE_SKILLS/$SKILL_REL"
DST="$REPO_ROOT/skills/$SKILL_REL"

if [[ ! -d "$SRC" ]]; then
  echo "Source skill directory not found: $SRC" >&2
  exit 1
fi

rm -rf "$DST"
mkdir -p "$(dirname "$DST")"
cp -R "$SRC" "$DST"
