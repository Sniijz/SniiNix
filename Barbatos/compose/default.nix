{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    (import ./syncthing/docker-compose.nix {inherit vars pkgs config lib;})
    # (import ./ollama/docker-compose.nix {inherit vars pkgs config lib;})
    # (import ./wolf/docker-compose.nix {inherit vars pkgs config lib;})
  ];
}
