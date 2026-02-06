return {
  -- Go Support
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg = true,
        lsp_gofumpt = true,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

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
}
