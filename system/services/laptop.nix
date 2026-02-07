{pkgs, ...}: {
  # Laptop-specific power management
  services.thermald.enable = true;

  # TLP for battery optimization (disabled since power-profiles-daemon is used)
  # services.tlp.enable = true;

  # Lid switch behavior - lock screen then suspend
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  # Ensure screen locks before suspend
  systemd.services."lock-before-suspend" = {
    description = "Lock screen before suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/loginctl lock-sessions";
    };
  };

  # Backlight control
  programs.light.enable = true;
}
