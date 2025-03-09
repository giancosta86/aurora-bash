# auroraDebug

Outputs the given message to **stderr**, but _only_ if the `AURORA_DEBUG` environment variable exists and is set to **true** - otherwise, the command does _nothing_.

## 💡Usage

1. _Source_ the script:

   ```bash
   source $AURORA_BASH_HOME/scripts/auroraDebug/main.sh
   ```

1. Enable the `AURORA_DEBUG` environment variable, if you want the message to appear:

   ```bash
   AURORA_DEBUG=true
   ```

1. Invoke the `auroraDebug` command, passing the message you want to log to **stderr**:

   ```bash
   auroraDebug "Now in: '$PWD'"
   ```

## 🌐Further references

- [aurora-bash](../../README.md)
