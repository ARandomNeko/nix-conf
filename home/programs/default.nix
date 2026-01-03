{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./helix.nix
    ./yazi.nix
    ./btop.nix
    ./mpv.nix
    ./zathura.nix
    ./imv.nix
  ];

  home.packages = with pkgs; [
    # Utilities
    ripgrep
    fd
    eza
    bat
    fzf
    jq
    trashy

    # Archive
    unzip
    zip
    p7zip

    # Networking
    wget
    curl
  ];
}