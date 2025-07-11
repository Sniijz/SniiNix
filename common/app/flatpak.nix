{
  config,
  lib,
  pkgs,
  ...
}: let
  # We point directly to 'gnugrep' instead of 'grep'
  grep = pkgs.gnugrep;

  # 1. Declare the Flatpaks you *want* on your system
  desiredFlatpaks = [
    #"com.spotify.Client"
    "com.sweethome3d.Sweethome3d"
    "com.vysp3r.ProtonPlus"
    "org.jdownloader.JDownloader"
    "com.github.Matoking.protontricks"
  ];
  cfg = config.customModules.flatpak;
in {
  options.customModules.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        whether to enable flatpak globally or not
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # Install Flatpak
    services.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      flatpak
    ];

    programs.dconf.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = "*";
    };

    system.activationScripts.flatpakManagement = {
      text = ''
        # 2. Ensure the Flathub repo is added
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
          https://flathub.org/repo/flathub.flatpakrepo

        # 3. Get currently installed Flatpaks
        installedFlatpaks=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

        # 4. Remove any Flatpaks that are NOT in the desired list
        for installed in $installedFlatpaks; do
          if ! echo ${toString desiredFlatpaks} | ${grep}/bin/grep -q $installed; then
            echo "Removing $installed because it's not in the desiredFlatpaks list."
            ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive $installed
          fi
        done

        # 5. Install or re-install the Flatpaks you DO want
        for app in ${toString desiredFlatpaks}; do
          echo "Ensuring $app is installed."
          ${pkgs.flatpak}/bin/flatpak install -y flathub $app
        done

        # 6. Update all installed Flatpaks
        ${pkgs.flatpak}/bin/flatpak update -y
      '';
    };
  };
}
