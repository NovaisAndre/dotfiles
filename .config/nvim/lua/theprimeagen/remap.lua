-- Set the leader key to space
vim.g.mapleader = " "

-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-p>", vim.cmd.bp)
vim.keymap.set("n", "<C-n>", vim.cmd.bn)

-- Open parent directory using the Oil plugin
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Move selected lines of text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- Move selected line(s) down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- Move selected line(s) up

-- Join lines and keep cursor in place
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll down and center the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Scroll up and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next and center the cursor
vim.keymap.set("n", "n", "nzzzv")

-- Search previous and center the cursor
vim.keymap.set("n", "N", "Nzzzv")

-- Paste and keep the replaced text in the default register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete to black hole register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Map Ctrl-c to Esc in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Open a new tmux window using tmux-sessionizer
vim.keymap.set("n", "<C-x>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Navigate quickfix list and center the cursor
vim.keymap.set("n", "<S-d>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-u>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")  -- Go to next item in the location list
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")  -- Go to previous item in the location list

-- Replace word under cursor
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- kitty +kitten icat ~/.wallpapers/TokyoNight2.png


-- Make current file executable
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Trigger CellularAutomaton plugin commands
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>gl", "<cmd>CellularAutomaton game_of_life<CR>")
vim.keymap.set("n", "<leader>r", "<cmd>update<CR> <cmd>make<CR>")

-- Toggle between the current and the previously edited buffer
vim.keymap.set("n", "<leader>l", "<C-^>", { noremap = true, silent = true })

function CopyKittyCommand()
  local file = vim.fn.expand('<cfile>')
  if file and file ~= "" then
    -- Get the current working directory
    local cwd = vim.fn.getcwd()
    -- Construct the full file path
    local full_path = cwd .. "/" .. file
    -- Create the Kitty command
    local command = "kitty +kitten icat " .. full_path
    -- Copy the command to the clipboard
    vim.fn.setreg('+', command)
    print("Kitty command copied to clipboard: " .. command)
  else
    print("No file under cursor")
  end
end

---- Keybinding to copy the Kitty icat command to clipboard
vim.keymap.set('n', '<leader>c', ':lua CopyKittyCommand()<CR>', { noremap = true, silent = true })

function InsertCurrentDate()
    local date = os.date("%d-%m-%Y") -- Adjust the format as needed
    vim.api.nvim_put({date}, "c", true, true)
end


function InsertCurrentTime()
    local time = os.date("%T ") -- Adjust the format as needed
    vim.api.nvim_put({time}, "c", true, true)
end

function TimeDifference()
    local function time_to_seconds(time_str)
        local h, m, s = time_str:match("(%d+):(%d+):(%d+)")
        return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
    end

    local time = os.date("%H:%M:%S") -- Get current time
    local line = vim.api.nvim_get_current_line() 
    local first_word = line:match("^(%d+:%d+:%d+)") -- Extract time
    local formatted_diff_minutes = " - No Valid Time Found"

    if first_word then
        local diff_seconds = math.abs(time_to_seconds(time) - time_to_seconds(first_word))
        local diff_minutes = diff_seconds / 60
        formatted_diff_minutes = string.format(" - %.2f min", diff_minutes)
    end
    vim.api.nvim_set_current_line((line or "") .. formatted_diff_minutes)

    local buf = vim.api.nvim_get_current_buf()
    local last_line = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_buf_set_lines(buf, last_line, last_line, false, {""})
    vim.api.nvim_buf_set_lines(buf, last_line+1, last_line+1, false, {time .. " -  "})
    local last_line_number = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(0, {last_line_number, 11})
end

vim.api.nvim_set_keymap('n', '<leader>d', ':lua InsertCurrentDate()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':lua InsertCurrentTime()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':lua TimeDifference()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cj', ':ChatGPT<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':TimerlyToggle<CR>', { noremap = true, silent = true})

vim.keymap.set("n", "<leader>T", function()
  vim.fn.jobstart({"bash", os.getenv("HOME") .. "/dotfiles/.scripts/time.sh"}, {
    detach = true
  })
end, { desc = "Run time tracking script" })

vim.keymap.set("v", "<leader>cc", ":lua CountMarkdownCheckboxes()<CR>", { silent = true })
vim.keymap.set("v", "<leader>cu", ":lua ClearMarkdownCheckboxes()<CR>", { silent = true })
vim.keymap.set("v", "<leader>cs", ":lua SumVisualSelection()<CR>", { silent = true })
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({
            filter = function(client)
                return client.name == "eslint"
                --return client.name ~= "tsserver"
            end,
            timeout_ms = 3000,
        })
    end)

    vim.diagnostic.config({
        virtual_text = true,
        signs = false,
    })
  end,
})

