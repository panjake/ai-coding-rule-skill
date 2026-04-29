#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib-developer-memory.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile> --task <text> --status <text> --done <text> --next <text> [--blockers <text>]

Update .agents/developers/{developer}/progress.md with a structured current-state snapshot.
EOF
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
status_text=
done_text=
next_text=
blockers_text="None."

while [ $# -gt 0 ]; do
  case "$1" in
    --task)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --task"
      task_text=$1
      ;;
    --status)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --status"
      status_text=$1
      ;;
    --done)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --done"
      done_text=$1
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
require_value --status "$status_text"
require_value --done "$done_text"
require_value --next "$next_text"

progress_file="$(developer_dir_for "$project_path" "$developer_profile")/progress.md"

progress_content=$(cat <<EOF
# Current Progress

- Current task:
  $task_text
- Current status:
  $status_text
- Completed:
  $done_text
- Next step:
  $next_text
- Blockers:
  $blockers_text
EOF
)

write_with_tmp "$progress_file" "$progress_content"
printf 'updated: %s\n' "$progress_file"
