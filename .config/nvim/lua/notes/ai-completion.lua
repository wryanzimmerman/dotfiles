-- Local LLM completion experiments — reference only, NOT imported/loaded.
-- To use, copy a spec into init.lua's lazy setup and adjust the ollama endpoint/model.
return {
	{
		"huggingface/llm.nvim",
		opts = {
			api_token = nil, -- cf Install paragraph
			model = "starcoder2:3b",
			-- model = "codestral:22b-v0.1-f16",
			-- model = "stable-code:latest",          -- the model ID, behavior depends on backend
			-- model = "stable-code",                 -- the model ID, behavior depends on backend
			backend = "ollama", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
			url = "http://localhost:11434/api/generate",
			tokens_to_clear = {
				"<|endoftext|>",
				-- "<fim_middle>",
				-- "</fim_middle>",
				-- "<fim_suffix>",
				-- "<fim_prefix>"
			}, -- tokens to remove from the model's output
			-- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
			request_body = {
				parameters = {
					max_new_tokens = 30,
					-- temperature = 0.2,
					-- top_p = 0.95,
				},
			},
			-- set this if the model supports fill in the middle
			fim = {
				enabled = true,
				prefix = "<fim_prefix>",
				middle = "<fim_middle>",
				suffix = "<fim_suffix>",
			},
			debounce_ms = 150,
			accept_keymap = "<S-Tab>",
			dismiss_keymap = "<C-Tab>",
			tls_skip_verify_insecure = true,
			-- -- llm-ls configuration, cf llm-ls section
			-- lsp = {
			--   bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
			-- },
			-- tokenizer = nil,                   -- cf Tokenizer paragraph
			-- context_window = 8192, -- max number of tokens for the context window
			-- context_window = 4096,
			-- context_window = 2048,
			context_window = 1024,
			enable_suggestions_on_startup = true,
			-- enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
			tokenizer = {
				repository = "bigcode/starcoder",
			},
		},
	},

	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({
				after_cursor_filter_length = 20,
				-- request_timeout = 10,
				provider = "openai_fim_compatible",
				provider_options = {
					openai_fim_compatible = {
						model = "qwen2.5-coder:3b",
						end_point = "http://localhost:11434/v1/completions",
						-- end_point = "http://localhost:11434/api/generate",
						name = "Ollama",
						stream = true,
						api_key = "LOCAL_LLM_KEY",
						optional = {
							stop = "<|endoftext|>",
							max_tokens = 256,
						},
					},
				},
				-- provider = "openai_compatible",
				-- provider_options = {
				-- 	openai_compatible = {
				-- 		model = "starcoder2:3b",
				-- 		-- end_point = "http://localhost:11434/api/generate",
				-- 		end_point = "http://localhost:11434/v1/completions",
				-- 		api_key = "LOCAL_LLM_KEY",
				-- 		name = "starcoder2:3b",
				-- 		stream = true,
				-- 		optional = {
				-- 			max_tokens = 256,
				-- 			stop = { "\n\n" },
				-- 		},
				-- 	},
				-- },
				virtualtext = {
					auto_trigger_ft = {
						"python",
						"sql",
						"lua",
						"go",
						"typescript",
						"typescriptreact",
						"tsx",
						"yaml",
						"yml",
					},
					keymap = {
						-- accept = "<A-A>",
						accept = "<S-Tab>",
						accept_line = "<A-a>",
						-- Cycle to prev completion item, or manually invoke completion
						prev = "<A-[>",
						-- Cycle to next completion item, or manually invoke completion
						next = "<A-]>",
						dismiss = "<A-e>",
					},
				},
			})
		end,
	},
}
