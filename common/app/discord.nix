{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  cfg = config.customModules.discord;
in {
  options.customModules.discord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable discord globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Install Discord
    environment.systemPackages = [pkgs.discord]; # Audio and Chat communication tool

    home-manager.users.${vars.user} = {
      xdg.desktopEntries.discord = {
        name = "Discord";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        exec = "Discord";
        icon = "discord";
        terminal = false;
        categories = ["Network" "InstantMessaging"];
        mimeType = ["x-scheme-handler/discord"];
        settings = {
          StartupWMClass = "discord";
        };
      };

      home.file.".config/autostart/discord.desktop" = {
        source = pkgs.writeText "discord.desktop" ''
          [Desktop Entry]
          Name=Discord
          GenericName=All-in-one cross-platform voice and text chat for gamers
          Exec=Discord --start-minimized
          X-KDE-Autostart-Delay=10
          X-GNOME-Autostart-Delay=10
          Icon=discord
          Terminal=false
          Categories=Network;InstantMessaging;
          MimeType=x-scheme-handler/discord;
          StartupWMClass=discord
          Type=Application
        '';
      };

      # Not yet implemented in Home-Manager 24.11
      # But deployed in 2025 : https://github.com/nix-community/home-manager/commits/master/modules/misc/xdg-autostart.nix
      # xdg.autostart = {
      #   enable = true;
      #   entries = ["discord.desktop"];
      # };
    };
  };
}
