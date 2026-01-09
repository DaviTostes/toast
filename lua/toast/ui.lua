local ui = {}

function ui.open_input_modal(opts, callback)
  local buf = vim.api.nvim_create_buf(false, true)

  local width = opts.width or 60
  local height = opts.height or 10

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = opts.title or " Input ",
    title_pos = "center",
  })

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = opts.filetype or "markdown"
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  if opts.default then
    local lines = vim.split(opts.default, "\n")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end

  vim.cmd("startinsert")

  local function close(submit)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    if submit then
      callback(table.concat(lines, "\n"))
    else
      callback(nil)
    end
  end

  vim.keymap.set("n", "<CR>", function() close(true) end, { buffer = buf })
  vim.keymap.set("n", "q", function() close(false) end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() close(false) end, { buffer = buf })
  vim.keymap.set({ "i", "n" }, "<C-CR>", function() close(true) end, { buffer = buf })
end

function ui.open_loading_modal()
  local buf = vim.api.nvim_create_buf(false, true)

  local width = 40
  local height = 3

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " Loading ",
    title_pos = "center",
  })

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false
  vim.wo[win].wrap = false

  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local message = "Please wait..."
  local frame_idx = 1
  local timer = nil

  local function update_display()
    vim.bo[buf].modifiable = true
    local display = frames[frame_idx] .. " " .. message
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "", display })
    vim.bo[buf].modifiable = false
    frame_idx = frame_idx % #frames + 1
  end

  update_display()

  timer = vim.loop.new_timer()
  timer:start(0, 100, vim.schedule_wrap(function()
    if vim.api.nvim_win_is_valid(win) then
      update_display()
    else
      timer:stop()
      timer:close()
    end
  end))

  return function()
    if timer then
      timer:stop()
      timer:close()
    end
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

return ui

