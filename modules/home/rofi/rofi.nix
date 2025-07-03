{
  pkgs,
  config,
  ...
}: {
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modi = "drun,filebrowser,run";
        show-icons = true;
        icon-theme = "Papirus";
        font = "JetBrainsMono Nerd Font Mono 12";
        drun-display-format = "{icon} {name}";
        display-drun = " Apps";
        display-run = " Run";
        display-filebrowser = " Files";
        sidebar-mode = true;
      };
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg = mkLiteral "#${config.lib.stylix.colors.base00}";
          bg-alt = mkLiteral "#${config.lib.stylix.colors.base01}";
          bg-selected = mkLiteral "#${config.lib.stylix.colors.base02}";
          fg = mkLiteral "#${config.lib.stylix.colors.base05}";
          fg-alt = mkLiteral "#${config.lib.stylix.colors.base04}";
          accent = mkLiteral "#${config.lib.stylix.colors.base0D}";  # Blue like Waybar workspaces
          accent-alt = mkLiteral "#${config.lib.stylix.colors.base08}"; # Red like Waybar active
          border-color = mkLiteral "#${config.lib.stylix.colors.base0C}"; # Cyan like Waybar start menu
          urgent = mkLiteral "#${config.lib.stylix.colors.base0E}";
        };
        
        "window" = {
          transparency = "real";
          location = mkLiteral "west";
          anchor = mkLiteral "west";
          fullscreen = false;
          width = mkLiteral "400px";
          height = mkLiteral "100%";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";
          background-color = mkLiteral "@bg";
          border = mkLiteral "0px 2px 0px 0px";
          border-color = mkLiteral "@border-color";
          border-radius = mkLiteral "0px 12px 12px 0px";
        };
        
        "mainbox" = {
          enabled = true;
          spacing = mkLiteral "0px";
          margin = mkLiteral "0px";
          padding = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          children = map mkLiteral [
            "inputbar"
            "mode-switcher" 
            "listview"
            "message"
          ];
        };
        
        "inputbar" = {
          enabled = true;
          spacing = mkLiteral "10px";
          margin = mkLiteral "0px 0px 16px 0px";
          padding = mkLiteral "12px 16px";
          border = mkLiteral "0px 0px 2px 0px";
          border-radius = mkLiteral "8px";
          border-color = mkLiteral "@border-color";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@fg";
          children = map mkLiteral [
            "textbox-prompt-colon"
            "entry"
          ];
        };
        
        "textbox-prompt-colon" = {
          enabled = true;
          expand = false;
          str = " ";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "@border-color"; # Cyan like start menu
        };
        
        "entry" = {
          enabled = true;
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "text";
          placeholder = "Search apps...";
          placeholder-color = mkLiteral "@fg-alt";
        };
        
        "mode-switcher" = {
          enabled = true;
          spacing = mkLiteral "8px";
          margin = mkLiteral "0px 0px 16px 0px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
        };
        
        "button" = {
          padding = mkLiteral "8px 16px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@fg";
          cursor = mkLiteral "pointer";
        };
        
        "button selected" = {
          background-color = mkLiteral "@accent"; # Blue like Waybar workspace buttons
          text-color = mkLiteral "@bg";
        };
        
        "listview" = {
          enabled = true;
          columns = 1;
          lines = 12;
          cycle = true;
          dynamic = true;
          scrollbar = true;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = true;
          spacing = mkLiteral "4px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
          cursor = "default";
        };
        
        "scrollbar" = {
          width = mkLiteral "4px";
          border = mkLiteral "0px";
          border-radius = mkLiteral "2px";
          background-color = mkLiteral "@bg-alt";
          handle-color = mkLiteral "@accent";
        };
        
        "element" = {
          enabled = true;
          spacing = mkLiteral "10px";
          margin = mkLiteral "0px";
          padding = mkLiteral "8px 12px";
          border = mkLiteral "0px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
          cursor = mkLiteral "pointer";
        };
        
        "element normal.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
        };
        
        "element selected.normal" = {
          background-color = mkLiteral "@accent-alt"; # Red like active Waybar items
          text-color = mkLiteral "@bg";
        };
        
        "element alternate.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
        };
        
        "element-icon" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "24px";
          cursor = mkLiteral "inherit";
        };
        
        "element-text" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        
        "message" = {
          enabled = true;
          margin = mkLiteral "0px";
          padding = mkLiteral "8px 12px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@fg-alt";
        };
        
        "textbox" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-alt";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
          highlight = mkLiteral "@accent";
        };
        
        "error-message" = {
          margin = mkLiteral "20px";
          padding = mkLiteral "12px";
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "@accent-alt";
          text-color = mkLiteral "@bg";
        };
      };
    };
  };
}
