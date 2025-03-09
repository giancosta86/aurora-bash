# mkcd

Shortcut command that:

1. runs `mkdir -p` to ensure the passed directory chain (for example, `x/y/z`) exists

1. executes `cd` to enter the rightmost directory (`z`, in the example above)

If you have defined a custom alias for `cd`, your version will be used.

## 💡Usage

1. _Source_ the script:

   ```bash
   source $AURORA_BASH_HOME/scripts/mkcd/main.sh
   ```

1. Invoke the `mkcd` command, passing the directory you want to enter - which will be created, together with its parents, if not existing:

   ```bash
   mkcd alpha/beta/gamma/delta
   ```

## 🌐Further references

- [aurora-bash](../../README.md)
