{ pkgs, config, lib, username, inputs, ... }:
let
  # DMS wrapper script to launch quickshell with the right config
  dmsScript = pkgs.writeShellScriptBin "dms" ''
    #!/usr/bin/env bash
    # DankMaterialShell wrapper for quickshell
    DMS_DIR="$HOME/.config/DankMaterialShell"
    
    # Forward all arguments to quickshell with the DMS path
    exec ${inputs.quickshell.packages.${pkgs.system}.default}/bin/quickshell --path "$DMS_DIR/quickshell" "$@"
  '';
  
  screenshotScript = pkgs.writeShellScriptBin "screenshot-area" ''
    # Take a screenshot of a selected area and save to Pictures/Screenshots
    SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$SCREENSHOT_DIR"
    FILENAME="$SCREENSHOT_DIR/Screenshot-$(date +%Y-%m-%d-%H%M%S).png"
    
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$FILENAME" && \
    ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$FILENAME" --icon="$FILENAME"
  '';
in {
  # Install QuickShell and dependencies
  home.packages = (with pkgs; [
    # DankMaterialShell dependencies
    go
    qt6.full
    kdePackages.qtwayland
    material-symbols
    
    # Matugen for theming
    matugen
    
    # Screenshot tools
    grim
    slurp
    
    # Optional integrations for calendar
    vdirsyncer
    khal
  ]) ++ [
    # QuickShell from flake input
    inputs.quickshell.packages.${pkgs.system}.default
    # DMS wrapper scripts
    dmsScript
    screenshotScript
  ];

  # Clone/install DankMaterialShell - runs during home-manager activation
  home.activation.installDankMaterialShell = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DMS_DIR="$HOME/.config/DankMaterialShell"
    
    # Remove symlink if it exists (from previous config)
    if [ -L "$DMS_DIR" ]; then
      rm "$DMS_DIR"
    fi
    
    # Clone or update the repository
    if [ ! -d "$DMS_DIR" ]; then
      echo "Cloning DankMaterialShell..."
      ${pkgs.git}/bin/git clone https://github.com/AvengeMedia/DankMaterialShell.git "$DMS_DIR"
    else
      echo "Updating DankMaterialShell..."
      cd "$DMS_DIR" && ${pkgs.git}/bin/git pull || true
    fi
  '';

  # Initialize default settings.json - DMS will manage it after first run
  home.activation.initDMSSettings = lib.hm.dag.entryAfter ["installDankMaterialShell"] ''
    SETTINGS_FILE="$HOME/.config/DankMaterialShell/settings.json"
    
    # Only create if it doesn't exist (let DMS manage it after that)
    if [ ! -f "$SETTINGS_FILE" ] || [ -L "$SETTINGS_FILE" ]; then
      # Remove symlink if it exists
      [ -L "$SETTINGS_FILE" ] && rm "$SETTINGS_FILE"
      
      # Create initial settings file
      cat > "$SETTINGS_FILE" << 'EOFSETTINGS'
{
  "matugen": {
    "enabled": true
  },
  "theme": {
    "applyGtkThemes": true,
    "applyQtThemes": true
  },
  "panels": {
    "topBar": {
      "enabled": true
    },
    "sideBar": {
      "enabled": true
    }
  }
}
EOFSETTINGS
      echo "Created initial DMS settings.json"
    fi
  '';
}

