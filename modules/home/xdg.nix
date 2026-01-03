{ ... }:

{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    
    # Portal configuration for Flatpak apps (managed by Nix)
    configFile."xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default=gtk
      org.freedesktop.impl.portal.FileChooser=gtk
      org.freedesktop.impl.portal.AppChooser=gtk
      org.freedesktop.impl.portal.Screenshot=wlr
      org.freedesktop.impl.portal.ScreenCast=wlr
    '';
  };
}
