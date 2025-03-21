# neovim
{
  config,
  pkgs,
  ...
}: {
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
}
