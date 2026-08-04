{ ... }: {
  imports = [
    ./auto-update.nix
    ./hardware.nix
    ./hermes.nix
    ./host-packages.nix
    ./remote-dev.nix
  ];

  # NVIDIA configuration is in hosts/default.nix
}
