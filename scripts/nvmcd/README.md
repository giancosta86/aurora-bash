# nvmcd

Just like the original `cd` command, but also looks for a **NodeJS** version request (in a `.nvmrc` file, in `package.json`, ...) within the target directory and its ancestors: if such request is found, run [nvm](https://github.com/nvm-sh/nvm) to install and use it.

## 💡Usage

1. _Source_ the script:

   ```bash
   source $AURORA_BASH_HOME/scripts/nvmcd/main.sh
   ```

1. Invoke the `nvmcd` command - which will initially forward its arguments to the native `cd` command:

   ```bash
   nvmcd some/target/directory
   ```

1. After switching to the requested directory:

   1. If a `.nvmrc` file exists, its content becomes the requested NodeJS version

   1. Otherwise, if a `package.json` file exists, its `engines.node` field becomes the requested NodeJS version - after stripping any leading non-digit characters, then considering only the first version-related block.

      For example, given this block within **package.json**:

      ```json
      {
        "engines": {
          "node": ">=16.14.0 <20"
        }
      }
      ```

      will request version `v16.14.0`.

1. If no version is found in the target directory, _it remains the current directory_, but the scan continues to the parent directory - recursively up to:

   - the file system root, by default

   - the directory referenced by the `AURORA_NVMCD_LAST_DIRECTORY` variable, if set: no more directories will be scanned after it

1. If no requested NodeJS version was found, the algorithm ends here; otherwise, `nvm` is called to detect the NodeJS version currently used by the shell: if it matches the requested version, the algorithm ends.

1. Finally, if the requested NodeJS version is not installed in the system, `nvm install` will install and use it; otherwise `nvm use` will be invoked.

### Setting as the default cd

You can turn `nvmcd` into your default `cd` command just by adding these lines to your `~/.bashrc` file:

1. Source the script:

   ```bash
   source $AURORA_BASH_HOME/scripts/nvmcd/main.sh
   ```

1. Declare `cd` as an alias for `nvmcd`:

   ```bash
   alias cd='nvmcd'
   ```

## ☑️Requirements

The following commands are required:

- `jq` - to parse JSON files

- `nvm` - to install NodeJS versions and switch from one to another

## 🤹Environment variables:

- `AURORA_DEBUG`: when set to **true**, enables debug logging

- `AURORA_NVMCD_LAST_DIRECTORY`: when set, it must contain the **absolute path** of the **last** directory considered by the recursive algorithm described above; it is especially useful in shared CI/CD environment

## 🌐Further references

- [nvm](https://github.com/nvm-sh/nvm) - Node Version Manager

- [aurora-bash](../../README.md)
