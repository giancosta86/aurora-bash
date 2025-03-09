source "../../scripts/strict-mode/main.sh"
source ./constants.sh

main() {
  checkScriptActuallyFailed

  checkScriptDidNotRunEntirely

  cleanup

  echo "✅The script with strict-mode enabled was immediately terminated when executing a wrong command!"
}

checkScriptActuallyFailed() {
  if bash "failing-script.sh"
  then
    echo "❌The failing script should have non-zero exit code!" >&2
    exit 1
  fi
}

checkScriptDidNotRunEntirely() {
  if [[ -f "$unexpectedOutputPath" ]]
  then
    echo "❌The failing script should exit before creating its file!" >&2
    exit 1
  fi
}

cleanup() {
  echo "🧹Cleaning up..."
  rm -f "$unexpectedOutputPath"
}

main