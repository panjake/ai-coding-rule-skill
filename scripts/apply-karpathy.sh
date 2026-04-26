#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SNIPPET_DIR="$ROOT_DIR/skills/shared/karpathy"
AGENTS_SNIPPET="$SNIPPET_DIR/AGENTS-snippet.md"
RULES_SNIPPET="$SNIPPET_DIR/rules-snippet.md"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path>

Inject Karpathy guidelines into an existing project.

Behavior:
  - Modifies <project-path>/AGENTS.md if it exists and does not already contain
    the Karpathy project snippet.
  - Modifies <project-path>/.agents/common/rules.md if it exists and does not
    already contain the Karpathy common-rules snippet.
  - Does not create missing governance files.

Examples:
  $(basename "$0") /path/to/project
EOF
}

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

append_agents_snippet() {
  target=$1

  if grep -Fq "## Karpathy-Style Coding Guidelines" "$target"; then
    printf 'skip: %s already has project-level Karpathy guidelines\n' "$target"
    return
  fi

  printf '\n' >> "$target"
  cat "$AGENTS_SNIPPET" >> "$target"
  printf '\n' >> "$target"
  printf 'updated: %s\n' "$target"
}

prepend_rules_snippet() {
  target=$1
  tmp_file=$(mktemp "${TMPDIR:-/tmp}/karpathy-rules.XXXXXX")
  trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

  if grep -Fq "## Karpathy 准则 / Karpathy Guidelines" "$target"; then
    printf 'skip: %s already has common Karpathy rules\n' "$target"
    rm -f "$tmp_file"
    trap - EXIT HUP INT TERM
    return
  fi

  cat "$RULES_SNIPPET" > "$tmp_file"
  printf '\n' >> "$tmp_file"
  cat "$target" >> "$tmp_file"
  mv "$tmp_file" "$target"
  trap - EXIT HUP INT TERM
  printf 'updated: %s\n' "$target"
}

[ $# -eq 1 ] || {
  usage >&2
  exit 1
}

project_path=$1
[ -d "$project_path" ] || fail "error: project path does not exist: $project_path"

[ -f "$AGENTS_SNIPPET" ] || fail "error: missing template: $AGENTS_SNIPPET"
[ -f "$RULES_SNIPPET" ] || fail "error: missing template: $RULES_SNIPPET"

agents_file=$project_path/AGENTS.md
rules_file=$project_path/.agents/common/rules.md

did_work=0

if [ -f "$agents_file" ]; then
  append_agents_snippet "$agents_file"
  did_work=1
else
  printf 'skip: %s not found\n' "$agents_file"
fi

if [ -f "$rules_file" ]; then
  prepend_rules_snippet "$rules_file"
  did_work=1
else
  printf 'skip: %s not found\n' "$rules_file"
fi

[ "$did_work" -eq 1 ] || fail "error: no supported target files found under $project_path"
