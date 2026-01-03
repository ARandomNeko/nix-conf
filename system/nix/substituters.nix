{
  nix.settings = {
    # Parallel downloads
    max-jobs = "auto";
    http-connections = 25;
  };
}
