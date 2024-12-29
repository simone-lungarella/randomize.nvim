<div align="center">

# Randomize.nvim

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.9+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

</div>

**Welcome!** 

If you've stumbled upon this plugin, chances are you don't need it. `randomize.nvim` was created to address a simple yet annoying problem: generating mock data to test a **REST API**.

While a quick script might work for single use cases, I needed a solution that could speed up the data generation on different `CSV` files with varying numbers of columns and diverse values requirements. Relying on scripts would have meant cluttering them with numerous if statements to account for all the variations, making the process cumbersome and error-prone.

This plugin provides an easy way to generate random values directly within [Neovim](https://neovim.io), giving you fine control over the data to ensure it's both random and meaningful.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
    "simone-lungarella/randomize.nvim",
    config = function()
        require("randomize").setup()
    end,
},
```

## Usage

### RandomizeBetween

1. Select content in different lines in Visual mode;
2. Run `:RandomizeBetween <min> <max>`;
3. The function will replace selected content with random numbers in choosen range.

https://github.com/user-attachments/assets/f7c9a360-d9b3-4467-bdb3-a409c9ebafed

### RandomizeDateBetween

1. Select content in different lines in Visual mode;
2. Run `:RandomizeDateBetween 2025-01-01 2025-12-31`;
3. The function will replace selected content with random dates in choosen range.

https://github.com/user-attachments/assets/793829e4-775e-4338-9212-d713c1279a20

## License

This plugin is licensed under the MIT License.

