{
  config,
  pkgs,
  lib,
  vars,
  ...
}:

let
  cfg = config.customModules.crush;
  nur =
    import
      (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz")
      {
        inherit pkgs;
      };

  inherit (nur.repos.charmbracelet) crush;

  crushLspPackages = with pkgs; [
    nil
    gopls
  ];

in
{
  options.customModules.crush = {
    enable = lib.mkEnableOption "Enable crush shell";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      home.packages = [
        (pkgs.symlinkJoin {
          name = "crush-wrapped";
          paths = [ crush ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/crush \
              --suffix PATH : ${lib.makeBinPath crushLspPackages}
          '';
        })
      ];
    };
  };
}
