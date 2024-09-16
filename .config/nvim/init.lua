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
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.scrolloff = 18
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.python3_host_prog = "~/.config/nvim/neovim_env/bin/python"

vim.opt.splitright = true
vim.opt.splitbelow = true

-- vim.opt.colorcolumn = '81'

-- window navigation with leader key
vim.api.nvim_set_keymap("n", "<leader>h", ":wincmd h<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>j", ":wincmd j<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>k", ":wincmd k<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>l", ":wincmd l<cr>", { noremap = true })

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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
	"tpope/vim-sleuth",
	-- 'tpope/vim-fugitive',
	"tpope/vim-rhubarb",
	"tpope/vim-dotenv",
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
				timeout_ms = 3000, -- setting long timeout because of black
			},
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				xml = { "prettierd", "prettier" },
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
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
	},
	{ import = "plugins.feline" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
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
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["jj"] = cmp.mapping.complete({}),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "nvim_lsp" },
					-- { name = 'luasnip' },
					{ name = "path" },
					{ name = "vim-dadbod-completion" },
				},
			})
		end,
	},

	{
		"davidosomething/format-ts-errors.nvim",
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
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

					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local util = require("lspconfig.util")

			local servers = {
				-- clangd = {},
				-- gopls = {},
				tsserver = {
					capabilities = capabilities,
					-- on_attach = on_attach,
					handlers = {
						["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
							if result.diagnostics == nil then
								return
							end

							-- ignore some tsserver diagnostics
							local idx = 1
							while idx <= #result.diagnostics do
								local entry = result.diagnostics[idx]

								local formatter = require("format-ts-errors")[entry.code]
								entry.message = formatter and formatter(entry.message) or entry.message

								-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
								if entry.code == 80001 then
									-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
									table.remove(result.diagnostics, idx)
								else
									idx = idx + 1
								end
							end

							vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
						end,
					},
				},
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
								"--enable-all",
								"--disable",
								"lll",
								"--out-format",
								"json",
								"--issues-exit-code=1",
							},
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						if server_name == "tsserver" then
							server_name = "ts_ls"
						end
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		local lint = require("lint")
	-- 		lint.linters_by_ft = {
	-- 			markdown = { "markdownlint" },
	-- 			go = { "revive" },
	-- 		}
	--
	-- 		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	-- 		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	-- 			group = lint_augroup,
	-- 			callback = function()
	-- 				lint.try_lint()
	-- 			end,
	-- 		})
	-- 	end,
	-- },

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

	{ "windwp/nvim-ts-autotag", event = "InsertEnter", config = true },

	{
		"dmmulroy/tsc.nvim",
		opts = {
			keys = {
				{ "<leader>ts", "<CMD>TSC<CR>", mode = { "n" }, id = "<leader>ts" },
			},
		},
	},
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
		keys = {
			{ "<leader>nn", "<CMD>Neorg<CR>", mode = { "n" }, id = "<leader>nn" },
		},
	},
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
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_disable_progress_bar = 0
			-- map leader db to open dbui
			vim.api.nvim_set_keymap("n", "<leader>db", "<CMD>DBUI<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<S-Tab>",
				},
			},
			panel = { enabled = true },
			keys = {
				-- { "<leader>co", 'lua require("copilot.suggestion").toggle_auto_trigger()', mode = { "n", }, id = '<leader>co' },
				-- { "<leader>co", '<CMD> Copilot panel', mode = { "n", }, id = '<leader>co' },
				-- next = "<C-m>",
			},
		},
	},
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	main = "ibl",
	-- 	---@module "ibl"
	-- 	---@type ibl.config
	-- },
})

-- local highlight = {
-- 	"NordDarkBlue",
-- 	-- "RainbowYellow",
-- 	-- "RainbowBlue",
-- 	-- "RainbowOrange",
-- 	-- "RainbowGreen",
-- 	-- "RainbowViolet",
-- 	-- "RainbowCyan",
-- }
--
-- local hooks = require("ibl.hooks")
-- -- create the highlight groups in the highlight setup hook, so they are reset
-- -- every time the colorscheme changes
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
-- 	vim.api.nvim_set_hl(0, "NordDarkBlue", { fg = "#1a1e25" })
-- 	-- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
-- 	-- vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
-- 	-- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
-- 	-- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
-- 	-- vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
-- 	-- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
-- end)
--
-- require("ibl").setup({ indent = { highlight = highlight } })

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(opts)
		if vim.bo[opts.buf].filetype == "python" then
			vim.cmd("Black")
		end
	end,
})

vim.cmd("colorscheme onedark_dark")
vim.cmd("colorscheme nordfox")
