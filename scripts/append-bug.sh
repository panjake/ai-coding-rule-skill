#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib-developer-memory.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile> --summary <text> [--details <text>] [--impact <text>] [--status <text>]

Append a confirmed problem, failed approach, or risk to .agents/developers/{developer}/bugs.md.
EOF
}

require_value() {
  flag_name=$1
  value=$2
  [ -n "$value" ] || fail "error: missing value for $flag_name"
}

[ $# -ge 4 ] || {
  usage >&2
  exit 1
}

project_path=$1
developer_profile=$2
shift 2

summary_text=
details_text="Not documented yet."
impact_text="To be assessed."
status_text="Open"

while [ $# -gt 0 ]; do
  case "$1" in
    --summary)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --summary"
      summary_text=$1
      ;;
    --details)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --details"
      details_text=$1
      ;;
    --impact)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --impact"
      impact_text=$1
      ;;
    --status)
      shift
      [ $# -gt 0 ] || fail "error: missing value for --status"
      status_text=$1
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
require_value --summary "$summary_text"

bugs_file="$(developer_dir_for "$project_path" "$developer_profile")/bugs.md"

if [ ! -f "$bugs_file" ] || grep -Fq "No known bugs or risks recorded yet." "$bugs_file"; then
  write_with_tmp "$bugs_file" "# Known Bugs And Risks"
fi

bug_block=$(cat <<EOF
## $(date +%F) - $summary_text

- Details:
  $details_text
- Impact:
  $impact_text
- Status:
  $status_text
EOF
)

append_block "$bugs_file" "$bug_block"
printf 'updated: %s\n' "$bugs_file"
