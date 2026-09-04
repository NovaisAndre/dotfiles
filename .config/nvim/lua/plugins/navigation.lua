return {
    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzy-native.nvim",
                build = "make",
            },
            "nvim-telescope/telescope-live-grep-args.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "jsongerber/telescope-ssh-config",
        },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fw', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)

            vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>po", builtin.oldfiles, {})
            vim.keymap.set("n", "<leader>plb", function()
                builtin.git_branches({ show_remote_tracking_branches = false })
            end, {})

            vim.keymap.set("n", "<leader>plrb", builtin.git_branches, {})
            vim.keymap.set("n", "<leader>pgg", require("telescope").extensions.live_grep_args.live_grep_args)
            vim.keymap.set("n", "<leader>pgs", builtin.grep_string, {})
            vim.keymap.set("n", "<leader>ph", builtin.help_tags, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>fc', '<cmd>Telescope ssh-config<CR>', { desc = 'Open an ssh connexion' })
            vim.keymap.set("n", "<leader>ps", builtin.lsp_document_symbols, {})
            vim.keymap.set("n", "<leader>pc", builtin.commands, {})

            require("telescope").setup({
                defaults = require("telescope.themes").get_dropdown({
                    file_ignore_patterns = {},
                    hidden = true,
                    file_sorter = require("telescope.sorters").get_fzy_sorter,
                    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                    layout_strategy = "vertical",
                    layout_config = {
                        bottom_pane = {
                            height = 25,
                            preview_cutoff = 120,
                            prompt_position = "top"
                        },
                        center = {
                            height = 0.4,
                            preview_cutoff = 40,
                            prompt_position = "top",
                            width = 0.5
                        },
                        cursor = {
                            height = 0.9,
                            preview_cutoff = 40,
                            width = 0.8
                        },
                        horizontal = {
                            height = 80,
                            preview_cutoff = 80,
                            prompt_position = "bottom",
                            width = 80
                        },
                        vertical = {
                            height = 0.9,
                            prompt_position = "top",
                            width = 80
                        }
                    },
                    mappings = {
                        i = {
                            ["<C-x>"] = false,
                            ["<C-y>"] = require('telescope.actions').select_default,
                            ["<CR>"] = false,
                        },
                    },
                }),
                extensions = {
                    fzy_native = {
                        override_generic_sorter = false,
                        override_file_sorter = true,
                    },
                    ["ui-select"] = {
                        specific_opts = {
                            codeactions = false,
                        },
                    },
                    ['ssh-config'] = {
                        client = 'oil',
                        ssh_config_path = '~/.ssh/config',
                    },
                },
            })

            require("telescope").load_extension("fzy_native")
            require("telescope").load_extension("live_grep_args")
            require("telescope").load_extension("ui-select")
            require("telescope").load_extension('ssh-config')
        end,
    },

    -- File Explorer
    {
        'stevearc/oil.nvim',
        opts = {
            keymaps = {
                ["<C-y>"] = "actions.select",
            },
            view_options = {
                show_hidden = true,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, ".")
                end,
                is_always_hidden = function(name, bufnr)
                    return false
                end,
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Undo Tree
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },
}
