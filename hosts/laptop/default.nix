{ ... }: {
  imports = [
    ./eduroam.nix
    ./hardware.nix
    ./host-packages.nix
    ./keepassxc.nix
    ./remote-dev.nix
    ./wheel.nix
  ];

  # ASUS-specific services are configured in hosts/default.nix
}
