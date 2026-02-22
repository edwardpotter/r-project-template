# =============================================================================
# Makefile — Common Dev Commands
#
# Usage:
#   make build       — Build the Docker image
#   make up          — Start containers (detached)
#   make r           — Open an interactive R session in the container
#   make shiny       — Run the Shiny app
#   make test        — Run testthat tests
#   make lint        — Lint R code with lintr
#   make snapshot    — Snapshot renv lockfile
#   make down        — Stop and remove containers
#   make clean       — Remove containers, volumes, and images
#   make smoke-test  — Run the full template example pipeline
#   make clean-example — Remove all template_example files
# =============================================================================

COMPOSE_PROJECT_NAME ?= r-project
export COMPOSE_PROJECT_NAME

# -- Docker -------------------------------------------------------------------

.PHONY: build up down clean

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

clean:
	docker compose down -v --rmi local

# -- R Sessions ---------------------------------------------------------------

.PHONY: r shiny

## Open interactive R console inside the container
r:
	docker compose run --rm --service-ports r-dev R

## Run the Shiny app (accessible at http://localhost:3838)
## Uses template_example_app.R by default; change APP_DIR for your own app
APP_DIR ?= /project/R/shiny
APP_FILE ?= template_example_app.R

shiny:
	docker compose run --rm --service-ports r-dev \
		R -e "shiny::runApp('$(APP_DIR)/$(APP_FILE)', host='0.0.0.0', port=3838)"

# -- Code Quality -------------------------------------------------------------

.PHONY: test lint

## Run all tests
test:
	docker compose run --rm r-dev Rscript tests/testthat.R

## Lint R files with lintr
lint:
	docker compose run --rm r-dev \
		R -e "lintr::lint_dir('R')"

# -- renv ---------------------------------------------------------------------

.PHONY: snapshot restore install

## Snapshot current packages to renv.lock
snapshot:
	docker compose run --rm r-dev \
		R -e "renv::snapshot(prompt = FALSE)"

## Restore packages from renv.lock
restore:
	docker compose run --rm r-dev \
		R -e "renv::restore(prompt = FALSE)"

## Install a package (usage: make install PKG=dplyr)
install:
	docker compose run --rm r-dev \
		R -e "renv::install('$(PKG)'); renv::snapshot(prompt = FALSE)"

# -- Scripts ------------------------------------------------------------------

.PHONY: run

## Run an analysis script (usage: make run SCRIPT=R/analysis/01_explore.R)
run:
	docker compose run --rm r-dev Rscript $(SCRIPT)

# -- Database -----------------------------------------------------------------

.PHONY: psql

## Open psql shell (requires postgres service to be running)
psql:
	docker compose exec postgres psql -U $${POSTGRES_USER:-r_user} -d $${POSTGRES_DB:-r_project_db}

# -- Template Example (Smoke Test) -------------------------------------------

.PHONY: smoke-test clean-example

## Run the full template example pipeline: analysis → tests → shiny prompt
smoke-test:
	@echo ""
	@echo "=========================================="
	@echo "  SMOKE TEST: Template Example Pipeline"
	@echo "=========================================="
	@echo ""
	@echo "Step 1/3: Running analysis script..."
	docker compose run --rm r-dev \
		Rscript R/analysis/01_template_example_explore.R
	@echo ""
	@echo "Step 2/3: Running tests..."
	docker compose run --rm r-dev \
		Rscript tests/testthat.R
	@echo ""
	@echo "Step 3/3: Ready to launch Shiny dashboard"
	@echo "  Run 'make shiny' to start the dashboard at http://localhost:3838"
	@echo ""
	@echo "=========================================="
	@echo "  SMOKE TEST PASSED"
	@echo "=========================================="
	@echo ""
	@echo "Your environment is working correctly!"
	@echo "Run 'make clean-example' to remove template files when ready."

## Remove all template_example files to start fresh
clean-example:
	@echo "Removing template_example files..."
	rm -f data/raw/template_example_*.csv
	rm -f data/processed/template_example_*.csv
	rm -f output/figures/template_example_*.png
	rm -f R/analysis/01_template_example_explore.R
	rm -f R/shiny/template_example_app.R
	rm -f tests/testthat/test_template_example.R
	@echo ""
	@echo "Template example files removed."
	@echo "Your project is now a clean slate."
	@echo "The original app.R and test_helpers.R remain as starting points."
