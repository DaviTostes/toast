vim.api.nvim_create_user_command("Toast", function()
  require "toast".generate_completion()
end, {})
