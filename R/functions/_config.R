# =============================================================================
# Project Configuration
# Loaded automatically via .Rprofile
# =============================================================================

# -- Paths --------------------------------------------------------------------
PATHS <- list(
  raw_data   = "data/raw",
  processed  = "data/processed",
  figures    = "output/figures",
  reports    = "output/reports"
)

# -- Database (uncomment when Postgres is enabled) ----------------------------
# DB_CONFIG <- list(
#   host     = Sys.getenv("PGHOST", "localhost"),
#   port     = as.integer(Sys.getenv("PGPORT", "5432")),
#   dbname   = Sys.getenv("PGDATABASE", "r_project_db"),
#   user     = Sys.getenv("PGUSER", "r_user"),
#   password = Sys.getenv("PGPASSWORD", "changeme")
# )

# -- Helper: connect to Postgres ----------------------------------------------
# db_connect <- function() {
#   DBI::dbConnect(
#     RPostgres::Postgres(),
#     host     = DB_CONFIG$host,
#     port     = DB_CONFIG$port,
#     dbname   = DB_CONFIG$dbname,
#     user     = DB_CONFIG$user,
#     password = DB_CONFIG$password
#   )
# }
