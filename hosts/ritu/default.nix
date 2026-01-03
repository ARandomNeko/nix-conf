{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # NVIDIA configuration is in hosts/default.nix
}
