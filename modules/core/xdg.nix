{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.AppChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      };
      niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.AppChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      };
    };
  };
  
  # Ensure portal services start properly with D-Bus
  systemd.user.services.xdg-desktop-portal = {
    wantedBy = [ "graphical-session.target" ];
    after = [ "dbus.socket" ];
  };
  
  systemd.user.services.xdg-desktop-portal-gtk = {
    wantedBy = [ "graphical-session.target" ];
    after = [ "dbus.socket" "xdg-desktop-portal.service" ];
  };
  
  systemd.user.services.xdg-desktop-portal-gnome = {
    wantedBy = [ "graphical-session.target" ];
    after = [ "dbus.socket" "xdg-desktop-portal.service" ];
  };
}

