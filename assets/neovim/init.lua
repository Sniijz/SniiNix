-- =======================================================================================
-- Global Variables and Settings
-- =======================================================================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set localleader key to space
vim.g.mkdp_browser = "firefox" -- set firefox as default browser

-- =======================================================================================
-- Basic Neovim Options
-- =======================================================================================
vim.opt.termguicolors = true -- Enable true color support
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2 -- Number of spaces tabs count for in editing operations
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Override ignorecase if search pattern has uppercase letters
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor when scrolling
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor when scrolling
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show search results incrementally
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 300 -- Faster update time for CursorHold events (e.g., LSP hover)
vim.opt.signcolumn = "yes" -- Always show the sign column to avoid layout shifts
vim.opt.laststatus = 3 -- Use a global statusline, required for lualine
vim.opt.wrap = false -- Force vim to show all text in actual window/pane
vim.opt.linebreak = true -- Avoid to open a new line in a middle of a word for too long lines
vim.opt.completeopt = { "menu", "menuone" } -- Setup completion
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

if vim.fn.has("clipboard") == 1 then -- Configure unique clipboard between vim and system
	vim.opt.clipboard = "unnamedplus"
end

-- Configure diagnostics/errors/warning/info
-- vim.diagnostic.config({
-- 	virtual_lines = true,
-- 	signs = true,
-- })

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- =======================================================================================
-- Keymaps
-- =======================================================================================
-- Helper function for keymaps
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Move lines up/down
map("n", "<A-j>", ":m+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m'>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m'<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<A-Down>", ":m+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", ":m-2<CR>==", { desc = "Move line up" })
map("v", "<A-Down>", ":m'>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m'<-2<CR>gv=gv", { desc = "Move selection up" })

-- Add keymaps for Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
map("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Show undo tree of active buffer" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "previous files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })

-- Hotkey configuration for neo-tree
-- <C-b> means Ctrl + b in normal mode
map("n", "<C-b>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree (Files)" })

-- Keymaps for barbar (replace bufferline)
map("n", "<leader>bn", ":BufferNext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", ":BufferPrevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bq", ":BufferClose<CR>", { desc = "Close actual buffer" })
map("n", "<leader>bu", ":BufferRestore<CR>", { desc = "Reopen last closed buffer" })
map("n", "<leader>bh", ":BufferMovePrevious<CR>", { desc = "Move actual buffer before Previous buffer" })
map("n", "<leader>bl", ":BufferMoveNext<CR>", { desc = "Move actual buffer after next buffer" })
map("n", "<leader>bp", ":BufferPin<CR>", { desc = "Pin actual buffer" })
-- Keymaps for barbar buffer navigation (<leader> + Shift + <num>)
map("n", "<leader>&", ":BufferGoto 1<CR>", { desc = "Go to buffer 1" })
map("n", "<leader>é", ":BufferGoto 2<CR>", { desc = "Go to buffer 2" })
map("n", '<leader>"', ":BufferGoto 3<CR>", { desc = "Go to buffer 3" })
map("n", "<leader>'", ":BufferGoto 4<CR>", { desc = "Go to buffer 4" })
map("n", "<leader>(", ":BufferGoto 5<CR>", { desc = "Go to buffer 5" })
map("n", "<leader>-", ":BufferGoto 6<CR>", { desc = "Go to buffer 6" })
map("n", "<leader>è", ":BufferGoto 7<CR>", { desc = "Go to buffer 7" })
map("n", "<leader>_", ":BufferGoto 8<CR>", { desc = "Go to buffer 8" })
map("n", "<leader>ç", ":BufferGoto 9<CR>", { desc = "Go to buffer 9" })

-- Keymaps for git blame
map("n", "<leader>gb", ":GitBlameToggle<CR>", { desc = "Toggle Git blame" })

-- Keymaps for Lazygit
map("n", "<leader>lg", ":LazyGitCurrentFile<CR>", { desc = "Open LazyGit on current file" })

-- Keymaps for Toggleterm
-- Keymaps for opening horizontal terminal
map("n", "<A-t>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal horizontally" }) -- horizontal term toggle in insert mode
map("t", "<A-t>", [[<Cmd>ToggleTerm<CR>]], { desc = "Toggle Terminal" }) -- horizontal term toggle in terminal mode

-- Keymaps for Floaterm
-- Keymaps for opening horizontal terminal
map("n", "<F9>", ":FloatermToggle<CR>", { desc = "Toggle Floating terminal on current file" })
map("t", "<F9>", "<C-\\><C-n>:FloatermToggle<CR>", { desc = "Toggle Floating terminal on current file" })

