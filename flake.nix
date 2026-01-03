{
  description = "ritu's NixOS configuration based on Kaku";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [./hosts ./pkgs];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells = {
          default = pkgs.mkShell {
            packages = [pkgs.alejandra pkgs.git config.packages.repl];
            name = "nix-conf";
            DIRENV_LOG_FORMAT = "";
          };
        };
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    systems.url = "github:nix-systems/default-linux";
    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    import-tree.url = "github:vic/import-tree";
    mynixpkgs.url = "github:linuxmobile/mynixpkgs";

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    quickshell.url = "github:outfoxxed/quickshell";
  };
}
