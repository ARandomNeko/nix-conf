{ inputs, pkgs, ... }: {
  imports = [ inputs.noctalia.nixosModules.default ];

  services.noctalia-shell.enable = true;
  
  # Add the package to system packages so it's available in the path
  environment.systemPackages = [ inputs.noctalia.packages.${pkgs.system}.default ];
}
