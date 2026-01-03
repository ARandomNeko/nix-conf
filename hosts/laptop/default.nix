{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # ASUS-specific services are configured in hosts/default.nix
}
