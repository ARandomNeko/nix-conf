{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    # ASUS ROG Zephyrus G14 hardware optimizations are now added in hosts/default.nix
  ];

  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;
}