-- =======================================================================================
-- Neovim Theme
-- =======================================================================================
-- colorscheme
vim.cmd.colorscheme("vscode")

-- Transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Remove grey background on diagnostics
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "none" })

-- Additional colors to override vscode mapping for markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#D4D4D4", bold = true, bg = "NONE" })
		vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#C586C0", bold = true, bg = "NONE" })
		vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#CE9178", bold = true, bg = "NONE" })
		vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#569CD6", bold = true, bg = "NONE" })
		vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#DCDCAA", bold = true, bg = "NONE" })
		vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#B5CEA8", bold = true, bg = "NONE" })
	end,
})

-- Associate Jinja2 extensions for treesitter
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.jinja", "*.jinja2", "*.j2" },
	callback = function()
		vim.bo.filetype = "jinja"
	end,
})

-- Lualine & Barbar Configuration
-- Configuration de Lualine (status bar)
require("lualine").setup({
	options = {
		theme = "vscode",
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- BarBar configuration
require("barbar").setup({
	icons = {
		buffer_index = true,
		buffer_numbner = true,
		pinned = { button = "", filename = true },
		modified = { button = "●" },
	},
	gitsigns = {
		added = { enabled = true, icon = "+" },
		changed = { enabled = true, icon = "~" },
		deleted = { enabled = true, icon = "-" },
	},
})

-- =======================================================================================
-- Autocmds
-- =======================================================================================

-- hl on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- =======================================================================================
-- Plugin Configuration
-- =======================================================================================

-- Neo-tree configuration
require("neo-tree").setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	default_source = "filesystem",
	source_selector = {
		winbar = false,
		statusline = false,
	},
	sources = {
		"filesystem",
		"git_status",
		"document_symbols",
	},
	window = {
		position = "left",
		width = 40,
		mappings = {
			["<C-b>"] = "close_window",
		},
		split = "horizontal",
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
			debounce_delay = 200,
		},
		hijack_netrw_behavior = "open_current",
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_hidden = true,
		},
	},
	git_status = {},
	document_symbols = {
		follow_current_file = true,
	},
})

-- Setup Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "ruby", "markdown" },
	},
	indent = {
		enable = true,
	},
})

-- Noice configuration
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		progress = {
			enabled = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
	},
	routes = {
		{
			view = "mini",
			filter = {
				event = "msg_showmode",
				any = {
					{ find = "recording" },
				},
			},
		},
	},
})

vim.diagnostic.config({ virtual_text = false })
require("tiny-inline-diagnostic").setup({
	preset = "powerline",
	options = {
		multilines = {
			enabled = true,
			always_show = true,
			trim_whitespaces = true,
		},
		show_all_diags_on_cursorline = true,
		show_source = {
			enabled = true,
		},
	},
})

-- Configuration pour nvim-notify
require("notify").setup({
	background_colour = "#000000",
})

-- Configuration for git-blame
require("gitblame").setup({
	enabled = false,
})

-- Autosession plugin to save and resurrect session
require("auto-session").setup({
	log_level = "error",
	suppressed_dirs = { "~/", "~/Projects" },
})

-- Toggleterm configuration
require("toggleterm").setup({
	direction = "horizontal", -- open termin in split horizontal
	size = 20, -- Height of terminal (20 lines)
	start_in_insert = true, -- Start in insert mode at opening
	close_on_exit = true, -- Close windows on shell closing
})

-- Autoclose toggleterm when leaving vim
vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	command = "ToggleTermToggleAll",
})

-- Floaterm configuration
vim.g.floaterm_width = 0.95 -- Uses xx% screen width
vim.g.floaterm_height = 0.95 -- Uses xx% screen height

-- Enabling markdown rendering tools
require("glow").setup({})

-- Enabling colors rendering
-- require("colorizer").setup({})

-- Enabling cursor animation
require("smear_cursor").setup({
	-- Smear cursor when switching buffers or windows.
	smear_between_buffers = true,

	-- Smear cursor when moving within line or to neighbor lines.
	-- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
	smear_between_neighbor_lines = true,

	-- Draw the smear in buffer space instead of screen space when scrolling
	scroll_buffer_space = true,

	-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
	-- Smears will blend better on all backgrounds.
	legacy_computing_symbols_support = false,

	-- Smear cursor in insert mode.
	-- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
	smear_insert_mode = true,
})

-- =======================================================================================
-- LSP Configuration
-- =======================================================================================

