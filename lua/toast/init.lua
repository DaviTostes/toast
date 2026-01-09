local M = {}

local ui = require "toast.ui"
local p = require "toast.prompt"
local utils = require "toast.utils"

M.config = {
  model = "anthropic/claude-sonnet-4-5",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.generate_completion()
  local lines = {}
  local start_line = 0
  local end_line = -1
  local buf = vim.api.nvim_get_current_buf()

  local is_visual = vim.fn.visualmode() ~= ""
  if is_visual then
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>")
  end

  lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)

  if #lines == 0 then
    vim.notify("Any content found")
    return
  end

  local content = table.concat(lines, "\n")
  local filetype = vim.bo.filetype

  ui.open_input_modal({
    title = " " .. M.config.model .. " ",
    width = 80,
    height = 5,
  }, function(input)
    if not input then
      vim.notify("Input not valid")
      return
    end
    local prompt = p.get_prompt(filetype, content, input)

    local close_loading_modal = ui.open_loading_modal()

    vim.system(
      { "opencode", "-m", M.config.model, "run", prompt },
      { text = true },
      function(result)
        vim.schedule(function()
          close_loading_modal()

          if result.code ~= 0 then
            vim.notify(result.stderr, vim.log.levels.ERROR)
            return
          end

          local output = utils.strip_markdown_blocks(result.stdout)

          local new_lines = vim.split(output, "\n")
          vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, new_lines)
        end)
      end
    )
  end)
end

return M
