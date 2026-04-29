#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib-developer-memory.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile> --topic <text> --decision <text> --reason <text> [--impact <text>] [--slug <text>]

Create a decision record under .agents/developers/{developer}/decisions/.
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

[ $# -ge 8 ] || {
  usage >&2
  exit 1
}

project_path=$1
developer_profile=$2
shift 2

topic_text=
decision_text=
reason_text=
impact_text="To be documented."
slug_text=

while [ $# -gt 0 ]; do
  case "$1" in
    --topic)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --topic"
      topic_text=$1
      ;;
    --decision)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --decision"
      decision_text=$1
      ;;
    --reason)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --reason"
      reason_text=$1
      ;;
    --impact)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --impact"
      impact_text=$1
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
require_value --topic "$topic_text"
require_value --decision "$decision_text"
require_value --reason "$reason_text"

[ -n "$slug_text" ] || slug_text=$(slugify "$topic_text")
[ -n "$slug_text" ] || slug_text="decision"

decision_dir="$(developer_dir_for "$project_path" "$developer_profile")/decisions"
decision_file="$decision_dir/$(date +%F)-$slug_text-$(date +%H%M%S).md"

decision_content=$(cat <<EOF
# Decision Record

- Date:
  $(date +%F)
- Topic:
  $topic_text
- Decision:
  $decision_text
- Reason:
  $reason_text
- Impact:
  $impact_text
EOF
)

write_with_tmp "$decision_file" "$decision_content"
printf 'updated: %s\n' "$decision_file"
