#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

assert_exists() {
  path=$1
  if [ ! -e "$path" ]; then
    fail "expected path to exist: $path"
  fi
}

assert_contains() {
  file=$1
  pattern=$2
  if ! grep -Fq "$pattern" "$file"; then
    fail "expected to find pattern in $file: $pattern"
  fi
}

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/ai-coding-rule-bootstrap-test.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

project_dir=$tmp_dir/project
mkdir -p "$project_dir/.agents/common"

cat > "$project_dir/AGENTS.md" <<'EOF'
# Demo AGENTS
EOF

cat > "$project_dir/.agents/common/rules.md" <<'EOF'
# Demo Rules
EOF

cat > "$project_dir/.agents/common/context.md" <<'EOF'
# Demo Context
EOF

"$REPO_DIR/scripts/bootstrap-developer.sh" "$project_dir" jake

assert_exists "$project_dir/.agents/developers/jake/AGENTS.md"
assert_exists "$project_dir/.agents/developers/jake/progress.md"
assert_exists "$project_dir/.agents/developers/jake/bugs.md"
assert_exists "$project_dir/.agents/developers/jake/sessions"
assert_exists "$project_dir/.agents/developers/jake/decisions"
assert_exists "$project_dir/.agents/developers/jake/templates/session-template.md"
assert_exists "$project_dir/.agents/developers/jake/templates/decision-template.md"

assert_contains "$project_dir/.agents/developers/jake/AGENTS.md" 'Current developer profile: `jake`'
assert_contains "$project_dir/.agents/developers/jake/AGENTS.md" '.agents/developers/jake/'
assert_contains "$project_dir/.agents/developers/jake/progress.md" "Task not initialized yet. Waiting for the developer to define the task."
assert_contains "$project_dir/.agents/developers/jake/bugs.md" "None recorded yet."

if "$REPO_DIR/scripts/bootstrap-developer.sh" "$project_dir" common >/dev/null 2>&1; then
  fail "expected reserved developer profile to be rejected"
fi

printf 'ok: bootstrap-developer initializes developer scaffold\n'
