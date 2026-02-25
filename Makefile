SHELL := /bin/sh
.DEFAULT_GOAL := help

.PHONY: help dev dev-down dev-reset test lint build db-migrate-up db-migrate-down sqlc-generate api-generate

help: ## Show available targets and descriptions
	@printf "Available targets:\n"
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dev: ## Start local development services
	@command -v docker >/dev/null 2>&1 || { echo "Error: docker is required for 'dev'. Install Docker Desktop or Docker Engine."; exit 1; }
	@docker compose version >/dev/null 2>&1 || { echo "Error: docker compose is required for 'dev'. Install Docker Compose v2."; exit 1; }
	@if [ ! -f docker-compose.yml ]; then \
		echo "Error: docker-compose.yml was not found at repo root. It is introduced in Story 1.3."; \
		exit 1; \
	fi
	@docker compose up -d
	@echo "Development services started."

dev-down: ## Stop local development services
	@command -v docker >/dev/null 2>&1 || { echo "Error: docker is required for 'dev-down'. Install Docker Desktop or Docker Engine."; exit 1; }
	@docker compose version >/dev/null 2>&1 || { echo "Error: docker compose is required for 'dev-down'. Install Docker Compose v2."; exit 1; }
	@if [ ! -f docker-compose.yml ]; then \
		echo "Error: docker-compose.yml was not found at repo root. It is introduced in Story 1.3."; \
		exit 1; \
	fi
	@docker compose down
	@echo "Development services stopped."

dev-reset: ## Reset local development services and volumes
	@command -v docker >/dev/null 2>&1 || { echo "Error: docker is required for 'dev-reset'. Install Docker Desktop or Docker Engine."; exit 1; }
	@docker compose version >/dev/null 2>&1 || { echo "Error: docker compose is required for 'dev-reset'. Install Docker Compose v2."; exit 1; }
	@if [ ! -f docker-compose.yml ]; then \
		echo "Error: docker-compose.yml was not found at repo root. It is introduced in Story 1.3."; \
		exit 1; \
	fi
	@docker compose down -v
	@docker compose up -d
	@echo "Development services reset."

test: ## Run repository structure verification checks
	@sh ./tools/verify-structure.sh

lint: ## Run lint checks
	@echo "No lint tooling is configured yet. This target will be wired in upcoming stories."

build: ## Build project artifacts
	@echo "No build artifacts are configured yet. This target will be wired in upcoming stories."

db-migrate-up: ## Apply database migrations
	@command -v migrate >/dev/null 2>&1 || { echo "Error: golang-migrate CLI is required for 'db-migrate-up'. Install from https://github.com/golang-migrate/migrate."; exit 1; }
	@[ -n "$$DATABASE_URL" ] || { echo "Error: DATABASE_URL is not set. Export it or copy values from .env.example."; exit 1; }
	@migrate -path backend/migrations -database "$$DATABASE_URL" up

db-migrate-down: ## Roll back the most recent database migration
	@command -v migrate >/dev/null 2>&1 || { echo "Error: golang-migrate CLI is required for 'db-migrate-down'. Install from https://github.com/golang-migrate/migrate."; exit 1; }
	@[ -n "$$DATABASE_URL" ] || { echo "Error: DATABASE_URL is not set. Export it or copy values from .env.example."; exit 1; }
	@migrate -path backend/migrations -database "$$DATABASE_URL" down 1

sqlc-generate: ## Generate Go code from sqlc queries
	@command -v sqlc >/dev/null 2>&1 || { echo "Error: sqlc is required for 'sqlc-generate'. Install from https://docs.sqlc.dev/en/latest/overview/install.html."; exit 1; }
	@if [ ! -f backend/sqlc.yaml ]; then \
		echo "Error: backend/sqlc.yaml not found. sqlc setup is planned for Story 2.4."; \
		exit 1; \
	fi
	@sqlc generate -f backend/sqlc.yaml

api-generate: ## Placeholder for API code generation (Story 2.6)
	@echo "API code generation will be implemented in Story 2.6."
