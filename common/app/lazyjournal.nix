{
  config,
  pkgs,
  lib,
  ...
}: let
  sources = import ../../nix/sources.nix;
in {
  options.customModules.lazyjournal = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable lazyjournal globally or not
      '';
    };
  };

  config = lib.mkIf config.customModules.lazyjournal.enable {
    environment.systemPackages = with pkgs; [
      (pkgs.buildGoModule {
        name = "lazyjournal";

        src = sources.lazyjournal;

        vendorHash = "sha256-faMGgTJuD/6CqR+OfGknE0dGdDOSwoODySNcb3kBLv8=";
        doCheck = false; # Désactiver les tests go
        meta = with lib; {
          description = "A journaling CLI written in Go";
          homepage = "https://github.com/Lifailon/lazyjournal";
          license = licenses.mit;
        };
      })
    ];
  };
}
