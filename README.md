# toast-nvim

A Neovim plugin that integrates with OpenCode to provide AI-powered code completions and modifications directly in your editor.

## Features

- Generate AI-powered code completions and modifications using OpenCode
- Context-aware code generation based on current buffer content
- Support for multiple AI models via OpenCode
- Simple and intuitive user interface

## Requirements

- Neovim 0.10+
- [OpenCode CLI](https://opencode.ai) installed and configured

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "toast",
  config = function()
    require("toast").setup({
      model = "anthropic/claude-sonnet-4-5",  -- Default model
      display_errors = false,                  -- Display error messages
    })
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'toast',
  config = function()
    require('toast').setup({
      model = "anthropic/claude-sonnet-4-5",
      display_errors = false,
    })
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'toast'
```

Then in your `init.lua`:

```lua
require('toast').setup({
  model = "anthropic/claude-sonnet-4-5",
  display_errors = false,
})
```

## Configuration

The plugin accepts the following configuration options:

```lua
require('toast').setup({
  -- The AI model to use (any model supported by OpenCode)
  model = "anthropic/claude-sonnet-4-5",
  
  -- Whether to display error messages
  display_errors = false,
})
```

## Usage

### Command

The plugin provides a `:Toast` command that you can use to generate code completions:

1. Open a file in Neovim
2. Run `:Toast`
3. Enter your prompt
4. Wait for the AI to generate the code
5. The entire buffer will be replaced with the generated code

### Keybinding

You can add a keybinding for quick access:

```lua
vim.keymap.set('n', '<leader>t', ':Toast<CR>', { desc = 'Toast: Generate completion' })
```

## License

MIT[LICENSE]