-- Autoformat on save
require("conform").setup({
	-- Configure formatters for specific file types
	formatters = {
		nixfmt_with_args = {
			command = "nixfmt",
			args = { "--width", "80" },
		},
	},

	formatters_by_ft = {
		_ = { "dprint" }, -- configure dprint by default
		lua = { "stylua" },
		go = { "gofumpt", "goimports" },
		python = { "isort", "black" },
		nix = { "nixfmt_with_args" },
		yaml = { "yamlfmt" },
		markdown = { "neoformat" },
		json = { "jq" },
		ansible = { "ansible-lint" },
	},

	-- Enable format on save
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true, -- use lsp formatter as fallback
	},
})

-- Linters
-- https://github.com/mfussenegger/nvim-lint
require("lint").linters_by_ft = {
	ansible = { "ansiblelint" },
	go = { "golangcilint" },
	nix = { "statix" },
	python = { "pylint" },
	html = { "htmlhint" },
	css = { "stylelint" },
	javascript = { "eslint" },
	javascriptreact = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
}

-- Lint on save
local lint = require("lint")
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})

-- Setup LSP (nvim-lspconfig)
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Defines capabilities for LSP servers based on nvim-cmp setup
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Function to run on LSP attach (sets buffer-local keymaps)
local on_attach = function(client, bufnr)
	map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to Definition" })
	map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
	map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to Implementation" })
	map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: Show References" })
	map("n", "<F2>", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
	map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })
	map("n", "gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP: Show Line Diagnostics" })
	map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "LSP: Previous Diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "LSP: Next Diagnostic" })

	-- Enable formatting via conformif the LSP server doesn't provide it natively
	if client.server_capabilities.documentFormattingProvider then
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = bufnr, desc = "LSP: Format" })
	end

	-- Auto import package on save for go
	if client.name == "gopls" then
		if client.supports_method("textDocument/codeAction") then
			local augroup = vim.api.nvim_create_augroup("GoImportsOnSave", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
					vim.lsp.buf.code_action({
						context = { only = { "source.organizeImports" }, diagnostics = vim.diagnostic.get(bufnr) },
						apply = true,
					})
					vim.lsp.buf.code_action({
						context = { only = { "source.fixAll" }, diagnostics = vim.diagnostic.get(bufnr) },
						apply = true,
					})
				end,
			})
		end
	end
end

local servers = {
	-- Default values servers
	bashls = {},
	jsonls = {},
	terraformls = {},
	yamlls = {},
	ltex = {
		filetypes = {
			"bib",
			"gitcommit",
			"latex",
			"markdown",
			"org",
			"plaintext",
			"rst",
			"rnoweb",
			"quarto",
			"context",
		},
		settings = {
			ltex = {
				language = "fr",
				additionalRules = {
					languageModel = "~/models/ngrams/",
				},
			},
		},
	},

	-- Specific configurations servers
	gopls = {
		settings = {
			gopls = {
				gofumpt = true,
				staticcheck = true,
				ui = {
					semanticTokens = true,
				},
				analyses = {
					unusedparams = true,
					unreachable = true,
					fieldalignment = true,
					shadow = true,
					ifaceassert = true,
					unusedwrite = true,
					nilness = true,
					ifelse = true,
				},
			},
		},
	},

	pyright = {
		settings = {
			python = {
				pythonPath = vim.fn.exepath("python"),
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					typeCheckingMode = "basic",
				},
			},
		},
	},

	lua_ls = {
		settings = {
			Lua = {
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				diagnostics = {
					globals = { "vim" },
				},
				format = {
					enable = true,
				},
				hint = {
					enable = true,
				},
			},
		},
	},
}

-- Loop to start all servers
for server_name, custom_config in pairs(servers) do
	local final_config = vim.tbl_deep_extend("force", {
		on_attach = on_attach,
		capabilities = capabilities,
	}, custom_config)

	lspconfig[server_name].setup(final_config)
end

-- =======================================================================================
-- CMP Configuration
-- =======================================================================================
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
	cmdline = {
		[":"] = {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
		},
		["/"] = {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		},
	},
})

-- Setup Telescope (fuzzy finder)
local telescope = require("telescope")
telescope.setup({
	defaults = {
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
	},
	pickers = {
		-- Configure specific pickers if needed
		find_files = {
			find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
		},
	},
	extensions = {
		-- Load extensions if you add any
	},
})

-- Setup Telescope Extensions
require("telescope").load_extension("file_browser")
require("telescope").load_extension("media_files")
