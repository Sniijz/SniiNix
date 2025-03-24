# konsole
{
  vars,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.customModules.konsole;
in {
  options.customModules.konsole = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable konsole globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Konsole home-manager example :
    # https://github.com/gboncoffee/nix-configs/blob/bfd9ee135e76009e7f59f5cb86368676b6c332cd/home-manager.nix#L15
    # https://nix-community.github.io/plasma-manager/options.xhtml
    home-manager.users.${vars.user} = {
      programs.konsole = {
        enable = true;
        defaultProfile = "Sniinix";
        customColorSchemes = {
          SniiBreeze = ./configs/Breeze.colorscheme;
        };
        profiles = {
          SniiNix = {
            name = "Sniinix";
            font = {
              name = "DroidSansM Nerd Font";
              size = 12;
            };
            extraConfig = {
              Appearance = {
                ColorScheme = "SniiBreeze";
              };

              General = {
                Parent = "FALLBACK/";
              };

              "Interaction Options" = {
                AutoCopySelectedText = true;
                TrimLeadingSpacesInSelectedText = true;
                TrimTrailingSpacesInSelectedText = true;
              };

              MainWindow = {
                ToolBarsMovable = "Disabled";
              };

              "Notification Messages" = {
                CloseAllTabs = true;
              };
            };
          };
        };
      };
    };
  };
}
