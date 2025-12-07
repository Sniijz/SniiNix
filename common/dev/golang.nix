# golang
{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.customModules.golang;
in
{
  options.customModules.golang = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable golang globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      home.packages = [ pkgs.gcc ];
      home.sessionPath = [
        "$HOME/go/bin"
      ];
      programs.go = {
        enable = true;
        goPath = "go";
      };
      home.sessionVariables = {
        CGO_ENABLED = "1";
      };
    };
  };
}
