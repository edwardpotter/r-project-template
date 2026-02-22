#!/usr/bin/env bash
# =============================================================================
# new-project.sh — Create a new R project from this template
#
# Usage:
#   ./scripts/new-project.sh <project-name> [target-directory]
#
# Example:
#   ./scripts/new-project.sh customer-churn ~/projects
#   → Creates ~/projects/customer-churn/ with the full template
# =============================================================================

set -euo pipefail

PROJECT_NAME="${1:?Usage: $0 <project-name> [target-directory]}"
TARGET_DIR="${2:-.}"
TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${TARGET_DIR}/${PROJECT_NAME}"

if [ -d "$DEST" ]; then
  echo "Error: Directory already exists: $DEST"
  exit 1
fi

echo "Creating new R project: ${PROJECT_NAME}"
echo "  From template: ${TEMPLATE_DIR}"
echo "  Destination:   ${DEST}"
echo ""

# Copy template (excluding git history and this script's meta)
mkdir -p "$DEST"
rsync -a \
  --exclude='.git' \
  --exclude='scripts/new-project.sh' \
  "${TEMPLATE_DIR}/" "${DEST}/"

# Copy the new-project script too (useful for creating sub-projects)
cp "${TEMPLATE_DIR}/scripts/new-project.sh" "${DEST}/scripts/new-project.sh"

# Update project name in key files
cd "$DEST"

# Set compose project name
if [ -f ".env.example" ]; then
  sed "s/my-project-name/${PROJECT_NAME}/g" .env.example > .env
  echo "  Created .env from .env.example"
fi

# Initialize git
git init -q
git add -A
git commit -q -m "Initial project setup from r-project-template"
echo "  Initialized git repository"

echo ""
echo "Done! Next steps:"
echo "  cd ${DEST}"
echo "  make build        # Build the Docker image"
echo "  make r            # Start an R session"
echo ""
echo "  # Or open in VSCode with Dev Containers:"
echo "  code ${DEST}"
echo "  # Then: Cmd+Shift+P → 'Reopen in Container'"
