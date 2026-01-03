{pkgs, ...}: {
  home.packages = [pkgs.ghostty];

  # Ghostty configuration
  # Note: Colors will be managed by noctalia's matugen templates
  xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = JetBrainsMono Nerd Font
    font-size = 12

    # Window
    window-padding-x = 10
    window-padding-y = 10
    window-decoration = false

    # Cursor
    cursor-style = bar
    cursor-style-blink = true

    # Shell integration
    shell-integration = fish

    # Scrollback
    scrollback-limit = 10000

    # Clipboard
    clipboard-read = allow
    clipboard-write = allow

    # Keybindings
    keybind = ctrl+shift+c=copy_to_clipboard
    keybind = ctrl+shift+v=paste_from_clipboard
    keybind = ctrl+shift+n=new_window
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+w=close_surface
    keybind = ctrl+plus=increase_font_size:1
    keybind = ctrl+minus=decrease_font_size:1
    keybind = ctrl+zero=reset_font_size
  '';
}


