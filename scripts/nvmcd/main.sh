source "${BASH_SOURCE[0]%/*}/../strict-mode/main.sh"
source "${BASH_SOURCE[0]%/*}/../auroraDebug/main.sh"

nvmcd() {
  command cd "$@"

  local startDirectory
  startDirectory="$(realpath .)"

  auroraDebug "🔎Start directory: '$startDirectory'"

  local requestedNodeVersion
  requestedNodeVersion="$(_findRequestedNodeVersionRecursively "$startDirectory")"

  auroraDebug "🔎Requested NodeJS version: '$requestedNodeVersion'"

  if [[ -n "$requestedNodeVersion" ]]
  then
    _useNodeVersion "$requestedNodeVersion"
  else
    auroraDebug "💭No version request was found for NodeJS up the directory tree!"
  fi
}

_findRequestedNodeVersionRecursively() {
  local currentDirectory="$1"

  auroraDebug "📁Now scanning: '$currentDirectory'"

  local nodeVersionInCurrentDirectory
  nodeVersionInCurrentDirectory="$(_getRequestedNodeVersion "$currentDirectory")"

  if [[ -n "$nodeVersionInCurrentDirectory" ]]
  then
    echo "$nodeVersionInCurrentDirectory"
    return
  else
    auroraDebug "💭NodeJS requests not found in this directory"
  fi

  if [[ "$currentDirectory" == "${AURORA_NVMCD_LAST_DIRECTORY:-}" ]]
  then
    auroraDebug "🛑Recursive search stops at this directory, as requested"
    return
  fi

  local nextDirectory
  nextDirectory="$(realpath "$currentDirectory/..")"

  if [[ "$nextDirectory" != "$currentDirectory" ]]
  then
    auroraDebug "▲ Moving to the parent directory..."
    _findRequestedNodeVersionRecursively "$nextDirectory"
  fi
}

_getRequestedNodeVersion() {
  local directory="$1"

  local versionFromNvmrc
  versionFromNvmrc="$(_getRequestedNodeVersionFromNvmrc "$directory")"

  if [[ -n "$versionFromNvmrc" ]]
  then
    auroraDebug "NodeJS version found in $directory/.nvmrc! Version: '$versionFromNvmrc'"
    echo "$versionFromNvmrc"
    return
  fi

  local versionFromPackageJson
  versionFromPackageJson="$(_getRequestedNodeVersionFromPackageJson "$directory")"

  if [[ -n "$versionFromPackageJson" ]]
  then
    auroraDebug "NodeJS version found in $directory/package.json! Version: '$versionFromPackageJson'"
    echo "$versionFromPackageJson"
    return
  fi
}

_getRequestedNodeVersionFromNvmrc() {
  local directory="$1"

  local nvmrcPath="$directory/.nvmrc"

  if [[ -f "$nvmrcPath" ]]
  then
    cat "$nvmrcPath"
  fi
}

_getRequestedNodeVersionFromPackageJson() {
  local directory="$1"

  local packageJsonPath="$directory/package.json"

  if [[ -f "$packageJsonPath" ]]
  then
    local nodeVersionField
    nodeVersionField="$(jq -r '.engines.node // ""' "$packageJsonPath")"

    if [[ -n "$nodeVersionField" ]]
    then
      auroraDebug "🔎Node version field in package.json: '$nodeVersionField'"

      local extrapolatedVersion
      extrapolatedVersion="$(echo "$nodeVersionField" | perl -pe 's/.*?(\d+(?:\.\d+)*).*/$1/')"
      auroraDebug "🔎Extrapolated version: '$extrapolatedVersion'"

      echo "v${extrapolatedVersion}"
    fi
  fi
}

_useNodeVersion() {
  local requestedVersion="$1"
  auroraDebug "📦NodeJS version to use: $requestedVersion"

  local currentVersion
  currentVersion="$(nvm current)"

  auroraDebug "🔮Current NodeJS version: '$currentVersion'"

  if [[ "$requestedVersion" == "$currentVersion" ]]
  then
    auroraDebug "🍀No need to call nvm - the NodeJS version is already the one expected!"
    return
  fi


  if [[ "$(nvm ls --no-colors "$requestedVersion" | command tail -1 | command tr -d '\->*' | command tr -d '[:space:]')" == "N/A" ]]
  then
    auroraDebug "📥Now installing and using NodeJS $requestedVersion..."
    nvm install --no-progress "$requestedVersion"
  else
    auroraDebug "⚙Now switching to NodeJS $requestedVersion..."
    nvm use "$requestedVersion"
  fi
}
