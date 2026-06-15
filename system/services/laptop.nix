{...}: {
  # Laptop-specific power management
  services.thermald.enable = true;

  # TLP for battery optimization (disabled since power-profiles-daemon is used)
  # services.tlp.enable = true;

  # Lid switch behavior:
  # - On battery: suspend (Noctalia locks via logind integration before sleep)
  # - On AC power: lock only (logind lock signal handled by Noctalia)
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
  };

}
