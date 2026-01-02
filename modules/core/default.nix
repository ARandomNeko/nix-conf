{inputs, ...}: {
  imports = [
    ./boot.nix
    ./fonts.nix
    ./hardware.nix
    ./network.nix
    ./nh.nix
    ./packages.nix
    ./services.nix
    ./steam.nix
    ./stylix.nix
    ./system.nix
    ./user.nix
    ./logitech.nix
    ./virtualisation.nix
    ./xdg.nix
    ./xwayland.nix
    inputs.stylix.nixosModules.stylix
  ];
}

