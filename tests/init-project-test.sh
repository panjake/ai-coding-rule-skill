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
  if ! grep -Fq -- "$pattern" "$file"; then
    fail "expected to find pattern in $file: $pattern"
  fi
}

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/ai-coding-rule-init-test.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

project_dir=$tmp_dir/project
mkdir -p "$project_dir"

"$REPO_DIR/scripts/init-project.sh" "$project_dir" jake

assert_exists "$project_dir/AGENTS.md"
assert_exists "$project_dir/.agents/common/rules.md"
assert_exists "$project_dir/.agents/common/context.md"
assert_exists "$project_dir/.agents/developers/jake/AGENTS.md"
assert_exists "$project_dir/.agents/developers/jake/progress.md"
assert_exists "$project_dir/.agents/developers/jake/bugs.md"

assert_contains "$project_dir/AGENTS.md" "Use the jake profile."
assert_contains "$project_dir/.agents/common/rules.md" "Use the jake profile."
assert_contains "$project_dir/.agents/developers/jake/AGENTS.md" 'Current developer profile: `jake`'

printf 'ok: init-project creates common files and developer scaffold\n'
