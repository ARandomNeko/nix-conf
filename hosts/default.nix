{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";
    home = "${self}/home";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    laptop = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ laptop
        ++ [
          ./laptop
          "${mod}/services/gnome-services.nix"
          "${home}"

          inputs.agenix.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
