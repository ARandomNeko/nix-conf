{ lib, pkgs, ... }:
{
  # Advertise an Apple DeviceID so AirPods expose the features LibrePods uses.
  hardware.bluetooth.settings.General.DeviceID = "bluetooth:004C:0000:0000";

  # Laptop-specific packages
  environment.systemPackages = with pkgs; [
    # ASUS tools
    asusctl
    supergfxctl

    # Power management
    acpi
    powertop

    # Media (laptop use)
    audacity
    librepods
    obs-studio
  ];

  # LibrePods is tray-based, so start it with the desktop and expose Noctalia's
  # tray widget on this host.
  home-manager.users.ritu = {
    programs.noctalia.settings.bar.default.end = lib.mkBefore [ "tray" ];

    systemd.user.services.librepods = {
      Unit = {
        Description = "LibrePods AirPods integration";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.librepods;
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
