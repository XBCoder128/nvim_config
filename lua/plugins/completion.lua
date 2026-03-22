--- 比单拍 vim.schedule 略晚再 show，减少与 indent/statuscolumn 同帧抢光标（手动 `<A-/>` 等）
local function blink_show_deferred(cmp, opts)
	vim.defer_fn(function()
		if opts then
			cmp.show(opts)
		else
			cmp.show()
		end
	end, 25)
	return true
end

local kind_icons = {
	-- LLM Provider icons
	claude = "󰋦",
	Qwen3Coder = "󱢆",
	codestral = "󱎥",
	gemini = "",
	Groq = "",
	Openrouter = "󱂇",
	Ollama = "󰳆",
	["Llama.cpp"] = "󰳆",
	Deepseek = "",
}

return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			-- 'rafamadriz/friendly-snippets'
			"nvim-tree/nvim-web-devicons",
			"onsails/lspkind.nvim",
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				-- If the command/function returns false or nil, the next command/function will be run.
				preset = "none",
				["<A-j>"] = {
					function(cmp)
						return cmp.select_next({ auto_insert = false })
					end,
					"fallback",
				},
				["<A-k>"] = {
					function(cmp)
						return cmp.select_prev({ auto_insert = false })
					end,
					"fallback",
				},
				["<C-n>"] = {
					function(cmp)
						return cmp.select_next({ auto_insert = false })
					end,
					"fallback",
				},
				["<C-p>"] = {
					function(cmp)
						return cmp.select_prev({ auto_insert = false })
					end,
					"fallback",
				},

				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },

				-- 须菜单打开且已选中项才 accept；避免 preselect 下 Tab/回车误接受第一项导致前缀被乱改
				["<Tab>"] = {
					function(cmp)
						if not cmp.is_menu_visible() then
							return false
						end
						return cmp.accept()
					end,
					"fallback",
				},
				["<CR>"] = {
					function(cmp)
						if not cmp.is_menu_visible() then
							return false
						end
						return cmp.accept()
					end,
					"fallback",
				},
				-- Close current completion and insert a newline
				["<S-CR>"] = {
					function(cmp)
						cmp.hide()
						return false
					end,
					"fallback",
				},

				-- Show/Remove completion（show 一律 defer，hide 保持同步）
				["<A-/>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.hide()
						end
						return blink_show_deferred(cmp)
					end,
					"fallback",
				},
				["<C-Space>"] = {
					function(cmp)
						return blink_show_deferred(cmp)
					end,
					"fallback",
				},
				["<A-.>"] = {
					function(cmp)
						return blink_show_deferred(cmp)
					end,
					"fallback",
				},

				["<A-n>"] = {
					function(cmp)
						return blink_show_deferred(cmp, { providers = { "buffer" } })
					end,
				},
				["<A-p>"] = {
					function(cmp)
						return blink_show_deferred(cmp, { providers = { "buffer" } })
					end,
				},

				["<A-y>"] = {
					function(cmp)
						if vim.bo.filetype == "codecompanion" then
							return false
						end
						return blink_show_deferred(cmp, { providers = { "minuet" } })
					end,
					"fallback",
				},
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "normal",
				kind_icons = kind_icons,
			},

			-- (Default) Only show the documentation popup when manually triggered
			-- completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = function()
					local success, node = pcall(vim.treesitter.get_node)
					if
						success
						and node
						and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
					then
						return { "buffer" }
					end
					-- CodeCompanion 聊天里不用 Minuet
					if vim.bo.filetype == "codecompanion" then
						return { "lazydev", "lsp", "path", "snippets", "buffer" }
					end
					return { "lazydev", "lsp", "path", "snippets", "buffer"} -- , "minuet" 
				end,
				providers = {
					-- minuet = {
					-- 	name = "minuet",
					-- 	module = "minuet.blink",
					-- 	score_offset = 100,
					-- 	async = true,
					-- 	-- Should match minuet.config.request_timeout * 1000,
					-- 	-- since minuet.config.request_timeout is in seconds
					-- 	timeout_ms = 3000,
					-- },
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 95,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			-- 使用 lua 实现以便下面 config 里 patch iskeyword；rust 路径不经过该逻辑
			fuzzy = {
				implementation = "lua",
				sorts = {
					"exact",
					"score",
					"sort_text",
				},
			},

			completion = {
				accept = { auto_brackets = { enabled = true } },
				list = { selection = { preselect = false, auto_insert = false } },
				menu = {
					border = "rounded",
					max_height = 20,
					draw = {
						align_to = "label",
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 350,
					window = {
						min_width = 10,
						max_width = 120,
						max_height = 20,
						border = "rounded",
						winblend = 0,
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
						-- Note that the gutter will be disabled when border ~= 'none'
						scrollbar = true,
						-- Which directions to show the documentation window,
						-- for each of the possible menu window directions,
						-- falling back to the next direction when there's not enough space
						direction_priority = {
							menu_north = { "e", "w", "n", "s" },
							menu_south = { "e", "w", "s", "n" },
						},
					},
				},
				ghost_text = { enabled = true },
			},
		},
		signature = {
			enabled = true,
			window = {
				min_width = 1,
				max_width = 100,
				max_height = 10,
				border = "single", -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
				winblend = 0,
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
				-- Which directions to show the window,
				-- falling back to the next direction when there's not enough space,
				-- or another window is in the way
				direction_priority = { "n" },
				-- Disable if you run into performance issues
				treesitter_highlighting = true,
				show_documentation = true,
			},
		},
			opts_extend = { "sources.default" },

			-- `:` / 命令行窗口：与插入模式分开配置，否则 `<A-j/k>` 不会作用在补全菜单上
			cmdline = {
				keymap = {
					preset = "cmdline",
					["<A-j>"] = {
						function(cmp)
							return cmp.select_next({ auto_insert = false })
						end,
						"fallback",
					},
					["<A-k>"] = {
						function(cmp)
							return cmp.select_prev({ auto_insert = false })
						end,
						"fallback",
					},
				},
			},

		config = function(_, opts)
			require("blink.cmp").setup(opts)
			-- blink#968 类：get_bounds 期间临时改 vim.bo.iskeyword 会与插入模式重绘抢光标
			local kw = require("blink.cmp.fuzzy.lua.keyword")
			kw.with_constant_is_keyword = function(cb)
				return cb()
			end
		end,
	},
}
