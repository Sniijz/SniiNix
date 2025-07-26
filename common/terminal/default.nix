{
vars,
pkgs,
lib,
config,
...
}: let
  sharedShellAbbrs = {
    # General Terminal Aliases
    ll = "exa -alh";
    tree = "exa --tree";
    k = "${pkgs.kubectl}/bin/kubectl";
    fs = "du -hd 1 | sort -h";
  };

  sharedShellAliases = {
  };

  sharedShellFunctions = {};
in {
  imports = [
    (import ./bash.nix {inherit pkgs config;})
    (import ./fish.nix {inherit pkgs config sharedShellAbbrs sharedShellAliases sharedShellFunctions;})
    (import ./tmux.nix {inherit pkgs config;})
    (import ./starship.nix {inherit vars pkgs lib config;})
    (import ./konsole.nix {inherit vars lib pkgs config;})
    (import ./ghostty.nix {inherit vars lib pkgs config;})
    (import ./kitty.nix {inherit vars lib pkgs config;})
  ];
}
