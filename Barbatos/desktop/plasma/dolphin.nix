{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.customModules.dolphin;
  sidebarIconSize = 22;
  previewPlugins = [
    "jpegthumbnail"
    "comicbookthumbnail"
    "cursorthumbnail"
    "djvuthumbnail"
    "windowsimagethumbnail"
    "svgthumbnail"
    "appimagethumbnail"
    "windowsexethumbnail"
    "audiothumbnail"
    "ebookthumbnail"
    "exrthumbnail"
    "directorythumbnail"
    "imagethumbnail"
    "opendocumentthumbnail"
    "kraorathumbnail"
    "fontthumbnail"
    "gsthumbnail"
    "mobithumbnail"
    "blenderthumbnail"
    "ffmpegthumbs"
    "rawthumbnail"
    "aseprite"
  ];
in {
  options.customModules.dolphin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Dolphin globally or not";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      programs.plasma.configFile.dolphinrc = {
        General = {
          GlobalViewProps = false;
          ConfirmClosingMultipleTabs = false;
          RememberOpenedTabs = true;
          ShowFullPath = true;
        };
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = sidebarIconSize;
        };
        MainWindow = {
          MenuBar = false;
          ToolBarsMovable = false;
        };
        PlacesPanel = {
          IconSize = sidebarIconSize;
        };
        PreviewSettings = {
          Plugins = lib.concatStringsSep "," previewPlugins;
        };
      };
    };
  };
}
