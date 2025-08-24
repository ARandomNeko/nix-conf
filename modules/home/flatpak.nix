{ pkgs, lib, ... }:

{
  # Install Zen Browser
  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];

  # Set permissions for Zen Browser
  home.activation.flatpakPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.flatpak}/bin/flatpak override --user --filesystem=home app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --filesystem=xdg-documents app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --filesystem=xdg-pictures app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --talk-name=org.freedesktop.portal.Desktop app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --talk-name=org.freedesktop.portal.FileChooser app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --talk-name=org.freedesktop.portal.Documents app.zen_browser.zen
  '';
}
