{ lib, pkgs, ... }:
{
  # The packaged driver concatenates these flags into a shell array. Quote them
  # so the kernel's cmd_sign=$(...) make expression reaches make unchanged.
  nixpkgs.overlays = [
    (_: previous: {
      linuxPackages_latest = previous.linuxPackages_latest.extend (
        _: kernelPrevious: {
          new-lg4ff = kernelPrevious.new-lg4ff.override {
            kernelModuleMakeFlags = map lib.escapeShellArg kernelPrevious.kernelModuleMakeFlags;
          };
        }
      );
    })
  ];

  # Replace the stock Logitech wheel driver with full force-feedback support.
  hardware.new-lg4ff.enable = true;

  environment.systemPackages = [ pkgs.oversteer ];

  # Allow Oversteer to configure rotation, centering and force-feedback gains.
  services.udev.packages = [ pkgs.oversteer ];
}
