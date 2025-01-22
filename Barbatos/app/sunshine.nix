{
  config,
  lib,
  pkgs,
  ...
}: let
  # Helper utility for launching Steam games from Sunshine. This works around
  # issue where Sunshine's security wrapper prevents Steam from launching.
  # Examples:
  #   steam-run-url steam://rungameid/1086940  # Start Baldur's Gate 3
  #   steam-run-url steam://open/bigpicture    # Start Steam in Big Picture mode
  steam-run-url = pkgs.writeShellApplication {
    name = "steam-run-url";
    text = ''
      echo "$1" > "/run/user/$(id --user)/steam-run-url.fifo"
    '';
    runtimeInputs = [
      pkgs.coreutils # For `id` command
    ];
  };
in {
  # Sunshine Service Configuration
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "Barbatos-NixOS";
      output_name = 1;
      key_rightalt_to_key_win = "enabled";
    };
    applications = {
      apps = [
        {
          name = "Launch BigSteam";
          detached = [
            "steam-run-url steam://open/gamepadui"
          ];
          image-path = "steam.png";
        }
      ];
    };
  };

  systemd.user.services.sunshine = {
    description = "Self-hosted game stream host for Moonlight";
    path = [steam-run-url]; # Allow running `steam-run-url` from Sunshine without knowing the script's
    # wantedBy = ["default.target"];
    # partOf = ["default.target"];
    # wants = ["default.target"];
    # after = ["default.target"];
    after = ["graphical-session.target"]; # Ensure graphical session is ready
    bindsTo = ["graphical-session.target"]; # Stop service when graphical session ends
    wantedBy = ["default.target"]; # Run after the user session is fully initialized
    partOf = ["graphical-session.target"];

    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 15"; # Delay by 10 seconds to ensure graphical session is ready
      ExecStop = "${pkgs.procps}/bin/pkill -SIGTERM -f sunshine";
      ExecStopPost = "${pkgs.procps}/bin/pkill -SIGKILL -f sunshine";
      KillSignal = "SIGTERM";
      Restart = "on-failure";
      TimeoutStopSec = "10s";
      KillMode = "mixed";
      type = "simple";
      stopWhenUnneeded = true;
      RemainAfterExit = "no";
    };
  };

  # Allow running `steam-run-url` from shell for testing purposes
  environment.systemPackages = [steam-run-url];

  # Service part for `steam-run-url`. This listens for Steam urls from a named
  # pipe (typically at path `/run/user/1000/steam-run-url.fifo`) and then
  # launches Steam, passing the url to it.
  systemd.user.services.steam-run-url-service = {
    enable = true;
    description = "Listen and starts steam games by id";
    wantedBy = ["default.target"];
    partOf = ["default.target"];
    wants = ["default.target"];
    after = ["default.target"];
    serviceConfig.Restart = "on-failure";
    script = toString (pkgs.writers.writePython3 "steam-run-url-service" {} ''
      import os
      from pathlib import Path
      import subprocess

      pipe_path = Path(f'/run/user/{os.getuid()}/steam-run-url.fifo')
      try:
          pipe_path.parent.mkdir(parents=True, exist_ok=True)
          pipe_path.unlink(missing_ok=True)
          os.mkfifo(pipe_path, 0o600)
          while True:
              with pipe_path.open(encoding='utf-8') as pipe:
                  subprocess.Popen(['steam', pipe.read().strip()])
      finally:
          pipe_path.unlink(missing_ok=True)
    '');
    path = [
      pkgs.gamemode
      pkgs.steam
    ];
  };
}
