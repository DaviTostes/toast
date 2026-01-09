# toast-nvim

A Neovim plugin that integrates with OpenCode to provide AI-powered code transformations and modifications directly in your editor.

## Features

- AI-powered code transformations using OpenCode CLI
- Context-aware code generation based on current buffer or visual selection
- Support for all AI models available through OpenCode
- Beautiful modal UI with loading indicator and animated spinner
- Deterministic code transformation with no markdown formatting
- Works on entire buffer or visual selections
- Language-aware prompts that respect your filetype

## Requirements

- Neovim 0.10+
- [OpenCode CLI](https://opencode.ai) installed and configured

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "davitostesos/toast-nvim",
  config = function()
    require("toast").setup({
      model = "anthropic/claude-sonnet-4-5",
    })
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'davitostesos/toast-nvim',
  config = function()
    require('toast').setup({
      model = "anthropic/claude-sonnet-4-5",
    })
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'davitostesos/toast-nvim'
```

## Configuration

The plugin accepts the following configuration options:

```lua
require('toast').setup({
  -- The AI model to use (any model supported by OpenCode)
  model = "anthropic/claude-sonnet-4-5",
})
```

## Usage

### Command

The plugin provides a `:Toast` command that you can use to transform code:

1. Open a file in Neovim
2. Optionally, select code in visual mode to transform only that selection
3. Run `:Toast`
4. Enter your transformation request in the modal window (press `<CR>` or `<C-CR>` to submit, `q` or `<Esc>` to cancel)
5. Wait for the AI to generate the transformed code
6. The selected region (or entire buffer) will be replaced with the generated code

### Modal Controls

When the input modal appears:
- `<CR>` (normal mode) - Submit the request
- `<C-CR>` (insert or normal mode) - Submit the request
- `q` (normal mode) - Cancel
- `<Esc>` (normal mode) - Cancel

### Visual Mode

Toast works seamlessly with visual selections:

```lua
-- Select code in visual mode, then run :Toast
vim.keymap.set('v', '<leader>t', ':Toast<CR>', { desc = 'Toast: Transform selection' })
```

### Keybinding Examples

```lua
-- Transform entire buffer
vim.keymap.set('n', '<leader>t', ':Toast<CR>', { desc = 'Toast: Transform buffer' })

-- Transform visual selection
vim.keymap.set('v', '<leader>t', ':Toast<CR>', { desc = 'Toast: Transform selection' })
```
