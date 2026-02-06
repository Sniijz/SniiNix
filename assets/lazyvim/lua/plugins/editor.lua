return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        "<leader>fe",
        function()
          local telescope = require("telescope")
          local actions = require("telescope.actions")
          local fb_actions = telescope.extensions.file_browser.actions
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
        end,
        desc = "File Browser",
      },
    },
    opts = {
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
    opts = {
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
