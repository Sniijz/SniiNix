{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  cfg = config.customModules.TurtleWoW;
in {
  options.customModules.TurtleWoW = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable TurtleWoW globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Install TurtleWoW

    home-manager.users.${vars.user} = {
      xdg.desktopEntries.TurtleWoW = {
        name = "TurtleWoW";
        genericName = "Turtle WoW Private Server";
        exec = "appimage-run /home/sniijz/Games/TurtleWoW/TurtleWoW.AppImage";
        icon = "/home/sniijz/Games/TurtleWoW/Banners/turtle_wow_icon.jpg";
        terminal = false;
        settings = {
          StartupWMClass = "TurtleWoW";
        };
      };
    };
  };
}
