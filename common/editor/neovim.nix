# neovim
{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.customModules.neovim;
  # minimap-vim = pkgs.vimUtils.buildVimPlugin {
  #   name = "minimap-vim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "wfxr";
  #     repo = "minimap.vim";
  #     rev = "3fe7878d83156cc9351fa94e25b0de854bcd6f8d";
  #     sha256 = "1l9di7q0mlbcgs4xbqg2ias3hy5qib72zi1nwjw06snxlffz2hpq";
  #   };
  # };
in
{
  options.customModules.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable neovim globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [code-minimap];
    home-manager.users.${vars.user} = {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        extraPackages = with pkgs; [
          ansible-lint
          black
          chafa
          dprint
          eslint
          fd
          fontpreview
          gccgo
          gofumpt
          golangci-lint
          gopls
          gotools
          htmlhint
          isort
          lazygit
          ltex-ls
          ltex-ls-plus
          lua-language-server
          nixd
          nixfmt-rfc-style
          nodePackages.jsonlint
          nodejs
          python313Packages.pynvim
          ripgrep
          statix
          stylelint
          stylua
          terraform-ls
          tree-sitter
          vscode-langservers-extracted
          yaml-language-server
          yamlfmt
          yamllint
          yq
        ];
        plugins = with pkgs.vimPlugins; [
          # --- Core Dependencies ---

          # --- ColorScheme ---
          vscode-nvim # vscode theme
          everforest # everforest theme
          gruvbox-material # gruvbox-material theme

          # --- LSP (Language Server Protocol) ---
          nvim-lspconfig # Configurations for the built-in LSP client
          cmp-nvim-lsp # LSP completion source for nvim-cmp
          nvim-lint # nvim linter

          # --- Completion ---
          cmp-buffer # Completion source for text in current buffer
          cmp-path # Completion source for filesystem paths
          cmp_luasnip # Luasnip completion source for nvim-cmp
          friendly-snippets # Provides useful snippets for many languages
          lspkind-nvim # Nice icons in lsp helps messages
          luasnip # Snippet engine
          nvim-cmp # Autocompletion plugin

          # --- Syntax Highlighting ---
          nvim-treesitter.withAllGrammars # Parsers/Syntax Highlighting for all languages detailed in lockfile

          # --- Typing and Formatting ---
          conform-nvim # Lightweight formatting plugin
          vim-commentary # comment tool

          # --- User Interface & Utility ---
          auto-session # automatic session recover
          barbar-nvim # Buffer Tab tool
          colorizer # Show colors when using hexcodes
          glow-nvim # Markdown rendering tool
          lualine-nvim # Status line
          markdown-preview-nvim # Mardown http rendering tool
          neo-tree-nvim # File tree for navigation
          neoformat # Markdown formatter
          noice-nvim # Replaces the UI for messages and cmdline
          nui-nvim # Dependency for noice and neo-tree
          nvim-notify # Recommended dependency for better notifications
          nvim-web-devicons # nice icons
          plenary-nvim # Dependency for noice and neo-tree
          smear-cursor-nvim # cursors animation
          telescope-file-browser-nvim # File browser
          telescope-media-files-nvim # media file previewer for telescope
          telescope-nvim # Fuzzy finder (files, buffers, grep, etc.)
          telescope-undo-nvim # Parse through file/git history of actual buffer
          tiny-inline-diagnostic-nvim # inline diagnostic
          toggleterm-nvim # integrated nvim term
          vim-floaterm # integrated floating nvim terminal
          vim-tmux-navigator # tmux plugin for vim
          zoomwintab-vim # plugin to zoominout with ctrl+w + o
          zoxide-vim # add zoxide z support in vim -> :Z

          # --- git ---
          lazygit-nvim # to integrate lazygit into vim
          vim-fugitive # better git for merge conflict, blame
          vim-gitgutter # to show modifications made in the gutter (left side of editor)
          git-blame-nvim # git blame inline plugin

          # --- Vim Game ---
          vim-be-good
        ];
        extraLuaConfig = builtins.readFile ../../assets/neovim/init.lua;
      };
      # Formatters and linters tuning
      # yamlfmt config
      xdg.configFile."yamlfmt/.yamlfmt".text = ''
        formatter:
          retain_line_breaks: true
      '';
    };
  };
}
