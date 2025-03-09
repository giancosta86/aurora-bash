# crash

Simple command designed to _fatally exit_ the current shell with style:

1. Prints ❌, followed by the given `message`, to **stderr**

1. Exits the shell with error code `1`

## 💡Usage

1. _Source_ the script:

   ```bash
   source $AURORA_BASH_HOME/scripts/crash/main.sh
   ```

1. Invoke the `crash` command, passing an error message:

   ```bash
   crash "The expected configuration file does not exist!"
   ```

## 🌐Further references

- [aurora-bash](../../README.md)
