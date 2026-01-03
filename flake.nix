{
  description = "ritu's NixOS configuration based on Kaku";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./hosts
        ./pkgs
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          devShells = {
            default = pkgs.mkShell {
              packages = [
                pkgs.alejandra
                pkgs.git
                config.packages.repl
              ];
              name = "nix-conf";
              DIRENV_LOG_FORMAT = "";
            };
          };
          formatter = pkgs.alejandra;
        };
    };

  inputs = {
    systems.url = "git+https://github.com/nix-systems/default-linux";
    flake-compat.url = "git+https://github.com/edolstra/flake-compat";

    flake-utils = {
      url = "git+https://github.com/numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "git+https://github.com/hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable";

    import-tree.url = "git+https://github.com/vic/import-tree";
    mynixpkgs.url = "git+https://github.com/linuxmobile/mynixpkgs";

    nix-index-db = {
      url = "git+https://github.com/Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "git+https://github.com/NixOS/nixos-hardware?ref=master";
    stylix.url = "git+https://github.com/danth/stylix";
    quickshell.url = "git+https://github.com/outfoxxed/quickshell";
    noctalia = {
      url = "git+https://github.com/noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
