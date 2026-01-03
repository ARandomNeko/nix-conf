{
  self,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  mod = "${self}/system";
  home = "${self}/home";

  # Get the basic config from system
  inherit (import "${self}/system") desktop laptop;

  specialArgs = {inherit inputs self;};
in {
  # Desktop with NVIDIA
  ritu = nixosSystem {
    inherit specialArgs;
    modules =
      desktop
      ++ [
        ./ritu
        "${mod}/services/gnome-services.nix"
        "${home}"

        ({pkgs, config, ...}: {
          networking.hostName = "ritu";

          # NVIDIA
          hardware.graphics.enable = true;
          services.xserver.videoDrivers = ["nvidia"];
          hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            # Use NVIDIA drivers matching the kernel version
            package = config.boot.kernelPackages.nvidiaPackages.stable;
          };

          # Services
          services.cloudflare-warp.enable = true;
        })
      ];
  };

  # Laptop with NVIDIA + AMD hybrid (ASUS ROG Zephyrus G14)
  laptop = nixosSystem {
    inherit specialArgs;
    modules =
      laptop
      ++ [
        ./laptop
        "${mod}/services/gnome-services.nix"
        "${home}"

        inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-nvidia

        ({
          pkgs,
          lib,
          config,
          ...
        }: {
          networking.hostName = "laptop";

          # NVIDIA Prime - use mkForce to override nixos-hardware
          hardware.graphics.enable = true;
          services.xserver.videoDrivers = ["nvidia"];
          hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = true;
            powerManagement.finegrained = true;
            open = false;
            nvidiaSettings = true;
            # Use NVIDIA drivers matching the kernel version
            package = config.boot.kernelPackages.nvidiaPackages.stable;
            prime = {
              offload = {
                enable = lib.mkForce true;
                enableOffloadCmd = lib.mkForce true;
              };
              amdgpuBusId = lib.mkForce "PCI:65:0:0";
              nvidiaBusId = lib.mkForce "PCI:0:2:0";
            };
          };

          # ASUS services
          services.asusd.enable = true;
          services.asusd.enableUserService = true;
          services.supergfxd.enable = true;

          # Services
          services.cloudflare-warp.enable = true;
        })
      ];
  };
}
