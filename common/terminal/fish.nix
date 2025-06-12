# FISH
{
  config,
  pkgs,
  sharedShellAbbrs,
  sharedShellAliases,
  sharedShellFunctions,
  ...
}: {
  # Install DroidSansMono NerdFont
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
  ];

  environment.systemPackages = with pkgs; [
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.z
    fzf
  ];

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

      bind \ck 'k9s'

      function journalctl_fzf
          journalctl -n 1500 --no-pager | fzf
      end
      bind \cj journalctl_fzf
    '';

    shellAbbrs = sharedShellAbbrs;

    shellAliases = sharedShellAliases;
  };
}
