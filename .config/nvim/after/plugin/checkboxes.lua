function CountMarkdownCheckboxes()
  -- Get visual selection range
  local _, ls, cs = unpack(vim.fn.getpos("'<"))
  local _, le, ce = unpack(vim.fn.getpos("'>"))

  -- Get selected lines
  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)

  local unchecked = 0
  local checked = 0

  for _, line in ipairs(lines) do
    unchecked = unchecked + select(2, line:gsub("%- %[% %]", ""))
    checked = checked + select(2, line:gsub("%- %[[xX]%]", ""))
  end

  -- Where to insert result (below the visual selection)
  local insert_line = le

  local total = checked + unchecked
  local percent = checked/total * 100
  local result = string.format("Total: %d/%d", checked, total)
  local result_percent  = string.format("%d%% complete", percent)

  vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { result })
  vim.api.nvim_buf_set_lines(0, insert_line + 1, insert_line + 1, false, { result_percent })
  vim.api.nvim_win_set_cursor(0, { insert_line + 2, 0 })

end

function ClearMarkdownCheckboxes()
  -- Get visual selection
  local _, ls, _ = unpack(vim.fn.getpos("'<"))
  local _, le, _ = unpack(vim.fn.getpos("'>"))

  -- Get selected lines
  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)

  -- Replace [x] or [X] with [ ]
  for i, line in ipairs(lines) do
    line = line:gsub("%[%s*[xX]%s*%]", "[ ]")
    lines[i] = line
  end

  -- Apply changes safely
  vim.schedule(function()
    vim.api.nvim_buf_set_lines(0, ls - 1, le, false, lines)
  end)
end



