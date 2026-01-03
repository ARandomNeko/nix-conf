{pkgs, ...}: {
  # Laptop-specific power management
  services.thermald.enable = true;

  # TLP for battery optimization (disabled since power-profiles-daemon is used)
  # services.tlp.enable = true;

  # Lid switch behavior
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
    };
  };

  # Backlight control
  programs.light.enable = true;
}
