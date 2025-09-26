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
  nvim-treesitter-with-parsers = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.go
    p.json
    p.lua
    p.markdown
    p.nix
    p.python
    p.regex
    p.yaml
  ]);
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
        extraPackages = with pkgs; [
          ansible-lint
          black
          dprint
          fd
          gccgo
          gofumpt
          golangci-lint
          gopls
          gotools
          isort
          lazygit
          lua-language-server
          nixd
          nixfmt-rfc-style
          nodePackages.jsonlint
          nodejs-slim
          python313Packages.pynvim
          ripgrep
          statix
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
          plenary-nvim

          # --- ColorScheme ---
          vscode-nvim

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
          nvim-treesitter-with-parsers # Treesitter for better syntax highlighting

          # --- Typing and Formatting ---
          auto-pairs # Pluging to autoclose opening brackets
          conform-nvim # Lightweight formatting plugin
          vim-commentary # comment tool

          # --- User Interface & Utility ---
          auto-session # automatic session recover
          bufferline-nvim # Buffer Tab tool
          lualine-nvim # Status line
          noice-nvim # Replaces the UI for messages and cmdline
          nui-nvim # Dependency for noice
          nvim-notify # Recommended dependency for better notifications
          nvim-tree-lua # File Tree for navigation
          nvim-web-devicons # nice icons
          telescope-file-browser-nvim # File browser
          telescope-nvim # Fuzzy finder (files, buffers, grep, etc.)
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
    };
  };
}
