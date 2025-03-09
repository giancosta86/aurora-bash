source "../../scripts/strict-mode/main.sh"
source "../../scripts/crash/main.sh"
source ./constants.sh

crash "$errorMessage" 2> "$errorOutputPath"

