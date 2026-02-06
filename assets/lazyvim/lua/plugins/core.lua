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
}
