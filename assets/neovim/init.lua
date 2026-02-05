-- =======================================================================================
-- Global Variables and Settings
-- =======================================================================================
vim.g.loaded_netrw = 1
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
vim.opt.updatetime = 500 -- Faster update time for CursorHold events (e.g., LSP hover)
vim.opt.signcolumn = "yes" -- Always show the sign column to avoid layout shifts
vim.opt.laststatus = 3 -- Use a global statusline, required for lualine
vim.opt.wrap = false -- Force vim to show all text in actual window/pane
vim.opt.linebreak = true -- Avoid to open a new line in a middle of a word for too long lines
vim.opt.completeopt = { "menu", "menuone" } -- Setup completion
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- =======================================================================================
-- Race condition plugin to launch asap
-- =======================================================================================
-- Setup Icons
-- Must be called before barbar, telescope init
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- =======================================================================================
-- Neovim Optimization
-- =======================================================================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

if vim.fn.has("clipboard") == 1 then
	-- OSC 52 feature to remote copy/paste
	vim.g.clipboard = "osc52"
	vim.opt.clipboard = "unnamedplus"
end

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
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "Telescope file browser into all system" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
map("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Show undo tree of active buffer" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "previous files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>fj", "<cmd>Telescope emoji<cr>", { desc = "Show emoji" })
map("n", "<leader>fc", "<cmd>Telescope git_bcommits<cr>", { desc = "Git commits (Current File)" })
map("n", "<leader>fC", "<cmd>GitConflictListQf<cr>", { desc = "Git Conflicts (Current File)" })
map("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Navigate through marks" })

-- Switch with showing absolute and relatives numbers
map("n", "<leader>no", function()
	local nu = vim.opt.number:get()
	local rnu = vim.opt.relativenumber:get()

	if nu and rnu then
		vim.cmd("set nonumber norelativenumber")
	elseif nu and not rnu then
		vim.cmd("set nonumber norelativenumber")
	else
		vim.cmd("set number relativenumber")
	end
end, { desc = "Cycle Numbering (Hybrid -> Absolute -> None)" })

-- Hotkey configuration for neo-tree
-- <C-b> means Ctrl + b in normal mode
map("n", "<C-b>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree (Files)" })

-- Keymaps for barbar (replace bufferline)
map("n", "<leader>bn", ":BufferNext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", ":BufferPrevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bq", ":BufferClose<CR>", { desc = "Close actual buffer" })
map("n", "<leader>bx", ":BufferCloseAllButCurrent<CR>", { desc = "Close all buffer but current" })
map("n", "<leader>bc", ":BufferCloseBuffersLeft<CR>", { desc = "Close all buffer left to current" })
map("n", "<leader>bv", ":BufferCloseBuffersRight<CR>", { desc = "Close all buffer right to current" })
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

-- Keymaps for Lazygit
map("n", "<leader>lg", ":LazyGitCurrentFile<CR>", { desc = "Open LazyGit on current file" })

-- Keymaps for diagnostics
map("n", "gl", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

-- Keymap for highlight
map("n", "<F3>", ":noh<CR>", { desc = "Remove search highlight" })

-- =======================================================================================
-- Mini.nvim Configuration
-- =======================================================================================
-- Git & Diff
require("mini.git").setup()

-- show git blame with leader gb
map("n", "<leader>gb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Show git blame info" })

require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "│", change = "│", delete = "_" },
	},
	mappings = {
		apply = "<leader>hs",
		reset = "<leader>hu",
		textobject = "gh",
		goto_first = "[H",
		goto_last = "]H",
		goto_prev = "[h",
		goto_next = "]h",
	},
})

vim.keymap.set("n", "<leader>hp", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Preview Hunk (Overlay)" })

-- Editing tools
require("mini.pairs").setup()
require("mini.comment").setup()

-- Misc (vim zoom with ctrl+w + o)
require("mini.misc").setup()
vim.keymap.set("n", "<C-w>o", MiniMisc.zoom, { desc = "Zoom Toggle" })

-- Indent Scope
require("mini.indentscope").setup()

-- =======================================================================================
-- Neovim Theme
-- =======================================================================================
-- colorscheme
-- vim.cmd.colorscheme("vscode")
vim.g.everforest_background = "soft" -- Background Contrast ('hard', 'medium', 'soft')
vim.g.everforest_transparent_background = 1 -- Enable transparency for everforest theme
vim.cmd.colorscheme("everforest")
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Remove grey background on diagnostics
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "none" })
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

