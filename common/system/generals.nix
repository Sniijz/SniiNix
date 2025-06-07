{
  config,
  pkgs,
  lib,
  ...
}: let
  themeCyberpunk = pkgs.fetchFromGitHub {
    owner = "anoopmsivadas";
    repo = "Cyberpunk-GRUB-Theme";
    rev = "1efd2cd4a1f82e5809e494d1c8b7b31fdbd1f3d0";
    sha256 = "sha256-UlO3/KvfBbRc6FTFREmhmduQLrXlyJwZh6ufRtgFEK0=";
  };
  themeXenlism = pkgs.fetchFromGitHub {
    owner = "xenlism";
    repo = "Grub-themes";
    rev = "40ac048df9aacfc053c515b97fcd24af1a06762f";
    sha256 = "sha256-ProTKsFocIxWAFbYgQ46A+GVZ7mUHXxZrvdiPJqZJ6I=";
  };
in {
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # https://discourse.nixos.org/t/how-to-customize-grub-cfg/59311
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    extraConfig = ''
      GRUB_DISABLE_OS_PROBER=false
      GRUB_TIMEOUT_STYLE=menu
      GRUB_TERMINAL_OUTPUT=gfxterm
    '';
    theme = "${themeXenlism}/xenlism-grub-2k-nixos/Xenlism-Nixos";
  };

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

  # Configure console/tty keymap
  # console.keyMap = "fr";
  console = {
    earlySetup = true;
    font = "eurlatgr";
    keyMap = "fr";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [epson-escpr epson-escpr2];
    browsing = true;
    defaultShared = true;
  };

  # Scanner activation
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.epsonscan2];
  };
}
