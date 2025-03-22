# Vscode
#
{
  vars,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${vars.user} = {
    nixpkgs.config.allowUnfree = true;
    programs = {
      vscode = {
        enable = true;
        mutableExtensionsDir = false;
        extensions = with pkgs.vscode-extensions; [
          # General
          oderwat.indent-rainbow
          esbenp.prettier-vscode
          christian-kohler.path-intellisense
          foxundermoon.shell-format
          # Nix Formater
          kamadorueda.alejandra
          bbenoist.nix
          # Markdown
          yzhang.markdown-all-in-one
          bierner.markdown-mermaid
          # Jinja
          samuelcolvin.jinjahtml
          wholroyd.jinja
          # YAML
          redhat.vscode-yaml
          # Ansible
          redhat.ansible
          # Python
          ms-python.python
          ms-python.debugpy
          ms-python.vscode-pylance
          # Golang
          golang.go
          # Kubernetes
          ms-kubernetes-tools.vscode-kubernetes-tools
          # Terraform
          hashicorp.terraform
          # Gitignore
          codezombiech.gitignore
          # gitmoji
          seatonjiang.gitmoji-vscode
          # Docker
          ms-azuretools.vscode-docker
          # errorlens
          usernamehw.errorlens
        ];

        userSettings = {
          "editor.mouseWheelZoom" = true;
          "diffEditor.renderSideBySide" = true;
          "workbench.startupEditor" = "newUntitledFile";
          "git.autofetch" = true;
          "workbench.colorTheme" = "Visual Studio Dark";
          "workbench.colorCustomizations" = {
            "statusBar.background" = "#1da063ec";
            "statusBar.noFolderBackground" = "#1da063ec";
            "statusBar.debuggingBackground" = "#1da063ec";
            "list.activeSelectionBackground" = "#1da063ec";
            #titleBar.activeBackground" = "#1da063ec";
            "list.focusAndSelectionOutline" = "#1da063ec";
            "sideBar.dropBackground" = "#1da063ec";
            "button.background" = "#1da063ec";
            "scmGraph.historyItemRefColor" = "#1da063ec";
            "editor.selectionBackground" = "#0f3f29";
            "menubar.selectionBackground" = "#186943";
            "menu.selectionBackground" = "#186943";
            "checkbox.background" = "#186943";
            "selection.background" = "#1da063ec";
            "minimap.selectionHighlight" = "#186943";
            "toolbar.hoverBackground" = "#186943";
            "editorActionList.background" = "#186943";
            "settings.dropdownBackground" = "#186943";
            "dropdown.foreground" = "#186943";
            "activityBarBadge.background" = "#186943";
            "list.hoverBackground" = "#186943";
            "inputOption.activeBorder" = "#186943";
            "inputOption.activeBackground" = "#186943";
            "input.activeBorder" = "#186943";
            "panelInput.border" = "#186943";
            "focusBorder" = "#186943";
            "extensionButton.hoverBackground" = "#186943";
          };
          "python.terminal.activateEnvInCurrentTerminal" = true;
          "python.terminal.executeInFileDir" = true;
          "git.enableSmartCommit" = true;
          "explorer.confirmDelete" = false;
          "editor.fontFamily" = "DroidSansM Nerd Font";
          "git.confirmSync" = false;
          "redhat.telemetry.enabled" = false;
          "security.workspace.trust.untrustedFiles" = "open";
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "files.autoSave" = "afterDelay";
          "editor.formatOnSave" = true;
          "terminal.integrated.copyOnSelection" = true;
          "terminal.integrated.cwd" = "\${fileDirname}";
          "files.trimTrailingWhitespace" = true;
          "files.trimFinalNewlines" = true;
          "[xml]" = {
            "editor.defaultFormatter" = "DotJoshJohnson.xml";
          };
          "[shellscript]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[terraform]" = {
            "editor.defaultFormatter" = "hashicorp.terraform";
          };
          "[nix]" = {
            "editor.defaultFormatter" = "kamadorueda.alejandra";
          };
          "[YAML]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[gitignore]" = {
            "editor.defaultFormatter" = "codezombiech.gitignore";
          };
          "git.ignoreRebaseWarning" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            # settings for 'nil' LSP
            "nil" = {
              "diagnostics" = {
                "ignored" = ["unused_binding" "unused_with"];
              };
              "formatting" = {
                "command" = ["alejandra"];
              };
            };
          };
          "files.exclude" = {
            "**/tmp/**" = true;
            "**/node_modules/**" = true;
            "**/.git/objects/**" = true;
          };
          "files.watcherExclude" = {
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
            "**/node_modules/**" = true;
            "**/tmp/**" = true;
            "**/dist/**" = true;
          };
          "search.exclude" = {
            "**/node_modules/**" = true;
            "**/dist/**" = true;
            "**/tmp/**" = true;
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
          };
          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;
          "search.followSymlinks" = false;
        };
        keybindings = [
          {
            command = "workbench.action.terminal.new";
            key = "ctrl+shift+t";
            when = "terminalFocus && terminalProcessSupported || terminalFocus && terminalWebExtensionContributedProfile";
          }
          {
            command = "workbench.action.togglePanel";
            key = "ctrl+t";
          }
          {
            command = "editor.action.commentLine";
            key = "ctrl+[Backquote]";
          }
        ];
      };
    };
  };
}
