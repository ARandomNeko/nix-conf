{
  # nh default flake path
  environment.variables.NH_FLAKE = "/home/ritu/nix-conf";

  programs.nh = {
    enable = true;
    # Weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
  };
}

