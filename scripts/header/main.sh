header() {
  local text="$1"

  local line
  line="$(printf '=%.0s' $(seq 1 "${#text}"))"

  echo -e "$line\n$text\n$line" >&2
}