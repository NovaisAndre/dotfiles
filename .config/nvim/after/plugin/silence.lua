local orig_notify = vim.notify

vim.notify = function(msg, level, opts)
  if type(msg) == "string" then
    if msg:match("Invalid 'end_col'") or msg:match("Invalid 'end_row'") then
      return
    end
  end
  orig_notify(msg, level, opts)
end

do
  local orig = vim.api.nvim_buf_set_extmark
  vim.api.nvim_buf_set_extmark = function(...)
    local ok, result = pcall(orig, ...)
    if ok then
      return result
    else
      -- swallow extmark errors like "Invalid 'end_col'"
      return nil
    end
  end
end
