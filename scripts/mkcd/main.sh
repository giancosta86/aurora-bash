source "${BASH_SOURCE[0]%/*}/../auroraDebug/main.sh"

mkcd() {
  local directory="$1"

  auroraDebug "📁Ensuring directory exists: '$directory'..."
  mkdir -p "$directory"

  auroraDebug "🚪Now entering directory: '$directory'"
  eval cd "$directory"
}
