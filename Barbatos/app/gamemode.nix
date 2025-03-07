{
  config,
  pkgs,
  ...
}: let
in {
  # Install Gamemode
  # Settings available here : https://github.com/FeralInteractive/gamemode/blob/master/example/gamemode.ini
  programs.gamemode = {
    enable = true;
    enableRenice = true;

    settings = {
      general = {
        renice = 10;
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
}
