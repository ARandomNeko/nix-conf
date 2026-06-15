{pkgs, ...}: {
  # GNOME services for integration
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.evolution-data-server.enable = true;

  # Unlock the Secret Service keyring on login under greetd/tuigreet.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Thumbnail generation
  services.tumbler.enable = true;

  # GNOME packages for file management
  environment.systemPackages = with pkgs; [
    # Keychain management
    seahorse
    libsecret

    nautilus
    file-roller
    gnome-calculator
    gnome-disk-utility
    evince
  ];
}


