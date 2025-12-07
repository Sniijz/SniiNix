# Kitty
{
  vars,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.customModules.kitty;
in
{
  options.customModules.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable kitty globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      programs.kitty = {
        enable = true;
        font.name = "DroidSansM Nerd Font";
        settings = {
          term = "xterm-256color";
          # SSH configuration
          ssh_env = "TERM=xterm-256color"; # Use compatible TERM for SSH
          # SSH clipboard integration
          share_connections = true;
          remote_kitty = "if-needed";
          close_window_with_confirmation = false;
          scrollback = "10000";
          bold_font = "auto";
          italic_font = "auto";
          bold_italic_font = "auto";
          # url_style = "dotted";
          open_url_with = "default";
          url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
          url_style = "curly";
          detect_urls = "yes";
          show_hyperlink_targets = "yes";
          underline_hyperlinks = "hover";
          copy_on_select = "yes";
          paste_actions = "quote-urls-at-prompt,confirm";
          strip_trailing_spaces = "smart";
          mouse_map = "ctrl+left release grabbed,ungrabbed mouse_handle_click link";
          window_margin_width = 2;
          single_window_margin_width = -1;
          hide_window_decorations = "yes";
          background_opacity = "0.70";
          background_blur = "9";
          enabled_layouts = "splits";
          remember_window_size = "yes";
          cursor_trail = 3;
          cursor_trail_decay = "0.1 0.3";
          cursor_trail_start_threshold = 1;
          cursor_shape = "block";
          enable_audio_bell = false;
          window_alert_on_bell = true;
          bell_on_tab = true;
        };
        keybindings = {
          "ctrl+shift+equal" = "change_font_size all +1.0";
          "ctrl+equal" = "change_font_size all +1.0";
          "ctrl+plus" = "change_font_size all +1.0";
          "ctrl+kp_add" = "change_font_size all +1.0";
          "ctrl+shift+minus" = "change_font_size all -1.0";
          "ctrl+minus" = "change_font_size all -1.0";
          "ctrl+kp_subtract" = "change_font_size all -1.0";
          "super+q" = "quit";
        };
      };
    };
  };
}
