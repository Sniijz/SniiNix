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
      set -U fish_user_paths (go env GOPATH)/bin $fish_user_paths
    '';

    shellAbbrs = sharedShellAbbrs;

    shellAliases = sharedShellAliases;
  };
}
