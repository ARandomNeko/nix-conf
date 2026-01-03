{pkgs, ...}: {
  # GNOME services for integration
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.evolution-data-server.enable = true;

  # Thumbnail generation
  services.tumbler.enable = true;

  # GNOME packages for file management
  environment.systemPackages = with pkgs; [
    nautilus
    file-roller
    gnome-calculator
    gnome-disk-utility
    evince
  ];
}