-- =======================================================================================
-- Diagnostics Configuration
-- =======================================================================================

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

require("tiny-inline-diagnostic").setup({
	preset = "powerline",
	options = {
		multilines = {
			enabled = true,
			always_show = true,
			trim_whitespaces = true,
		},
		show_all_diags_on_cursorline = true,
		show_diags_only_under_cursor = false,
		show_source = {
			enabled = true,
		},
	},
})

-- =======================================================================================
-- LSP Configuration
-- =======================================================================================
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

-- pico8 support
vim.filetype.add({
	extension = {
		p8 = "pico8",
	},
})

-- Associate Jinja2 extensions for treesitter
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.jinja", "*.jinja2", "*.j2" },
	callback = function()
		vim.bo.filetype = "jinja"
	end,
})

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
	-- format_on_save = {
	-- 	timeout_ms = 500,
	-- 	lsp_fallback = true, -- use lsp formatter as fallback
	-- },
	format_on_save = function(bufnr)
		-- Si c'est un fichier PICO-8
		if vim.bo[bufnr].filetype == "pico8" then
			return {
				timeout_ms = 5000, -- On laisse du temps à Node.js
				lsp_fallback = true, -- OUI, utilise le LSP
				formatters = {}, -- On vide la liste pour écraser le "_" (dprint)
			}
		end

		-- Pour tous les autres fichiers
		return {
			timeout_ms = 500,
			lsp_fallback = true,
		}
	end,
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

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})

-- Setup LSP (nvim-lspconfig)
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
	-- Prevent Neovim's default K key behavior (keywordprg) from interfering with LSP hover
	vim.bo[bufnr].keywordprg = ""

	local map = vim.keymap.set
	map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to Definition" })
	map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
	map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to Implementation" })
	map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: Show References" })
	map("n", "<F2>", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
	map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })

	if client.server_capabilities.documentFormattingProvider then
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = bufnr, desc = "LSP: Format" })
	end
end

local servers = {
	bashls = {},
	jsonls = {},
	terraformls = {},
	yamlls = {},
	nixd = {},

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
				checkOnType = false,
				checkOnSave = true,
			},
		},
	},

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

	pico_ls = {
		cmd = { "pico8-ls" },
		filetypes = { "pico8" },
		root_dir = function()
			return nil
		end,
		single_file_support = true,
	},

	lua_ls = {
		filetypes = { "lua" },
		settings = {
			Lua = {
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				diagnostics = {
					globals = { "vim" },
					delay = 500,
					checkOnType = false,
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

-- Configure and Enable servers according to new API (nvim-lspconfig for nvim 0.11+)
for server_name, custom_config in pairs(servers) do
	local final_config = vim.tbl_deep_extend("force", {
		on_attach = on_attach,
		capabilities = capabilities,
	}, custom_config or {})

	-- Set the configuration using the new API
	vim.lsp.config[server_name] = vim.tbl_deep_extend("force", vim.lsp.config[server_name] or {}, final_config)

	-- Enable the server so it starts on the correct filetypes
	vim.lsp.enable(server_name)
end

-- The LspAttach event is triggered after a client attaches to a buffer.
-- We use this to reliably call our on_attach function.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.config and client.config.on_attach then
			client.config.on_attach(client, event.buf)
		end
	end,
})

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

-- =======================================================================================
-- Telescope Configuration
-- =======================================================================================
local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<Up>"] = actions.cycle_history_prev,
				["<Down>"] = actions.cycle_history_next,
			},
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
	},
	pickers = {
		-- Configure specific pickers if needed
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
})

-- =======================================================================================
-- TELESCOPE FILE BROWSER EXTENSION CONFIG
-- =======================================================================================

-- On crée une fonction dédiée pour garantir que les mappings sont appliqués
local function open_file_browser()
	local fb_actions = require("telescope").extensions.file_browser.actions
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = vim.fn.expand("%:p:h"),
		cwd_to_path = true,
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		initial_mode = "normal",

		attach_mappings = function(prompt_bufnr, map)
			map("n", "l", actions.select_default)
			map("n", "<CR>", actions.select_default)

			map("n", "h", fb_actions.goto_parent_dir)
			map("n", "<BS>", fb_actions.goto_parent_dir)
			map("n", "<C-h>", fb_actions.goto_parent_dir)

			map("n", "c", fb_actions.create)
			map("n", "r", fb_actions.rename)
			map("n", "m", fb_actions.move)
			map("n", "y", fb_actions.copy)
			map("n", "d", fb_actions.remove)

			map("n", "e", fb_actions.goto_home_dir)
			map("n", "w", fb_actions.goto_cwd)
			map("n", "t", fb_actions.change_cwd)
			map("n", "f", fb_actions.toggle_browser)
			map("n", ".", fb_actions.toggle_hidden)

			return true
		end,
	})
