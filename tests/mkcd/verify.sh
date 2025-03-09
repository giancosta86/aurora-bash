source "../../scripts/strict-mode/main.sh"
source "../../scripts/crash/main.sh"
source "../../scripts/header/main.sh"
source "../../scripts/mkcd/main.sh"

AURORA_DEBUG=true

main() {
  testSingleNewDirectory

  testMultipleNewDirectories

  testExistingDirectories

  cleanup

  auroraDebug "✅All the tests are successful!"
}

expectToBeInDirectory() {
  local expectedDirectoryName
  expectedDirectoryName="$(basename "$1")"

  local currentDirectoryName
  currentDirectoryName="$(basename "$PWD")"

  if [[ "$currentDirectoryName" == "$expectedDirectoryName" ]]
  then
    auroraDebug "✅Now within the directory named: '$expectedDirectoryName'!"
  else
    crash "Not within the directory named: '$expectedDirectoryName'!"
  fi
}

testCase() {
  local headerText="$1"
  local directory="$2"

  header "$headerText"

  mkcd "$directory"

  expectToBeInDirectory "$directory"

  cd -
}

testSingleNewDirectory() {
  testCase "Testing creation of a single directory" "alpha"
}

testMultipleNewDirectories() {
  testCase "Testing creation of multiple directories" "ro/sigma/tau"
}

testExistingDirectories() {
  local testDirectory="ro/sigma/tau"

  if [[ ! -d "$testDirectory" ]]
  then
    crash "The test expects that directory '$testDirectory' exists!"
  fi

  testCase "Testing on multiple existing directories" "$testDirectory"
}

cleanup() {
  auroraDebug "🧹Cleaning up..."
  rm -rf alpha
  rm -rf ro
}

main