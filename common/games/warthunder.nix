{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  cfg = config.customModules.WarThunder;
in {
  options.customModules.WarThunder = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable WarThunder globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Install WarThunder

    home-manager.users.${vars.user} = {
      xdg.desktopEntries.WarThunder = {
        name = "WarThunder";
        genericName = "War Thunder Steam Launcher";
        exec = ''steam-run "/home/sniijz/.local/share/Steam/steamapps/common/War Thunder/launcher"'';
        icon = "/home/sniijz/.local/share/Steam/steamapps/common/War Thunder/launcher.ico";
        terminal = false;
        settings = {
          StartupWMClass = "WarThunder";
        };
      };
    };
  };
}
