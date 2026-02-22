# =============================================================================
# R Project Docker Image
# Base: rocker/r-ver (versioned R, Debian-based)
# Includes: renv, Shiny, common system libs for R packages
# =============================================================================

ARG R_VERSION=4.4.1
FROM rocker/r-ver:${R_VERSION}

LABEL maintainer="Ed <2kjeeptj@gmail.com>"
LABEL description="Standardized R development environment"

# -- System dependencies commonly needed by R packages -----------------------
# (xml2, curl, openssl, postgres, spatial, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    # General build tools
    build-essential \
    cmake \
    git \
    # curl / httr / web
    libcurl4-openssl-dev \
    libssl-dev \
    # XML
    libxml2-dev \
    # Postgres (DBI / RPostgres)
    libpq-dev \
    # Font / text rendering (ggplot, knitr)
    libfontconfig1-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    # Image handling (magick)
    libmagick++-dev \
    # PDF / document generation
    pandoc \
    # Spatial (sf, terra) — uncomment if needed
    # libgdal-dev \
    # libgeos-dev \
    # libproj-dev \
    # libudunits2-dev \
    && rm -rf /var/lib/apt/lists/*

# -- renv setup ---------------------------------------------------------------
ENV RENV_VERSION=1.0.7
ENV RENV_PATHS_CACHE=/renv/cache
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org')"

# -- Create app directory -----------------------------------------------------
WORKDIR /project

# -- Restore renv packages (layer caching: only re-runs when lockfile changes)
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json
RUN R -e "renv::restore(prompt = FALSE)"

# -- Copy project files -------------------------------------------------------
COPY . .

# -- Default: interactive R session -------------------------------------------
# Override in docker-compose for Shiny, scripts, etc.
CMD ["R"]
