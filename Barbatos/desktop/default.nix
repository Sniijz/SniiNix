{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./kde/kde.nix {inherit vars pkgs config lib;})
  ];
}
