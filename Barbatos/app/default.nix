{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./flatpak.nix {inherit vars lib pkgs config;})
    (import ./gamemode.nix {inherit vars lib pkgs config;})
    (import ./steam.nix {inherit vars lib pkgs config;})
    (import ./sunshine.nix {inherit vars lib pkgs config;})
  ];
}
