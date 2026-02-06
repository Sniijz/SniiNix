return {
	-- Theme
	{
		"sainnhe/everforest",
		lazy = true,
		priority = 1000,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "everforest",
		},
	},

	-- Disable Bufferline (using Barbar instead)
	{ "akinsho/bufferline.nvim", enabled = false },
	-- Barbar (Tabs)
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = false, -- Disable animation
			icons = {
				buffer_index = true,
				buffer_number = true,
				pinned = { button = "", filename = true },
				modified = { button = "●" },
				gitsigns = {
					added = { enabled = true, icon = "+" },
					changed = { enabled = true, icon = "~" },
					deleted = { enabled = true, icon = "-" },
				},
			},
		},
	},

	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "everforest",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},

	-- Noice (Configure to disable scroll animation if any remains)
	{
		"folke/noice.nvim",
		keys = {
			{ "<C-b>", false, mode = { "n", "i", "s" } },
			{ "<C-f>", false, mode = { "n", "i", "s" } },
		},
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
	},
}
