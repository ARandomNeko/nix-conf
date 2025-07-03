{...}: {
  home.file.".config/rofi/config-long.rasi".text = ''
    @import "~/.config/rofi/config.rasi"
    
    window {
      width: 600px;
      height: 400px;
      location: center;
      anchor: center;
      border-radius: 12px;
    }
    
    mainbox {
      orientation: vertical;
      children: [ "inputbar", "mode-switcher", "listview" ];
      padding: 20px;
      spacing: 16px;
    }
    
    inputbar {
      margin: 0px 0px 16px 0px;
      padding: 12px 16px;
      background-color: @bg-alt;
      children: [ "textbox-prompt-colon", "entry" ];
    }
    
    mode-switcher {
      margin: 0px 0px 16px 0px;
      spacing: 8px;
    }
    
    listview {
      lines: 8;
      columns: 1;
      scrollbar: false;
    }
    
    element {
      spacing: 10px;
      padding: 8px 12px;
      border-radius: 6px;
    }
  '';
}
