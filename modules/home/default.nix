{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./bash.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./emoji.nix
    ./fastfetch
    ./fish.nix      # Kaku's fish config
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./niri.nix      # Kaku's niri + quickshell
    ./kitty.nix
    ./nvf.nix
    ./helix.nix
    ./qt.nix
    ./scripts
    ./starship.nix

    ./virtmanager.nix
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
    ./flatpak.nix
  ];
}

