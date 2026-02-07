{...}: {
  # Laptop-specific power management
  services.thermald.enable = true;

  # TLP for battery optimization (disabled since power-profiles-daemon is used)
  # services.tlp.enable = true;

  # Lid switch behavior:
  # - On battery: suspend (swayidle triggers noctalia lock before sleep)
  # - On AC power: lock only (swayidle catches lock signal from logind)
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  # Backlight control
  programs.light.enable = true;
}
