return {
    -- Colorschemes
    "folke/tokyonight.nvim",
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    -- UI Components
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",

    -- Visual enhancements
    {
        'norcalli/nvim-colorizer.lua',
        event = 'VeryLazy',
        config = function()
            require("colorizer").setup()
        end
    },
}
