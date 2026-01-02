{lib, ...}: {
  imports = [
    ./security.nix
    ./users.nix
    ../nix
    ../programs/fish.nix
  ];

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

  # don't touch this
  system = {
    switch.enable = true;
    stateVersion = lib.mkDefault "25.05";
  };

  time = {
    timeZone = lib.mkDefault "Asia/Kolkata";
    hardwareClockInLocalTime = lib.mkDefault true;
  };

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
}
