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
    vim = "nvim";
    vi = "nvim";
    k = "${pkgs.kubectl}/bin/kubectl";
    fs = "du -hd 1 | sort -h";
  };

  sharedShellAliases = {
    tmux = "tmux new-session -A";
  };

  sharedShellFunctions = {};
in {
  imports = [
    (import ./bash/bash.nix {inherit pkgs config;})
    (import ./fish/fish.nix {inherit pkgs config sharedShellAbbrs sharedShellAliases sharedShellFunctions;})
    (import ./tmux/tmux.nix {inherit pkgs config;})
    (import ./neovim/neovim.nix {inherit pkgs lib config;})
    (import ./starship/starship.nix {inherit vars pkgs config;})
    (import ./konsole/konsole.nix {inherit vars lib pkgs config;})
    (import ./ghostty/ghostty.nix {inherit vars lib pkgs config;})
    (import ./kitty/kitty.nix {inherit vars lib pkgs config;})
  ];
}
