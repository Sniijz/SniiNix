{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git.enable = true;
  programs.git.config = {
    user.name = "Robin CASSAGNE";
    user.email = "robin.jean.cassagne@gmail.com";
  };
}
