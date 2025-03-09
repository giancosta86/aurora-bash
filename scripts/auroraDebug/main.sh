source "${BASH_SOURCE[0]%/*}/../strict-mode/main.sh"

auroraDebug() {
  if [[ "${AURORA_DEBUG:-}" != "true" ]]
  then
    return
  fi

  local message="${1:-}"

  echo "$message" >&2
}