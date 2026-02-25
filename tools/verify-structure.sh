#!/usr/bin/env sh
set -eu

required_paths="
backend
frontend
infra
docs
api
.github
backend/cmd/server/.gitkeep
backend/internal/domain/.gitkeep
backend/internal/service/.gitkeep
backend/internal/adapter/.gitkeep
backend/internal/handler/.gitkeep
backend/migrations/.gitkeep
backend/docs/events/README.md
frontend/README.md
infra/.gitkeep
api/openapi.yaml
Makefile
.env.example
.gitignore
"

missing=""
for path in $required_paths; do
  if [ ! -e "$path" ]; then
    missing="$missing\n$path"
  fi
done

if [ -n "$missing" ]; then
  printf "Missing required paths:%b\n" "$missing"
  exit 1
fi

required_targets="dev test lint build help db-migrate-up db-migrate-down sqlc-generate"
for target in $required_targets; do
  if ! grep -Eq "^$target:.*##" Makefile; then
    echo "Missing Makefile target description: $target"
    exit 1
  fi
done

while IFS= read -r message; do
  if [ -z "$message" ]; then
    continue
  fi
  if ! grep -Fq "$message" Makefile; then
    echo "Missing dependency help text in Makefile: $message"
    exit 1
  fi
done <<'EOF'
docker is required for 'dev'
docker compose is required for 'dev'
golang-migrate CLI is required for 'db-migrate-up'
golang-migrate CLI is required for 'db-migrate-down'
sqlc is required for 'sqlc-generate'
EOF

if ! tr -d '\r' < api/openapi.yaml | grep -Eq '^openapi: 3\.1\.0$'; then
  echo "api/openapi.yaml must declare OpenAPI 3.1.0"
  exit 1
fi

if ! tr -d '\r' < api/openapi.yaml | grep -Eq '^info:$'; then
  echo "api/openapi.yaml must include an info section"
  exit 1
fi

echo "Structure verification passed."
