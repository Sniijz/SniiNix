# tmux
{ pkgs, vars, ... }:
{
  home-manager.users.${vars.user} = {

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
        continuum
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

        # Enabling tmux-continuum for session save
        set -g @continuum-boot 'on'

        # True color support
        set-option -a terminal-features 'xterm-256color:RGB'

        ######## Copy ##########
        # Enable mouse + scrolling + copy paste + vim keymaps
        set -g mouse on
        # Enable VI keymaps in copymode
        set-window-option -g mode-keys vi
        # Enter copy mode with Prefix + Enter
        bind Enter copy-mode
        # Quit copy-mode with escape
        bind-key -T copy-mode-vi Escape send-keys -X cancel
        # Start selection with v (like vim)
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        # Copy selection in system clipboard with 'y'
        bind-key -T copy-mode-vi y send-keys -X copy-pipe 'xsel -i --clipboard'
        # Copy selection with mouse without exiting copy-mode
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe 'xsel -i --clipboard'

        ####### Bindings #######
        # Set the prefix to Ctrl+a
        set -g prefix C-q

        # Remove the old prefix
        unbind C-b

        # Send key to applications by pressing it twice
        bind-key -n C-q send-prefix

        ### Split panes bindings
        # Split panes horizontal and keep actual path
        bind t split-window -h -c "#{pane_current_path}"
        # Split panes vertically and keep actual path
        bind r split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        ## Switch panes using Ctrl-arrow without prefix
        #bind -n C-Left select-pane -L
        #bind -n C-Right select-pane -R
        #bind -n C-Up select-pane -U
        #bind -n C-Down select-pane -D

        ## Switch panes using vim motions h j k l
        #bind -n C-h select-pane -L
        #bind -n C-j select-pane -D
        #bind -n C-k select-pane -U
        #bind -n C-l select-pane -R

        # zoom on actual pane with prefix+o
        bind-key o resize-pane -Z

        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +''${vim_pattern}$'"

        # Bindings for h, j, k, l
        bind-key -n 'C-h' if-shell "''$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "''$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "''$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "''$is_vim" 'send-keys C-l'  'select-pane -R'

        # Bindings for Arrow Keys
        bind-key -n 'C-Left' if-shell "''$is_vim" 'send-keys C-Left'  'select-pane -L'
        bind-key -n 'C-Right' if-shell "''$is_vim" 'send-keys C-Right' 'select-pane -R'
        bind-key -n 'C-Up' if-shell "''$is_vim" 'send-keys C-Up'  'select-pane -U'
        bind-key -n 'C-Down' if-shell "''$is_vim" 'send-keys C-Down'  'select-pane -D'

        # Bindings for pane cycling
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "''$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"''$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "''$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"''$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        # Bindings for copy-mode-vi
        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l
        bind-key -T copy-mode-vi 'C-Left' select-pane -L
        bind-key -T copy-mode-vi 'C-Right' select-pane -R
        bind-key -T copy-mode-vi 'C-Up' select-pane -U
        bind-key -T copy-mode-vi 'C-Down' select-pane -D

        bind-key -n -N 'Toggle scratch session in a popup window' F9 if -F '#{==:#{session_name},scratch}' {
            detach-client
        } {
            display-popup -d "#{pane_current_path}" -xC -yC -w 90% -h 90% -E 'tmux new-session -A -s scratch -c "#{pane_current_path}"'
        }

        # Restore a closed pane
        bind u respawn-pane -k

        # Switch tabs/window with arrows
        bind -n S-M-Left previous-window
        bind -n S-M-Right next-window

        # Switch tabs/window with h l
        bind -n S-M-h previous-window
        bind -n S-M-l next-window

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

        # Save Terminal output in log file
        # hotkey (prefix + p) to save all pane in a file with date
        bind-key p run-shell "tmux capture-pane -S - ; tmux save-buffer - | cat > ~/Desktop/output-$(date +'%Y%m%d-%H%M%S').txt" \; display-message "Pane saved to Desktop"

        # Specific S3NS Shortcuts
        bind g new-window -n "VPN" 'vpn-gs1-stg'
        bind h new-window -n "VPN-OOB" 'vpn-oob-gs1-stg'

        # tmux resurrect configuration
        set -g @resurrect-strategy-nvim 'session'
        resurrect_dir=~/.tmux/resurrect/
        set -g @resurrect-dir $resurrect_dir
        set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'

        #####################
        ####### Theme #######
        #####################

        # --- Color Palett ---
        set -g @c_bg_dark "#3c3836"
        set -g @c_bg_med "#665c54"
        set -g @c_text_cream "#fbf1c7"
        set -g @c_blue "#458588"
        set -g @c_aqua "#689d6a"
        set -g @c_green "#98971a"
        set -g @c_orange "#d65d0e"
        set -g @c_purple "#b16286"
        set -g @c_red "#cc241d"
        set -g @c_yellow "#d79921"

        # --- Icons ---
        set -g @rarrow ""
        set -g @larrow ""
        set -g @nix_icon ""
        set -g @session_icon ""
        set -g @time_icon ""
        set -g @date_icon ""
        set -g @cpu_icon ""
        set -g @ram_icon ""
        set -g @nix_blue "colour81"

        # --- General config ---
        set -g status-interval 1
        set -g status "on"
        set -g status-position top
        set -g status-justify "left"
        set -g status-left-length "100"
        set -g status-right-length "100"
        setw -g window-status-separator ""

        set -g status-bg "#3c3836"

        # --- Left side bar (Nix + Session) ---
        set -g status-left "#[fg=#{@c_text_cream},bg=#{@c_blue},bold] #{@nix_icon} #[fg=#{@c_blue},bg=#{@c_aqua},nobold,nounderscore,noitalics]#{@rarrow}#[fg=#{@c_bg_dark},bg=#{@c_aqua},bold] #{@session_icon} #S #[fg=#{@c_aqua},bg=#{@c_bg_dark},nobold,nounderscore,noitalics]#{@rarrow}"

        # --- Right side bar  ---
        set -g status-right "#[fg=#{@c_bg_med},bg=#{@c_bg_dark},nobold,nounderscore,noitalics]#{@larrow}#[fg=#{@c_text_cream},bg=#{@c_bg_med}] #{@cpu_icon} #{cpu_percentage}  #{@ram_icon} #{ram_percentage}  #{@date_icon} %d/%m/%Y  #{@time_icon} %H:%M #[fg=#{@c_orange},bg=#{@c_bg_med},nobold,nounderscore,noitalics]#{@larrow}#[fg=#{@c_bg_dark},bg=#{@c_orange},bold] #h "

        # --- Inactive Windows ---
        setw -g window-status-format "#[fg=#{@c_bg_dark},bg=#{@c_bg_med},noitalics]#{@rarrow}#[fg=#{@c_text_cream},bg=#{@c_bg_med}] #I #[fg=#{@c_text_cream},bg=#{@c_bg_med}] #W #[fg=#{@c_bg_med},bg=#{@c_bg_dark},noitalics]#{@rarrow}"

        # --- Active Windows ---
        setw -g window-status-current-format "#[fg=#{@c_bg_dark},bg=#{@c_green},nobold,nounderscore,noitalics]#{@rarrow}#[fg=#{@c_bg_dark},bg=#{@c_green},bold] #I #[fg=#{@c_bg_dark},bg=#{@c_green},bold] #W #[fg=#{@c_green},bg=#{@c_bg_dark},nobold,nounderscore,noitalics]#{@rarrow}"
        # setw -g window-status-current-format "#[fg=#{@c_bg_dark},bg=#{@c_green},nobold,nounderscore,noitalics]#{@rarrow}#[fg=#{@c_text_cream},bg=#{@c_green},bold] #I #[fg=#{@c_text_cream},bg=#{@c_green},bold] #W #[fg=#{@c_green},bg=#{@c_bg_dark},nobold,nounderscore,noitalics]#{@rarrow}"

        # --- Copy Mode ---
        set -g mode-style "fg=#3c3836,bg=#689d6a,bold"

        # Pane border
        set -g pane-border-style "fg=#665c54"
        set -g pane-active-border-style "fg=#689d6a"

        # --- Launching CPU plugin ---
        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux

      '';
    };
  };
}
