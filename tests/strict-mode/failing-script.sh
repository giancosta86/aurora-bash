source "../../scripts/strict-mode/main.sh"
source ./constants.sh

INEXISTING_COMMAND

echo "This file should not be generated!" > "$unexpectedOutputPath"

