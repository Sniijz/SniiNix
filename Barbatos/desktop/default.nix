{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./plasma/kde.nix {inherit vars pkgs config lib;})
    (import ./plasma/dolphin.nix {inherit vars pkgs config lib;})
  ];
}
