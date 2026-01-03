{
  pkgs,
  lib,
  ...
}: let
  configFile = "ghostty/config";
in {
  users.users.ritu.packages = with pkgs; [
    ghostty
  ];

  xdg.configFile."${configFile}".text = ''
    ${lib.generators.toKeyValue {
        mkKeyValue = k: v: "${k}=${v}";
        listsAsDuplicateKeys = true;
      } {
        # User's font preference
        font-family = "Space Mono";
        font-size = "14";
        font-thicken = "false";
        font-feature = "ss04,ss01";
        bold-is-bright = "false";

        # Cursor settings (merged)
        cursor-style = "bar";
        cursor-style-blink = "false";
        adjust-cursor-thickness = "1";

        # Window settings (merged)
        window-padding-x = "4";
        window-padding-y = "6";
        window-padding-balance = "true";
        window-decoration = "none";
        title = "GhosTTY";

        # Behavior
        scrollback-limit = "10000";
        copy-on-select = "false";
        confirm-close-surface = "false";
        mouse-hide-while-typing = "true";
        gtk-single-instance = "true";
        quit-after-last-window-closed = "false";
        window-inherit-working-directory = "true";

        # Notifications
        desktop-notifications = "true";
        app-notifications = "no-clipboard-copy";

        # Box/underline adjustments
        adjust-box-thickness = "1";
        adjust-underline-thickness = "100%";
        adjust-underline-position = "110%";

        resize-overlay = "never";
        bell-features = "audio";
      }}
    ${lib.concatMapStringsSep "\n" (binding: "keybind=${binding}") [
      "ctrl+shift+i=inspector:toggle"
      "ctrl+shift+p=toggle_command_palette"
      "ctrl+shift+c=copy_to_clipboard"
      "ctrl+shift+v=paste_from_clipboard"
      "ctrl+shift+minus=decrease_font_size:1"
      "ctrl+shift+plus=increase_font_size:1"
      "ctrl+shift+0=reset_font_size"
      "ctrl+shift+r=reload_config"
      "alt+v=new_split:right"
      "alt+s=new_split:down"
      "alt+h=goto_split:left"
      "alt+l=goto_split:right"
      "alt+j=goto_split:bottom"
      "alt+k=goto_split:top"
      "alt+n=new_tab"
      "ctrl++=increase_font_size:1"
      "ctrl+-=decrease_font_size:1"
    ]}
  '';
}
