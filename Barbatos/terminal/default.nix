{
  pkgs,
  config,
  ...
}: let
  sharedShellAbbrs = {
    # General Terminal Aliases
    ll = "exa -alh";
    tree = "exa --tree";
    vim = "nvim";
    vi = "nvim";
    k = "${pkgs.kubectl}/bin/kubectl";
    cat = "bat";
    fs = "du -hd 1 | sort -h";
  };

  sharedShellAliases = {
    tmux = "tmux new-session -A";
  };

  sharedShellFunctions = {};
in {
  imports = [
    (import ./bash.nix {inherit pkgs config;})
    (import ./fish.nix {inherit pkgs config sharedShellAbbrs sharedShellAliases sharedShellFunctions;})
    (import ./tmux.nix {inherit pkgs config sharedShellAbbrs sharedShellAliases sharedShellFunctions;})
  ];
}
