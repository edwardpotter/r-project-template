# R Project Template

Standardized development environment for R analysis projects using Docker, renv, and VSCode.

## Tech Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Language | R 4.4.1 | Statistical computing & analysis |
| Containers | Docker + Compose | Reproducible, isolated environments |
| Package Mgmt | renv | Per-project R package lockfiles |
| Web Apps | Shiny | Interactive dashboards & visualizations |
| Database | PostgreSQL 16 | Persistent data storage (optional) |
| Editor | VSCode + Dev Containers | Develop inside the Docker container |
| Version Control | Git + GitHub | Code versioning & collaboration |

## Quick Start

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (with Compose v2)
- [VSCode](https://code.visualstudio.com/) with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
- Git

### Create a New Project from This Template

```bash
./scripts/new-project.sh my-analysis-project ~/projects
cd ~/projects/my-analysis-project
```

### Build & Verify

```bash
# Build the Docker image
make build

# Run the smoke test to verify everything works
make smoke-test

# Launch the example Shiny dashboard
make shiny
# Open http://localhost:3838

# Once verified, clean out the example files and start your real work
make clean-example
```

### Open in VSCode

```bash
# Or open in VSCode and use Dev Containers:
# Cmd+Shift+P → "Dev Containers: Reopen in Container"
```

### Install R Packages

From inside the container (or VSCode terminal):

```r
# Install a package
renv::install("tidyverse")

# Save the lockfile
renv::snapshot()
```

Or from the host:

```bash
make install PKG=tidyverse
```

### Run the Shiny App

```bash
make shiny
# Open http://localhost:3838
```

### Run Tests

```bash
make test
```

## Project Structure

```
├── .devcontainer/          # VSCode Dev Container config
│   └── devcontainer.json
├── R/
│   ├── functions/          # Reusable functions & config
│   │   ├── _config.R       # Project-wide settings (auto-loaded)
│   │   └── helpers.R       # Shared helper functions
│   ├── analysis/           # Numbered analysis scripts
│   │   └── 01_template_example_explore.R  ← smoke test (delete after)
│   └── shiny/              # Shiny web app
│       ├── app.R                          ← your app (blank starter)
│       └── template_example_app.R         ← smoke test (delete after)
├── tests/
│   ├── testthat.R          # Test runner
│   └── testthat/           # Test files
│       ├── test_helpers.R
│       └── test_template_example.R        ← smoke test (delete after)
├── data/
│   ├── raw/                # Original, immutable data
│   │   └── template_example_sensor_data.csv  ← smoke test data
│   └── processed/          # Cleaned / transformed data
├── output/
│   ├── figures/            # Generated plots
│   └── reports/            # Generated reports
├── docker/
│   └── init-db.sql         # Postgres initialization (optional)
├── scripts/
│   └── new-project.sh      # Create new projects from template
├── .Rprofile               # R session config (loads renv + project settings)
├── .env.example            # Environment variable template
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── Makefile                # Common dev commands
└── renv.lock               # Package lockfile
```

## Smoke Test (Template Example)

Every new project includes a built-in smoke test that exercises the full pipeline: data loading, cleaning, visualization, Shiny, and tests. All example files are prefixed with `template_example_` so they're easy to identify and remove.

```bash
# Run the full pipeline
make smoke-test

# Launch the interactive dashboard
make shiny
# Open http://localhost:3838

# When you're satisfied everything works, clean up
make clean-example
```

The smoke test validates: CSV loading from `data/raw/`, data cleaning and transformation, figure generation to `output/figures/`, processed data output to `data/processed/`, Shiny app startup, and the testthat test framework. The `clean-example` command removes all `template_example_*` files, leaving the blank starter files (`app.R`, `test_helpers.R`) intact.

## Enabling Optional Services

### PostgreSQL

1. Uncomment the `postgres` service in `docker-compose.yml`
2. Uncomment the `pgdata` volume
3. Uncomment the Postgres env vars in the `r-dev` service
4. Uncomment the `depends_on` block in `r-dev`
5. Uncomment the DB config in `R/functions/_config.R`
6. Install the R packages: `make install PKG=DBI` then `make install PKG=RPostgres`
7. Edit `docker/init-db.sql` for your schema

### Standalone Shiny Server

1. Uncomment the `shiny` service in `docker-compose.yml`
2. Run `docker compose up shiny`

## Make Commands Reference

| Command | Description |
|---------|-------------|
| `make build` | Build the Docker image |
| `make up` | Start containers (detached) |
| `make down` | Stop containers |
| `make clean` | Remove containers, volumes, and images |
| `make r` | Interactive R session |
| `make shiny` | Run Shiny app on port 3838 |
| `make test` | Run testthat tests |
| `make lint` | Lint R code with lintr |
| `make snapshot` | Save renv lockfile |
| `make restore` | Restore packages from lockfile |
| `make install PKG=x` | Install package and snapshot |
| `make run SCRIPT=path` | Run an R script |
| `make psql` | Open psql shell |
| `make smoke-test` | Run full template example pipeline |
| `make clean-example` | Remove all template_example files |
