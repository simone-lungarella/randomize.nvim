# randomizer.nvim

A simple Neovim plugin to replace selected lines with random numbers in a specified range. Not yet usable, there is a lot of work needed still.

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use "simone-lungarella/randomizer.nvim"
```

## Usage

1. Select lines in Visual mode.
2. Run `:RandomizeBetween <min> <max>`.

Example:

- To replace selected lines with random numbers between 1 and 10:
  ```
  :RandomizeBetween 1 10
  ```

## License

This plugin is licensed under the MIT License.

