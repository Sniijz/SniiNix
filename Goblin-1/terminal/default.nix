{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
  sharedShellAbbrs = {
    # General Terminal Aliases
    ll = "exa -alh";
    tree = "exa --tree";
    vim = "nvim";
    vi = "nvim";
    k = "${pkgs.kubectl}/bin/kubectl";
  };

  sharedShellAliases = {};

  sharedShellFunctions = {};
in {
  imports = [
    (import ./bash.nix {inherit vars pkgs config lib;})
    (import ./fish.nix {inherit vars pkgs config lib sharedShellAbbrs sharedShellAliases sharedShellFunctions;})
  ];
}
