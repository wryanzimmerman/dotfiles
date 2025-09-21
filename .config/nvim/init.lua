vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.showmode = false

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.termguicolors = true

vim.opt.tabstop = 4
-- vim.opt.expandtab = true
vim.opt.shiftwidth = 4
-- vim.opt.softtabstop = 4
-- vim.opt.softtabstop = 2
-- vim.opt.shiftwidth = 2

vim.opt.scrolloff = 18
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "

vim.g.python3_host_prog = "~/.config/nvim/neovim_env/bin/python"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_user_command("W", "w", {})

-- window navigation with leader key
vim.api.nvim_set_keymap("n", "<leader>h", ":wincmd h<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>j", ":wincmd j<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>k", ":wincmd k<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>l", ":wincmd l<cr>", { noremap = true })

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- Disable auto-comment on new line after comment
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	group = general,
	desc = "Disable New Line Comment",
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth",
	"nvim-lua/plenary.nvim",
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"tpope/vim-dotenv",
	-- "f-person/git-blame.nvim",
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"vimdoc",
				"typescript",
				"javascript",
				"css",
				"sql",
				"styled",
			},
			ignore_install = { "csv" },
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<M-space>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			-- Prefer git instead of curl in order to improve connectivity in some environments
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [H]elp" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[f]ind [F]iles" })
			vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[f]ind [S]elect Telescope" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[f]ind current [W]ord" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[f]ind by [G]rep" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[f]ind [D]iagnostics" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[f]ind [R]esume" })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[f]ind Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "[f]ind [t]hemes" })
			vim.keymap.set("n", "<leader>fp", builtin.commands, { desc = "[f]ind [c]ommands" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			format = {
				timeout_ms = 5000, -- setting long timeout because of black
			},
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				xml = { "prettierd", "prettier", stop_after_first = true },
				go = { "gofmt" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
			formatters = {
				prettierd = {
					prepend_args = { "--prose-wrap=always" },
				},
			},
		},
	},

	{
		"voldikss/vim-floaterm",
		config = function()
			vim.g.floaterm_width = 0.9
			vim.g.floaterm_height = 0.9
			vim.g.floaterm_autoclose = 1
		end,
		opts = {},
		keys = {
			{ "<leader>tg", "<CMD>FloatermNew lazygit<CR>", mode = { "n" }, id = "<leader>tg" },
		},
	},

	{ import = "plugins.nightfox" },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		opts = {
			styles = {
				transparency = true,
				italic = true,
				bold = true,
			},
		},
		-- config = function()
		-- 	vim.g.rose_pine_variant = "dawn"
		-- 	vim.g.rose_pine_enable_italics = true
		-- 	vim.cmd("colorscheme rose-pine-dawn")
		-- end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
		opts = {
			palette_overrides = {
				-- bright_green = "#BB8D25",
				-- bright_green = "#34A157",
				-- bright_green = "#6AA16A",
				bright_green = "#A3BE8C",
				bright_orange = "#E37B25",
			},
			transparent_mode = true,
		},
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
	},
	-- {
	-- 	"2giosangmitom/nightfall.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		color_overrides = {
	-- 			deepernight = {
	-- 				background = "#000000",
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd("colorscheme nordfox")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd("colorscheme dayfox")
			end,
		},
	},
	{ "HiPhish/rainbow-delimiters.nvim" },
	-- { import = "plugins.feline" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = {
			window = {
				width = 35,
			},
		},
		keys = {
			{ "<leader>e", "<CMD>Neotree toggle reveal<CR>", mode = { "n" }, id = "<leader>e" },
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},

	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		-- Snippet Engine & its associated nvim-cmp source
	-- 		{
	-- 			"L3MON4D3/LuaSnip",
	-- 			build = (function()
	-- 				-- Build Step is needed for regex support in snippets.
	-- 				-- This step is not supported in many windows environments.
	-- 				-- Remove the below condition to re-enable on windows.
	-- 				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
	-- 					return
	-- 				end
	-- 				return "make install_jsregexp"
	-- 			end)(),
	-- 			dependencies = {},
	-- 		},
	-- 		"saadparwaiz1/cmp_luasnip",
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-path",
	-- 	},
	-- 	config = function()
	-- 		-- See `:help cmp`
	-- 		local cmp = require("cmp")
	-- 		local luasnip = require("luasnip")
	-- 		luasnip.config.setup({})
	--
	-- 		cmp.setup({
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			completion = { completeopt = "menu,menuone,noinsert" },
	--
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				["<C-n>"] = cmp.mapping.select_next_item(),
	-- 				["<C-p>"] = cmp.mapping.select_prev_item(),
	--
	-- 				["<C-b>"] = cmp.mapping.scroll_docs(-4),
	-- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
	--
	-- 				["<CR>"] = cmp.mapping.confirm({
	-- 					behavior = cmp.ConfirmBehavior.Replace,
	-- 					select = true,
	-- 				}),
	-- 				["jj"] = cmp.mapping.complete({}),
	--
	-- 				["<C-l>"] = cmp.mapping(function()
	-- 					if luasnip.expand_or_locally_jumpable() then
	-- 						luasnip.expand_or_jump()
	-- 					end
	-- 				end, { "i", "s" }),
	-- 				["<C-h>"] = cmp.mapping(function()
	-- 					if luasnip.locally_jumpable(-1) then
	-- 						luasnip.jump(-1)
	-- 					end
	-- 				end, { "i", "s" }),
	--
	-- 				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
	-- 				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
	-- 			}),
	-- 			sources = {
	-- 				{ name = "nvim_lsp" },
	-- 				-- { name = 'luasnip' },
	-- 				{ name = "path" },
	-- 				{ name = "vim-dadbod-completion" },
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				-- preset = "super-tab",
				-- preset = "none",

				preset = "none",

				-- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "cancel", "fallback" },

				-- ["<Tab>"] = {
				["<Enter>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				-- ["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "fallback_to_mappings" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},

	-- {
	-- 	"davidosomething/format-ts-errors.nvim",
	-- },

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("]g", vim.diagnostic.goto_next, "[g]o to next diagnostic")
					map("[g", vim.diagnostic.goto_prev, "[g]o to previous diagnostic")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- if client and client.server_capabilities.documentHighlightProvider then
					--   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
					--   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
					--     buffer = event.buf,
					--     group = highlight_augroup,
					--     callback = vim.lsp.buf.document_highlight,
					--   })
					--
					--   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					--     buffer = event.buf,
					--     group = highlight_augroup,
					--     callback = vim.lsp.buf.clear_references,
					--   })
					--
					--   vim.api.nvim_create_autocmd('LspDetach', {
					--     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
					--     callback = function(event2)
					--       vim.lsp.buf.clear_references()
					--       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
					--     end,
					--   })
					-- end

					-- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					if
						client
						and client:supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local util = require("lspconfig.util")

			local servers = {
				-- clangd = {},
				-- gopls = {},
				ts_ls = {
					settings = {},
				},
				-- denols = {
				-- 	settings = {},
				-- },
				-- ts_ls = {
				-- 	-- capabilities = capabilities,
				-- 	-- on_attach = on_attach,
				-- 	root_dir = require("lspconfig").util.root_pattern({ "package.json", "tsconfig.json" }),
				-- 	single_file_support = false,
				-- 	handlers = {
				-- 		["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
				-- 			if result.diagnostics == nil then
				-- 				return
				-- 			end
				--
				-- 			-- ignore some tsserver diagnostics
				-- 			local idx = 1
				-- 			while idx <= #result.diagnostics do
				-- 				local entry = result.diagnostics[idx]
				--
				-- 				local formatter = require("format-ts-errors")[entry.code]
				-- 				entry.message = formatter and formatter(entry.message) or entry.message
				--
				-- 				-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
				-- 				if entry.code == 80001 then
				-- 					-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
				-- 					table.remove(result.diagnostics, idx)
				-- 				else
				-- 					idx = idx + 1
				-- 				end
				-- 			end
				--
				-- 			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
				-- 		end,
				-- 	},
				-- },
				pyright = {
					capabilities = capabilities,
					-- on_attach = on_attach,
					filetypes = { "python" },
					-- Making pyright climb up to the pyproject.toml file to set the root_dir,
					-- In pharos-api it was hitting the files in the root of the lambda and
					-- setting root_dir there instead of the project-wide root_dir.
					root_dir = function(fname)
						local root_files = {
							"pyproject.toml",
						}

						return util.root_pattern(unpack(root_files))(fname)
							or util.find_git_ancestor(fname)
							or util.path.dirname(fname)
					end,
					settings = {
						python = {
							analysis = {
								diagnosticMode = "workspace",
							},
						},
					},
				},
				rust_analyzer = {},
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
				golangci_lint_ls = {
					default_config = {
						cmd = { "golangci-lint-langserver" },
						root_dir = require("lspconfig").util.root_pattern(".git", "go.mod"),
						init_options = {
							command = {
								"golangci-lint",
								"run",
								"--disable",
								"lll",
								"--out-format",
								"json",
								"--issues-exit-code=1",
							},
						},
					},
				},
				terraformls = {
					default_config = {
						cmd = { "terraform-ls", "serve" },
						filetypes = { "hcl", "tf", "tfvars", "terraform", "terraform-vars", "pkr.hcl", "pkr" },
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- -- You can add other tools here that you want Mason to install
			-- -- for you, so that they are available from within Neovim.
			-- local ensure_installed = vim.tbl_keys(servers or {})
			-- vim.list_extend(ensure_installed, {
			-- 	"stylua", -- Used to format Lua code
			-- })

			-- Setup other servers through mason-lspconfig
			local other_servers = vim.tbl_filter(function(name)
				return name ~= "ts_ls" and name ~= "denols"
			end, vim.tbl_keys(servers))

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						-- Skip ts_ls and denols as they're handled by custom handlers
						if server_name == "ts_ls" or server_name == "denols" then
							return
						end

						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

						require("lspconfig")[server_name].setup(server)
					end,
					-- Custom handlers that conditionally setup servers
					ts_ls = function()
						-- Set up an autocommand to handle ts_ls when TypeScript files are opened
						vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
							pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
							callback = function()
								local bufnr = vim.api.nvim_get_current_buf()
								local filepath = vim.api.nvim_buf_get_name(bufnr)
								if filepath == "" then
									return
								end

								local root = util.root_pattern("package.json", "tsconfig.json")(filepath)
								if not root then
									return
								end

								-- Don't start if deno files are present
								if
									vim.fn.filereadable(root .. "/deno.json") == 1
									or vim.fn.filereadable(root .. "/deno.jsonc") == 1
								then
									return
								end

								-- Start ts_ls if not already running for this root
								local clients = vim.lsp.get_clients({ name = "ts_ls" })
								for _, client in ipairs(clients) do
									if client.config.root_dir == root then
										return -- Already running
									end
								end

								vim.lsp.start({
									name = "ts_ls",
									cmd = { "typescript-language-server", "--stdio" },
									capabilities = capabilities,
									root_dir = root,
									settings = servers.ts_ls.settings or {},
								}, { bufnr = bufnr })
							end,
						})
					end,
					denols = function()
						-- Set up an autocommand to handle denols when TypeScript files are opened
						vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
							pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
							callback = function()
								local bufnr = vim.api.nvim_get_current_buf()
								local filepath = vim.api.nvim_buf_get_name(bufnr)
								if filepath == "" then
									return
								end

								local root = util.root_pattern("deno.json", "deno.jsonc")(filepath)
								if not root then
									return
								end

								-- Start denols if not already running for this root
								local clients = vim.lsp.get_clients({ name = "denols" })
								for _, client in ipairs(clients) do
									if client.config.root_dir == root then
										return -- Already running
									end
								end

								vim.lsp.start({
									name = "denols",
									cmd = { "deno", "lsp" },
									capabilities = capabilities,
									root_dir = root,
									settings = servers.denols.settings or {},
									init_options = {
										enable = true,
										lint = true,
										unstable = true,
									},
								}, { bufnr = bufnr })
							end,
						})
					end,
				},
			})

			-- Aggressive autocommand to stop conflicting servers immediately
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					local root_dir = client.config.root_dir
					if not root_dir then
						return
					end

					local has_deno = vim.fn.filereadable(root_dir .. "/deno.json") == 1
						or vim.fn.filereadable(root_dir .. "/deno.jsonc") == 1
					local has_node = vim.fn.filereadable(root_dir .. "/package.json") == 1
						or vim.fn.filereadable(root_dir .. "/tsconfig.json") == 1

					-- In Deno projects, stop ts_ls
					if client.name == "ts_ls" and has_deno then
						vim.schedule(function()
							vim.lsp.stop_client(client.id, true)
						end)
					end

					-- In Node.js projects, stop denols
					if client.name == "denols" and has_node and not has_deno then
						vim.schedule(function()
							vim.lsp.stop_client(client.id, true)
						end)
					end
				end,
			})

			-- require("mason-lspconfig").setup({
			-- 	ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			-- 	automatic_installation = false,
			-- 	handlers = {
			-- 		function(server_name)
			-- 			local config = servers[server_name] or {}
			-- 			vim.lsp.config(server_name, config)
			-- 			vim.lsp.enable(server_name)
			-- 			-- This handles overriding only values explicitly passed
			-- 			-- by the server configuration above. Useful when disabling
			-- 			-- certain features of an LSP (for example, turning off formatting for ts_ls)
			-- 			-- server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			-- 			-- require("lspconfig")[server_name].setup(server)
			-- 		end,
			-- 	},
			-- })
		end,
	},

	{
		"cameron-wags/rainbow_csv.nvim",
		config = true,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	-- { "windwp/nvim-ts-autotag", event = "InsertEnter", config = true },

	-- {
	-- 	"dmmulroy/tsc.nvim",
	-- 	config = function()
	-- 		require("tsc").setup({
	-- 			flags = "--project tsconfig.app.json",
	-- 			auto_start_watch_mode = true,
	--
	-- 			vim.keymap.set("n", "<leader>ts", "<CMD>TSC<CR>", { desc = "Run TSC" }),
	-- 			keys = {
	-- 				{ "<leader>ts", "<CMD>TSC<CR>", mode = { "n" }, id = "<leader>ts" },
	-- 			},
	-- 		})
	-- 	end,
	--
	-- 	-- opts = {
	-- 	-- 	auto_start_watch_mode = false,
	-- 	-- 	flags = "--project tsconfig.app.json",
	-- 	-- 	keys = {
	-- 	-- 		{ "<leader>ts", "<CMD>TSC<CR>", mode = { "n" }, id = "<leader>ts" },
	-- 	-- 	},
	-- 	-- },
	-- },

	{
		"github/copilot.vim",
		init = function()
			-- Disable copilot for now
			-- vim.g.copilot_enabled = false
			vim.g.copilot_no_tab_map = true -- disable tab mapping
			vim.g.copilot_assume_mapped = true -- assume that tab is already mapped
			vim.api.nvim_set_keymap(
				"i",
				"<S-Tab>",
				'copilot#Accept("<CR>")',
				{ expr = true, silent = true, noremap = true }
			)
			-- vim.g.copilot_filetypes = { ["*"] = false } -- disable copilot for all filetypes
		end,
	},

	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	enabled = true,
	-- 	cmd = "Copilot",
	-- 	event = "InsertEnter",
	-- 	opts = {
	-- 		suggestion = {
	-- 			enabled = true,
	-- 			auto_trigger = true,
	-- 			keymap = {
	-- 				accept = "<S-Tab>",
	-- 			},
	-- 		},
	-- 		panel = { enabled = true },
	-- 		keys = {
	-- 			-- { "<leader>co", 'lua require("copilot.suggestion").toggle_auto_trigger()', mode = { "n", }, id = '<leader>co' },
	-- 			-- { "<leader>co", '<CMD> Copilot panel', mode = { "n", }, id = '<leader>co' },
	-- 			-- next = "<C-m>",
	-- 		},
	-- 	},
	-- },

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_env_variable_url = "DATABASE_URL"
			vim.g.db_ui_win_position = "right"
			vim.g.db_ui_disable_progress_bar = 0
			-- map leader db to open dbui
			vim.api.nvim_set_keymap("n", "<leader>db", "<CMD>DBUI<CR>", { noremap = true, silent = true })
		end,
	},

	-- {
	-- 	"huggingface/llm.nvim",
	-- 	opts = {
	-- 		api_token = nil, -- cf Install paragraph
	-- 		model = "starcoder2:3b",
	-- 		-- model = "codestral:22b-v0.1-f16",
	-- 		-- model = "stable-code:latest",          -- the model ID, behavior depends on backend
	-- 		-- model = "stable-code",                 -- the model ID, behavior depends on backend
	-- 		backend = "ollama", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
	-- 		url = "http://localhost:11434/api/generate",
	-- 		tokens_to_clear = {
	-- 			"<|endoftext|>",
	-- 			-- "<fim_middle>",
	-- 			-- "</fim_middle>",
	-- 			-- "<fim_suffix>",
	-- 			-- "<fim_prefix>"
	-- 		}, -- tokens to remove from the model's output
	-- 		-- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
	-- 		request_body = {
	-- 			parameters = {
	-- 				max_new_tokens = 30,
	-- 				-- temperature = 0.2,
	-- 				-- top_p = 0.95,
	-- 			},
	-- 		},
	-- 		-- set this if the model supports fill in the middle
	-- 		fim = {
	-- 			enabled = true,
	-- 			prefix = "<fim_prefix>",
	-- 			middle = "<fim_middle>",
	-- 			suffix = "<fim_suffix>",
	-- 		},
	-- 		debounce_ms = 150,
	-- 		accept_keymap = "<S-Tab>",
	-- 		dismiss_keymap = "<C-Tab>",
	-- 		tls_skip_verify_insecure = true,
	-- 		-- -- llm-ls configuration, cf llm-ls section
	-- 		-- lsp = {
	-- 		--   bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
	-- 		-- },
	-- 		-- tokenizer = nil,                   -- cf Tokenizer paragraph
	-- 		-- context_window = 8192, -- max number of tokens for the context window
	-- 		-- context_window = 4096,
	-- 		-- context_window = 2048,
	-- 		context_window = 1024,
	-- 		enable_suggestions_on_startup = true,
	-- 		-- enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
	-- 		tokenizer = {
	-- 			repository = "bigcode/starcoder",
	-- 		},
	-- 	},
	-- },

	-- {
	-- 	"milanglacier/minuet-ai.nvim",
	-- 	config = function()
	-- 		require("minuet").setup({
	-- 			after_cursor_filter_length = 20,
	-- 			-- request_timeout = 10,
	-- 			provider = "openai_fim_compatible",
	-- 			provider_options = {
	-- 				openai_fim_compatible = {
	-- 					model = "qwen2.5-coder:3b",
	-- 					end_point = "http://localhost:11434/v1/completions",
	-- 					-- end_point = "http://localhost:11434/api/generate",
	-- 					name = "Ollama",
	-- 					stream = true,
	-- 					api_key = "LOCAL_LLM_KEY",
	-- 					optional = {
	-- 						stop = "<|endoftext|>",
	-- 						max_tokens = 256,
	-- 					},
	-- 				},
	-- 			},
	-- 			-- provider = "openai_compatible",
	-- 			-- provider_options = {
	-- 			-- 	openai_compatible = {
	-- 			-- 		model = "starcoder2:3b",
	-- 			-- 		-- end_point = "http://localhost:11434/api/generate",
	-- 			-- 		end_point = "http://localhost:11434/v1/completions",
	-- 			-- 		api_key = "LOCAL_LLM_KEY",
	-- 			-- 		name = "starcoder2:3b",
	-- 			-- 		stream = true,
	-- 			-- 		optional = {
	-- 			-- 			max_tokens = 256,
	-- 			-- 			stop = { "\n\n" },
	-- 			-- 		},
	-- 			-- 	},
	-- 			-- },
	-- 			virtualtext = {
	-- 				auto_trigger_ft = {
	-- 					"python",
	-- 					"sql",
	-- 					"lua",
	-- 					"go",
	-- 					"typescript",
	-- 					"typescriptreact",
	-- 					"tsx",
	-- 					"yaml",
	-- 					"yml",
	-- 				},
	-- 				keymap = {
	-- 					-- accept = "<A-A>",
	-- 					accept = "<S-Tab>",
	-- 					accept_line = "<A-a>",
	-- 					-- Cycle to prev completion item, or manually invoke completion
	-- 					prev = "<A-[>",
	-- 					-- Cycle to next completion item, or manually invoke completion
	-- 					next = "<A-]>",
	-- 					dismiss = "<A-e>",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
})

-- vim.cmd("colorscheme nordfox")
-- vim.cmd("colorscheme gruvbox")
vim.cmd("colorscheme onedark_dark")
vim.cmd("colorscheme nordfox")
