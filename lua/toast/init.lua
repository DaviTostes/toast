local M = {}

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

  local user_prompt = vim.fn.input("Prompt: ")

  local filetype = vim.bo.filetype

  local prompt = table.concat({
    "Language: " .. filetype,
    "",
    "Code to be modified:",
    content,
    "",
    "User request: " .. user_prompt,
    "",
    "Rules:",
    "- Return only the code to be replaced, nothing more",
    "- If there's something to add that is not code, make it as comments",
    "- No markdown code blocks",
    "- Preserve original indentation",
  }, "\n")

  vim.system(
    { "opencode", "-m", M.config.model, "run", prompt },
    { text = true },
    function(obj)
      local new_lines = vim.split(obj.stdout, "\n")

      vim.schedule(function()
        vim.api.nvim_buf_set_lines(0, 0, -1, true, new_lines)
        vim.notify("Completion finished")
      end)
    end
  )
end

return M
