# mysql
{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.customModules.mysql;
in
{
  options.customModules.mysql = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable mysql globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
}
