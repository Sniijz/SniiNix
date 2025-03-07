{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./flatpak.nix {inherit vars pkgs config;})
    (import ./gamemode.nix {inherit vars pkgs config;})
    (import ./steam.nix {inherit vars pkgs config;})
    # (import ./sunshine.nix {inherit vars pkgs config lib;})
  ];
}
