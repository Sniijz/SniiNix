# neovim
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.customModules.neovim;
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
    programs.neovim = {
      enable = true;
      # plugins = with pkgs.vimPlugins; [
      #   lazy-nvim
      #   clangd_extensions-nvim
      #   nvim-lspconfig
      #   nvchad
      # ];
      #extraLuaConfig = builtins.readFile ./configs/init.lua;
    };
  };
}
