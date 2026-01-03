{
  nix.settings = {
    # Parallel downloads
    max-jobs = "auto";
    http-connections = 50;
    
    substituters = [
      # high priority since it's almost always used
      "https://cache.nixos.org?priority=10"

      # "https://chaotic-nyx.cachix.org/"
      "https://fufexan.cachix.org"
      "https://ritu.cachix.org"
      "https://niri.cachix.org"
      # "https://nix-community.cachix.org"
      "https://quickshell.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "ritu.cachix.org-1:2K7KEjzbd3U+qMQRte/DGqttosw8EGgGVvu8vKu8D6A="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "quickshell.cachix.org-1:EAjGF7X2a6jCr99abEoN9TGaJ2wPUyevq8VNv7cYvL4="
    ];
  };
}
