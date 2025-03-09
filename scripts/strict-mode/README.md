# strict-mode

When imported, this script enables **safe mode**, modifying the behavior of the current shell, so that:

- Whenever a command returns an **untested error code**, the shell fails (`set -e`)

- Referencing an **unset variable** without proper handling causes an error (`set -u`)

- A failure occurs if any command within a **pipeline** fails (`set -o pipefail`)

- **Aliases** are expanded in non-interactive shells (`shopt -s expand_aliases`)

## 💡Usage

Just _source_ this script within any script or shell that should enable safe mode; for example:

```bash
source $AURORA_BASH_HOME/scripts/strict-mode/main.sh
```

## 🌐Further references

- [aurora-bash](../../README.md)
