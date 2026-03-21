#!/usr/bin/env bash
# Run all E2E tests
# Usage: bash tests/e2e/run.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOTAL_PASS=0
TOTAL_FAIL=0
FAILED_SUITES=()

for test_file in "$SCRIPT_DIR"/test_*.sh; do
    [ -f "$test_file" ] || continue
    suite_name="$(basename "$test_file")"

    echo ""
    echo "########## $suite_name ##########"
    echo ""

    if bash "$test_file"; then
        echo ""
        echo ">>> $suite_name: ALL PASSED"
    else
        echo ""
        echo ">>> $suite_name: HAS FAILURES"
        FAILED_SUITES+=("$suite_name")
    fi
done

echo ""
echo "============================================"
if [ ${#FAILED_SUITES[@]} -eq 0 ]; then
    echo "All test suites passed."
    exit 0
else
    echo "Failed suites: ${FAILED_SUITES[*]}"
    exit 1
fi
