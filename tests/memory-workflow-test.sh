#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

assert_exists() {
  path=$1
  if [ ! -e "$path" ]; then
    fail "expected path to exist: $path"
  fi
}

assert_contains() {
  file=$1
  pattern=$2
  if ! grep -Fq -- "$pattern" "$file"; then
    fail "expected to find pattern in $file: $pattern"
  fi
}

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/ai-coding-rule-memory-workflow-test.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

project_dir=$tmp_dir/project
mkdir -p "$project_dir"

sh "$REPO_DIR/scripts/init-project.sh" "$project_dir" jake

sh "$REPO_DIR/scripts/update-progress.sh" "$project_dir" jake \
  --task "Implement automatic session-close persistence" \
  --status "Scripts are created and under integration testing" \
  --done "Initial progress/session/bug/decision scripts are complete" \
  --next "Add tests and update documentation" \
  --blockers "None."

progress_file="$project_dir/.agents/developers/jake/progress.md"
assert_contains "$progress_file" "Implement automatic session-close persistence"
assert_contains "$progress_file" "Scripts are created and under integration testing"

sh "$REPO_DIR/scripts/append-session.sh" "$project_dir" jake \
  --task "Implement automatic session-close persistence" \
  --done "Progress persistence is complete" \
  --status "Bug and decision validation is still pending" \
  --next "Add close-session coverage" \
  --blockers "None." \
  --risks "The model may still skip script invocation" \
  --slug "memory-workflow"

session_file=$(find "$project_dir/.agents/developers/jake/sessions" -type f | sort | tail -n 1)
assert_exists "$session_file"
assert_contains "$session_file" "Implement automatic session-close persistence"
assert_contains "$session_file" "The model may still skip script invocation"

sh "$REPO_DIR/scripts/append-bug.sh" "$project_dir" jake \
  --summary "Rules alone cannot guarantee automatic persistence" \
  --details "The model may acknowledge the rule verbally without actually writing files" \
  --impact "progress and session files may remain stale" \
  --status "Identified"

bugs_file="$project_dir/.agents/developers/jake/bugs.md"
assert_contains "$bugs_file" "# Known Bugs And Risks"
assert_contains "$bugs_file" "Rules alone cannot guarantee automatic persistence"

sh "$REPO_DIR/scripts/append-decision.sh" "$project_dir" jake \
  --topic "Session-close workflow" \
  --decision "Use close-session.sh as the unified persistence entrypoint" \
  --reason "Reduce reliance on the model's self-discipline" \
  --impact "End-of-session updates can reliably persist progress, sessions, bugs, and decisions" \
  --slug "session-workflow"

decision_file=$(find "$project_dir/.agents/developers/jake/decisions" -type f | sort | tail -n 1)
assert_exists "$decision_file"
assert_contains "$decision_file" "Use close-session.sh as the unified persistence entrypoint"

sh "$REPO_DIR/scripts/close-session.sh" "$project_dir" jake \
  --task "Implement automatic session-close persistence" \
  --status "Scripts and tests are complete" \
  --done "close-session now connects progress, session, bug, and decision persistence" \
  --next "Polish documentation and prepare the release" \
  --blockers "None." \
  --risks "Callers still need to actually execute the script" \
  --session-slug "close-session" \
  --bug-summary "If the model does not call the script, memory still will not persist automatically" \
  --bug-details "This is a workflow-execution problem, not a missing-template problem" \
  --bug-impact "The final summary can drift away from actual file state" \
  --bug-status "Recorded" \
  --decision-topic "Default end-of-session action" \
  --decision "Call close-session.sh before ending a meaningful work session" \
  --decision-reason "Update all key memory layers consistently" \
  --decision-impact "Closer to the stable session-close workflow used in bzt-crm" \
  --decision-slug "close-session-default"

assert_contains "$progress_file" "Scripts and tests are complete"
assert_contains "$bugs_file" "If the model does not call the script, memory still will not persist automatically"

session_count=$(find "$project_dir/.agents/developers/jake/sessions" -type f | wc -l | tr -d ' ')
[ "$session_count" -ge 2 ] || fail "expected at least 2 session files, got: $session_count"

decision_count=$(find "$project_dir/.agents/developers/jake/decisions" -type f | wc -l | tr -d ' ')
[ "$decision_count" -ge 2 ] || fail "expected at least 2 decision files, got: $decision_count"

printf 'ok: memory workflow scripts persist progress, sessions, bugs, and decisions\n'
