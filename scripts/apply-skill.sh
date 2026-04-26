#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<EOF
Usage: $(basename "$0") <skill-name> <project-path>

Apply a registered repository skill into an explicit project path.

Supported skills:
  - karpathy

Examples:
  $(basename "$0") karpathy /path/to/project
EOF
}

[ $# -eq 2 ] || {
  usage >&2
  exit 1
}

skill_name=$1
project_path=$2

case "$skill_name" in
  karpathy)
    exec "$SCRIPT_DIR/apply-karpathy.sh" "$project_path"
    ;;
  *)
    printf 'error: unsupported skill: %s\n' "$skill_name" >&2
    usage >&2
    exit 1
    ;;
esac
