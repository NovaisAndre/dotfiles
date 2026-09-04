function SumVisualSelection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos   = vim.fn.getpos("'>")

  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Trim to exact selection (still good to keep)
  lines[1] = string.sub(lines[1], start_pos[3])
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

  local sum = 0

  for _, line in ipairs(lines) do
    local num = line:match("^%s*([-]?%d+)")
    if num then
      sum = sum + tonumber(num)
    end
  end

  -- Insert total right below selection
  vim.api.nvim_buf_set_lines(
    0,
    end_pos[2],
    end_pos[2],
    false,
    { "Total: " .. sum }
  )
  vim.api.nvim_win_set_cursor(0, { end_pos[2] + 2, 0 })
end

