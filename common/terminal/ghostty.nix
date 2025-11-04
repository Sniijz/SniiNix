# Ghostty New Terminal Emulator by Hashimoto, Hashicorp creator
{
  vars,
  config,
  pkgs,
  lib,
  ...
}:
# let
# ghostty-updated = pkgs.ghostty.overrideAttrs (oldAttrs: {
#   pname = "ghostty";
#   version = "1.1.2";
#   # nix-prefetch-url --unpack --print-path https://github.com/ghostty-org/ghostty/archive/refs/tags/v1.1.2.tar.gz
#   # nix hash to-sri --type sha256 1vysqjv4n6bk84v38d86fhj0k6ckdd677nsfbm3kybg5fz3ax60x
#   src = pkgs.fetchFromGitHub {
#     owner = "ghostty";
#     repo = "ghostty";
#     rev = "v1.1.2";
#     sha256 = "sha256-HZiuxnflLT9HXU7bc0xrk5kJJHQGNTQ2QXMZS7bE2u8="; # Replace this
#   };
# });
# in
let
  cfg = config.customModules.ghostty;
in
{
  options.customModules.ghostty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable ghostty globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      programs.ghostty = {
        enable = true;
        # package = ghostty-updated;
        settings = {
          font-family = "DroidSansM Nerd Font";
          theme = "Horizon";
          background-opacity = "0.9";
          background-blur = true;
          background = "#1B1E20";
          window-padding-balance = true;
          maximize = true;
          window-decoration = "auto";
          confirm-close-surface = false;
          copy-on-select = "clipboard";
          working-directory = "inherit";
          app-notifications = "no-clipboard-copy";

          keybind = [
            "ctrl+shift+t=new_tab"
            "ctrl+t=new_split:auto"
            "super+q=close_window"
            "ctrl+0=reset_font_size"
            # "keybind = ctrl+tab=next_tab"
            # "keybind = ctrl+shift+tab=previous_tab"
            # "ctrl+scroll_up=increase_font_size"
            # "ctrl+scroll_down=decrease_font_size"
            # "ctrl+a>c=new_tab"
            # "ctrl+a>v=new_split:down"
            # "ctrl+a>;=new_split:right"

            # "ctrl+a>l=goto_split:right"
            # "ctrl+a>h=goto_split:left"
            # "ctrl+a>k=goto_split:up"
            # "ctrl+a>j=goto_split:down"
          ];
        };
      };
    };
  };
}
