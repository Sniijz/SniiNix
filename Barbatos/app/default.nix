{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./vscode.nix {inherit vars pkgs config lib;})
    (import ./sunshine.nix {inherit vars pkgs config lib;})
    (import ./flatpak.nix {inherit vars pkgs config;})
    (import ./docker.nix {inherit vars pkgs config;})
  ];
}
