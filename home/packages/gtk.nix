{pkgs, lib, ...}: {
  users.users.ritu.packages = with pkgs; [
    bibata-cursors
    (whitesur-icon-theme.override {
      boldPanelIcons = true;
      alternativeIcons = true;
    })
    gsettings-desktop-schemas
  ];

  environment.sessionVariables = {
    XDG_ICON_DIR = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    XCURSOR_THEME = lib.mkDefault "Bibata-Original-Ice";
    XCURSOR_SIZE = lib.mkDefault "24";  # Match stylix
  };
}
