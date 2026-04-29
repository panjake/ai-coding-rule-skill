#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SNIPPET_DIR="$ROOT_DIR/skills/shared/karpathy"
AGENTS_SNIPPET="$SNIPPET_DIR/AGENTS-snippet.md"
RULES_SNIPPET="$SNIPPET_DIR/rules-snippet.md"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> [manager-profile]

Inject Karpathy guidelines into an existing project.

Behavior:
  - Creates or updates <project-path>/AGENTS.md.
  - Creates or updates <project-path>/.agents/common/rules.md.
  - Preserves existing file content by appending/prepending the shared snippets
    when the target files already exist.

Examples:
  $(basename "$0") /path/to/project
  $(basename "$0") /path/to/project jake
EOF
}

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

render_template() {
  template=$1
  output=$2
  manager_profile=$3

  sed "s/__PROJECT_MANAGER__/$manager_profile/g" "$template" > "$output"
}

append_agents_snippet() {
  target=$1
  snippet=$2

  if [ ! -f "$target" ]; then
    cat "$snippet" > "$target"
    printf '\n' >> "$target"
    printf 'updated: %s\n' "$target"
    return
  fi

  if grep -Fq "## Karpathy-Style Coding Guidelines" "$target"; then
    printf 'skip: %s already has project-level Karpathy guidelines\n' "$target"
    return
  fi

  printf '\n' >> "$target"
  cat "$snippet" >> "$target"
  printf '\n' >> "$target"
  printf 'updated: %s\n' "$target"
}

prepend_rules_snippet() {
  target=$1
  snippet=$2
  tmp_file=$(mktemp "${TMPDIR:-/tmp}/karpathy-rules.XXXXXX")
  trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

  if [ ! -f "$target" ]; then
    cat "$snippet" > "$target"
    printf '\n' >> "$target"
    rm -f "$tmp_file"
    trap - EXIT HUP INT TERM
    printf 'updated: %s\n' "$target"
    return
  fi

  if grep -Fq "## Karpathy Behavioral Guidelines" "$target"; then
    printf 'skip: %s already has common Karpathy rules\n' "$target"
    rm -f "$tmp_file"
    trap - EXIT HUP INT TERM
    return
  fi

  cat "$snippet" > "$tmp_file"
  printf '\n' >> "$tmp_file"
  cat "$target" >> "$tmp_file"
  mv "$tmp_file" "$target"
  trap - EXIT HUP INT TERM
  printf 'updated: %s\n' "$target"
}

[ $# -ge 1 ] && [ $# -le 2 ] || {
  usage >&2
  exit 1
}

project_path=$1
manager_profile=${2:-jake}
[ -d "$project_path" ] || fail "error: project path does not exist: $project_path"

[ -f "$AGENTS_SNIPPET" ] || fail "error: missing template: $AGENTS_SNIPPET"
[ -f "$RULES_SNIPPET" ] || fail "error: missing template: $RULES_SNIPPET"

rendered_agents=$(mktemp "${TMPDIR:-/tmp}/karpathy-agents.XXXXXX")
rendered_rules=$(mktemp "${TMPDIR:-/tmp}/karpathy-rules-rendered.XXXXXX")
trap 'rm -f "$rendered_agents" "$rendered_rules"' EXIT HUP INT TERM
render_template "$AGENTS_SNIPPET" "$rendered_agents" "$manager_profile"
render_template "$RULES_SNIPPET" "$rendered_rules" "$manager_profile"

agents_file=$project_path/AGENTS.md
rules_file=$project_path/.agents/common/rules.md
mkdir -p "$project_path/.agents/common"

append_agents_snippet "$agents_file" "$rendered_agents"
prepend_rules_snippet "$rules_file" "$rendered_rules"
