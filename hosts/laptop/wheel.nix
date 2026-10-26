{ pkgs, ... }:
{
  # Replace the stock Logitech wheel driver with full force-feedback support.
  hardware.new-lg4ff.enable = true;

  environment.systemPackages = [ pkgs.oversteer ];

  # Allow Oversteer to configure rotation, centering and force-feedback gains.
  services.udev.packages = [ pkgs.oversteer ];
}
