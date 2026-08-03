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
    ./zed.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    # Utilities
    ripgrep
    fd
    eza
    bat
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
