return {
    -- Key helper
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },

    -- Syntax Highlighting (currently using default config)
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        -- config = function()
        --     require'nvim-treesitter.configs'.setup {
        --         sync_install = false,
        --         auto_install = false,
        --         ignore_install = { "latex", "tex" },
        --         highlight = {
        --             enable = true,
        --             disable = { "latex", "tex" },
        --             additional_vim_regex_highlighting = false,
        --         },
        --     }
        -- end,
    },

    -- Utility library (dependency for many plugins)
    "nvim-lua/plenary.nvim",

    -- Formatting
    "prettier/vim-prettier",
}
