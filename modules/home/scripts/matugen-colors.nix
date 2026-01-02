{ pkgs, username, ... }:

pkgs.writeShellScriptBin "update-niri-matugen-colors" ''
  # Update Niri config with matugen colors
  # This script extracts colors from matugen-generated CSS and updates Niri config
  
  NIRI_CONFIG="$HOME/.config/niri/config.kdl"
  GTK3_CSS="$HOME/.config/gtk-3.0/dank-colors.css"
  GTK4_CSS="$HOME/.config/gtk-4.0/dank-colors.css"
  COLOR_CACHE="$HOME/.cache/matugen-niri-colors.txt"
  
  # Function to extract hex color from CSS
  extract_color() {
    local file=$1
    local pattern=$2
    local fallback=$3
    
    if [ -f "$file" ]; then
      # Try multiple patterns to find colors
      local color=$(grep -oP "$pattern" "$file" 2>/dev/null | head -1 | tr -d '#' | tr '[:upper:]' '[:lower:]')
      if [ -n "$color" ] && [ ''${#color} -eq 6 ]; then
        echo "$color"
        return 0
      fi
    fi
    
    if [ -n "$fallback" ]; then
      echo "$fallback"
      return 0
    fi
    
    return 1
  }
  
  # Try to extract primary/accent color (for active borders)
  PRIMARY_COLOR=""
  if [ -f "$GTK3_CSS" ]; then
    PRIMARY_COLOR=$(extract_color "$GTK3_CSS" '(?<=--md-sys-color-primary:\s*#)[0-9a-fA-F]{6}' || \
                    extract_color "$GTK3_CSS" '(?<=--color-primary:\s*#)[0-9a-fA-F]{6}' || \
                    extract_color "$GTK3_CSS" '#[0-9a-fA-F]{6}' | head -1)
  fi
  
  if [ -z "$PRIMARY_COLOR" ] && [ -f "$GTK4_CSS" ]; then
    PRIMARY_COLOR=$(extract_color "$GTK4_CSS" '(?<=--md-sys-color-primary:\s*#)[0-9a-fA-F]{6}' || \
                    extract_color "$GTK4_CSS" '(?<=--color-primary:\s*#)[0-9a-fA-F]{6}' || \
                    extract_color "$GTK4_CSS" '#[0-9a-fA-F]{6}' | head -1)
  fi
  
  # Try to extract surface/inactive color (for inactive borders)
  INACTIVE_COLOR=""
  if [ -f "$GTK3_CSS" ]; then
    INACTIVE_COLOR=$(extract_color "$GTK3_CSS" '(?<=--md-sys-color-surface:\s*#)[0-9a-fA-F]{6}' || \
                     extract_color "$GTK3_CSS" '(?<=--color-surface:\s*#)[0-9a-fA-F]{6}' || \
                     extract_color "$GTK3_CSS" '#[0-9a-fA-F]{6}' | tail -1)
  fi
  
  if [ -z "$INACTIVE_COLOR" ] && [ -f "$GTK4_CSS" ]; then
    INACTIVE_COLOR=$(extract_color "$GTK4_CSS" '(?<=--md-sys-color-surface:\s*#)[0-9a-fA-F]{6}' || \
                     extract_color "$GTK4_CSS" '(?<=--color-surface:\s*#)[0-9a-fA-F]{6}' || \
                     extract_color "$GTK4_CSS" '#[0-9a-fA-F]{6}' | tail -1)
  fi
  
  # If we found colors, cache them and update Niri config
  if [ -n "$PRIMARY_COLOR" ] && [ -n "$INACTIVE_COLOR" ]; then
    # Cache colors
    mkdir -p "$(dirname "$COLOR_CACHE")"
    echo "$PRIMARY_COLOR" > "$COLOR_CACHE"
    echo "$INACTIVE_COLOR" >> "$COLOR_CACHE"
    
    # Update Niri config if it exists
    # Since home-manager manages the config as a symlink to the Nix store (read-only),
    # we create a local override file that Niri can use
    if [ -f "$NIRI_CONFIG" ] || [ -L "$NIRI_CONFIG" ]; then
      # Read the original config (follow symlinks)
      ORIGINAL_CONFIG=$(readlink -f "$NIRI_CONFIG" 2>/dev/null || echo "$NIRI_CONFIG")
      
      # Create a local config file with updated colors
      # This will be used to override the home-manager managed config
      LOCAL_CONFIG="$HOME/.config/niri/config-matugen.kdl"
      
      # Copy original config to local file
      cat "$ORIGINAL_CONFIG" > "$LOCAL_CONFIG"
      
      # Update active-color in focus-ring and border sections
      ${pkgs.gnused}/bin/sed -i "s/active-color \"#[0-9a-fA-F]\{6\}\"/active-color \"#$PRIMARY_COLOR\"/g" "$LOCAL_CONFIG" 2>/dev/null || \
        ${pkgs.gnused}/bin/sed -i "s/active-color.*/active-color \"#$PRIMARY_COLOR\"/g" "$LOCAL_CONFIG"
      
      # Update inactive-color in focus-ring and border sections  
      ${pkgs.gnused}/bin/sed -i "s/inactive-color \"#[0-9a-fA-F]\{6\}\"/inactive-color \"#$INACTIVE_COLOR\"/g" "$LOCAL_CONFIG" 2>/dev/null || \
        ${pkgs.gnused}/bin/sed -i "s/inactive-color.*/inactive-color \"#$INACTIVE_COLOR\"/g" "$LOCAL_CONFIG"
      
      # Don't replace the symlink - instead, use Niri's IPC to update colors dynamically
      # Or create a local override that Niri can use
      # Since we can't modify the Nix store file, we'll use sed to update in-place
      # if it's a regular file, or skip if it's a symlink (to avoid breaking home-manager)
      if [ ! -L "$NIRI_CONFIG" ]; then
        # Regular file - can update directly
        cp "$LOCAL_CONFIG" "$NIRI_CONFIG"
      else
        # It's a symlink - don't break it, just log that we can't update
        echo "Note: Niri config is managed by home-manager (symlink)."
        echo "Colors will be updated on next rebuild. For immediate update, run:"
        echo "  home-manager switch --flake .#laptop"
      fi
      
      # Reload Niri config
      ${pkgs.niri}/bin/niri msg action reload-config 2>/dev/null || true
      
      echo "Updated Niri colors: primary=$PRIMARY_COLOR, inactive=$INACTIVE_COLOR"
    fi
  else
    echo "Could not extract matugen colors. Make sure matugen has been run first."
    exit 1
  fi
''

