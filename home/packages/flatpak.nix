{pkgs, lib, ...}: {
  # Install Zen Browser via Flatpak
  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];

  # Global Flatpak overrides for Wayland support
  # This fixes Electron apps and other GUI apps in Flatpak sandboxes
  home.activation.flatpakPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Global overrides for all Flatpak apps (Wayland + D-Bus access)
    ${pkgs.flatpak}/bin/flatpak override --user --socket=wayland
    ${pkgs.flatpak}/bin/flatpak override --user --socket=fallback-x11
    ${pkgs.flatpak}/bin/flatpak override --user --socket=session-bus
    ${pkgs.flatpak}/bin/flatpak override --user --socket=system-bus
    ${pkgs.flatpak}/bin/flatpak override --user --device=dri
    ${pkgs.flatpak}/bin/flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto
    ${pkgs.flatpak}/bin/flatpak override --user --env=NIXOS_OZONE_WL=1

    # Zen Browser specific permissions
    ${pkgs.flatpak}/bin/flatpak override --user --filesystem=home app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --filesystem=xdg-documents app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --filesystem=xdg-pictures app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --talk-name=org.freedesktop.portal.Desktop app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --talk-name=org.freedesktop.portal.FileChooser app.zen_browser.zen
    ${pkgs.flatpak}/bin/flatpak override --user --talk-name=org.freedesktop.portal.Documents app.zen_browser.zen
  '';
}

