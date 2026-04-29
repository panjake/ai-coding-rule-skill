#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<EOF
Usage: $(basename "$0") <skill-name> <project-path> [manager-profile]

Apply a registered repository skill into an explicit project path.

Supported skills:
  - karpathy
  - context
  - all

Examples:
  $(basename "$0") karpathy /path/to/project
  $(basename "$0") karpathy /path/to/project jake
  $(basename "$0") context /path/to/project
  $(basename "$0") all /path/to/project
EOF
}

[ $# -ge 2 ] && [ $# -le 3 ] || {
  usage >&2
  exit 1
}

skill_name=$1
project_path=$2
manager_profile=${3:-jake}

case "$skill_name" in
  karpathy)
    exec "$SCRIPT_DIR/apply-karpathy.sh" "$project_path" "$manager_profile"
    ;;
  context)
    exec "$SCRIPT_DIR/apply-context.sh" "$project_path"
    ;;
  all)
    "$SCRIPT_DIR/apply-karpathy.sh" "$project_path" "$manager_profile"
    exec "$SCRIPT_DIR/apply-context.sh" "$project_path"
    ;;
  *)
    printf 'error: unsupported skill: %s\n' "$skill_name" >&2
    usage >&2
    exit 1
    ;;
esac
