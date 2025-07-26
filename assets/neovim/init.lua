-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Basic Neovim Options
vim.opt.termguicolors = true -- Enable true color support
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 2       -- Size of an indent
vim.opt.tabstop = 2          -- Number of spaces tabs count for
vim.opt.softtabstop = 2      -- Number of spaces tabs count for in editing operations
vim.opt.ignorecase = true    -- Ignore case when searching
vim.opt.smartcase = true     -- Override ignorecase if search pattern has uppercase letters
vim.opt.wrap = false         -- Do not wrap lines
vim.opt.scrolloff = 8        -- Keep 8 lines visible above/below cursor when scrolling
vim.opt.sidescrolloff = 8    -- Keep 8 columns visible left/right of cursor when scrolling
vim.opt.hlsearch = true      -- Highlight search results
vim.opt.incsearch = true     -- Show search results incrementally
vim.opt.undofile = true      -- Enable persistent undo
vim.opt.updatetime = 300     -- Faster update time for CursorHold events (e.g., LSP hover)
vim.opt.signcolumn = "yes"   -- Always show the sign column to avoid layout shifts
vim.opt.wrap = true          -- Force vim to show all text in actual window/pane
vim.opt.linebreak = true     -- Avoid to open a new line in a middle of a word for too long lines
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set localleader key to space

if vim.fn.has("clipboard") == 1 then
  vim.opt.clipboard = "unnamedplus"
end
vim.diagnostic.config({
  virtual_lines= true,
  signs = true,
})

-- nvim-tree config
-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
-- Hotkey configuration for nvim-tree
-- <C-b> means Ctrl + b in normal mode
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", {
  noremap = true,
  silent = true,
})


-- Move actual line/selection with Alt + j/k
vim.keymap.set('n', '<A-j>', ':m+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m-2<CR>==')
vim.keymap.set('v', '<A-j>', ":m'>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m'<-2<CR>gv=gv")

-- Move actual line/selection with arrow keys
vim.keymap.set('n', '<A-Down>', ':m+1<CR>==')
vim.keymap.set('n', '<A-Up>',   ':m-2<CR>==')
vim.keymap.set('v', '<A-Down>', ":m'>+1<CR>gv=gv")
vim.keymap.set('v', '<A-Up>',   ":m'<-2<CR>gv=gv")

-- NeoVim Theme
vim.cmd.colorscheme('vscode')

-- Transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


-- hl on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
})

-- Helper function for keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Setup Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {},
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- Setup LSP (nvim-lspconfig)
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Defines capabilities for LSP servers based on nvim-cmp setup
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Function to run on LSP attach (sets buffer-local keymaps)
local on_attach = function(client, bufnr)
  map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to Definition" })
  map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
  map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to Implementation" })
  map('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: Show References" })
  map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
  map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })
  map('n', 'gl', vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP: Show Line Diagnostics" })
  map('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = "LSP: Previous Diagnostic" })
  map('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = "LSP: Next Diagnostic" })

  -- Enable formatting via conformif the LSP server doesn't provide it natively
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "LSP: Format" })
  end
end

local servers = {
  'bashls',
  'gopls',
  'jsonls',
  'terraformls',
  'yamlls',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Configure pyright (Python)
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      pythonPath = vim.fn.exepath('python'),
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      }
    }
  }
}

-- Configure nixd language server
lspconfig.nixd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    nixd = {
      formatting = {
        command = { "alejandra" };
      };
    };
  };
}
-- Configure lua_ls language server
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua= {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = {
        globals = { 'vim' },
      };
      format = {
        enable = true,
      },
      hint = {
        enable = true,
      },
    };
  };
}

-- Setup completion
vim.opt.completeopt = {'menu', 'menuone'}

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' }
  })
})

-- Configure autoIndent on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Sauvegarde la position du curseur et de la vue
    local view = vim.fn.winsaveview()
    -- Indente tout le fichier (gg=G)
    vim.cmd('normal! gg=G')
    -- Restaure la position du curseur et de la vue
    vim.fn.winrestview(view)
  end,
})

-- Setup Telescope (fuzzy finder)
local telescope = require('telescope')
telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--no-ignore'
    }
  },
  pickers = {
    -- Configure specific pickers if needed
  },
  extensions = {
    -- Load extensions if you add any
  }
}
-- Add keymaps for Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find Files" })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live Grep" })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = "Find Buffers" })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = "Help Tags" })
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = "previous files" })

-- Setup Telescope File Browser
require('telescope').load_extension('file_browser')
-- Add keympas for Telescope File Browser
map('n', '<leader>fe', '<cmd>Telescope file_browser<cr>', { desc = "Browse Files" })
