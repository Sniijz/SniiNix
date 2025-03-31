{
  vars,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.customModules.dolphin;
  sidebarIconSize = 22;
  previewPlugins = [
    "jpegthumbnail"
    "comicbookthumbnail"
    "cursorthumbnail"
    "djvuthumbnail"
    "windowsimagethumbnail"
    "svgthumbnail"
    "appimagethumbnail"
    "windowsexethumbnail"
    "audiothumbnail"
    "ebookthumbnail"
    "exrthumbnail"
    "directorythumbnail"
    "imagethumbnail"
    "opendocumentthumbnail"
    "kraorathumbnail"
    "fontthumbnail"
    "gsthumbnail"
    "mobithumbnail"
    "blenderthumbnail"
    "ffmpegthumbs"
    "rawthumbnail"
    "aseprite"
  ];
in {
  options.customModules.dolphin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Dolphin globally or not";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      programs.plasma.configFile.dolphinrc = {
        General = {
          GlobalViewProps = false;
          ConfirmClosingMultipleTabs = false;
          RememberOpenedTabs = true;
          ShowFullPath = true;
        };
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = sidebarIconSize;
        };
        MainWindow = {
          MenuBar = false;
          ToolBarsMovable = false;
        };
        PlacesPanel = {
          IconSize = sidebarIconSize;
        };
        PreviewSettings = {
          Plugins = lib.concatStringsSep "," previewPlugins;
        };
      };
      home.file.".local/share/kxmlgui5/dolphin/dolphinui.rc".text = ''
        <?xml version='1.0'?>
        <!DOCTYPE gui SYSTEM 'kpartgui.dtd'>
        <gui name="dolphin" version="40">
        <MenuBar>
        <Menu name="file">
        <Action name="new_menu"/>
        <Action name="file_new"/>
        <Action name="new_tab"/>
        <Action name="file_close"/>
        <Action name="undo_close_tab"/>
        <Separator/>
        <Action name="add_to_places"/>
        <Separator/>
        <Action name="renamefile"/>
        <Action name="duplicate"/>
        <Action name="movetotrash"/>
        <Action name="deletefile"/>
        <Separator/>
        <Action name="show_target"/>
        <Separator/>
        <Action name="properties"/>
        </Menu>
        <Menu name="edit">
        <Action name="edit_undo"/>
        <Separator/>
        <Action name="edit_cut"/>
        <Action name="edit_copy"/>
        <Action name="copy_location"/>
        <Action name="edit_paste"/>
        <Separator/>
        <Action name="show_filter_bar"/>
        <Action name="edit_find"/>
        <Separator/>
        <Action name="toggle_selection_mode"/>
        <Action name="copy_to_inactive_split_view"/>
        <Action name="move_to_inactive_split_view"/>
        <Action name="edit_select_all"/>
        <Action name="invert_selection"/>
        </Menu>
        <Menu name="view">
        <Action name="view_zoom_in"/>
        <Action name="view_zoom_reset"/>
        <Action name="view_zoom_out"/>
        <Separator/>
        <Action name="sort"/>
        <Action name="view_mode"/>
        <Action name="additional_info"/>
        <Action name="show_preview"/>
        <Action name="show_in_groups"/>
        <Action name="show_hidden_files"/>
        <Action name="act_as_admin"/>
        <Separator/>
        <Action name="split_view_menu"/>
        <Action name="popout_split_view"/>
        <Action name="split_stash"/>
        <Action name="redisplay"/>
        <Action name="stop"/>
        <Separator/>
        <Action name="panels"/>
        <Menu icon="edit-select-text" name="location_bar">
        <text context="@title:menu">Location Bar</text>
        <Action name="editable_location"/>
        <Action name="replace_location"/>
        </Menu>
        <Separator/>
        <Action name="view_properties"/>
        </Menu>
        <Menu name="go">
        <Action name="bookmarks"/>
        <Action name="closed_tabs"/>
        </Menu>
        <Menu name="tools">
        <Action name="open_preferred_search_tool"/>
        <Action name="open_terminal"/>
        <Action name="open_terminal_here"/>
        <Action name="focus_terminal_panel"/>
        <Action name="compare_files"/>
        <Action name="change_remote_encoding"/>
        </Menu>
        </MenuBar>
        <State name="new_file">
        <disable>
        <Action name="edit_undo"/>
        <Action name="edit_redo"/>
        <Action name="edit_cut"/>
        <Action name="renamefile"/>
        <Action name="movetotrash"/>
        <Action name="deletefile"/>
        <Action name="invert_selection"/>
        <Separator/>
        <Action name="go_back"/>
        <Action name="go_forward"/>
        </disable>
        </State>
        <State name="has_selection">
        <enable>
        <Action name="invert_selection"/>
        </enable>
        </State>
        <State name="has_no_selection">
        <disable>
        <Action name="delete_shortcut"/>
        <Action name="invert_selection"/>
        </disable>
        </State>
        <ToolBar name="mainToolBar" noMerge="1">
        <text context="@title:menu">Main Toolbar</text>
        <Action name="go_back"/>
        <Action name="go_forward"/>
        <Separator name="separator_1"/>
        <Action name="icons"/>
        <Action name="compact"/>
        <Action name="details"/>
        <Action name="url_navigators"/>
        <Action name="split_view"/>
        <Action name="split_stash"/>
        <Action name="toggle_search"/>
        <Action name="hamburger_menu"/>
        </ToolBar>
        <ActionProperties scheme="Default">
        <Action name="go_back" priority="0"/>
        <Action name="go_forward" priority="0"/>
        <Action name="go_up" priority="0"/>
        <Action name="go_home" priority="0"/>
        <Action name="stop" priority="0"/>
        <Action name="icons" priority="0"/>
        <Action name="compact" priority="0"/>
        <Action name="details" priority="0"/>
        <Action name="view_zoom_in" priority="0"/>
        <Action name="view_zoom_reset" priority="0"/>
        <Action name="view_zoom_out" priority="0"/>
        <Action name="edit_cut" priority="0" shortcut="Ctrl+X"/>
        <Action name="edit_copy" priority="0"/>
        <Action name="edit_paste" priority="0"/>
        <Action name="toggle_search" priority="0"/>
        <Action name="toggle_filter" priority="0"/>
        <Action name="new_tab" shortcut="Ctrl+Shift+T; "/>
        <Action name="split_view_menu" shortcut="F3; Ctrl+T"/>
        <Action name="undo_close_tab" shortcut="; "/>
        </ActionProperties>
        </gui>
      '';
    };
  };
}
