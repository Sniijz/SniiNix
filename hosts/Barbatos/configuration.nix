# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:
let
  vars = {
    user = "sniijz";
    location = "$HOME/.setup";
    gitUser = "robin.cassagne";
    terminal = "konsole";
    editor = "code";
  };

  # latestKonsole = pkgs.konsole.overrideAttrs (oldAttrs: rec {
  #   version = "25.03.80"; # Replace with the latest version
  #   src = pkgs.fetchFromGitHub {
  #     owner = "KDE";
  #     repo = "konsole";
  #     rev = "v25.03.80";
  #     # nix-prefetch-url --unpack https://github.com/KDE/konsole/archive/refs/tags/v25.03.80.tar.gz
  #     sha256 = "1hsmy26bf0paycdq1jzgvqaf709nlh0x3hnl8bbh34yp9pqrdby1";
  #   };
  # });

  pythonSubPackages =
    ps: with ps; [
      ansible # ansible love nix
      backoff # enable retry on web requests
      black # most used python formatter
      jinja2 # text renderer
      mitogen # ansible accelerator
      netaddr # handle ip with python
      netmiko # network oriented paramiko extension
      openpyxl # openpyxl to read/write excel sheet
      pandas # data manipulation
      paramiko # ssh pythonic
      passlib # generate hash for cisco switches
      pexpect # expect on python
      pip # python package manager
      pynetbox # official api sdk netbox
      python-box # make python dict easy
      pyyaml # yaml on python
      requests # python http
      rich # make beautiful ux on cli with python
      scp # ssh copy
      textfsm # text parser
      tqdm # lightweight progress bar
      ttp # text parser
      ttp-templates # bunch of ttp community templates
    ];
