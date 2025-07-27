# neovim
{
config,
pkgs,
lib,
vars,
...
}: let
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
    p.yaml
  ]);
in {
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
          nixd
          statix
          alejandra
          ripgrep
          fd
          gopls
          lua-language-server
        ];
        plugins = with pkgs.vimPlugins; [
          # --- Core Dependencies ---
          plenary-nvim

          # --- ColorScheme ---
          # gruvbox-nvim
          vscode-nvim

          # --- LSP (Language Server Protocol) ---
          nvim-lspconfig # Configurations for the built-in LSP client
          cmp-nvim-lsp # LSP completion source for nvim-cmp

          # --- Completion ---
          nvim-cmp # Autocompletion plugin
          cmp-buffer # Completion source for text in current buffer
          cmp-path # Completion source for filesystem paths
          luasnip # Snippet engine
          cmp_luasnip # Luasnip completion source for nvim-cmp
          # Optional: Provides useful snippets for many languages
          friendly-snippets

          # --- Syntax Highlighting ---
          nvim-treesitter-with-parsers # Treesitter for better syntax highlighting

          # --- Formatting ---
          conform-nvim # Lightweight formatting plugin
          auto-pairs # Pluging to autoclose opening brackets

          # --- User Interface & Utility ---
          lualine-nvim # Status line
          nvim-tree-lua # File Tree for navigation
          telescope-nvim # Fuzzy finder (files, buffers, grep, etc.)
          telescope-file-browser-nvim # File browser
          vim-tmux-navigator # tmux plugin for vim
          vim-commentary # comment tool

          # --- git ---
          vim-gitgutter # to show modifications made in the gutter (left side of editor)
          vim-fugitive # better git for merge conflict, blame
        ];
        extraLuaConfig = builtins.readFile ../../assets/neovim/init.lua;
      };
    };
  };
}
