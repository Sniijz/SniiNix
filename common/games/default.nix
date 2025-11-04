{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./gamemode.nix {inherit vars lib pkgs config;})
    (import ./steam.nix {inherit vars lib pkgs config;})
    (import ./sunshine.nix {inherit vars lib pkgs config;})
    (import ./turtlewow.nix {inherit vars lib pkgs config;})
    (import ./warthunder.nix {inherit vars lib pkgs config;})
  ];
}
