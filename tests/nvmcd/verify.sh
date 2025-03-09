source "../../scripts/strict-mode/main.sh"
source "../../scripts/crash/main.sh"
source "../../scripts/auroraDebug/main.sh"
source "../../scripts/header/main.sh"
source "../../scripts/mkcd/main.sh"
source "../../scripts/nvmcd/main.sh"

alias cd='nvmcd'

NVM_DIR="$HOME/.nvm"

AURORA_DEBUG=true
AURORA_NVMCD_LAST_DIRECTORY="$HOME"

initialVersion="v13.0.0"
nvmrcVersion="v18.17.1"
packageJsonVersion="v16.14.0"

nvmrcOnlyDir="nvmrc"
packageJsonOnlyDir="package-json"
mixedContentDir="package-json-and-nvmrc"
emptyDir="no-request"

expectNodeVersion() {
  local expectedVersion="$1"

  local actualVersion
  actualVersion="$(node --version)"

  auroraDebug "🔎Expected NodeJS version: '$expectedVersion'"
  auroraDebug "🔎Actual NodeJS version: '$actualVersion'"

  if [[ "$actualVersion" == "$expectedVersion" ]]
  then
    auroraDebug "✅The expected NodeJS version is in use!"
  else
    crash "The expected NodeJS version is NOT in use!"
  fi
}

main() {
  initializeNvm
  switchToInitialVersion
  setupDirectories

  testBasicNvmrc
  testBasicPackageJson
  testBasicPackageJsonAndNvmrc

  switchToInitialVersion

  testNvmrcWithRecursion
  testPackageJsonWithRecursion
  testPackageJsonAndNvmrcWithRecursion

  testReusingTheSameVersion

  testRecursionUpToLastDirectory

  cleanup

  auroraDebug "✅All tests successful!"
}

initializeNvm() {
  if [[ -d "$NVM_DIR" ]]
  then
    auroraDebug "🎉nvm is already installed!"
  else
    auroraDebug "💭nvm is not installed - retrieving it now..."
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    auroraDebug "📥nvm retrieved!"
  fi

  if type nvm > /dev/null 2>&1
  then
    auroraDebug "🚀nvm is already configured!"
  else
    auroraDebug "💭nvm not configured - loading it now..."
    source "$NVM_DIR/nvm.sh"
    auroraDebug "🚀nvm ready!"
  fi
}

switchToInitialVersion() {
  header "Switching to the initial NodeJS version"

  nvm install --no-progress "$initialVersion"
  expectNodeVersion "$initialVersion"
}

setupDirectories() {
  mkdir -p "$nvmrcOnlyDir"
  writeNvmrcFile "$nvmrcOnlyDir"

  mkdir -p "$packageJsonOnlyDir"
  writePackageJsonFile "$packageJsonOnlyDir"

  mkdir -p "$mixedContentDir"
  writeNvmrcFile "$mixedContentDir"
  writePackageJsonFile "$mixedContentDir"
}

writeNvmrcFile() {
  local targetDirectory="$1"
  echo "$nvmrcVersion" > "$targetDirectory/.nvmrc"
}

writePackageJsonFile() {
  local targetDirectory="$1"

  local versionForJson
  versionForJson="$(echo "$packageJsonVersion" | cut -c 2-)"

  echo "{ \"engines\": { \"node\": \">=$versionForJson <90\" }}" > "$targetDirectory/package.json"
}

testBasicNvmrc() {
  header "Testing basic .nvmrc file"

  nvmcd "$nvmrcOnlyDir"

  expectNodeVersion "$nvmrcVersion"

  command cd -
}

testBasicPackageJson() {
  header "Testing basic package.json field"

  nvmcd "$packageJsonOnlyDir"

  expectNodeVersion "$packageJsonVersion"

  command cd -
}

testBasicPackageJsonAndNvmrc() {
  header "Testing with both package.json field and .nvmrc file"

  nvmcd "$mixedContentDir"

  expectNodeVersion "$nvmrcVersion"

  command cd -
}

testNvmrcWithRecursion() {
  header "Testing .nvmrc file located in an ancestor directory"

  mkcd "$nvmrcOnlyDir/alpha/beta/gamma"

  expectNodeVersion "$nvmrcVersion"

  command cd -
}

testPackageJsonWithRecursion() {
  header "Testing package.json field located in an ancestor directory"

  mkcd "$packageJsonOnlyDir/epsilon/zeta/eta"

  expectNodeVersion "$packageJsonVersion"

  command cd -
}

testPackageJsonAndNvmrcWithRecursion() {
  header "Testing with both version sources located in an ancestor directory"

  mkcd "$mixedContentDir/ro/sigma/tau"

  expectNodeVersion "$nvmrcVersion"

  command cd -
}

testReusingTheSameVersion() {
  header "Testing the request via .nvmrc once more"

  expectNodeVersion "$nvmrcVersion"

  mkcd "$mixedContentDir/ro/sigma"

  expectNodeVersion "$nvmrcVersion"

  command cd -
}

testRecursionUpToLastDirectory() {
  header "Testing recursion stop"

  switchToInitialVersion

  mkcd "$emptyDir/psi/omega"

  expectNodeVersion "$initialVersion"

  command cd -
}

cleanup() {
  auroraDebug "🧹Cleaning up in '$PWD'..."
  rm -rf "$emptyDir"
  rm -rf "$nvmrcOnlyDir"
  rm -rf "$packageJsonOnlyDir"
  rm -rf "$mixedContentDir"
}

main