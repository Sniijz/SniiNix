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
    (import ./terminal {inherit pkgs config;})
    (import ./desktop {inherit vars pkgs config lib;})
    (import ./app {inherit vars pkgs config lib;})

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ######################### Global Settings #########################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

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

  # Configure kernel with amdgpu driver
  boot.initrd.kernelModules = ["amdgpu"];

  # Force xserver to uses amdgpu driver
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Clean /tmp at boot
  boot.tmp.cleanOnBoot = true;
  # Home manager fix
  home-manager.backupFileExtension = "rebuild";

  ######################### Networking #########################

  networking.hostName = "Barbatos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  ######################### Accounts ##########################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    description = "Sniijz";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
    ];
  };

  ######################### Home-Manager #########################
  # To install home manager version 24.11 channel :
  # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
  # sudo nix-channel --update

  # users.users.sniijz.isNormalUser = true;
  home-manager.users.${vars.user} = {pkgs, ...}: {
    home.file = {
      ".config/starship.toml".source = ./terminal/configs/starship.toml;
      ".local/share/konsole/Sniijz.profile".source = ./terminal/configs/SniijzKonsole.profile;
      ".local/share/konsole/Breeze.colorscheme".source = ./terminal/configs/Breeze.colorscheme;
      ".config/konsolerc".source = ./terminal/configs/konsolerc;
      ".config/kglobalshortcutsrc".source = ./desktop/configs/kglobalshortcutsrc;
      ".config/autostart/steam.desktop".source = ./desktop/configs/autostart/steam.desktop;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

  ######################### Packages #########################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.git.enable = true;
  programs.git.config = {
    user.name = "Robin CASSAGNE";
    user.email = "robin.jean.cassagne@gmail.com";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Install Flatpak
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment = {
    variables = {
      K3S_RESOLV_CONF = /etc/resolv.conf;
    };

    systemPackages = with pkgs; [
      amdgpu_top # Tool to display AMD GPU Usage
      alsa-scarlett-gui # Gui to configure Focusrite Scarlett audio interface
      ansible # Automation tool
      arandr # graphical tool for monitor/screen mgmt
      aseprite # Pixel art editor
      ark # Archiving tool
      btop # Top tool written in C++
      cmake # Compilation
      cmatrix # matrix effect package
      corectrl # Control your computer hardware via app profiles, perfect for FAN control
      discord # Audio and Chat communication tool
      dosbox # PC DOS-Emulator
      eza # modern replacement of ls
      fd # Alternative to find
      filelight # Disk Usage information viewer
      fish # alternative to bash
      fishPlugins.fzf-fish # fzf plugin for fish
      fishPlugins.z # zoxide plugin for fish
      flatpak # Tool to manager container sandboxed apps
      fzf # fuzzy finderz
      godot_4 # Video Game Editor
      gotop # top tool written in go
      guitarix # Virtual guitar amplifier
      gxplugins-lv2 # lv2 plugins from guitarix
      htop # Top tool with colors
      kdePackages.dolphin # File manager
      kdePackages.dolphin-plugins # additionals plugins for dolphin file explorer
      kcalc # kde calc
      k9s # Kubernetes mgmt
      krita # Image drawing editor
      kronometer # Stopwatch application
      kubectl # Kubenertes config tool
      lutris # Open Source Gaming Platform
      man # Linux Documentation
      neofetch # System Info Script
      neovim # text editor
      ncdu # Disk Usage Analyzer with ncurses interface
      nettools # Network Tools
      onlyoffice-desktopeditors # Document editor
      obsidian # markdown documentation tool
      pinta # image editor
      (python312.withPackages pythonSubPackages) # Python packages
      qjackctl # QT app to control Jack Sound Server
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtl
      radeontop # Top like for AMD GPU
      reaper # DAW Music Editor
      remmina # XRDP & VNC Clint
      rsync # Syncer
      smartmontools # Tool for monitoring health of packages
      spectacle # screenshot tool
      starship # theme for terminal
      surge-XT # VST3 Synth
      tldr # man summary
      thunderbird # E-mail Client
      tonelib-gfx # Amp and effects modeling
      unrar-free # rar extractor
      vim # text editor
      vscode # Visual Code Editor
      warpinator # Share files across LAN
      wget # cli tool for download
      wireshark # packet capture for network tshoot
      wine # Open Source implementation of the Windows API
      yabridge # Use Windows VST2/3 On Linux
      yabridgectl # Utility to setup and update yabridge
      zram-generator # systemd unit generator for zram devices
    ];
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["DroidSansMono"];})
  ];
}
