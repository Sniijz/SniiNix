{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  cfg = config.customModules.onedrive;
in {
  options.customModules.onedrive = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable onedrive globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Install onedrive
    environment.systemPackages = [pkgs.onedrive pkgs.onedrivegui]; # Audio and Chat communication tool

    home-manager.users.${vars.user} = {
      home.file.".config/autostart/onedrivegui.desktop" = {
        source = pkgs.writeText "onedrive.desktop" ''
          [Desktop Entry]
          Name=onedrivegui
          GenericName=All-in-one cross-platform voice and text chat for gamers
          Exec=onedrivegui
          X-KDE-Autostart-Delay=10
          X-GNOME-Autostart-Delay=10
          Icon=onedrive
          Terminal=false
          Categories=Network;Files;
          MimeType=x-scheme-handler/onedrivegui;
          StartupWMClass=onedrivegui
          Type=Application
        '';
      };
    };
  };
}
