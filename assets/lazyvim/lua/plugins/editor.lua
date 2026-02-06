return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
			"debugloop/telescope-undo.nvim",
			"xiyaowong/telescope-emoji.nvim",
		},
		keys = {
			{
				"<leader>fe",
				function()
					require("telescope").extensions.file_browser.file_browser({
						cwd = "/", -- "into all system" implies starting from root or allowing broad access
						hidden = true,
						respect_gitignore = false,
					})
				end,
				desc = "Telescope file browser into all system",
			},
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{
				"<leader>fg",
				function()
					local function get_visual_selection()
						local _, ls, cs = unpack(vim.fn.getpos("v"))
						local _, le, ce = unpack(vim.fn.getpos("."))
						-- Handle potential reverse selection
						if ls > le or (ls == le and cs > ce) then
							ls, cs, le, ce = le, ce, ls, cs
						end
						local lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
						return table.concat(lines, " ")
					end
					require("telescope.builtin").live_grep({ default_text = get_visual_selection() })
				end,
				mode = "v",
				desc = "Live Grep sur la sélection",
			},
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
			{
				"<leader>fu",
				function()
					require("telescope").extensions.undo.undo()
				end,
				desc = "Show undo tree of active buffer",
			},
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Previous files" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
			{
				"<leader>fj",
				function()
					require("telescope").extensions.emoji.emoji()
				end,
				desc = "Show emoji",
			},
			{ "<leader>fc", "<cmd>Telescope git_bcommits<cr>", desc = "Git commits (Current File)" },
			{ "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Navigate through marks" },
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("file_browser")
			telescope.load_extension("undo")
			telescope.load_extension("emoji")
		end,
		opts = {
			defaults = {
				mappings = {
					i = {},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--no-ignore",
					"--hidden",
				},
				pickers = {
					find_files = {
						hidden = false,
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
					},
				},
				extensions = {
					emoji = {
						action = function(emoji)
							vim.api.nvim_put({ emoji.value }, "c", false, true)
						end,
					},
				},
			},
		},
	},

	-- Git Conflict
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
		keys = {
			{ "<leader>fC", "<cmd>GitConflictListQf<cr>", desc = "Git Conflicts (Current File)" },
		},
	},

	-- Grug-far (Search and Replace)
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "terminal" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	-- Neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<C-b>",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
				end,
				desc = "Explorer NeoTree (Root Dir)",
			},
		},
		opts = {
			window = {
				mappings = {
					["<C-b>"] = "close_window",
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
		},
	},
}
