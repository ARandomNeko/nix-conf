{lib, ...}: {
  imports = [
    ./security.nix
    ./users.nix
    ../nix
    ../programs/fish.nix
  ];

  # User's locale settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  console.keyMap = "us";

  system = {
    switch.enable = true;
    stateVersion = lib.mkDefault "23.11";
  };

  # User's timezone
  time = {
    timeZone = lib.mkDefault "Asia/Kolkata";
    hardwareClockInLocalTime = lib.mkDefault true;
  };

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # Environment
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "hx";
    VISUAL = "hx";
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
  };

  # Power management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
