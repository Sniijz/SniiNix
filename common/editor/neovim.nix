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

  pico8-extension = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "pico8-ls";
      publisher = "pollywoggames";
      version = "0.6.1";
      sha256 = "sha256-TlULqIKb3R+bvjN3f4Bwha0bewqCHpPVFiePHNV2kmE=";
    };
  };

  pico8-ls = pkgs.writeShellScriptBin "pico8-ls" ''
    exec ${pkgs.nodejs}/bin/node \
      ${pico8-extension}/share/vscode/extensions/PollywogGames.pico8-ls/server/out-min/main.js \
      "$@"
  '';
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
          # ansible-lint
          black
          chafa
          delve
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
          nodejs
          pico8-ls
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
          nvim-lint # nvim linter
          vim-pico8-syntax # pico8 syntax

          # --- Completion ---
          cmp-nvim-lsp # LSP completion source for nvim-cmp
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

          # --- User Interface & Utility ---
          auto-session # automatic session recover
          barbar-nvim # Buffer Tab tool
          lualine-nvim # Status line
          markdown-preview-nvim # Mardown http rendering tool
          mini-nvim # All-in-one plugin
          neo-tree-nvim # File tree for navigation
          neoformat # Markdown formatter
          noice-nvim # Replaces the UI for messages and cmdline
          nui-nvim # Dependency for noice and neo-tree
          nvim-notify # Recommended dependency for better notifications
          plenary-nvim # Dependency for noice and neo-tree
          satellite-nvim # scrollbar
          telescope-emoji-nvim # emoji finder for telescope
          telescope-file-browser-nvim # File browser
          telescope-media-files-nvim # media file previewer for telescope
          telescope-nvim # Fuzzy finder (files, buffers, grep, etc.)
          telescope-undo-nvim # Parse through file/git history of actual buffer
          tiny-inline-diagnostic-nvim # inline diagnostic
          vim-tmux-navigator # tmux plugin for vim
          zoxide-vim # add zoxide z support in vim -> :Z

          # --- Debug Adapter Protocol ---
          nvim-dap
          nvim-dap-ui
          nvim-dap-go

          # --- git ---
          lazygit-nvim # to integrate lazygit into vim
          vim-fugitive # better git for merge conflict, blame

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
