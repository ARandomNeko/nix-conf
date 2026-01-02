{
  description = "NixOS Configuration with Niri + DankMaterialShell";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    quickshell.url = "github:outfoxxed/quickshell";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    dms.url = "github:AvengeMedia/DankMaterialShell";
  };

  outputs = {nixpkgs, nixpkgs-unstable, ...} @ inputs: let
    system = "x86_64-linux";
    username = "ritu";
    
    # Helper function to generate a host configuration
    mkHost = { hostName, profileName }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs nixpkgs-unstable;
        inherit (inputs) nixos-hardware;
        inherit username;
        host = hostName;
        profile = profileName;
      };
      modules = [ ./profiles/${profileName} ];
    };
    
  in {
    nixosConfigurations = {
      ritu = mkHost { hostName = "ritu"; profileName = "nvidia"; };
      laptop = mkHost { hostName = "laptop"; profileName = "nvidia-laptop"; };
    };
  };
}

