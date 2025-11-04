{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.customModules.bluetooth;
in {
  options.customModules.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable bluetooth globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # enables support for Bluetooth
    hardware.bluetooth.enable = true;
    # powers up the default Bluetooth controller on boot
    hardware.bluetooth.powerOnBoot = true;
    # Blueman soft instead of kdePackages.bluedevil, disabling applet from systemtray
    # services.blueman.enable = true;
  };
}
