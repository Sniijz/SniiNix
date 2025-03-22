# konsole
{
  vars,
  config,
  pkgs,
  ...
}: {
  # Konsole home-manager example :
  # https://github.com/gboncoffee/nix-configs/blob/bfd9ee135e76009e7f59f5cb86368676b6c332cd/home-manager.nix#L15
  home-manager.users.${vars.user} = {
    home.file = {
      ".local/share/konsole/Sniijz.profile".source = ./configs/SniijzKonsole.profile;
      ".local/share/konsole/Breeze.colorscheme".source = ./configs/Breeze.colorscheme;
      ".config/konsolerc".source = ./configs/konsolerc;
    };
  };
}
