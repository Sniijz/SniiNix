# neovim
{
  config,
  pkgs,
  lib,
  vars,
  ...}:
let
  cfg = config.customModules.neovim;

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
    home-manager.users.${vars.user} = {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        
        # Tools and LSPs managed by Nix
        extraPackages = with pkgs; [
          # Build tools & Formatters
          gcc
          gnumake
          unzip
          wget
          curl
          gzip
          gnutar
          
          # LSPs and Linters
          ansible-lint
          black
          delve
          dprint
          eslint
          fd
          gofumpt
          golangci-lint
          gopls
          gotests
          gotools
          htmlhint
          isort
          lazygit
          lua-language-server
          nixd
          nixfmt-rfc-style
          nodejs
          python313Packages.pynvim
          ripgrep
          statix
          stylelint
          stylua
          terraform-ls
          vscode-langservers-extracted
          yaml-language-server
          yamlfmt
          yamllint
          
          # Custom
          pico8-ls
        ];
      };

      # Link LazyVim configuration files
      xdg.configFile."nvim/init.lua".source = ../../assets/lazyvim/init.lua;
      xdg.configFile."nvim/lua/config/lazy.lua".source = ../../assets/lazyvim/lua/config/lazy.lua;
      xdg.configFile."nvim/lua/config/options.lua".source = ../../assets/lazyvim/lua/config/options.lua;
      xdg.configFile."nvim/lua/config/keymaps.lua".source = ../../assets/lazyvim/lua/config/keymaps.lua;
      xdg.configFile."nvim/lua/config/autocmds.lua".source = ../../assets/lazyvim/lua/config/autocmds.lua;
      
      # Plugins Configuration
      xdg.configFile."nvim/lua/plugins/core.lua".source = ../../assets/lazyvim/lua/plugins/core.lua;
      xdg.configFile."nvim/lua/plugins/ui.lua".source = ../../assets/lazyvim/lua/plugins/ui.lua;
      xdg.configFile."nvim/lua/plugins/editor.lua".source = ../../assets/lazyvim/lua/plugins/editor.lua;
      xdg.configFile."nvim/lua/plugins/coding.lua".source = ../../assets/lazyvim/lua/plugins/coding.lua;
      xdg.configFile."nvim/lua/plugins/lsp.lua".source = ../../assets/lazyvim/lua/plugins/lsp.lua;

      # YAML formatter config
      xdg.configFile."yamlfmt/.yamlfmt".text = ''
        formatter:
          retain_line_breaks: true
      '';
    };
  };
}