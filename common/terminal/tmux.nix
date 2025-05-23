# tmux
{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "tmux-256color";
    clock24 = true;
    escapeTime = 100;
    historyLimit = 100000;
    plugins = with pkgs.tmuxPlugins; [
      logging
      resurrect
      better-mouse-mode
      cpu
      yank
    ];
    extraConfig = ''
      ####### General tmux config  #######
      # start with window 1 (instead of 0)
      set -g base-index 1

      # start with pane 1
      set -g pane-base-index 1

      # allow focus events to get through to applications running in tmux
      set -g focus-events on

      # Automaticly renumber windows when shutting one
      set -g renumber-windows on

      # Stay in same path when creating a new windows
      bind c new-window -c "#{pane_current_path}"

      # Enable mouse + scrolling + copy paste
      set -g mouse on
      set -s set-clipboard on
      set -g @yank_selection 'clipboard'
      set -g @yank_selection_mouse 'clipboard'

      ####### Bindings #######
      # Set the prefix to Ctrl+a
      set -g prefix C-a

      # Remove the old prefix
      unbind C-b

      # Send key to applications by pressing it twice
      bind-key -n C-a send-prefix

      ### Split panes bindings
      # Split panes horizontal and keep actual path
      bind t split-window -h -c "#{pane_current_path}"
      # Split panes vertically and keep actual path
      bind r split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Switch tabs/windows
      bind -n S-M-Left previous-window
      bind -n S-M-Right next-window
      # toggle to last window used
      bind Space last-window
      # Rebind window selection for Azerty keyboard
      bind -n M-1 select-window -t 1  # Alt + & → 1
      bind -n M-2 select-window -t 2  # Alt + é → 2
      bind -n M-3 select-window -t 3  # Alt + " → 3
      bind -n M-4 select-window -t 4  # Alt + ' → 4
      bind -n M-5 select-window -t 5  # Alt + ( → 5
      bind -n M-6 select-window -t 6  # Alt + - → 6
      bind -n M-7 select-window -t 7  # Alt + è → 7
      bind -n M-8 select-window -t 8  # Alt + _ → 8
      bind -n M-9 select-window -t 9  # Alt + ç → 9
      bind -n M-0 select-window -t 0  # Alt + à → 0

      # Specific Home Shortcus
      bind-key k new-window -n "k9s" "k9s"
      bind-key l new-window -n "logs" "journalctl -fe"

      # Specific S3NS Shortcuts
      bind-key g new-window -n "VPN" "vpn-gs1-stg"
      bind-key h new-window -n "VPN" "vpn-oob-gs1-stg"

      ####### Theme #######
      # This tmux statusbar config was created based on gruvbox colorscheme

      set -g status "on"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-bg "colour237"
      setw -g window-status-separator ""

      set -g status-left "#[fg=colour248,bg=colour241] #S #[fg=colour241,bg=colour237,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=colour239,bg=colour237,nobold,nounderscore,noitalics]#[fg=colour246,bg=colour239] %Y-%m-%d %H:%M  CPU 🖥️: #{cpu_percentage} RAM 🗄️: #{ram_percentage} #[fg=colour248,bg=colour239,nobold,nounderscore,noitalics]#[fg=colour237,bg=colour248] #h"
      setw -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I #[fg=colour223,bg=colour239] #W #[fg=colour239,bg=colour237,noitalics]"
      setw -g window-status-current-format "#[fg=colour239,bg=colour248,:nobold,nounderscore,noitalics]#[fg=colour239,bg=colour214] #I #[fg=colour239,bg=colour214,bold] #W #[fg=colour214,bg=colour237,nobold,nounderscore,noitalics]"
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
