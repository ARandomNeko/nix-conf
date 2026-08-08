{ ... }: {
  imports = [
    ./auto-update.nix
    ./hardware.nix
    ./hermes.nix
    ./host-packages.nix
    ./pihole.nix
    ./remote-dev.nix
  ];

  fileSystems."/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # NVIDIA configuration is in hosts/default.nix
}
