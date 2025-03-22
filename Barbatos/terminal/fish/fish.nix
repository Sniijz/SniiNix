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

    # bind ctrl+f to launch fzf
    interactiveShellInit = ''
      function fzf_find
          commandline -r (find . | fzf)
      end
      bind \cf fzf_find
    '';

    shellAbbrs = sharedShellAbbrs;

    shellAliases = sharedShellAliases;
  };
}
