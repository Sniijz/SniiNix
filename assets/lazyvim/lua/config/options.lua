-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable auto format (LazyVim default is true, confirming here)
vim.g.autoformat = true

-- LazyVim root dir detection
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Default Options from your config
vim.opt.termguicolors = true -- Enable true color support
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Override ignorecase if search pattern has uppercase letters
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor when scrolling
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor when scrolling
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show search results incrementally
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 500 -- Faster update time for CursorHold events
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.wrap = false -- Force vim to show all text in actual window/pane
-- vim.opt.linebreak = true -- Disabled because wrap is false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Clipboard (NixOS usually handles this via 'xclip' or 'wl-copy' in system packages)
if vim.fn.has("clipboard") == 1 then
  vim.g.clipboard = "osc52"
  vim.opt.clipboard = "unnamedplus"
end

-- Markdown browser
vim.g.mkdp_browser = "firefox"

-- Everforest settings (Must be set before loading the theme)
vim.g.everforest_background = "soft"
vim.g.everforest_transparent_background = 1

-- Diabling mini.animate for scroll animations
vim.g.snacks_animate = false
