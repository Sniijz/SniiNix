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
    (import ./lazyjournal.nix {inherit vars lib pkgs config;})
    (import ./discord.nix {inherit vars lib pkgs config;})
    (import ./onedrive.nix {inherit vars lib pkgs config;})
  ];
}
