# ==============================================================================
# MAKEFILE CONFIGURATION
# ==============================================================================

# Modern Makefile best practices
.PHONY: help
.DELETE_ON_ERROR:
.ONESHELL:

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# ==============================================================================
# PROJECT CONFIGURATION
# ==============================================================================

# Default goal
.DEFAULT_GOAL := help

# REF: https://github.com/ansible/ansible/issues/76322
# REF: https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos-as-a-controller
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY := YES

# If .env file exists, include the file and export all env vars.
-include .env
.EXPORT_ALL_VARIABLES:

# If .secrets file exists, include the file and export all env vars.
-include .secrets
.EXPORT_ALL_VARIABLES:

# Common CLI arguments for all Ansible commands
ANSIBLE_CLI_ARGS = --timeout 5

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
# TROUBLESHOOTING
# ==============================================================================

ping: ## Test connectivity to all hosts
	@echo "Testing connectivity to all hosts..."
	@ansible all --module-name ansible.builtin.ping --args="data=pong" $(ANSIBLE_CLI_ARGS) # --ask-pass
	@echo "✓ Ping complete"

facts: ## Gather system facts from all hosts
	@echo "Gathering system facts..."
	@ansible all --module-name ansible.builtin.setup --tree /tmp/ansible-facts $(ANSIBLE_CLI_ARGS)
	@echo "✓ Facts complete"

echo: ## Test raw command execution on all hosts
	@echo "Testing raw command execution..."
	@ansible --verbose all --module-name ansible.builtin.raw --args="echo hi" $(ANSIBLE_CLI_ARGS)
	@echo "✓ Raw command complete"

# ==============================================================================
# OPERATIONS
# ==============================================================================

apply: main
main: ## Run main playbook
	@echo "Running main playbook..."
	@ansible-playbook ./main.yml $(ANSIBLE_CLI_ARGS) # --ask-become-pass

# ==============================================================================
# CLEANUP
# ==============================================================================

clean: ## Clean up temporary files and molecule instances
	@echo "Cleaning up..."
	@devenv shell -- bash -c "molecule destroy" || true
	@find . -name "*.retry" -type f -delete 2>/dev/null || true
	@rm -rf .ansible/ 2>/dev/null || true
	@echo "✓ Cleanup complete"
