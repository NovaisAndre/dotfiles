return {
    -- Time tracking
    'wakatime/vim-wakatime',

    -- Fun stuff
    'eandrju/cellular-automaton.nvim',

    -- Show key presses on screen
    {
        'nvzone/showkeys',
        cmd = "ShowkeysToggle",
        opts = {
            position = "bottom-left",
            maxkeys = 5,
            show_count = true,
        }
    },

    -- Volt (dependency for nvzone plugins)
    "nvzone/volt",

    -- Pomodoro Timer
    {
        "nvzone/timerly",
        cmd = "TimerlyToggle",
        config = {
            minutes = { 50, 10 },
            on_start = nil,
            on_finish = function()
                vim.notify "Timerly: time's up!"
            end,
            mapping = nil,
            position = "bottom-right",
        },
    },
}
