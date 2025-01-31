# KDE
{
  vars,
  pkgs,
  config,
  lib,
  ...
}: {
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable sddm login screen
  services.displayManager.sddm.enable = true;
  # Configure displayManager autologin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sniijz";

  # To force plasma in x11 in plasma5
  # services.displayManager.defaultSession = "plasma";
  # To force plasma in x11 in plasma6
  # services.displayManager.defaultSession = "plasmax11";

  # Enable/disable the plasma5 Desktop Environment
  services.xserver.desktopManager.plasma5.enable = false;

  # Enable/disable plasma6 enable the following
  services.desktopManager.plasma6.enable = true;

  # To exclude default plasma packages
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [elisa];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [];

  # Fix issue of having both gnome and plasma5 :
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";
}
