{
  description = "ZaneyOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    username = "ritu";

    getHost = profile:
      if profile == "nvidia-laptop"
      then "laptop"
      else if profile == "nvidia"
      then "ritu"
      else "default-host"; # Add a default host if needed
  in {
    nixosConfigurations = {
      amd = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = getHost "amd";
          profile = "amd";
        };
        modules = [./profiles/amd];
      };
      nvidia = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = getHost "nvidia";
          profile = "nvidia";
        };
        modules = [./profiles/nvidia];
      };
      "nvidia-laptop" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = getHost "nvidia-laptop";
          profile = "nvidia-laptop";
        };
        modules = [./profiles/nvidia-laptop];
      };
      intel = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = getHost "intel";
          profile = "intel";
        };
        modules = [./profiles/intel];
      };
      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = getHost "vm";
          profile = "vm";
        };
        modules = [./profiles/vm];
      };
    };
  };
}
