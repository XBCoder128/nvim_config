return {
    {
        'milanglacier/minuet-ai.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('minuet').setup({
                lsp = {
                    enabled_ft = { 'toml', 'lua', 'cpp' },
                    -- Enables automatic completion triggering using `vim.lsp.completion.enable`
                    enabled_auto_trigger_ft = { 'cpp', 'lua' },
                },
                appearance = {
                    nerd_font_variant = 'normal',
                    kind_icons = kind_icons
                },
                provider = "openai_fim_compatible",
                provider_options = {
                    openai_fim_compatible = {
                        model = 'deepseek-chat',
                        end_point = 'https://api.deepseek.com/beta/completions',
                        api_key = function ()
                            if not os.getenv('COMPLETION_API_KEY') then
                                vim.notify_once('  COMPLETION_API_KEY is not set', 'warning')
                            end
                            return os.getenv('COMPLETION_API_KEY')
                        end,
                        name = 'Deepseek',
                        stream = true,
                        template = {
                            prompt = require('minuet.config').default_fim_prompt,
                            suffix = require('minuet.config').default_fim_suffix,
                        },
                        -- a list of functions to transform the endpoint, header, and request body
                        transform = {},
                        -- Custom function to extract LLM-generated text from JSON output
                        get_text_fn = {},
                        optional = {
                            max_tokens = 256,
                            stop = { '\n\n' },
                        },
                    }
                }
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        "petertriho/nvim-scrollbar",
    }
}
