local M = {}

local ui = require("toast.ui")

M.config = {
  model = "anthropic/claude-sonnet-4-5",
  display_errors = false,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.generate_completion()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  ui.open_input_modal({
    title = " " .. M.config.model .. " ",
    width = 80,
    height = 5,
  }, function(input)
    if not input then
      vim.notify("Input not valid")
      return
    end

    local filetype = vim.bo.filetype

    local prompt = table.concat({
      "Language: " .. filetype,
      "",
      "Code to be modified:",
      content,
      "",
      "User request: " .. input,
      "",
      "Rules:",
      "- Return only the code to be replaced, nothing more",
      "- If there's something to add that is not code, make it as comments",
      "- No markdown code blocks",
      "- Preserve original indentation",
    }, "\n")

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

          local new_lines = vim.split(result.stdout, "\n")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
        end)
      end
    )
  end)
end

return M
