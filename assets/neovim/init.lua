-- =======================================================================================
-- Global Variables and Settings
-- =======================================================================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set localleader key to space

-- =======================================================================================
-- Basic Neovim Options
-- =======================================================================================
vim.opt.termguicolors = true -- Enable true color support
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 2       -- Size of an indent
vim.opt.tabstop = 2          -- Number of spaces tabs count for
vim.opt.softtabstop = 2      -- Number of spaces tabs count for in editing operations
vim.opt.ignorecase = true    -- Ignore case when searching
vim.opt.smartcase = true     -- Override ignorecase if search pattern has uppercase letters
vim.opt.scrolloff = 8        -- Keep 8 lines visible above/below cursor when scrolling
vim.opt.sidescrolloff = 8    -- Keep 8 columns visible left/right of cursor when scrolling
vim.opt.hlsearch = true      -- Highlight search results
vim.opt.incsearch = true     -- Show search results incrementally
vim.opt.undofile = true      -- Enable persistent undo
vim.opt.updatetime = 300     -- Faster update time for CursorHold events (e.g., LSP hover)
vim.opt.signcolumn = "yes"   -- Always show the sign column to avoid layout shifts
vim.opt.laststatus = 3       -- Use a global statusline, required for lualine
vim.opt.wrap = true          -- Force vim to show all text in actual window/pane
vim.opt.linebreak = true     -- Avoid to open a new line in a middle of a word for too long lines
vim.opt.completeopt = {'menu', 'menuone'} -- Setup completion

if vim.fn.has("clipboard") == 1 then -- Configure unique clipboard between vim and system
  vim.opt.clipboard = "unnamedplus"
end

vim.diagnostic.config({
  virtual_lines= true,
  signs = true,
})

-- =======================================================================================
-- Keymaps
-- =======================================================================================
-- Helper function for keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Move lines up/down
map('n', '<A-j>', ':m+1<CR>==', { desc = "Move line down" })
map('n', '<A-k>', ':m-2<CR>==', { desc = "Move line up" })
map('v', '<A-j>', ":m'>+1<CR>gv=gv", { desc = "Move selection down" })
map('v', '<A-k>', ":m'<-2<CR>gv=gv", { desc = "Move selection up" })
map('n', '<A-Down>', ':m+1<CR>==', { desc = "Move line down" })
map('n', '<A-Up>', ':m-2<CR>==', { desc = "Move line up" })
map('v', '<A-Down>', ":m'>+1<CR>gv=gv", { desc = "Move selection down" })
map('v', '<A-Up>', ":m'<-2<CR>gv=gv", { desc = "Move selection up" })

-- Add keymaps for Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find Files" })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live Grep" })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = "Find Buffers" })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = "Help Tags" })
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = "previous files" })

-- Hotkey configuration for nvim-tree
-- <C-b> means Ctrl + b in normal mode
map("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- Keymaps for bufferline
map('n', '<leader>bn', ':BufferLineCycleNext<CR>', { desc = "Next buffer" })
map('n', '<leader>bp', ':BufferLineCyclePrev<CR>', { desc = "Previous buffer" })


-- =======================================================================================
-- Neovim Theme
-- =======================================================================================
-- colorscheme
vim.cmd.colorscheme('vscode')

-- Transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


-- Lualine & Bufferline Configuration
-- Configuration de Lualine (status bar)
require('lualine').setup {
  options = {
    theme = 'vscode',
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {'nvim-tree'}
}

-- Configuration de Bufferline (onglets)
require('bufferline').setup {
  options = {
    mode = "buffers", -- style of tabs
    separator_style = "thin", -- thin vertical bar to separate tabs
    numbers = "ordinal", -- show buffers numbers
    show_buffer_close_icons = true, -- close icons
    show_close_icon = true,
    offsets = {     -- Offset tabs to not overlap nvimtree
        {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true
        }
    }
  }
}


-- =======================================================================================
-- Autocmds
-- =======================================================================================

-- hl on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
})

-- =======================================================================================
-- Plugin Configuration
-- =======================================================================================

-- nvim-tree config
-- setup with some options
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

-- Noice configuration
require('noice').setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = true,
    }
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
})

-- Configuration pour nvim-notify
require("notify").setup({
  background_colour = "#000000",
})

-- =======================================================================================
-- LSP Configuration
-- =======================================================================================

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
  map('n', '<F2>', vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
  map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })
  map('n', 'gl', vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP: Show Line Diagnostics" })
  map('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = "LSP: Previous Diagnostic" })
  map('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = "LSP: Next Diagnostic" })

  -- Enable formatting via conformif the LSP server doesn't provide it natively
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "LSP: Format" })
  end

  -- Auto import package on save for go
  if client.name == "gopls" then
    if client.supports_method("textDocument/codeAction") then
      local augroup = vim.api.nvim_create_augroup("GoImportsOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" }, diagnostics = vim.diagnostic.get(bufnr) },
            apply = true,
          })
        end,
      })
    end
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

-- Configure gopls language server
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      staticcheck = true,
      gofumpt = true,
    }
  }
})

-- =======================================================================================
-- CMP Configuration
-- =======================================================================================
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

cmp.setup{
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
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
    })
  },
  cmdline = {
    [':'] = {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' }
      })
    },
    ['/'] = {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    }
  },
}

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


-- Setup Telescope File Browser
require('telescope').load_extension('file_browser')


