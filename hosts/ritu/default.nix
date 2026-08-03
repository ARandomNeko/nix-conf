{ ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./remote-dev.nix
  ];

  # NVIDIA configuration is in hosts/default.nix
}
