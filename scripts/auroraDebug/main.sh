auroraDebug() {
  if [[ "${AURORA_DEBUG:-}" != "true" ]]
  then
    return
  fi

  local message="${1:-}"

  echo "$message" >&2
}