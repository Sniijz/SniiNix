{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.customModules.gamemode;
in {
  options.customModules.gamemode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable gamemode globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Install Gamemode
    # Settings available here : https://github.com/FeralInteractive/gamemode/blob/master/example/gamemode.ini
    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          softrealtime = "auto";
          desiredgov = "performance";
          desiredprof = "performance";
          igpu_desiredgov = "performance";
          inhibit_screensaver = 1;
        };
        custom = let
          notify = "${pkgs.libnotify}/bin/notify-send";
        in {
          start = "${notify} 'Game Mode Enabled'";
          end = "${notify} 'Game Mode Disabled'";
        };
      };
    };
  };
}
