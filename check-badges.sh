#!/usr/bin/env bash
set -euo pipefail

# Prints public achievement slugs visible on a GitHub profile.
if [[ "${1:-}" == "--self-test" ]]; then
  sample='data-achievement-slug="yolo" data-achievement-slug="pull-shark"'
  got=$(printf '%s\n' "$sample" | grep -oE 'data-achievement-slug="[a-z0-9-]+"' | cut -d'"' -f2 | paste -sd, -)
  [[ "$got" == "yolo,pull-shark" ]]
  echo "self-test passed"
  exit 0
fi

user="${1:-VhalennnG}"
if [[ ! "$user" =~ ^[a-zA-Z0-9-]+$ ]]; then
  echo "invalid GitHub username: $user" >&2
  exit 1
fi

html=$(curl -fsSL "https://github.com/${user}?tab=achievements")
slugs=$(printf '%s\n' "$html" | grep -oE 'data-achievement-slug="[a-z0-9-]+"' | cut -d'"' -f2 | sort -u || true)

if [[ -z "$slugs" ]]; then
  echo "No public achievements found for ${user}."
else
  echo "Achievements for ${user}:"
  printf ' - %s\n' $slugs
fi
