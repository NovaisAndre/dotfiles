local ok, oil = pcall(require, "oil")
if not ok then return end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(args)
    local bufnr = args.buf

    vim.keymap.set("n", "<CR>", function()
      local entry = oil.get_cursor_entry()
      if not entry or entry.type ~= "file" then
        return oil.select()
      end

      local name = entry.name:lower()
      local is_image = name:match("%.png$")
        or name:match("%.jpe?g$")
        or name:match("%.gif$")
        or name:match("%.webp$")
        or name:match("%.svg$")
      local is_audio = name:match("%.mp3$")
        or name:match("%.wav$")
        or name:match("%.ogg$")
        or name:match("%.flac$")
        or name:match("%.m4a$")
        or name:match("%.opus$")
      local is_pdf = name:match("%.pdf$")

      local dir = oil.get_current_dir()
      if not dir then return end
      local fullpath = vim.fs.joinpath(dir, entry.name)
      local escaped_path = vim.fn.fnameescape(fullpath)

      if is_audio then
        -- open audio with mpv in background
        vim.fn.jobstart({ "pkill", "-f", "mpv" })
        vim.fn.jobstart({ "mpv", "--no-terminal", escaped_path }, { detach = true })

        vim.fn.jobstart({ "mpv", "--no-terminal", escaped_path }, { detach = true })
        vim.notify("🎵 Playing: " .. entry.name, vim.log.levels.INFO)
        return
      end

      if is_pdf then
        vim.fn.jobstart({ "zathura", fullpath }, { detach = true })
        vim.notify("Opened: " .. entry.name, vim.log.levels.INFO)
        return
      end

      if not is_image then
        return oil.select()
      end

      local oil_win = vim.api.nvim_get_current_win()

      -- find existing preview window
      local preview_win = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ok_var, is_preview = pcall(vim.api.nvim_buf_get_var, buf, "oil_is_preview")
        if ok_var and is_preview == true and vim.api.nvim_win_is_valid(win) then
          preview_win = win
          break
        end
      end

      if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
        -- create preview window on the right and open the image there
        vim.cmd("rightbelow vsplit")
        vim.cmd("edit " .. escaped_path)

        local cur_win = vim.api.nvim_get_current_win()
        local cur_buf = vim.api.nvim_get_current_buf()
        pcall(vim.api.nvim_buf_set_var, cur_buf, "oil_is_preview", true)
        pcall(vim.api.nvim_win_set_width, cur_win, 80)
      else
        -- reuse existing preview window
        vim.api.nvim_set_current_win(preview_win)
        vim.cmd("edit " .. escaped_path)
        local cur_buf = vim.api.nvim_win_get_buf(preview_win)
        pcall(vim.api.nvim_buf_set_var, cur_buf, "oil_is_preview", true)
      end

      -- return focus to oil window
      if vim.api.nvim_win_is_valid(oil_win) then
        vim.api.nvim_set_current_win(oil_win)
      end
    end, { buffer = bufnr, noremap = true, silent = true })
  end,
})

