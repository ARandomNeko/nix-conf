{pkgs, ...}: {
  services.flatpak = {
    enable = true;
    packages = [
      "app.zen_browser.zen"
    ];
    
    overrides = {
      "app.zen_browser.zen" = {
        filesystems = [
          "home"
          "xdg-documents"
          "xdg-pictures"
        ];
        socket = [
          "wayland"
          "x11"
        ];
        talk-name = [
           "org.freedesktop.portal.Desktop"
           "org.freedesktop.portal.FileChooser"
           "org.freedesktop.portal.Documents"
        ];
      };
    };
  };

  # Required for xdg-desktop-portal-gtk to work with flatpaks if you aren't using GNOME
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
