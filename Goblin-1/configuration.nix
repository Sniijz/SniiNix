{
  config,
  pkgs,
  lib,
  ...
}: 
let
  docker-compose-file = "./wings/docker-compose.yml";
in
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

  # Rook/Ceph support
  boot.kernelModules = [ "rbd" ];

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
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.1.9";
      prefixLength = 24;
    }];
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

######################### Accounts #########################


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sniijz = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMNh6mxUA3+3VgfK5zy6IFmHajtKOVIDaSQ5YQUx05NoGtvM/bOOYM/alhoBvZB7C+DUDDv31tm1ON6TALfEFdeCaj7N08mLBvzwe45dTc1dH6sJI1kA9ny/L48fMSCF4qr9FgLDC5uj06RT0lKLP4HDQttLG1VV+jHx7mkBS12WVCTYiB4ZKde4BkrURVx36LqHrxvH8DZsJUr0yd1D8WhqfWvNP1Mn2nGXVkoCp1OcQaxncVFN3U1XBF9wqk+mnHjfwDjyVPoRG6PjuxXxlm4JcvjkTWdEeqlXhAYWPgHQ9KkFTk6QVQNZDV8nkZBkvYY91UcKcerGqR2jZ3PxYmhHWX0YkTz3QrPVWvhJrpQlkybNWqUnmRYRIhcgCsv4k1et6p7tld2qUDrT6O9KpVwWndKJugoHbM2geXQ7c2fsUMcCYF3i6zXobm18oaP4Fzqs1DVfLk/mB3j+9fNscMVJSYG2LaKB6bX4T4+4E6RUGNCQzXSSyjKKLgZZplUWUVsf68vGcWviXSRYmZ/4nHH9BZ/I+3hYb9H0j5QXSKFecX0EWWW7iLZ9zTj1PH+GVS6AnLC6JZzSdty8yHN9ectmP5+TLKpnZaGGKJFQDGORmQG77/156R2VKTs+kkY8xnR67IClUt1zkVLOKX8E6u3sVe4+qV9mW46tF3QRfNJw== sniijz@SniiZone"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdOoFm2Gt99VvykGJZRyMa+y1iFCJ37/V7yB2M6HXJ77w56Zqh1ibdCdBP/AlFfGueZ5e5EtxJTPIO/sExEo1kY2eG0SNvn+pKwsPiffa7cQckiXz5jZk0VCJ/nhiIsITTfDyKHT7faQR6ck+z+hsb09u6v60z+z4ght9bJEl5LouTGwIlRS+XUfhzZo2LCe4YdSyZcsHfgWRDZOr+qtRhb0WpLQLzrD3CMkQydw19Nv11bhpY2HZHKoGC5nfNx+hKP3gvKpiY/JCjR9MxkXvSTa/oBMR7Ru9fC/BUdxHRerqLkUE0i7GEbtVemnfbfnOlPginvqhl2Kgz0v2LyB3ZvBLVrYU0AXRhW8PNq+KDZR6rJXmvt0DwLFg2DIrQloCD2h9AlPQOwF210cPRkux3TjkC6PJTLi5i48k/YgYJ2+SfHqUGF+d/iw5bkZicGQXbQE0gIiFK5n7D01b8L9PSw2g2kmrq4NRbKTTWzNlg3vtdw+AcgNdWGyvGsGkkO/BJFEtMuAvb9NTGYWBcQq9COe1/KN/GQXWSYA4/Ft031K0S8P4cIWckGGG8IjTKCh44J4IaYlUpAdFsDqHrqaUuZmqv2LZWtkx+8p04/qqPTH5stQldnDvlJNebU6xt5fWaMP94LCH7evp/VD1wfotI7cb0Zo9GbUookJqayIyW/w== sniijz@Barbatos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2KqKf5CYuJvfH1hYrlg4k/OiFiRAD6851O2DCN1LKvBkN8k0PlAmuNLI0+fnxruqFvaRMN8JedV+JmzDEvjjhrG34eXredUW6mfPaS4GYspZCSCDRGy8F9d4478nyO5mg6EyUmrWK4kh7CryLbTMctlTwWwcqJhi9JIUoxnSYZZlQtUOf43MfOVsjIHzBjvbSgLWpCIA8GwQafGaouh9tT+xyxru7DW5C48HPnFLbcI3TYElYh94XqAYT4YAVyuYU97lTuCLdgpdr2g9WFGWEHme6GTbGPOVkLIaBzwpGqwbhqISqxquqMy27SVydMflXpZFlVnm/hbAFNmXYsxnS4HS7G3TjQowYCWL5ht5/oIQ3cJpCd76viVJwL5c+iqzijX9oG/MX/nEmkqmlgOkz3TSmja+RtuY90/W72l49WFJfjEVp/c3AwWgWrm3tJOk1Kg/FaYFQ5XocnznfTBwMlgfG4UsSCYfzLOZcorDRVPG2ccF4WbOlbstfEhVeIhzHmsfyoaLrVUuc3/4TJ8rmuwqOPc7PbzEaWRlyNiYqwcSPQxIudaf0nzHi2QtE5ZVffsrAVDmW5vSyORPXyM59yzQ2eGXHtTK+kB6a2AEhqqtIGfnsp7zgNHqHe4Z0xxzdu/nVnbhqYnIxy+4wTM+Dv6ftWKkpN736nZp5sn1XGw== sniijz@SniiPi"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0x7yxXnij6HaeMqXcrzNEP5XO87VU9T3VLTya60gFR7pCEStLtItwc7Q5/Pxh+Veg038nIXZUsKgwf7xAuN51Hj2yoQtaFoUMDtP9cALuPj0O9XOG51N9NgnpVQymwc8kpnC23uxuThLGLbffvJw1AUFtbpMmCDfRNCC8NlqV0lq25UT0mvDXy2TGknBw4u8X8X27eeZXaSoQ83QssEQ7nyuGz2bDFDgmS1fatYswqXEKI6AkVSVr6f6w5tpRuhCoQXJ2JQ1m5oc35eFKmZZ0weddH+3CyVQEmKPwcxQKu2icdV5jbV5qalvdBJY6cEsYB5GBzpYJWUTMnPLt1dbVqD0M4M9i89Vm2S4J/O/YK/vn5YxW/k3rVBwVVkgVUDVmZP6Pc9LIVDDd8POD+mFtpNFCAqcEDZhBEECMNyswstemplXSGnNYbJVoEFQtep6RvYflqc+JVr6aVoHpgZAJyuZvuxoF6I3oE1Pa4ISO9hlzCVVjGpaVLYUD7eJk1ZY0LF4/R1kCxDYHN3X5yaEMzJYxfWIR54U00wESWYVtEXZNSOG9OI8lsO95BOXz/BV/RtRNuD5Kk+ui0vwUJ63ba3CLqdbLLWGBd0PVRy+nFS3K9ojZ4Y7YRuL8TEM0pysS8i0Vb1ZaZ40Kp3y5fQbxV+rgbj4CEqt1N3usnHOPew== sniijz@sniiplex"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJy3YYea/Yfsi3TReN/QSd6yQBsMj/sXrwIZ9qixEczJ robin.cassagne@wanadoo.fr"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvrXVUq0NjXODiYASDOjf7MAvjtE56d20aBzc1MuDCU internet@internet"
    ];
  };


