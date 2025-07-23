# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = {
    user = "sniijz";
    location = "$HOME/.setup";
    gitUser = "robin.cassagne";
    terminal = "konsole";
    editor = "code";
  };

  pythonSubPackages = ps:
    with ps; [
      ansible # ansible love nix
      pip # python package manager
      pyyaml # yaml on python
      scp # ssh copy
      python-box # make python dict easy
      jinja2 # text renderer
      pynetbox # official api sdk netbox
      netaddr # handle ip with python
      paramiko # ssh pythonic
      netmiko # network oriented paramiko extension
      textfsm # text parser
      ttp # text parser
      ttp-templates # bunch of ttp community templates
      requests # python http
      rich # make beautiful ux on cli with python
      backoff # enable retry on web requests
      black # most used python formatter
      tqdm # lightweight progress bar
      mitogen # ansible accelerator
      pexpect # expect on python
      passlib # generate hash for cisco switches
      pandas # data manipulation
      openpyxl # openpyxl to read/write excel sheet
    ];
in {
  imports = [
    (import ../../common/terminal {inherit vars lib pkgs config;})
    (import ../../common/desktop {inherit vars pkgs config lib;})
    (import ../../common/app {inherit vars pkgs config lib;})
    (import ../../common/games {inherit vars pkgs config lib;})
    (import ../../common/editor {inherit vars pkgs config lib;})
    (import ../../common/compose {inherit vars pkgs config lib;})
    (import ../../common/system {inherit vars pkgs config lib;})
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Install home manager as a module : https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
    <home-manager/nixos>
  ];

  customModules = {
    # Terminal
    ghostty.enable = true;
    kitty.enable = false;
    konsole.enable = true;
    neovim.enable = true;
    starship.GruvboxRainbow.enable = true;
    starship.PastelPowerline.enable = false;
    # Editor
    vscode.enable = true;
    # Desktop
    kde.enable = true;
    dolphin.enable = true;
    # Compose
    ollama.enable = false;
    wolf.enable = false;
    syncthing.enable = true;
    # App
    flatpak.enable = true;
    gamemode.enable = true;
    steam.enable = true;
    sunshine.enable = false;
    lazyjournal.enable = true;
    discord.enable = true;
    onedrive.enable = true;
    # Games
    TurtleWoW.enable = true;
    WarThunder.enable = false;
    # System
    audio.enable = true;
    bluetooth.enable = true;
    printer.enable = true;
  };

  ######################### Global Settings #########################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Disk Encrypt
  boot.initrd.luks.devices."luks-00286d7d-7c2f-4912-9d83-aaa0c992f906".device = "/dev/disk/by-uuid/00286d7d-7c2f-4912-9d83-aaa0c992f906";

  # Enable Hibernation
  # boot.kernelParams = ["resume_offset=38553600"]; # swap physical offset got through sudo filefrag -v /var/lib/swapfile | head
  boot.resumeDevice = "/dev/disk/by-uuid/e19036f3-3de5-4783-847d-28646b2c095a"; # L'UUID du swap déverouillé
  powerManagement.enable = true;

  ######################### Graphics Settings #########################

  # Enable Network Avahi/Bonjour network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    publish.addresses = true;
    publish.userServices = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Clean /tmp at boot
  boot.tmp.cleanOnBoot = true;

  # Allow experimental features and commands like nix hash
  nix.settings.experimental-features = "nix-command";

  ######################### Networking #########################

  networking.hostName = "Aerial"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Tailscale configuration
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  ######################### Accounts ##########################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    description = "Sniijz";
    extraGroups = ["networkmanager" "wheel" "audio" "docker" "video" "input" "gamemode" "lp" "scanner"];
    packages = with pkgs; [
    ];
  };

  ######################### Home-Manager #########################
  # To install home manager version 24.11 channel :
  # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
  # sudo nix-channel --update

  # users.users.sniijz.isNormalUser = true;
  # To check for home manager nix module availability
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/starship.nix
  home-manager.users.${vars.user} = {pkgs, ...}: {
    home.file = {
      #".config/starship.toml".source = ./terminal/configs/starship.toml;
      # ".local/share/konsole/Sniijz.profile".source = ./terminal/configs/SniijzKonsole.profile;
      # ".local/share/konsole/Breeze.colorscheme".source = ./terminal/configs/Breeze.colorscheme;
      # ".config/konsolerc".source = ./terminal/configs/konsolerc;
      # ".config/kglobalshortcutsrc".source = ./desktop/configs/kglobalshortcutsrc;
    };

    home.sessionVariables = {
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

  # Home manager fix
  home-manager.backupFileExtension = "rebuild";

  ######################### Packages #########################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };

    systemPackages = with pkgs; [
      alsa-scarlett-gui # Gui to configure Focusrite Scarlett audio interface
      alsa-utils # Advanced Linux Sound Architecture utils
      ansible # Automation tool
      appimage-run # Tool to run appimage on nixos
      arandr # graphical tool for monitor/screen mgmt
      aseprite # Pixel art editor
      bat # Better version of bat
      bitwarden-desktop # Password Manager
      bottles # Easy to use wineprefix manager
      btop # Top tool written in C++
      cardinal # Music Plugin wrapper around VCV Rack
      cmake # Compilation
      cmatrix # matrix effect package
      corectrl # Control your computer hardware via app profiles, perfect for FAN control
      compose2nix # Tool to convert docker-compose files for nix
      eza # Modern replacement of ls
      firefox # Web browser
      fzf # Fuzzy finder
      gamescope-wsi # game performance HDR tool
      gitmoji-cli # Git commit emjoji-cli support
      gimp # Image editor
      glances # Top nicolargo tool
      go # Golang language
      godot_4 # Video Game Editor
      gotop # top tool written in go
      goverlay # GUI to configure Mangohud
      guitarix # Virtual guitar amplifier
      gxplugins-lv2 # lv2 plugins from guitarix
      hollywood # flex hacker package
      helm # Music polyphonic synthesizer
      htop # Top tool with colors
      ifuse # Tpol to plug iphone through usb
      inetutils # network tools like telnet
      iperf # Network latency tool
      k9s # Kubernetes mgmt
      kdePackages.kcalc # kde calc
      kdePackages.ark # Archive Manager Tool
      kdePackages.dolphin # File manager
      kdePackages.dolphin-plugins # additionals plugins for dolphin file explorer
      kdePackages.kscreen # Additional options to display & monitor in kde
      kdePackages.skanlite # KDE Scanner tool
      kdePackages.spectacle # screenshot tool
      krita # Image drawing editor
      kronometer # Stopwatch application
      kubectl # Kubenertes config tool
      lsp-plugins # Collection of open-source audio mastering plugins
      libimobiledevice # package to plug iphone through usb
      lutris # Open Source Gaming Platform
      man # Linux Documentation
      mangohud # overlay for monitoring system  perf inside app or games
      mesa-demos # Mesa tools/utilities
      ncdu # Disk Usage Analyzer with ncurses interface
      neofetch # System Info Script
      neovim # text editor
      nettools # Network Tools
      niv # Painless dependencies for Nix projects
      nix-index # Files database for nixpkgs : gives nix-locate /bin/sleep command
      nix-search-cli # Tool to search for nixpkgs
      nvtopPackages.amd # GPU tui graph tool for amd gpu
      odin2 # Music Odin2 synthesizer plugin
      onedrive # Onedrive native linux filesystem for Microsoft Onedrive
      onedrivegui # Gui for onedrive configuration
      onlyoffice-desktopeditors # Document editor
      obsidian # markdown documentation tool
      pinta # image editor
      (python312.withPackages pythonSubPackages) # Python packages
      qjackctl # QT app to control Jack Sound Server
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtl
      reaper # DAW Music Editor
      remmina # XRDP & VNC Clint
      rsync # Syncer
      signal-desktop # Desktop app for signal chat
      smartmontools # Tool for monitoring health of packages
      spotify # Music Streaming Service
      starship # theme for terminal
      steam # Valve gaming platform
      surge-XT # VST3 Synth
      tailscale # wireguard vpn home access
      tcpdump # packet capture network tool
      tldr # man summary
      thunderbird # E-mail Client
      tmux # Terminal multiplexer
      tonelib-gfx # Amp and effects modeling
      tonelib-jam # Rocksmith like tab player
      tonelib-metal # Metal Amp and effects modeling
      unrar-free # rar extractor
      usbmuxd # Drivers to plug iphone through usb
      vim # text editor
      vital # Music Spectral warping wavetable synth
      vcv-rack # Music Open-source virtual modular synthesizer
      vlc # Video player
      warpinator # Share files across LAN
      wget # cli tool for download
      wireshark # packet capture for network tshoot
      wineWowPackages.waylandFull # Open Source implementation of the Windows API
      winetricks # Tool to work around problems in Wine
      wolf-shaper # Music Waveshaper plugin with spline-based graph editor
      xclip # xclip copying clipboard tool
      (xsane.override {gimpSupport = true;}) # scanner tool + gimp support
      yabridge # Use Windows VST2/3 On Linux
      yabridgectl # Utility to setup and update yabridge
      zram-generator # systemd unit generator for zram devices
    ];
  };

  # Override Package download, fix will be applied in NixOS 25.05
  nixpkgs.overlays = [
    (final: prev: {
      # Override Package download for TonelibMetal
      tonelib-metal = prev.tonelib-metal.overrideAttrs (oldAttrs: {
        src = builtins.fetchurl {
          url = "https://tonelib.vip/download/24-10-24/ToneLib-Metal-amd64.deb";
          sha256 = "sha256-H19ZUOFI7prQJPo9NWWAHSOwpZ4RIbpRJHfQVjDp/VA=";
        };
      });
    })
  ];
}
