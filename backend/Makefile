SHELL := /bin/sh
.DEFAULT_GOAL := help

.PHONY: help test lint

help: ## Show backend-local targets
	@printf "Backend targets:\n"
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

test: ## Placeholder for backend tests (Story 2.1+)
	@echo "Backend tests will be wired in Story 2.1+."

lint: ## Placeholder for backend linting (Story 2.1+)
	@echo "Backend linting will be wired in Story 2.1+."
