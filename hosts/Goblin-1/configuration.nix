{
  config,
  pkgs,
  lib,
  ...
}: let
  secrets = import ./secrets.nix;
  vars = {
    user = "sniijz";
    location = "$HOME/.setup";
    gitUser = "robin.cassagne";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    (import ../../common/terminal {inherit vars lib pkgs config;})
    (import ../../common/desktop {inherit vars pkgs config lib;})
    (import ../../common/app {inherit vars pkgs config lib;})
    (import ../../common/editor {inherit vars pkgs config lib;})
    (import ../../common/compose {inherit vars pkgs config lib;})
  ];

  customModules = {
    # Terminal
    starship.GruvboxRainbow.enable = true;
    starship.PastelPowerline.enable = false;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Rook/Ceph support
  boot.kernelModules = ["rbd"];

  ######################### Global Settings #########################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  ######################### Networking #########################

  # Define your hostname.
  networking.hostName = "Goblin-1";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    nameservers = ["192.168.1.2" "192.168.1.3"];
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.1.9";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };
  };

  programs.ssh.startAgent = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Configure network proxy if necessary
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # List services that you want to enable:

  ######################### Accounts ###########################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = secrets.pubKeys;
  };

  ######################### Home-Manager #########################
  # To install home manager version 24.05 channel :
  # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
  # sudo nix-channel --update

  # users.users.sniijz.isNormalUser = true;
  home-manager.users.sniijz = {pkgs, ...}: {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

  ######################### Packages #########################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install and configure git
  programs.git.enable = true;
  programs.git.config = {
    user.name = "Robin CASSAGNE";
    user.email = "robin.jean.cassagne@gmail.com";
  };

  environment = {
    variables = {
      K3S_RESOLV_CONF = /etc/resolv.conf;
    };

    systemPackages = with pkgs; [
      atuin # Shell History
      rsync # Syncer
      ansible # Automation tool
      vim # text editor
      neovim # text editor
      cmatrix # matrix effect package
      eza # modern replacement of ls
      fzf # fuzzy finder
      gotop # top tool written in go
      btop # Top tool written in C++
      htop # Graphical top
      fish # alternative to bash
      fishPlugins.z # zoxide plugin for fish
      fishPlugins.fzf-fish # fzf plugin for fish
      starship # theme for terminal
      tldr # man summary
      wget # cli tool for download
      termshark # cli packet capture
      nfs-utils # Needed for Longhorn
      util-linux # contains nsenter for longhorn
      jellyfin-ffmpeg # For Jellyfin transcoding
      jellyfin-mpv-shim # For Jellyfin transcoding
    ];
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["DroidSansMono"];})
  ];

  ##################### NFS Configuration ##########################

  fileSystems."/mnt/SniiNAS" = {
    device = "192.168.1.5:/volume1/SniiNAS";
    fsType = "nfs4";
    options = [
      "rw"
      "hard"
      "intr"
      "nolock"
      "user"
    ];
  };

  ##################### K3S Configuration ##########################

  services.k3s = {
    enable = true;
    package = pkgs.k3s_1_30;
    serverAddr = "https://192.168.1.30:6443";
    token = secrets.apiTokens.k3s;
    role = "agent";
    extraFlags = toString [
      "--node-name=goblin-1"
      #"--disable servicelb"
      #"--disable traefik"
    ];
  };

  ###################### iscsi configuration for longhorn ###########

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost";
  };
}
