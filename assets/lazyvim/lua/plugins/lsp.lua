return {
	-- Disable Mason (managed by Nix)
	{ "mason-org/mason.nvim", enabled = false },
	{ "maso-org/mason-lspconfig.nvim", enabled = false },

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				nixd = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				-- Pico8
				pico_ls = {
					cmd = { "pico8-ls" },
					filetypes = { "pico8" },
					root_dir = function()
						return nil
					end,
					single_file_support = true,
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
							},
						},
					},
				},
			},
		},
	},

	-- Conform (Formatting)
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				["_"] = { "dprint" },
				lua = { "stylua" },
				go = { "gofumpt", "goimports" },
				python = { "isort", "black" },
				nix = { "nixfmt_with_args" },
				yaml = { "yamlfmt" },
				markdown = { "neoformat" },
				json = { "jq" },
			},
			formatters = {
				nixfmt_with_args = {
					command = "nixfmt",
					args = { "--width", "80" },
				},
			},
			format_on_save = function(bufnr)
				-- Disable autoformat for pico8 if needed or customize
				if vim.bo[bufnr].filetype == "pico8" then
					return {
						timeout_ms = 5000,
						lsp_fallback = true,
						formatters = {},
					}
				end
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,
		},
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				ansible = { "ansiblelint" },
				go = { "golangcilint" },
				nix = { "statix" },
				python = { "pylint" },
				html = { "htmlhint" },
				css = { "stylelint" },
				javascript = { "eslint" },
				typescript = { "eslint" },
			},
		},
	},
}
