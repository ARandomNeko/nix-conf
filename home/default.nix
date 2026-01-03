{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";  # Backup existing files instead of failing
    extraSpecialArgs = {inherit inputs;};

    users.ritu = {
      imports = [
        inputs.noctalia.homeModules.default
        ./programs
        ./shell
        ./noctalia.nix
      ];

      home = {
        username = "ritu";
        homeDirectory = "/home/ritu";
        stateVersion = "24.11";
      };

      # Let home-manager manage itself
      programs.home-manager.enable = true;
    };
  };
}


