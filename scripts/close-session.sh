#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-path> <developer-profile> --task <text> --status <text> --done <text> --next <text> [--blockers <text>] [--risks <text>] [--session-slug <text>] [--bug-summary <text>] [--bug-details <text>] [--bug-impact <text>] [--bug-status <text>] [--decision-topic <text>] [--decision <text>] [--decision-reason <text>] [--decision-impact <text>] [--decision-slug <text>]

Close a work session by updating progress, appending a session note, and optionally writing bug and decision records.
EOF
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
blockers_text=
risks_text=
session_slug=
bug_summary=
bug_details=
bug_impact=
bug_status=
decision_topic=
decision_text=
decision_reason=
decision_impact=
decision_slug=

while [ $# -gt 0 ]; do
  case "$1" in
    --task)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --task\n' >&2; exit 1; }; task_text=$1 ;;
    --status)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --status\n' >&2; exit 1; }; status_text=$1 ;;
    --done)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --done\n' >&2; exit 1; }; done_text=$1 ;;
    --next)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --next\n' >&2; exit 1; }; next_text=$1 ;;
    --blockers)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --blockers\n' >&2; exit 1; }; blockers_text=$1 ;;
    --risks)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --risks\n' >&2; exit 1; }; risks_text=$1 ;;
    --session-slug)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --session-slug\n' >&2; exit 1; }; session_slug=$1 ;;
    --bug-summary)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --bug-summary\n' >&2; exit 1; }; bug_summary=$1 ;;
    --bug-details)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --bug-details\n' >&2; exit 1; }; bug_details=$1 ;;
    --bug-impact)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --bug-impact\n' >&2; exit 1; }; bug_impact=$1 ;;
    --bug-status)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --bug-status\n' >&2; exit 1; }; bug_status=$1 ;;
    --decision-topic)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --decision-topic\n' >&2; exit 1; }; decision_topic=$1 ;;
    --decision)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --decision\n' >&2; exit 1; }; decision_text=$1 ;;
    --decision-reason)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --decision-reason\n' >&2; exit 1; }; decision_reason=$1 ;;
    --decision-impact)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --decision-impact\n' >&2; exit 1; }; decision_impact=$1 ;;
    --decision-slug)
      shift; [ $# -gt 0 ] || { printf 'error: missing value for --decision-slug\n' >&2; exit 1; }; decision_slug=$1 ;;
    *)
      printf 'error: unsupported argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [ -n "$blockers_text" ]; then
  sh "$SCRIPT_DIR/update-progress.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --status "$status_text" \
    --done "$done_text" \
    --next "$next_text" \
    --blockers "$blockers_text"
else
  sh "$SCRIPT_DIR/update-progress.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --status "$status_text" \
    --done "$done_text" \
    --next "$next_text"
fi

session_args="base"
if [ -n "$blockers_text" ] && [ -n "$risks_text" ] && [ -n "$session_slug" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --blockers "$blockers_text" \
    --risks "$risks_text" \
    --slug "$session_slug"
elif [ -n "$blockers_text" ] && [ -n "$risks_text" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --blockers "$blockers_text" \
    --risks "$risks_text"
elif [ -n "$blockers_text" ] && [ -n "$session_slug" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --blockers "$blockers_text" \
    --slug "$session_slug"
elif [ -n "$risks_text" ] && [ -n "$session_slug" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --risks "$risks_text" \
    --slug "$session_slug"
elif [ -n "$blockers_text" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --blockers "$blockers_text"
elif [ -n "$risks_text" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --risks "$risks_text"
elif [ -n "$session_slug" ]; then
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text" \
    --slug "$session_slug"
else
  sh "$SCRIPT_DIR/append-session.sh" "$project_path" "$developer_profile" \
    --task "$task_text" \
    --done "$done_text" \
    --status "$status_text" \
    --next "$next_text"
fi

if [ -n "$bug_summary" ]; then
  if [ -n "$bug_details" ] && [ -n "$bug_impact" ] && [ -n "$bug_status" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --details "$bug_details" \
      --impact "$bug_impact" \
      --status "$bug_status"
  elif [ -n "$bug_details" ] && [ -n "$bug_impact" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --details "$bug_details" \
      --impact "$bug_impact"
  elif [ -n "$bug_details" ] && [ -n "$bug_status" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --details "$bug_details" \
      --status "$bug_status"
  elif [ -n "$bug_impact" ] && [ -n "$bug_status" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --impact "$bug_impact" \
      --status "$bug_status"
  elif [ -n "$bug_details" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --details "$bug_details"
  elif [ -n "$bug_impact" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --impact "$bug_impact"
  elif [ -n "$bug_status" ]; then
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary" \
      --status "$bug_status"
  else
    sh "$SCRIPT_DIR/append-bug.sh" "$project_path" "$developer_profile" \
      --summary "$bug_summary"
  fi
fi

if [ -n "$decision_topic" ] || [ -n "$decision_text" ] || [ -n "$decision_reason" ]; then
  [ -n "$decision_topic" ] || {
    printf 'error: --decision-topic is required when writing a decision\n' >&2
    exit 1
  }
  [ -n "$decision_text" ] || {
    printf 'error: --decision is required when writing a decision\n' >&2
    exit 1
  }
  [ -n "$decision_reason" ] || {
    printf 'error: --decision-reason is required when writing a decision\n' >&2
    exit 1
  }
  if [ -n "$decision_impact" ] && [ -n "$decision_slug" ]; then
    sh "$SCRIPT_DIR/append-decision.sh" "$project_path" "$developer_profile" \
      --topic "$decision_topic" \
      --decision "$decision_text" \
      --reason "$decision_reason" \
      --impact "$decision_impact" \
      --slug "$decision_slug"
  elif [ -n "$decision_impact" ]; then
    sh "$SCRIPT_DIR/append-decision.sh" "$project_path" "$developer_profile" \
      --topic "$decision_topic" \
      --decision "$decision_text" \
      --reason "$decision_reason" \
      --impact "$decision_impact"
  elif [ -n "$decision_slug" ]; then
    sh "$SCRIPT_DIR/append-decision.sh" "$project_path" "$developer_profile" \
      --topic "$decision_topic" \
      --decision "$decision_text" \
      --reason "$decision_reason" \
      --slug "$decision_slug"
  else
    sh "$SCRIPT_DIR/append-decision.sh" "$project_path" "$developer_profile" \
      --topic "$decision_topic" \
      --decision "$decision_text" \
      --reason "$decision_reason"
  fi
fi
