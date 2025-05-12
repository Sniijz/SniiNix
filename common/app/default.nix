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
    (import ./lazyjournal.nix {inherit vars lib pkgs config;})
    (import ./discord.nix {inherit vars lib pkgs config;})
    (import ./turtlewow.nix {inherit vars lib pkgs config;})
    (import ./warthunder.nix {inherit vars lib pkgs config;})
  ];
}
