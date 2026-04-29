#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

assert_contains() {
  file=$1
  pattern=$2

  if ! grep -Fq -- "$pattern" "$file"; then
    fail "expected to find pattern in $file: $pattern"
  fi
}

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/ai-coding-rule-skill-test.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

project_dir=$tmp_dir/project
mkdir -p "$project_dir"

"$REPO_DIR/scripts/apply-skill.sh" all "$project_dir" jake

assert_contains "$project_dir/AGENTS.md" "## Karpathy-Style Coding Guidelines"
assert_contains "$project_dir/AGENTS.md" "Use the jake profile."
assert_contains "$project_dir/AGENTS.md" "## Recovery Summary"
assert_contains "$project_dir/AGENTS.md" "Current developer profile:"
assert_contains "$project_dir/AGENTS.md" ".agents/developers/jake/"
assert_contains "$project_dir/AGENTS.md" "## Memory Layers"
assert_contains "$project_dir/AGENTS.md" "## End With Handoff"
assert_contains "$project_dir/AGENTS.md" 'If `.agents/common/context.md` does not exist'
assert_contains "$project_dir/.agents/common/rules.md" "## Karpathy Behavioral Guidelines"
assert_contains "$project_dir/.agents/common/rules.md" "## Collaboration Rules"
assert_contains "$project_dir/.agents/common/rules.md" "Recovery must be explicit."
assert_contains "$project_dir/.agents/common/rules.md" "## Core Rules"
assert_contains "$project_dir/.agents/common/rules.md" "## Verification Rules"
assert_contains "$project_dir/.agents/common/rules.md" "Use the jake profile."
assert_contains "$project_dir/.agents/common/context.md" "## Project Map Maintenance"
assert_contains "$project_dir/.agents/common/context.md" "### Required Sections"
assert_contains "$project_dir/.agents/common/context.md" "### Initialization Protocol"
assert_contains "$project_dir/.agents/common/context.md" "- Project positioning"
assert_contains "$project_dir/.agents/common/rules.md" "# Common Agent Rules"
if grep -Fq "Use the __PROJECT_MANAGER__ profile." "$project_dir/AGENTS.md"; then
  fail "expected manager placeholder to be replaced in AGENTS.md"
fi
if grep -Fq "Use the __PROJECT_MANAGER__ profile." "$project_dir/.agents/common/rules.md"; then
  fail "expected manager placeholder to be replaced in rules.md"
fi

printf 'ok: apply-skill all injects karpathy and context assets\n'
