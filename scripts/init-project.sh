#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile> [manager-profile]

Initialize a project for AI-assisted development.

Behavior:
  - creates or updates <project-path>/AGENTS.md
  - creates or updates <project-path>/.agents/common/rules.md
  - creates or updates <project-path>/.agents/common/context.md
  - initializes <project-path>/.agents/developers/<developer>/ with the standard scaffold

Examples:
  $(basename "$0") /path/to/project jake
  $(basename "$0") /path/to/project alice jake
EOF
}

[ $# -ge 2 ] && [ $# -le 3 ] || {
  usage >&2
  exit 1
}

project_path=$1
developer_profile=$2
manager_profile=${3:-$developer_profile}

"$SCRIPT_DIR/apply-skill.sh" all "$project_path" "$manager_profile"
"$SCRIPT_DIR/bootstrap-developer.sh" "$project_path" "$developer_profile"
