{ lib, pkgs, ... }:
let
  librepods = pkgs.callPackage ../../system/packages/librepods-noctalia.nix { };
in
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
    librepods
    obs-studio
  ];

  # The Noctalia plugin is the UI, so run its patched LibrePods backend without
  # the upstream Qt tray/window.
  home-manager.users.ritu = {
    systemd.user.services.librepods = {
      Unit = {
        Description = "LibrePods AirPods integration";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = [ "QT_LOGGING_RULES=openpods.debug=false" ];
        ExecStart = "${lib.getExe librepods} --headless";
        Restart = "on-failure";
        RestartSec = 3;
        UMask = "0077";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
