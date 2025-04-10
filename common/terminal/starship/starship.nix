# starship
{
  vars,
  config,
  pkgs,
  ...
}: {
  home-manager.users.${vars.user} = {
    programs.starship.enable = true;
    home.file.".config/starship.toml".source = ./configs/starship.toml;
  };
}
