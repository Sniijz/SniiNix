{
  vars,
  config,
  pkgs,
  lib,
  sources,
  ...
}:

{
  options.customModules.claude = {
    enable = lib.mkEnableOption "Enable claude terminal client";
  };

  config = lib.mkIf config.customModules.claude.enable {
    nixpkgs.overlays = [
      (final: prev: {
        claude-code = final.callPackage (
          sources.claude-code.outPath + "/package.nix"
        ) { };
      })
    ];
    home-manager.users.${vars.user}.home.packages = [ pkgs.claude-code ];
  };
}
