return {
	-- Mini Modules
	{
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.pairs").setup()
			require("mini.comment").setup()
			require("mini.misc").setup()
			require("mini.indentscope").setup()
			require("mini.git").setup()
			require("mini.diff").setup({
				view = {
					style = "sign",
					signs = { add = "│", change = "│", delete = "_" },
				},
				mappings = {
					apply = "<leader>hs",
					reset = "<leader>hu",
					textobject = "gh",
				},
			})
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
