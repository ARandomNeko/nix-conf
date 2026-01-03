{
  description = "NixOS Configuration with Niri + Kaku";

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
        # Nix Formatter
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    # Global inputs that can be followed
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
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix.url = "github:danth/stylix";

    # Editor
    nvf.url = "github:notashelf/nvf";

    # Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    # QuickShell
    quickshell.url = "github:outfoxxed/quickshell";

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Import tree for automatic module discovery
    import-tree.url = "github:vic/import-tree";

    # Linuxmobile's packages
    mynixpkgs.url = "github:linuxmobile/mynixpkgs";

    # Nix index database for command-not-found
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic Nyx for extra packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
}
