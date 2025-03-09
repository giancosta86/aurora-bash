source "${BASH_SOURCE[0]%/*}/../strict-mode/main.sh"

crash() {
  local message="$1"

  echo "❌$message" >&2
  exit 1
}