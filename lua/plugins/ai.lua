return {
    -- {
    --     'milanglacier/minuet-ai.nvim',
    --     dependencies = { 'nvim-lua/plenary.nvim' },
    --     config = function()
    --         require('minuet').setup({
    --             lsp = {
    --                 enabled_ft = { 'toml', 'lua', 'cpp' },
    --                 enabled_auto_trigger_ft = { 'cpp', 'lua' },
    --             },
    --             virtualtext = {
    --                 auto_trigger_ft = { 'cpp', 'lua' },
    --             },
    --             blink = { enable_auto_complete = true },
    --             provider = "openai_fim_compatible",
    --             provider_options = {
    --                 openai_fim_compatible = {
    --                     model = 'Qwen3-Coder-30B-A3B-Instruct',
    --                     end_point = "https://open.bigmodel.cn/api/paas/v4/completions",
    --                     api_key = function ()
    --                         if not os.getenv('COMPLETION_API_KEY') then
    --                             vim.notify_once('  COMPLETION_API_KEY is not set', 'warning', { title = 'minuet' })
    --                         end
    --                         return os.getenv('COMPLETION_API_KEY')
    --                     end,
    --                     name = 'glm-5',
    --                     stream = true,
    --                     template = {
    --                         prompt = function(context_before_cursor, context_after_cursor, _)
    --                             return '<|fim_prefix|>'
    --                                 .. context_before_cursor
    --                                 .. '<|fim_suffix|>'
    --                                 .. context_after_cursor
    --                                 .. '<|fim_middle|>'
    --                         end,
    --                         suffix = false,
    --                     },
    --                     optional = {
    --                         max_tokens = 2048,
    --                         top_p = 0.9,
    --                     },
    --                 }
    --             }
    --         })
    --     end,
    -- },
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        opts = {
            display = {
                chat = {
                    window = {
                        -- layout = "float",
                        -- position = "right",
                        width = 0.3,
                    }
                }
            },
            strategies = {
                chat = {
                    adapter = "qwen_code",
                    model = 'Qwen3-Coder-30B-A3B-Instruct',
                    keymaps = {
                        send = {
                            modes = { n = "<A-s>", i = "<A-s>" },
                            opts = {},
                        },
                        close = {
                            modes = { n = "<A-c>", i = "<A-c>" },
                            opts = {},
                        },
                    },
                    window = {
                        layout = "float",
                        -- position = "right",
                        width = 0.2,
                    }
                },
                inline = {
                    adapter = "qwen_code",
                    keymaps = {
                        accept_change = {
                            modes = { n = "<leader>a" },
                            description = "Accept the suggested change",
                        },
                        reject_change = {
                            modes = { n = "<leader>r" },
                            opts = { nowait = true },
                            description = "Reject the suggested change",
                        },
                    },
                },
            },
            adapters = {
                http = {
                    qwen_code = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            env = {
                                url = "https://open.bigmodel.cn/api/paas/v4",
                                api_key = function ()
                                    if not os.getenv('COMPLETION_API_KEY') then
                                        vim.notify_once('  COMPLETION_API_KEY is not set', 'warning', { title = 'minuet' })
                                    end
                                    return os.getenv('COMPLETION_API_KEY')
                                end,
                                chat_url = "/chat/completions",
                            },
                            schema = {
                                model = {
                                    default = "glm-5",
                                },
                            },
                        })
                    end,
                },
            },
        },
        keys = {
            {
                "<leader>cc",
                function()
                    require("codecompanion").toggle_chat()
                end,
                desc = "Code Companion（开/折，会话保留）",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
