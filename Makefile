# ==============================================================================
# MAKEFILE CONFIGURATION
# ==============================================================================

.PHONY: help
.DELETE_ON_ERROR:
.ONESHELL:

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

.DEFAULT_GOAL := help

# ==============================================================================
# CORE TARGETS
# ==============================================================================

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*?##"; printf "Available targets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-25s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# ==============================================================================
# TESTING
# ==============================================================================

test: ## Run full molecule test suite
	@echo "Running molecule test..."
	@devenv shell -- bash -c "molecule test"
	@echo "✓ Molecule test complete"

test-syntax: ## Run molecule syntax check
	@echo "Running molecule syntax check..."
	@devenv shell -- bash -c "molecule syntax"
	@echo "✓ Syntax check complete"

test-create: ## Create molecule instances
	@echo "Creating molecule instances..."
	@devenv shell -- bash -c "molecule create"
	@echo "✓ Instances created"

test-converge: ## Run molecule converge
	@echo "Running molecule converge..."
	@devenv shell -- bash -c "molecule converge"
	@echo "✓ Converge complete"

test-verify: ## Run molecule verify
	@echo "Running molecule verify..."
	@devenv shell -- bash -c "molecule verify"
	@echo "✓ Verify complete"

test-destroy: ## Destroy molecule instances
	@echo "Destroying molecule instances..."
	@devenv shell -- bash -c "molecule destroy"
	@echo "✓ Instances destroyed"

# ==============================================================================
# LINTING
# ==============================================================================

lint: ## Run ansible-lint on role
	@echo "Running ansible-lint..."
	@devenv shell -- bash -c "ansible-lint"
	@echo "✓ Lint complete"

lint-tasks: ## Run ansible-lint on tasks
	@echo "Running ansible-lint on tasks..."
	@devenv shell -- bash -c "ansible-lint tasks/"
	@echo "✓ Tasks lint complete"

lint-yaml: ## Run yamllint on all YAML files
	@echo "Running yamllint..."
	@devenv shell -- bash -c "yamllint ."
	@echo "✓ YAML lint complete"

# ==============================================================================
# CLEANUP
# ==============================================================================

clean: ## Clean up temporary files and molecule instances
	@echo "Cleaning up..."
	@devenv shell -- bash -c "molecule destroy" || true
	@find . -name "*.retry" -type f -delete 2>/dev/null || true
	@rm -rf .ansible/ 2>/dev/null || true
	@echo "✓ Cleanup complete"
