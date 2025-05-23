{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./git.nix {inherit vars lib pkgs config;})
    (import ./generals.nix {inherit vars lib pkgs config;})
    (import ./printer.nix {inherit vars lib pkgs config;})
    (import ./bluetooth.nix {inherit vars lib pkgs config;})
    (import ./audio.nix {inherit vars lib pkgs config;})
  ];
}
