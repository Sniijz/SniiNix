{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.customModules.printer;
in {
  options.customModules.printer = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable printer globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = with pkgs; [epson-escpr epson-escpr2];
      browsing = true;
      defaultShared = true;
    };

    # Scanner activation
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.epsonscan2];
    };
  };
}