in
{
  imports = [
    (import ../../common/terminal {
      inherit
        vars
        lib
        pkgs
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

  ######################### Graphics Settings #########################

  # Configure kernel with amdgpu driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Force xserver to uses amdgpu driver
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };

  hardware.enableAllFirmware = true;

  # install unstables mesa/amd drivers for 64 and 32 bits apps
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa ];
    enable32Bit = true;
    extraPackages32 = [ pkgs.driversi686Linux.mesa ];
  };

  # Enable Network Avahi/Bonjour network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Clean /tmp at boot
  boot.tmp.cleanOnBoot = true;

  # Allow experimental features and commands like nix hash
  nix.settings.experimental-features = "nix-command";

  ######################### Networking #########################

  networking = {
    hostName = "Barbatos"; # Define your hostname.

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    # Firewall open for kdeconnect
    firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  ######################### Accounts ##########################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    description = "Sniijz";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "docker"
      "video"
      "input"
      "gamemode"
      "lp"
      "scanner"
    ];
  };

  ######################### Home-Manager #########################
  # To install home manager version 24.11 channel :
  # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
  # sudo nix-channel --update

  # users.users.sniijz.isNormalUser = true;
  # To check for home manager nix module availability
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/starship.nix
  home-manager.users.${vars.user} =
    { pkgs, ... }:
    {
      home = {
        file = {
          #".config/starship.toml".source = ./terminal/configs/starship.toml;
          # ".local/share/konsole/Sniijz.profile".source = ./terminal/configs/SniijzKonsole.profile;
          # ".local/share/konsole/Breeze.colorscheme".source = ./terminal/configs/Breeze.colorscheme;
          # ".config/konsolerc".source = ./terminal/configs/konsolerc;
          # ".config/kglobalshortcutsrc".source = ./desktop/configs/kglobalshortcutsrc;
        };

        sessionVariables = {
        };

        # The state version is required and should stay at the version you
        # originally installed.
        stateVersion = "24.11";
      };
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
      # signal-desktop # Desktop app for signal chat
      (python312.withPackages pythonSubPackages) # Python packages
      (xsane.override { gimpSupport = true; }) # scanner tool + gimp support
      alsa-scarlett-gui # Gui to configure Focusrite Scarlett audio interface
      alsa-utils # Advanced Linux Sound Architecture utils
      amdgpu_top # Tool to display AMD GPU Usage
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
      compose2nix # Tool to convert docker-compose files for nix
      corectrl # Control your computer hardware via app profiles, perfect for FAN control
      easyeffects # pipewire mastering tool
      etlegacy # Wolfenstein open source
      eza # Modern replacement of ls
      firefox # Web browser
      fzf # Fuzzy finder
      gamescope-wsi # game performance HDR tool
      gimp # Image editor
      gitmoji-cli # Git commit emjoji-cli support
      glances # Top nicolargo tool
      glow # terminal markdown renderer
      gnomeExtensions.easyeffects-preset-selector # Presets easyeffects
      go # Golang language
      godot_4 # Video Game Editor
      gotop # top tool written in go
      goverlay # GUI to configure Mangohud
      guitarix # Virtual guitar amplifier
      gxplugins-lv2 # lv2 plugins from guitarix
      hollywood # flex hacker package
      htop # Top tool with colors
      ifuse # Tpol to plug iphone through usb
      iperf # Network latency tool
      k9s # Kubernetes mgmt
      kdePackages.ark # Archive Manager Tool
      kdePackages.dolphin # File manager
      kdePackages.dolphin-plugins # additionals plugins for dolphin file explorer
      kdePackages.isoimagewriter # Iso Writer for bootable USB key
      kdePackages.kcalc # kde calc
      kdePackages.kdeconnect-kde # Mobile management
      kdePackages.kscreen # Additional options to display & monitor in kde
      kdePackages.skanlite # KDE Scanner tool
      kdePackages.spectacle # screenshot tool
      krita # Image drawing editor
      kronometer # Stopwatch application
      kubectl # Kubenertes config tool
      kubectl # Kubernetes config tool
      kubernetes-helm # Kubernetes package manager
      lazygit # git tui tool
      libimobiledevice # package to plug iphone through usb
      linux-firmware # Binary firmware collection needed for ollama
      lsp-plugins # Collection of open-source audio mastering plugins
      lua-language-server # lua lsp for vim
      lutris # Open Source Gaming Platform
      lyrebird # Voice changing tool
      man # Linux Documentation
      mangohud # overlay for monitoring system  perf inside app or games
      mesa-demos # Mesa tools/utilities
      moreutils # unix tools like sponge for tmux
      ncdu # Disk Usage Analyzer with ncurses interface
      neofetch # System Info Script
      neovim # text editor
      nettools # Network Tools
      niv # Painless dependencies for Nix projects
      nix-index # Files database for nixpkgs : gives nix-locate /bin/sleep command
      nix-search-cli # Tool to search for nixpkgs
      nvtopPackages.amd # GPU tui graph tool for amd gpu
      obsidian # markdown documentation tool
      odin2 # Music Odin2 synthesizer plugin
      onedrive # Onedrive native linux filesystem for Microsoft Onedrive
      onedrivegui # Gui for onedrive configuration
      onlyoffice-desktopeditors # Document editor
      pinta # image editor
      qjackctl # QT app to control Jack Sound Server
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtl
      radeontop # Top like for AMD GPU
      reaper # DAW Music Editor
      remmina # XRDP & VNC Client
      rocmPackages.rocminfo
      rsync # Syncer
      smartmontools # Tool for monitoring health of packages
      spotify # Music Streaming Service
      starship # theme for terminal
      strace # debugging log tool
      surge-XT # VST3 Synth
      thunderbird # E-mail Client
      tldr # man summary
      tmux # Terminal multiplexer
      tonelib-gfx # Amp and effects modeling
      tonelib-jam # Rocksmith like tab player
      tonelib-metal # Metal Amp and effects modeling
      unrar-free # rar extractor
      urbanterror # Urban Terror Game
      usbmuxd # Drivers to plug iphone through usb
      vcv-rack # Music Open-source virtual modular synthesizer
      vim # text editor
      vital # Music Spectral warping wavetable synth
      vlc # Video player
      warpinator # Share files across LAN
      wget # cli tool for download
      wineWowPackages.waylandFull # Open Source implementation of the Windows API
      winetricks # Tool to work around problems in Wine
      wireshark # packet capture for network tshoot
      wl-clipboard # xclip copy clipboard tool equivalent under wayland
      wolf-shaper # Music Waveshaper plugin with spline-based graph editor
      xclip # xclip copying clipboard tool
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