######################### Home-Manager #########################
# To install home manager version 24.05 channel :
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
# sudo nix-channel --update

# users.users.sniijz.isNormalUser = true;
home-manager.users.sniijz = { pkgs, ... }: {
  home.file = {
  ".config/starship.toml".source = ./terminal/starship.toml;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
};


######################### Packages #########################

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      K3S_RESOLV_CONF=/etc/resolv.conf;
    };



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
      nfs-utils # Needed for Longhorn
      util-linux # contains nsenter for longhorn
      docker # To manage pterodactyl wings
      docker-compose # To manage pterodactyl wings
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
    serverAddr = "https://192.168.1.30:6443"; 
    token = "K10b47e4a41d9b550fe2730795c930df9ed9965ad1279b8aa0c733b071bc36e7b06::server:mEvZbtzjFk6eejXy4ojtojnTSwUWTxWY72Vgh3BjsnebuZ65WapQHkybv6CeavUY"; 
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

###################### docker configuration for Wings ############

  systemd.services.pterodactyl-wings = {
    description = "Pterodactyl Wings via Docker Compose";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${docker-compose-file} up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${docker-compose-file} down";
      WorkingDirectory = "/etc/pterodactyl";
      Restart = "always";
    };

    wantedBy = [ "multi-user.target" ]; # This start the service after every boot
  };

  # Ouvre les ports nécessaires
  networking.firewall.allowedTCPPorts = [ 8080 2022 443 ];

}
