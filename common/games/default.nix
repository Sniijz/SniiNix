{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./turtlewow.nix {inherit vars lib pkgs config;})
    (import ./warthunder.nix {inherit vars lib pkgs config;})
  ];
}
