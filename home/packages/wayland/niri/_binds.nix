{pkgs}: {
  # ===== Media/Volume/Brightness (kaku's quickshell) =====
  "XF86AudioPlay" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "media" "playPause"];
  };
  "XF86AudioStop" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "media" "stop"];
  };
  "XF86AudioNext" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "media" "next"];
  };
  "XF86AudioPrev" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "media" "previous"];
  };
  "XF86AudioMute" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "volume" "muteOutput"];
  };
  "XF86AudioMicMute" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "volume" "muteInput"];
  };
  "XF86AudioRaiseVolume" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "volume" "increase"];
  };
  "XF86AudioLowerVolume" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "volume" "decrease"];
  };
  "XF86MonBrightnessUp" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "brightness" "increase"];
  };
  "XF86MonBrightnessDown" = {
    _props.allow-when-locked = true;
    spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "brightness" "decrease"];
  };

  # ===== Launcher & Utilities (kaku's quickshell) =====
  "Ctrl+Alt+L".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "lockScreen" "lock"];
  "Mod+V".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "launcher" "clipboard"];
  "Mod+E".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "launcher" "emoji"];
  "Mod+U".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "settings" "toggle"];
  "Alt+Space".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "launcher" "toggle"];
  "Mod+D".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "launcher" "toggle"];
  # User's preferred launcher binding
  "Mod+Space".spawn._args = ["qs" "-c" "noctalia" "ipc" "call" "launcher" "toggle"];

  # ===== Terminal (user preference: ghostty) =====
  "Mod+T".spawn._args = ["${pkgs.ghostty}/bin/ghostty"];
  "Mod+Return".spawn._args = ["${pkgs.ghostty}/bin/ghostty"];

  # ===== Screenshots =====
  "Print".screenshot-screen = {};
  "Ctrl+Print".screenshot-screen = {};
  "Alt+Print".screenshot-window = {};
  "Mod+Shift+Alt+S".screenshot-window = {};
  "Mod+Shift+S".screenshot = {};
  "Mod+S".screenshot = {};  # User's preferred binding

  # ===== Window Management =====
  "Mod+Q".close-window = {};
  "Mod+R".switch-preset-column-width = {};  # User's binding
  "Mod+F".maximize-column = {};
  "Mod+Shift+F".toggle-window-floating = {};  # User's binding
  "Mod+C".center-column = {};  # User's binding (center single column)
  "Mod+W".toggle-column-tabbed-display = {};
  "Mod+Tab".switch-focus-between-floating-and-tiling = {};

  # ===== Column Width =====
  "Mod+1".set-column-width = "25%";
  "Mod+2".set-column-width = "50%";
  "Mod+3".set-column-width = "75%";
  "Mod+4".set-column-width = "100%";
  "Mod+Minus".set-column-width = "-10%";
  "Mod+Equal".set-column-width = "+10%";  # User's binding (Equal instead of Plus)
  "Mod+Shift+Minus".set-window-height = "-10%";
  "Mod+Shift+Equal".set-window-height = "+10%";  # User's binding

  # ===== Window Consume/Expel =====
  "Mod+Comma".consume-window-into-column = {};
  "Mod+Period".expel-window-from-column = {};
  "Mod+BracketLeft".consume-or-expel-window-left = {};  # User's binding
  "Mod+BracketRight".consume-or-expel-window-right = {};  # User's binding

  # ===== Navigation (vim-style + arrow keys) =====
  "Mod+H".focus-column-left = {};
  "Mod+J".focus-window-down = {};  # User prefers window, not workspace
  "Mod+K".focus-window-up = {};
  "Mod+L".focus-column-right = {};
  "Mod+Left".focus-column-left = {};
  "Mod+Right".focus-column-right = {};
  "Mod+Down".focus-window-down = {};
  "Mod+Up".focus-window-up = {};

  # ===== Move Windows =====
  "Mod+Ctrl+H".move-column-left = {};
  "Mod+Ctrl+J".move-window-down = {};
  "Mod+Ctrl+K".move-window-up = {};
  "Mod+Ctrl+L".move-column-right = {};
  "Mod+Ctrl+Left".move-column-left = {};
  "Mod+Ctrl+Right".move-column-right = {};
  "Mod+Ctrl+Down".move-window-down = {};
  "Mod+Ctrl+Up".move-window-up = {};
  "Mod+Shift+H".move-column-left = {};
  "Mod+Shift+L".move-column-right = {};

  # ===== Monitor Navigation (user's bindings) =====
  "Mod+Shift+Left".focus-monitor-left = {};
  "Mod+Shift+Down".focus-monitor-down = {};
  "Mod+Shift+Up".focus-monitor-up = {};
  "Mod+Shift+Right".focus-monitor-right = {};

  # ===== Move to Monitor =====
  "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
  "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
  "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
  "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};
  "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = {};
  "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = {};
  "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = {};
  "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = {};

  # ===== Workspace Navigation (user's bindings) =====
  "Mod+Page_Down".focus-workspace-down = {};
  "Mod+Page_Up".focus-workspace-up = {};
  "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
  "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};

  # ===== Workspace Numbers (user's bindings) =====
  "Mod+5".focus-workspace = 1;
  "Mod+6".focus-workspace = 2;
  "Mod+7".focus-workspace = 3;
  "Mod+8".focus-workspace = 4;
  "Mod+9".focus-workspace = 5;
  "Mod+Ctrl+5".move-column-to-workspace = 1;
  "Mod+Ctrl+6".move-column-to-workspace = 2;
  "Mod+Ctrl+7".move-column-to-workspace = 3;
  "Mod+Ctrl+8".move-column-to-workspace = 4;
  "Mod+Ctrl+9".move-column-to-workspace = 5;

  # ===== First/Last Column (user's bindings) =====
  "Mod+Home".focus-column-first = {};
  "Mod+End".focus-column-last = {};
  "Mod+Ctrl+Home".move-column-to-first = {};
  "Mod+Ctrl+End".move-column-to-last = {};

  # ===== System (user's bindings) =====
  "Mod+Shift+Slash".show-hotkey-overlay = {};
  "Mod+Shift+E".quit = {};
  "Mod+Shift+P".power-off-monitors = {};
  "Mod+Shift+Ctrl+T".toggle-debug-tint = {};
}
