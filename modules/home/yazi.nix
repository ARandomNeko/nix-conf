{...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    
    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "mtime";
        sort_reverse = true;
        linemode = "size";
      };
      
      opener = {
        text = [
          {
            run = "hx \"$@\"";
            desc = "Edit with Helix";
            block = true;
          }
        ];
        edit = [
          {
            run = "hx \"$@\"";
            desc = "Edit with Helix";  
            block = true;
          }
        ];
      };
      
      open = {
        rules = [
          { name = "*/"; use = [ "edit" "reveal" ]; }
          { mime = "text/*"; use = [ "edit" "reveal" ]; }
          { mime = "inode/x-empty"; use = [ "edit" "reveal" ]; }
        ];
      };
    };
    
    # Explicitly don't set any theme - let Stylix handle it
    theme = {};
  };
  
  # Set environment variables for this user session
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
} 