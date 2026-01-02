{nixos-hardware, ...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    # ASUS ROG Zephyrus G14 hardware optimizations (with NVIDIA support)
    nixos-hardware.nixosModules.asus-zephyrus-ga402x-nvidia
  ];

  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;
}

