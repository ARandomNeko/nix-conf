{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # Your modules
    yourCore = "${self}/modules/core";
    yourDrivers = "${self}/modules/drivers";

    # Only Kaku's modules that add new functionality (don't conflict)
    kakuSystem = "${self}/system";

    # Common modules
    commonModules = [
      yourCore
      yourDrivers

      # Kaku additions that don't conflict with your modules
      "${kakuSystem}/hardware/graphics.nix"    # GPU hardware config
      "${kakuSystem}/hardware/fwupd.nix"       # Firmware updates
      "${kakuSystem}/services/xdg-portal-fix.nix"  # Portal fixes
      "${kakuSystem}/services/gnome-services.nix"  # GNOME services

      # Flake modules
      inputs.chaotic.nixosModules.default
    ];
  in {
    # Desktop with NVIDIA
    ritu = nixosSystem {
      specialArgs = {
        inherit inputs self;
        nixpkgs-unstable = inputs.nixpkgs;
        username = "ritu";
        host = "ritu";
        profile = "nvidia";
      };
      modules =
        commonModules
        ++ [
          ./ritu

          ({...}: {
            drivers.nvidia.enable = true;
            drivers.amdgpu.enable = false;
            drivers.intel.enable = false;
            services.cloudflare-warp.enable = true;
          })
        ];
    };

    # Laptop with NVIDIA + AMD hybrid
    laptop = nixosSystem {
      specialArgs = {
        inherit inputs self;
        nixpkgs-unstable = inputs.nixpkgs;
        username = "ritu";
        host = "laptop";
        profile = "nvidia-laptop";
      };
      modules =
        commonModules
        ++ [
          ./laptop
          "${kakuSystem}/hardware/bluetooth.nix"
          inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-nvidia

          ({...}: let
            vars = import ./laptop/variables.nix;
          in {
            drivers.nvidia.enable = true;
            drivers.nvidia-prime = {
              enable = true;
              amdgpuBusID = vars.intelID;
              nvidiaBusID = vars.nvidiaID;
            };
            drivers.amdgpu.enable = false;
            drivers.intel.enable = false;
            services.cloudflare-warp.enable = true;
          })
        ];
    };
  };
}
