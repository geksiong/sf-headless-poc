#!/usr/bin/env bash
set -euo pipefail

# Import sample Accounts and Opportunities into a Salesforce org.
# Usage:
#   ./scripts/import-data.sh <org-alias-or-username>
#
# Example:
#   ./scripts/import-data.sh DevHubTrial

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <org-alias-or-username>"
  echo ""
  echo "Examples:"
  echo "  $0 DevHubTrial"
  echo "  $0 myuser@example.com"
  exit 1
fi

ORG="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Importing sample data into org: $ORG ==="
echo ""

sf data import tree \
  --plan "$PROJECT_DIR/data/sample-data-plan.json" \
  --target-org "$ORG"

echo ""
echo "=== Import complete ==="
