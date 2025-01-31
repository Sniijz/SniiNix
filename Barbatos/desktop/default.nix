{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./kde.nix {inherit vars pkgs config lib;})
  ];
}