end

vim.keymap.set("n", "<leader>fe", open_file_browser, { desc = "File Browser (Config Forcée)" })

-- =======================================================================================
-- TELESCOPE FILE BROWSER EXTENSION CONFIG
-- =======================================================================================
require("git-conflict").setup({
	default_mappings = true,
	disable_diagnostics = false,
	list_opener = "copen",
	highlights = {
		incoming = "DiffAdd",
		current = "DiffText",
	},
})

-- Search selected text in visual mode
local function get_visual_selection()
	local saved_reg = vim.fn.getreg("v")
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", saved_reg)
	text = string.gsub(text, "\n", "")
	return text
end

map("v", "<leader>fg", function()
	local text = get_visual_selection()
	require("telescope.builtin").live_grep({ default_text = text })
end, { desc = "Live Grep sur la sélection" })

-- =======================================================================================
-- Grug-far (Search and Replace)
-- =======================================================================================
require("grug-far").setup({
	icons = {
		enabled = true,
	},
	keymaps = {
		close = { n = "q" },
	},
})

local function grug_far_word_under_cursor()
	require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end

local function grug_far_visual_selection()
	require("grug-far").with_visual_selection({ prefills = { search = vim.fn.expand("<cword>") } })
end

-- Add keympas for grug-far search and replace
-- Mode Normal
map("n", "<leader>sr", ":GrugFar<CR>", { desc = "Search and Replace (Grug-far)" })
map("n", "<leader>sw", grug_far_word_under_cursor, { desc = "Search and Replace current Word" })
-- Visual Mode
map("v", "<leader>sr", grug_far_visual_selection, { desc = "Search and Replace Selection" })

-- =======================================================================================
-- DAP Debug Adapter Protocol Configuration
-- =======================================================================================

require("dapui").setup()
require("dap-go").setup()

local dap, dapui = require("dap"), require("dapui")

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- Keymaps for debugging
vim.keymap.set("n", "<Leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "[D]ebug [B]reakpoint" })
vim.keymap.set("n", "<Leader>dc", function()
	require("dap").continue()
end, { desc = "[D]ebug [C]ontinue" })
vim.keymap.set("n", "<Leader>do", function()
	require("dap").step_over()
end, { desc = "[D]ebug Step [O]ver" })
vim.keymap.set("n", "<Leader>di", function()
	require("dap").step_into()
end, { desc = "[D]ebug Step [I]nto" })
vim.keymap.set("n", "<Leader>du", function()
	require("dap").step_out()
end, { desc = "[D]ebug Step O[u]t" })
vim.keymap.set("n", "<Leader>dx", function()
	require("dap").terminate()
end, { desc = "[D]ebug Terminate/[D]isconnect" })
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end, { desc = "[D]ebug Open [R]EPL" })
vim.keymap.set("n", "<Leader>dt", function()
	require("dapui").toggle()
end, { desc = "[D]ebug [T]oggle UI" })

-- =======================================================================================
-- Interface Configuration
-- =======================================================================================
-- Starter Dashboard Alpha nvim
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	[[=================     ===============     ===============   ========  ========]],
	[[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
	[[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
	[[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
	[[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
	[[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
	[[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
	[[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
	[[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
	[[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
	[[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
	[[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
	[[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
	[[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
	[[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
	[[||.=='    _-'                                                     `' |  /==.||]],
	[[=='    _-'                        N E O V I M                         \/   `==]],
	[[\   _-'                                                                `-_   /]],
	[[ `''                                                                      ``' ]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("a", "󰃀  Marks", ":Telescope marks<CR>"),
	dashboard.button("g", "󰊄  Live grep", ":Telescope live_grep<CR>"),
	dashboard.button("e", "󰙅  Explorer", open_file_browser),
	dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
}
dashboard.section.header.opts.position = "center"
dashboard.section.buttons.opts.position = "center"

alpha.setup(dashboard.config)
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#A7C080", bold = true })

-- Lualine & Barbar Configuration
-- Configuration de Lualine (status bar)
require("lualine").setup({
	options = {
		theme = "everforest",
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

-- Neo-tree configuration
require("neo-tree").setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	auto_clean_after_session_restore = true,
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

-- hl on yank animation
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})
