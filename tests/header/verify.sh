source "../../scripts/strict-mode/main.sh"
source "../../scripts/crash/main.sh"
source "../../scripts/auroraDebug/main.sh"
source "../../scripts/header/main.sh"

AURORA_DEBUG=true

main() {
  checkBasicHeader
  auroraDebug "✅All tests successful!"
}

checkBasicHeader() {
  local expectedHeader
  expectedHeader=$(cat <<EOF
===============
This is a test!
===============
EOF
  )

  local actualHeader
  actualHeader="$(header "This is a test!" 2>&1)"

  auroraDebug "🔎Expected header:"
  auroraDebug "$expectedHeader"
  auroraDebug "🔎🔎🔎"
  auroraDebug
  auroraDebug "🔎Actual header:"
  auroraDebug "$actualHeader"
  auroraDebug "🔎🔎🔎"

  if [[ "$actualHeader" == "$expectedHeader" ]]
  then
    auroraDebug "✅Header generated correctly!"
  else
    crash "An incorrect header was generated!"
  fi
}

main