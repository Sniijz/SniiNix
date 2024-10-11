# FISH
{
  config,
  pkgs,
  lib,
  vars,
  sharedShellAbbrs,
  sharedShellAliases,
  sharedShellFunctions,
  ...
}: {
  home-manager.users.${vars.user} = {
    programs.fish = {
      enable = true;

      shellInit = ''
        starship init fish | source
      '';

      shellAbbrs = sharedShellAbbrs;

      shellAliases = sharedShellAliases;

      functions = sharedShellFunctions;
    };
  };
}
