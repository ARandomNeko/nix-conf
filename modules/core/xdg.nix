{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    wlr.enable = true;  # Enable wlr portal for Niri
    xdgOpenUsePortal = true;  # Force apps to use portals
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.AppChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      };
    };
  };
}
