{
  config,
  pkgs,
  lib,
  ...
}: 
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    (import ./terminal {inherit pkgs config;})
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "Goblin-1"; 
  


  # Enable networking
  networking = {
    networkmanager.enable = true;
    nameservers = ["192.168.1.3" "192.168.1.3"];
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.1.9";
      prefixLength = 24;
    }];
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };
  };


  # Configure network proxy if necessary
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs.ssh.startAgent = true;
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # List services that you want to enable:


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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


# users.users.sniijz.isNormalUser = true;
home-manager.users.sniijz = { pkgs, ... }: {
  home.file = {
  ".config/starship.toml".source = ./terminal/starship.toml;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
};


# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      atuin # Shell History
      rsync # Syncer
      ansible # Automation tool
      vim # text editor
      neovim # text editor
      cmatrix # matrix effect package
      git # version control tool
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
    ];
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["DroidSansMono"];})
  ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
