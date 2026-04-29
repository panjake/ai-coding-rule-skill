#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TEMPLATE_DIR="$ROOT_DIR/skills/shared/developer-bootstrap"
. "$SCRIPT_DIR/lib-developer-memory.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile>

Initialize the standard .agents/developers/{developer} scaffold for one developer.

Behavior:
  - Creates .agents/developers/<developer>/ if it does not exist.
  - Creates AGENTS.md, progress.md, bugs.md, sessions/, decisions/, templates/.
  - Rejects reserved names and unsafe developer profile characters.
  - Does not overwrite existing files.

Examples:
  $(basename "$0") /path/to/project jake
EOF
}

render_template() {
  template=$1
  output=$2
  developer_profile=$3

  sed "s/__DEVELOPER_PROFILE__/$developer_profile/g" "$template" > "$output"
}

write_if_missing() {
  target=$1
  template=$2
  developer_profile=$3

  if [ -e "$target" ]; then
    printf 'skip: %s already exists\n' "$target"
    return
  fi

  tmp_file=$(mktemp "${TMPDIR:-/tmp}/developer-bootstrap.XXXXXX")
  trap 'rm -f "$tmp_file"' EXIT HUP INT TERM
  render_template "$template" "$tmp_file" "$developer_profile"
  mv "$tmp_file" "$target"
  trap - EXIT HUP INT TERM
  printf 'updated: %s\n' "$target"
}

[ $# -eq 2 ] || {
  usage >&2
  exit 1
}

project_path=$1
developer_profile=$2

ensure_project_exists "$project_path"
validate_developer_profile "$developer_profile"

developer_dir=$(developer_dir_for "$project_path" "$developer_profile")
templates_dir=$developer_dir/templates

mkdir -p "$developer_dir" "$developer_dir/sessions" "$developer_dir/decisions" "$templates_dir"

write_if_missing "$developer_dir/AGENTS.md" "$TEMPLATE_DIR/AGENTS-template.md" "$developer_profile"
write_if_missing "$developer_dir/progress.md" "$TEMPLATE_DIR/progress-template.md" "$developer_profile"
write_if_missing "$developer_dir/bugs.md" "$TEMPLATE_DIR/bugs-template.md" "$developer_profile"
write_if_missing "$templates_dir/session-template.md" "$TEMPLATE_DIR/session-template.md" "$developer_profile"
write_if_missing "$templates_dir/decision-template.md" "$TEMPLATE_DIR/decision-template.md" "$developer_profile"
