{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./vscode.nix {inherit vars pkgs config lib;})
    (import ./neovim.nix {inherit vars pkgs lib config;})
  ];
}
