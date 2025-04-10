{
  vars,
  config,
  pkgs,
  lib,
  ...
}: let
  starshipCfg = config.customModules.starship;

  # On récupère le premier thème activé
  activeTheme = lib.head (lib.attrNames (lib.filterAttrs (_: v: v.enable) starshipCfg));
in {
  options.customModules.starship = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable this starship theme.";
      };
    });
    default = {};
    description = "Starship theme configuration";
  };

  config = lib.mkIf (activeTheme != null) {
    home-manager.users.${vars.user} = {
      programs.starship.enable = true;
      home.file.".config/starship.toml".source = ./configs/starship-${activeTheme}.toml;
    };
  };
}
