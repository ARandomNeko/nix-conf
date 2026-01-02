{ ... }:

{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    
    # Electron flags for Wayland support (Niri)
    configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
      --enable-wayland-ime
    '';
    
    configFile."electron25-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
      --enable-wayland-ime
    '';
    
    configFile."electron28-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
      --enable-wayland-ime
    '';
    
    configFile."code-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
      --enable-wayland-ime
    '';
  };
}
