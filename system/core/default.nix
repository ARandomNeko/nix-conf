{
  pkgs,
  lib,
  ...
}: {
  # Locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console
  console.keyMap = "us";

  # Users
  users.users.ritu = {
    isNormalUser = true;
    description = "ritu";
    extraGroups = ["networkmanager" "wheel" "video" "audio" "docker"];
    shell = pkgs.nushell;
  };

  # System state version
  system.stateVersion = "24.11";
}
