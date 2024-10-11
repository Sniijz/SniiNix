# FISH
{
  config,
  pkgs,
  sharedShellAbbrs,
  sharedShellAliases,
  sharedShellFunctions,
  ...
}: {

    programs.fish = {
      enable = true;

      shellInit = ''
        starship init fish | source
      '';

      shellAbbrs = sharedShellAbbrs;

      shellAliases = sharedShellAliases;

    };
}
