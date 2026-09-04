return {
    -- Debug Engine
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI for debugging
            "rcarriga/nvim-dap-ui",
            -- Mason integration for auto-installing debuggers
            "jay-babu/mason-nvim-dap.nvim",
            "williamboman/mason.nvim",
            -- Required for nvim-dap-ui
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup mason-nvim-dap for auto-installing debuggers
            require("mason-nvim-dap").setup({
                ensure_installed = { "js-debug-adapter" },
                automatic_installation = true,
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })
            -- Setup DAP UI
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    -- Use a table to apply multiple mappings
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                -- Use default layouts
                layouts = {
                    {
                        elements = {
                            -- Elements can be strings or table with id and size keys.
                            { id = "scopes", size = 0.25 },
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size = 40, -- 40 columns
                        position = "left",
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 0.25, -- 25% of total lines
                        position = "bottom",
                    },
                },
                controls = {
                    -- Requires Neovim nightly (or 0.8 when released)
                    enabled = true,
                    -- Display controls in this element
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "↻",
                        terminate = "⏹",
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen.
                    border = "single", -- Border style. Can be "single", "double" or "rounded"
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
                render = {
                    max_type_length = nil, -- Can be integer or nil.
                    max_value_lines = 100, -- Can be integer or nil.
                },
            })

            -- Auto open/close dap-ui
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Keybindings
            vim.keymap.set("n", "<F5>", function()
                dap.continue()
            end, { desc = "Debug: Start/Continue" })

            vim.keymap.set("n", "<F10>", function()
                dap.step_over()
            end, { desc = "Debug: Step Over" })

            vim.keymap.set("n", "<F11>", function()
                dap.step_into()
            end, { desc = "Debug: Step Into" })

            vim.keymap.set("n", "<F12>", function()
                dap.step_out()
            end, { desc = "Debug: Step Out" })

            vim.keymap.set("n", "<leader>b", function()
                dap.toggle_breakpoint()
            end, { desc = "Debug: Toggle Breakpoint" })

            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })

            vim.keymap.set("n", "<leader>dr", function()
                dap.repl.open()
            end, { desc = "Debug: Open REPL" })

            vim.keymap.set("n", "<leader>dl", function()
                dap.run_last()
            end, { desc = "Debug: Run Last" })

            -- DAP UI keybindings
            vim.keymap.set("n", "<leader>du", function()
                dapui.toggle()
            end, { desc = "Debug: Toggle UI" })

            vim.keymap.set("n", "<leader>de", function()
                dapui.eval()
            end, { desc = "Debug: Eval under cursor" })

            vim.keymap.set("v", "<leader>de", function()
                dapui.eval()
            end, { desc = "Debug: Eval selection" })

            -- Configure JavaScript/TypeScript debugging with js-debug-adapter
            -- Get the mason package path safely
            local ok, mason_registry = pcall(require, "mason-registry")
            local js_debug_path

            if ok then
                local success, js_debug_package = pcall(mason_registry.get_package, mason_registry, "js-debug-adapter")
                if success and js_debug_package then
                    js_debug_path = js_debug_package:get_install_path()
                end
            end

            -- Fallback: try to find the executable in PATH or use standard mason location
            if not js_debug_path then
                js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
            end

            -- dap.adapters["pwa-node"] = {
            --     type = "server",
            --     host = "localhost",
            --     port = "${port}",
            --     executable = {
            --         command = "node",
            --         args = {
            --             js_debug_path .. "/js-debug/src/dapDebugServer.js",
            --             "${port}",
            --         },
            --     },
            -- }
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                        "${port}",
                    },
                },
            }

            dap.configurations.javascript = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    -- -- Change the debug port if 9229 is in use
                    -- port = 9230,  -- or use 0 for auto-assign
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach 9230",
                    port = 9230,
                    address = "127.0.0.1",
                    cwd = "${workspaceFolder}",
                }
            }
            dap.configurations.typescript = {
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach 9230",
                    port = 9230,
                    address = "127.0.0.1",
                    cwd = "${workspaceFolder}",
                },
            }

            dap.configurations.typescript = dap.configurations.javascript
            dap.configurations.javascriptreact = dap.configurations.javascript
            dap.configurations.typescriptreact = dap.configurations.javascript
        end,
    },
}
