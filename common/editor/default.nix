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
  ];
}
