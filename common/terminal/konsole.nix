# konsole
{
  vars,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.customModules.konsole;
in {
  options.customModules.konsole = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable konsole globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Konsole home-manager example :
    # https://github.com/gboncoffee/nix-configs/blob/bfd9ee135e76009e7f59f5cb86368676b6c332cd/home-manager.nix#L15
    # https://nix-community.github.io/plasma-manager/options.xhtml
    # https://docs.kde.org/stable5/en/konsole/konsole/key-bindings.html
    home-manager.users.${vars.user} = {
      programs.konsole = {
        enable = true;
        defaultProfile = "Sniinix";
        customColorSchemes = {
          SniiBreeze = ../../assets/konsole/Breeze.colorscheme;
        };
        profiles = {
          SniiNix = {
            name = "Sniinix";
            font = {
              name = "DroidSansM Nerd Font";
              size = 12;
            };
            extraConfig = {
              Appearance = {
                ColorScheme = "SniiBreeze";
              };

              General = {
                Parent = "FALLBACK/";
              };

              "Interaction Options" = {
                AutoCopySelectedText = true;
                TrimLeadingSpacesInSelectedText = true;
                TrimTrailingSpacesInSelectedText = true;
              };

              MainWindow = {
                ToolBarsMovable = "Disabled";
              };

              # Scrollback HistorySize default value changed from 1000 to 2000
              Scrolling = {
                HistorySize = 2000;
              };

              "Notification Messages" = {
                CloseAllTabs = true;
              };
            };
          };
        };
      };
      # Implementing Shortcuts
      home.file.".local/share/kxmlgui5/konsole/konsoleui.rc".text = ''
        <?xml version='1.0'?>
        <!DOCTYPE gui SYSTEM 'kpartgui.dtd'>
        <gui name="konsole" version="20">
        <MenuBar>
        <Menu name="file">
        <text>File</text>
        <Action name="new-window"/>
        <Action name="new-tab"/>
        <Action name="clone-tab"/>
        <Separator/>
        <DefineGroup name="session-operations"/>
        <Separator/>
        <DefineGroup name="session-tab-operations"/>
        <Action name="close-window"/>
        </Menu>
        <Menu name="edit">
        <text>Edit</text>
        <DefineGroup name="session-edit-operations"/>
        </Menu>
        <Menu name="view">
        <text>View</text>
        <Menu name="view-split">
        <text>Split View</text>
        <Action name="split-view-left-right"/>
        <Action name="split-view-top-bottom"/>
        <Action name="split-view-left-right-next-tab"/>
        <Action name="split-view-top-bottom-next-tab"/>
        <Action name="close-active-view"/>
        <Action name="close-other-views"/>
        <Action name="expand-active-view"/>
        <Action name="shrink-active-view"/>
        <Action name="toggle-maximize-current-view"/>
        <Action name="equal-size-view"/>
        </Menu>
        <Separator/>
        <Action name="detach-tab"/>
        <Action name="detach-view"/>
        <Action name="save-layout"/>
        <Action name="load-layout"/>
        <Separator/>
        <DefineGroup name="session-view-operations"/>
        </Menu>
        <Action name="bookmark"/>
        <Menu name="settings">
        <text>Settings</text>
        <DefineGroup name="session-settings"/>
        <Action name="manage-profiles"/>
        <Action name="show-menubar"/>
        <Action name="window-colorscheme-menu"/>
        <Separator/>
        <Action name="view-full-screen"/>
        <Separator/>
        <Action name="configure-shortcuts"/>
        <Action name="configure-notifications"/>
        <Action name="configure-settings"/>
        </Menu>
        <Menu name="plugins">
        <text>Plugins</text>
        <ActionList name="plugin-submenu"/>
        </Menu>
        <Menu name="help">
        <text>Help</text>
        </Menu>
        </MenuBar>
        <ToolBar name="mainToolBar">
        <text>Main Toolbar</text>
        <index>0</index>
        <Action name="new-tab"/>
        <Action name="split-view"/>
        </ToolBar>
        <ActionProperties scheme="Default">
        <Action name="split-view-auto" shortcut="Ctrl+T"/>
        <Action name="close-window" shortcut="Ctrl+Shift+Q; Meta+Q"/>
        </ActionProperties>
        </gui>
      '';
      # Session settings
      home.file.".local/share/kxmlgui5/konsole/sessionui.rc".text = ''
        <?xml version='1.0'?>
        <!DOCTYPE gui SYSTEM 'kpartgui.dtd'>
        <gui name="session" version="35">
        <MenuBar>
        <Menu name="file">
        <Action group="session-operations" name="file_save_as"/>
        <Separator group="session-operations"/>
        <Action group="session-operations" name="file_print"/>
        <Separator group="session-operations"/>
        <Action group="session-operations" name="open-browser"/>
        <Action group="session-tab-operations" name="close-session"/>
        </Menu>
        <Menu name="edit">
        <Action group="session-edit-operations" name="edit_copy"/>
        <Action group="session-edit-operations" name="edit_paste"/>
        <Separator group="session-edit-operations"/>
        <Action group="session-edit-operations" name="select-all"/>
        <Action group="session-edit-operations" name="select-mode"/>
        <Separator group="session-edit-operations"/>
        <Action group="session-edit-operations" name="copy-input-to"/>
        <Action group="session-edit-operations" name="send-signal"/>
        <Action group="session-edit-operations" name="rename-session"/>
        <Action group="session-edit-operations" name="zmodem-upload"/>
        <Separator group="session-edit-operations"/>
        <Action group="session-edit-operations" name="edit_find"/>
        <Action group="session-edit-operations" name="edit_find_next"/>
        <Action group="session-edit-operations" name="edit_find_prev"/>
        </Menu>
        <Menu name="view">
        <Action group="session-view-operations" name="monitor-once"/>
        <Action group="session-view-operations" name="monitor-prompt"/>
        <Action group="session-view-operations" name="monitor-silence"/>
        <Action group="session-view-operations" name="monitor-activity"/>
        <Action group="session-view-operations" name="monitor-process-finish"/>
        <Separator group="session-view-operations"/>
        <Action group="session-view-operations" name="view-readonly"/>
        <Action group="session-view-operations" name="allow-mouse-tracking"/>
        <Separator group="session-view-operations"/>
        <Action group="session-view-operations" name="enlarge-font"/>
        <Action group="session-view-operations" name="reset-font-size"/>
        <Action group="session-view-operations" name="shrink-font"/>
        <Action group="session-view-operations" name="set-encoding"/>
        <Separator group="session-view-operations"/>
        <Action group="session-view-operations" name="clear-history"/>
        <Action group="session-view-operations" name="clear-history-and-reset"/>
        </Menu>
        <Menu name="settings">
        <Action group="session-settings" name="edit-current-profile"/>
        <Action group="session-settings" name="switch-profile"/>
        </Menu>
        </MenuBar>
        <Menu name="session-popup-menu">
        <Action name="edit_copy_contextmenu"/>
        <Action name="edit_copy_contextmenu_in"/>
        <Action name="edit_copy_contextmenu_out"/>
        <Action name="edit_copy_contextmenu_in_out"/>
        <Action name="edit_paste"/>
        <Action name="web-search"/>
        <Action name="open-browser"/>
        <Separator/>
        <Menu name="view-split">
        <text>Split View</text>
        <Action name="split-view-left-right"/>
        <Action name="split-view-top-bottom"/>
        </Menu>
        <Separator/>
        <Action name="set-encoding"/>
        <Action name="clear-history"/>
        <Action name="adjust-history"/>
        <Separator/>
        <Action name="view-readonly"/>
        <Action name="allow-mouse-tracking"/>
        <Separator/>
        <Action name="switch-profile"/>
        <Action name="edit-current-profile"/>
        </Menu>
        <ToolBar name="sessionToolbar">
        <text>Session Toolbar</text>
        <index>1</index>
        <Spacer/>
        <Action name="edit_copy"/>
        <Action name="edit_paste"/>
        <Action name="edit_find"/>
        <Action name="hamburger_menu"/>
        <Action name="hamburger_menu"/>
        <Action name="hamburger_menu"/>
        <Action name="hamburger_menu"/>
        <Action name="hamburger_menu"/>
        <Action name="hamburger_menu"/>
        </ToolBar>
        <ActionProperties scheme="Default">
        <Action name="edit_copy_contextmenu" shortcut="Ctrl+Shift+C"/>
        </ActionProperties>
        </gui>
      '';
    };
  };
}
