local oil = require("oil")

-- Override <CR> in oil to preview images
vim.keymap.set("n", "<CR>", function()
  local entry = oil.get_cursor_entry()
  if not entry then return end

  local fname = entry.name
  local dir = oil.get_current_dir()
  if not dir then return end
  print(fname)

  -- Only handle image files
  if fname:match("%.png$") or fname:match("%.jpg$") or fname:match("%.jpeg$") or fname:match("%.gif$") then
    local fullpath = vim.fs.joinpath(dir, fname)

    -- open preview split
    vim.cmd("vsplit")
    vim.cmd("enew")

    local Image = require("image")
    Image.from_file(fullpath, {
      buffer = 0,
      x = 0,
      y = 0,
      width = 60,
      height = 30,
    })
  else
    -- fallback: default oil action (open file / enter dir)
    oil.select()
  end
end, { buffer = true })

