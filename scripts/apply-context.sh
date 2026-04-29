#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SNIPPET_DIR="$ROOT_DIR/skills/shared/context"
CONTEXT_SNIPPET="$SNIPPET_DIR/context-snippet.md"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path>

Inject project-map context guidance into an existing project.

Behavior:
  - Creates <project-path>/.agents/common/context.md if missing.
  - Prepends a shared context-maintenance snippet when the file exists and does
    not already contain it.
  - Preserves any existing project-specific context below the injected snippet.

Examples:
  $(basename "$0") /path/to/project
EOF
}

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

prepend_or_create_context() {
  target=$1
  target_dir=$(dirname "$target")

  mkdir -p "$target_dir"

  if [ -f "$target" ] && grep -Fq "## Project Map Maintenance" "$target"; then
    printf 'skip: %s already has shared context guidance\n' "$target"
    return
  fi

  tmp_file=$(mktemp "${TMPDIR:-/tmp}/project-context.XXXXXX")
  trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

  cat "$CONTEXT_SNIPPET" > "$tmp_file"

  if [ -f "$target" ]; then
    printf '\n' >> "$tmp_file"
    cat "$target" >> "$tmp_file"
  else
    printf '\n' >> "$tmp_file"
  fi

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

[ -f "$CONTEXT_SNIPPET" ] || fail "error: missing template: $CONTEXT_SNIPPET"

context_file=$project_path/.agents/common/context.md

prepend_or_create_context "$context_file"
