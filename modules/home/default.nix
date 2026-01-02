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
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./niri.nix
    ./dankmaterialshell.nix
    ./kitty.nix
    ./nvf.nix
    ./helix.nix
    ./qt.nix
    ./scripts
    ./starship.nix
    ./stylix.nix
    ./virtmanager.nix
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
    ./flatpak.nix
  ];
}

