{ pkgs, ... }:
{
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;  # Don't power on at boot to avoid delays - will start asynchronously
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;  # Better device discovery and battery reporting
        };
      };
    };
  };

  # Make bluetooth start asynchronously and don't block boot
  systemd.services.bluetooth = {
    # Start in parallel, don't wait for network
    wants = [ "dbus.service" ];
    after = [ "dbus.service" ];
    # Remove blocking dependencies
    before = [ ];
    # Add timeouts to prevent hanging
    serviceConfig = {
      TimeoutStartSec = "20s";
      TimeoutStopSec = "5s";
      # Don't restart too aggressively if it fails
      RestartSec = "5s";
    };
  };

  # Make blueman start asynchronously (user service)
  systemd.user.services.blueman-applet = {
    # Don't wait for network or bluetooth to be fully ready
    wants = [ "dbus.service" ];
    after = [ "dbus.service" ];
    serviceConfig = {
      TimeoutStartSec = "15s";
    };
  };

  local.hardware-clock.enable = false;
}

