{ pkgs, ... }:
{
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;  # Ensure bluetooth is ready immediately
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;  # Better device discovery and battery reporting
        };
      };
    };
  };
  local.hardware-clock.enable = false;
}

