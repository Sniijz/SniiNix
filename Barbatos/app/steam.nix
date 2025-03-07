{
  config,
  pkgs,
  ...
}: let
in {
  # Install Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          gamemode
          mangohud
          # additional packages...
          # e.g. some games require python3
        ];
      extraEnv = {
        MANGOHUD = true;
      };
      # fix gamescope launch from within steam
      extraLibraries = p:
        with p; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
    extest.enable = false;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    gamescopeSession = {
      enable = true;
    };
  };

  systemd.user.services.steam_background = {
    enable = true;
    description = "Open Steam in the background at boot";
    wantedBy = ["default.target"]; # Run after the user session is fully initialized
    after = ["graphical-session.target"]; # Ensure graphical session is ready
    serviceConfig = {
      ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent %U";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # Delay by x seconds to ensure graphical session is ready
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = "DISPLAY=:0";
    };
  };
}
