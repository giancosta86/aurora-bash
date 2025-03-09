source "../../scripts/strict-mode/main.sh"
source "../../scripts/crash/main.sh"
source "../../scripts/auroraDebug/main.sh"

sourceMessage="Hello, world!"

main() {
  testWithVariableSetToTrue

  testWithVariableSetToFalse

  testWithVariableUnset

  echo "✅All tests successful!"
}

testCase() {
  local description="$1"
  local expectedMessage="$2"

  echo "*** 🎭$description ***"

  local printedMessage
  printedMessage="$(auroraDebug "$sourceMessage" 2>&1 >/dev/null)"

  echo "📤Source message: '$sourceMessage'"
  echo "🔎AURORA_DEBUG: '${AURORA_DEBUG:-}'"
  echo "🔎Expected message: '$expectedMessage'"
  echo "🔎Printed message: '$printedMessage'"

  if [[ "$printedMessage" == "$expectedMessage" ]]
  then
    echo "✅The debug message has the expected value!"
  else
    crash "The debug message is not the one expected!"
  fi
}

testWithVariableSetToTrue() {
  AURORA_DEBUG=true

  testCase "Testing with AURORA_DEBUG set to true" "$sourceMessage"
}

testWithVariableSetToFalse() {
  AURORA_DEBUG=false

  testCase "Testing with AURORA_DEBUG set to false" ""
}

testWithVariableUnset() {
  unset AURORA_DEBUG

  testCase "Testing with AURORA_DEBUG unset" ""
}

main