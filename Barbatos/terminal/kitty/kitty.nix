# Kitty
{
  vars,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${vars.user} = {
    programs.kitty = {
      enable = true;
      font.name = "DroidSansM Nerd Font";
      settings = {
        term = "xterm-256color";
        close_window_with_confirmation = false;
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        url_style = "dotted";
        open_url_with = "default";
        url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
        detect_urls = "yes";
        show_hyperlink_targets = "yes";
        underline_hyperlinks = "hover";
        copy_on_select = "yes";
        paste_actions = "quote-urls-at-prompt,confirm";
        strip_trailing_spaces = "smart";
        mouse_map = "right click ungrabbed paste_from_clipboard";
        window_margin_width = 2;
        single_window_margin_width = -1;
        hide_window_decorations = "no";
        background_opacity = "0.80";
        background_blur = "0";
        enabled_layouts = "splits";
        remember_window_size = "yes";
      };
      keybindings = {
        "ctrl+v" = "paste_from_clipboard";
        "alt+t" = "launch --location=hsplit";
        "ctrl+t" = "launch --location=vsplit";
        "ctrl+left" = "neighboring_window left";
        "ctrl+right" = "neighboring_window right";
        "ctrl+up" = "neighboring_window up";
        "ctrl+down" = "neighboring_window down";
        "ctrl+tab" = "next_window";
        "ctrl+shift+tab" = "previous_window";
        "ctrl+shift+equal" = "change_font_size all +2.0";
        "ctrl+equal" = "change_font_size all +2.0";
        "ctrl+plus" = "change_font_size all +2.0";
        "ctrl+kp_add" = "change_font_size all +2.0";
        "ctrl+shift+minus" = "change_font_size all -2.0";
        "ctrl+minus" = "change_font_size all -2.0";
        "ctrl+kp_subtract" = "change_font_size all -2.0";
        "super+q" = "quit";
      };
    };
  };
}
