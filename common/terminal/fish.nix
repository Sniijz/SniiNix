# FISH
{
  config,
  pkgs,
  sharedShellAbbrs,
  sharedShellAliases,
  sharedShellFunctions,
  ...
}:
{
  # Install DroidSansMono NerdFont
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
  ];

  environment.systemPackages = with pkgs; [
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.z
    fzf
  ];

  programs.fish = {
    enable = true;

    shellInit = ''
      starship init fish | source
    ''
    + ''
      # Fix pour l'erreur TERMINFO avec sudo dans Kitty
      # On force le TERM à xterm-256color quand on utilise sudo
      alias sudo="env TERM=xterm-256color sudo"
    '';

    # bind ctrl+f to launch fzf
    interactiveShellInit = ''
      function fzf_find
          commandline -r (find . | fzf)
      end
      bind \cf fzf_find

      function journalctl_fzf
          journalctl -n 1500 --no-pager | fzf
      end
      bind \cj journalctl_fzf

      # https://fishshell.com/docs/current/cmds/bind.html#cmd-bind-backward-kill-path-component
      # Alt+Right (move to next punct)
      bind alt-right forward-word

      # Alt+Left (move to previous punct)
      bind alt-left backward-word

      # delete to previous punct
      bind alt-backspace backward-kill-word
    '';

    shellAbbrs = sharedShellAbbrs;

    shellAliases = sharedShellAliases;
  };
}
