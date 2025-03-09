source "../../scripts/strict-mode/main.sh"
source ./constants.sh

main() {
  checkScriptActuallyFailed

  checkMessageWasWrittenToStderr

  checkMessageHasTheExpectedFormat

  cleanup

  echo "✅The error in the log was just as expected!"
}

checkScriptActuallyFailed() {
  if bash "failing-script.sh"
  then
    echo "❌The failing script should have non-zero exit code!"
    exit 1
  fi
}

checkMessageWasWrittenToStderr() {
  if [[ ! -f "$errorOutputPath" ]]
  then
    echo "❌No message was written to stderr!"
    exit 1
  fi
}

checkMessageHasTheExpectedFormat() {
  local expectedError="❌$errorMessage"

  local receivedError
  receivedError="$(cat "$errorOutputPath")"

  echo "🔎Expected error in the log: '$expectedError'"
  echo "🔎Error found in the log: '$receivedError'"

  if [[ "$receivedError" != "$expectedError" ]]
  then
    echo "❌The two error values do not match!"
    exit 1
  fi
}

cleanup() {
  echo "🧹Cleaning up..."
  rm -f "$errorOutputPath"
}

main
