{
  lib,
  config,
  pkgs,
  ...
}: let
  # Creating Smart Command to Launch on Big Picture
  # https://discourse.nixos.org/t/sunshine-self-hosted-game-stream/25608/24
  steam-run-url = pkgs.writeShellApplication {
    name = "steam-run-url";
    text = ''
      echo "$1" > "/run/user/$(id --user)/steam-run-url.fifo"
    '';
    runtimeInputs = [
      pkgs.coreutils # For id command
    ];
  };
in {
  # Sunshine Service Configuration
  services.sunshine = {
    enable = true;
    autoStart = true;
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
            "steam steam://open/gamepadui"
          ];
          image-path = "steam.png";
        }
      ];
    };
  };

  # Overriding the systemd service definition
  systemd.services.sunshine = lib.mkForce {
    description = "Sunshine Game Streaming Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine"; # Utilise le binaire Sunshine
      ExecStop = "${pkgs.procps}/bin/pkill -SIGTERM -f sunshine"; # Assure un arrêt propre
      Restart = "on-failure";
      TimeoutStopSec = "5s";
      KillMode = "mixed";
      AmbientCapabilities = "CAP_SYS_ADMIN"; # Autorise les capacités supplémentaires
      Environment = "PATH=${lib.makeBinPath [steam-run-url]}:$PATH"; # Ajoute steam-run-url au PATH
    };
  };

  environment.systemPackages = [steam-run-url];
  systemd.user.services.sunshine.path = [steam-run-url];
}
