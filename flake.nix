{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    username = "ritu";
    
    # Helper function to generate a host configuration
    mkHost = { hostName, profileName }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
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
