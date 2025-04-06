crash() {
  local message="$1"

  echo "❌$message" >&2
  exit 1
}