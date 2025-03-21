# konsole
{
  vars,
  config,
  pkgs,
  ...
}: {
  home-manager.users.${vars.user} = {
    home.file = {
      ".local/share/konsole/Sniijz.profile".source = ./configs/SniijzKonsole.profile;
      ".local/share/konsole/Breeze.colorscheme".source = ./configs/Breeze.colorscheme;
      ".config/konsolerc".source = ./configs/konsolerc;
    };
  };
}
