#!/bin/sh

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

validate_developer_profile() {
  developer_profile=$1

  [ -n "$developer_profile" ] || fail "error: developer profile must not be empty"

  case "$developer_profile" in
    .* )
      fail "error: developer profile must not start with a dot: $developer_profile"
      ;;
    -* | *- )
      fail "error: developer profile must not start or end with a hyphen: $developer_profile"
      ;;
    *[!abcdefghijklmnopqrstuvwxyz0123456789-]* )
      fail "error: developer profile may contain only lowercase letters, digits, and hyphens: $developer_profile"
      ;;
  esac

  case "$developer_profile" in
    common | templates | proposals | developers | system | shared )
      fail "error: developer profile uses a reserved name: $developer_profile"
      ;;
  esac
}

developer_dir_for() {
  project_path=$1
  developer_profile=$2
  printf '%s/.agents/developers/%s\n' "$project_path" "$developer_profile"
}

ensure_project_exists() {
  project_path=$1
  [ -d "$project_path" ] || fail "error: project path does not exist: $project_path"
}

ensure_developer_scaffold_exists() {
  project_path=$1
  developer_profile=$2
  developer_dir=$(developer_dir_for "$project_path" "$developer_profile")
  [ -d "$developer_dir" ] || fail "error: developer scaffold does not exist: $developer_dir"
}

write_with_tmp() {
  target=$1
  content=$2

  tmp_file=$(mktemp "${TMPDIR:-/tmp}/developer-memory.XXXXXX")
  trap 'rm -f "$tmp_file"' EXIT HUP INT TERM
  printf '%s' "$content" > "$tmp_file"
  mv "$tmp_file" "$target"
  trap - EXIT HUP INT TERM
}

append_block() {
  target=$1
  content=$2

  if [ -f "$target" ]; then
    printf '\n%s' "$content" >> "$target"
  else
    printf '%s' "$content" > "$target"
  fi
}
