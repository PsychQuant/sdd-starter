#!/usr/bin/env bash
# E2E Security Tests — validate special character rejection
# Covers: SPECIFY_FEATURE injection (#1), create-new-feature.sh input sanitization

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMMON_SH="$REPO_ROOT/.specify/scripts/bash/common.sh"
CREATE_FEATURE="$REPO_ROOT/.specify/scripts/bash/create-new-feature.sh"

PASS=0
FAIL=0

assert_rejected() {
    local description="$1"
    shift
    if "$@" >/dev/null 2>&1; then
        echo "  FAIL: $description (expected rejection, got exit 0)"
        FAIL=$((FAIL + 1))
    else
        echo "  PASS: $description"
        PASS=$((PASS + 1))
    fi
}

assert_accepted() {
    local description="$1"
    shift
    if "$@" >/dev/null 2>&1; then
        echo "  PASS: $description"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $description (expected success, got non-zero exit)"
        FAIL=$((FAIL + 1))
    fi
}

assert_output_not_contains() {
    local description="$1"
    local forbidden="$2"
    shift 2
    local output
    output=$("$@" 2>&1) || true
    if echo "$output" | grep -qF "$forbidden"; then
        echo "  FAIL: $description (output contains '$forbidden')"
        FAIL=$((FAIL + 1))
    else
        echo "  PASS: $description"
        PASS=$((PASS + 1))
    fi
}

# Helper: test SPECIFY_FEATURE by spawning a subshell with env
test_specify_feature() {
    local value="$1"
    env SPECIFY_FEATURE="$value" bash -c 'source "'"$COMMON_SH"'" && get_current_branch'
}

# ---------------------------------------------------------------------------
echo "=== SPECIFY_FEATURE validation (common.sh:get_current_branch) ==="
echo ""
echo "--- Should REJECT invalid values ---"

assert_rejected "shell injection: ; rm -rf /" \
    test_specify_feature '; rm -rf /'

assert_rejected 'command substitution: $(whoami)' \
    test_specify_feature '$(whoami)'

assert_rejected 'backtick injection: feat`id`' \
    test_specify_feature 'feat`id`'

assert_rejected "spaces: hello world" \
    test_specify_feature 'hello world'

assert_rejected "path traversal: ../../../etc/passwd" \
    test_specify_feature '../../../etc/passwd'

assert_rejected "ampersand: foo&bar" \
    test_specify_feature 'foo&bar'

assert_rejected "pipe: foo|bar" \
    test_specify_feature 'foo|bar'

echo ""
echo "--- Should ACCEPT valid values ---"

assert_accepted "standard branch: 001-my-feature" \
    test_specify_feature '001-my-feature'

assert_accepted "slash-dot branch: feat/login.v2" \
    test_specify_feature 'feat/login.v2'

assert_accepted "underscore branch: feat_login_v2" \
    test_specify_feature 'feat_login_v2'

# ---------------------------------------------------------------------------
echo ""
echo "=== create-new-feature.sh input sanitization ==="
echo ""
echo "--- Should NOT execute injected commands ---"

# $(whoami) should not be executed — the actual username must not appear in output
assert_output_not_contains 'no execution of $(whoami)' "$(whoami)" \
    bash "$CREATE_FEATURE" 'hello $(whoami) world'

# semicolon injection — rm should not execute, and "rm" should not appear as a command error
assert_output_not_contains "no execution of ; rm" "No such file" \
    bash "$CREATE_FEATURE" 'feature; rm -rf /'

echo ""
echo "--- Should REJECT empty/whitespace input ---"

assert_rejected "empty string" \
    bash "$CREATE_FEATURE" ''

assert_rejected "whitespace only" \
    bash "$CREATE_FEATURE" '   '

# ---------------------------------------------------------------------------
echo ""
echo "==========================================="
echo "Results: $PASS passed, $FAIL failed"
echo "==========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
