#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib-developer-memory.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile> --task <text> --done <text> --status <text> --next <text> [--blockers <text>] [--risks <text>] [--slug <text>]

Append a structured session note under .agents/developers/{developer}/sessions/.
EOF
}

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-'
}

require_value() {
  flag_name=$1
  value=$2
  [ -n "$value" ] || fail "error: missing value for $flag_name"
}

[ $# -ge 10 ] || {
  usage >&2
  exit 1
}

project_path=$1
developer_profile=$2
shift 2

task_text=
done_text=
status_text=
next_text=
blockers_text="None."
risks_text="None."
slug_text=

while [ $# -gt 0 ]; do
  case "$1" in
    --task)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --task"
      task_text=$1
      ;;
    --done)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --done"
      done_text=$1
      ;;
    --status)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --status"
      status_text=$1
      ;;
    --next)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --next"
      next_text=$1
      ;;
    --blockers)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --blockers"
      blockers_text=$1
      ;;
    --risks)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --risks"
      risks_text=$1
      ;;
    --slug)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --slug"
      slug_text=$1
      ;;
    *)
      fail "error: unsupported argument: $1"
      ;;
  esac
  shift
done

ensure_project_exists "$project_path"
validate_developer_profile "$developer_profile"
ensure_developer_scaffold_exists "$project_path" "$developer_profile"

require_value --task "$task_text"
require_value --done "$done_text"
require_value --status "$status_text"
require_value --next "$next_text"

[ -n "$slug_text" ] || slug_text=$(slugify "$task_text")
[ -n "$slug_text" ] || slug_text="session"

developer_dir=$(developer_dir_for "$project_path" "$developer_profile")
session_dir="$developer_dir/sessions"
session_file="$session_dir/$(date +%F)-$slug_text-$(date +%H%M%S).md"

session_content=$(cat <<EOF
# Session Note

- Date:
  $(date +%F)
- Task:
  $task_text
- Completed:
  $done_text
- Current status:
  $status_text
- Blockers:
  $blockers_text
- Risks:
  $risks_text
- Next step:
  $next_text
EOF
)

write_with_tmp "$session_file" "$session_content"
printf 'updated: %s\n' "$session_file"
