# Exit on error
set -e

# Treat unset variables as an error
set -u

# Exit if any command in a pipeline fails
set -o pipefail

# Expand aliases in a non-interactive shell
shopt -s expand_aliases