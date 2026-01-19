{
  config,
  pkgs,
  lib,
  ...
}:
let
  secrets = import ./secrets.nix;
  vars = {
    user = "sniijz";
    location = "$HOME/.setup";
    gitUser = "robin.cassagne";
  };
  sources = import ../../nix/sources.nix;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    (import ../../common/terminal {
      inherit
        vars
        lib
        pkgs
        sources
        config
        ;
    })
    (import ../../common/desktop {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/app {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/games {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/editor {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/compose {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/system {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
    (import ../../common/dev {
      inherit
        vars
        pkgs
        config
        lib
        ;
    })
  ];

  customModules = {
    # Terminal
    starship.PastelPowerline.enable = true;
    neovim.enable = true;
  };

  ######################### Global Settings #########################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  # KEEP IT LIKE THIS ON GOBLIN-2, THIS ONE HAS BEEN UPGRADED FROM 24.05, GOBLIN-1
  # HAS BEEN DIRECTLY INSTALLED IN 25.05

  # Use systemd-boot as bootloader and not grub like Aerial and Barbatos
  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce true;
  boot.loader.grub.enable = lib.mkForce false;

  # Rook/Ceph support
  boot.kernelModules = [ "rbd" ];

  ######################### Networking #########################

  # Define your hostname.
  networking.hostName = "Goblin-2";

  # Enable networking
  networking = {
    useNetworkd = lib.mkForce true;
    dhcpcd.enable = lib.mkForce false;
    useDHCP = lib.mkForce false;
    networkmanager.enable = lib.mkForce false;
    nameservers = [
      "192.168.1.2"
      "192.168.1.3"
    ];
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.1.10";
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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = secrets.pubKeys;
  };

  ######################### Home-Manager #########################
  # To install home manager version 24.05 channel :
  # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
  # sudo nix-channel --update

  # users.users.sniijz.isNormalUser = true;
  home-manager.users.sniijz =
    { pkgs, ... }:
    {
      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "24.05";
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
      ansible # Automation tool
      btop # Top tool written in C++
      cmatrix # matrix effect package
      eza # modern replacement of ls
      fish # alternative to bash
      fishPlugins.fzf-fish # fzf plugin for fish
      fishPlugins.z # zoxide plugin for fish
      fzf # fuzzy finder
      go # Golang language
      gotop # top tool written in go
      htop # Graphical top
      jellyfin-ffmpeg # For Jellyfin transcoding
      jellyfin-mpv-shim # For Jellyfin transcoding
      neovim # text editor
      nfs-utils # Needed for Longhorn
      rsync # Syncer
      starship # theme for terminal
      termshark # cli packet capture
      tldr # man summary
      util-linux # contains nsenter for longhorn
      vim # text editor
      wget # cli tool for download
    ];
  };

  ##################### NFS Configuration ##########################

  fileSystems."/mnt/SniiNAS" = {
    device = "192.168.1.5:/volume1/SniiNAS";
    fsType = "nfs4";
    options = [
      "_netdev"
      "rw"
      "hard"
      "nolock"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
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
      "--node-name=goblin-2"
      "--kubelet-arg=cgroup-driver=systemd"
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
