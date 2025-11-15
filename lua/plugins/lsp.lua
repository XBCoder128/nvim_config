return {
    { -- LSP 服务器
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },
            ensure_installed = {}
        },
        opts_extra = {
            "ensure_installed"
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end
    },
    { -- LSP 配置
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },

        -- example using `opts` for defining servers
        opts = {
            servers = {
                lua_ls = {}
            }
        },
        -- example calling setup directly for each LSP
        config = function()
            vim.diagnostic.config({
                underline = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '▏',
                        [vim.diagnostic.severity.WARN] = '▏',
                    },
                },
                update_in_insert = false,
                virtual_text = { spacing = 3, prefix = "" },
                severity_sory = true,
                float = {
                    border = "rounded",
                },
            })
        end
    },
    { -- 代码格式化
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            formatters_by_ft = {
                ["_"] = { "trim_whitespace" },
            },

            format_on_save = function(_)
                -- Disable with a global or buffer-local variable
                if vim.g.enable_autoformat then
                    return { timeout_ms = 500, lsp_format = "fallback" }
                end
            end,
        },
        init = function()
            vim.g.enable_autoformat = true
            require("snacks").toggle
                .new({
                    id = "auto_format",
                    name = "Auto format",
                    get = function()
                        return vim.g.enable_autoformat
                    end,
                    set = function(state)
                        vim.g.enable_autoformat = state
                    end,
                })
                :map("<leader>tf")
        end,
    },
}
