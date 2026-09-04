vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.showmode = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.makeprg = "python3 %"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.makeprg = "go build ./..."
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt_local.makeprg = "node %"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescript",
  callback = function()
    vim.opt_local.errorformat = {
      "%E%f:%l:%c - error %m",
      "%W%f:%l:%c - warning %m",
    }
    vim.opt_local.makeprg = "FORCE_COLOR=0 npm run test:e2e -- % --color=false --verbose --noStackTrace --silent --testLocationInResults"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    local filename = vim.api.nvim_buf_get_name(0)
    if filename:match("lint") then 
        vim.opt_local.makeprg = "npm run lint --silent"
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.makeprg = "cargo run"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local input = vim.fn.expand("%")
    local output = vim.fn.expand("%:r") .. ".pdf"

    vim.opt_local.makeprg = string.format(
        "pandoc %s -o %s && zathura %s &",
        input,
        output,
        output
    )
  end,
})



-- vim.opt.winbar = "%f"

