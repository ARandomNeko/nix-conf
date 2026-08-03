{ ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./remote-dev.nix
  ];

  # ASUS-specific services are configured in hosts/default.nix
}
