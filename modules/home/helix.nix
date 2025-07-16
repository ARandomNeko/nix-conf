{
  inputs,
  config,
  lib,
  ...
}: {
programs.helix = {
  enable = true;
  settings = {
    # Only basic editor settings, no theme overrides
    theme = lib.mkForce "flexoki_dark";
    editor = {
      cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      auto-completion = true;
      completion-trigger-len = 1;
      completion-timeout = 50; 
      line-number = "relative";
      lsp = {
        display-messages = true;
        display-inlay-hints = true;
      };
      statusline = {
      left = ["mode" "spinner" "file-name" "file-modification-indicator" "read-only-indicator"];
      right = ["diagnostics" "version-control" "selections" "position" "position-percentage" "file-type"];
      separator = ">";
      mode = {
        normal = "Normal";
        insert = "Insert";
        select = "Visual"; 
      };
     };
    end-of-line-diagnostics = "hint";
    inline-diagnostics = {
      cursor-line = "warning";
    };
    };
    
    keys.normal = {
      "space" = {
        "l" = {
          "a" = "code_action";
          "r" = "rename_symbol";
          "h" = "hover";
          "d" = "goto_definition";
          "D" = "goto_declaration";
          "t" = "goto_type_definition";
          "i" = "goto_implementation";
          "s" = "symbol_picker";
          "S" = "workspace_symbol_picker";
        };
      };
    };
    
    keys.insert = {
      "C-space" = "completion";
      "C-h" = "move_char_left";    #Ctrl + vim keys to move around in insert mode 
      "C-j" = "move_line_down";
      "C-k" = "move_line_up";
      "C-l" = "move_char_right";
      "j" = {"k" = "normal_mode";};
    };
  };
  languages.language = [
    {
      name = "nix";
      auto-format = true;
      language-servers = [ "nil" ];
    }
    {
      name = "rust";
      auto-format = true;
      language-servers = [ "rust-analyzer" ];
    }
    {
      name = "cpp";
      auto-format = true;
      language-servers = [ "clangd" ];
    }
    {
      name = "c";
      auto-format = true;
      language-servers = [ "clangd" ];
    }
    {
      name = "java";
      auto-format = true;
      language-servers = [ "jdtls" ];
    }
    {
      name = "python";
      auto-format = true;
      language-servers = [ "pyright" ];
    }
  ];
  
  languages.language-server = {
    rust-analyzer = {
      command = "rust-analyzer";
      config = {
        cargo = {
          buildScripts = {
            enable = true;
          };
          allFeatures = true;
        };
        procMacro = {
          enable = true;
        };
        completion = {
          addCallArgumentSnippets = true;
          addCallParenthesis = true;
        };
        diagnostics = {
          enable = true;
        };
        check = {
          command = "clippy";
        };
      };
    };
    
    clangd = {
      command = "clangd";
      args = [ "--background-index" "--clang-tidy" "--completion-style=bundled" "--header-insertion=iwyu" ];
    };
    
    jdtls = {
      command = "jdtls";
      args = [ "-data" "/tmp/jdtls-workspace" ];
      config = {
        java = {
          completion = {
            enabled = true;
          };
        };
      };
    };
    
    pyright = {
      command = "pyright-langserver";
      args = [ "--stdio" ];
      config = {
        python = {
          analysis = {
            typeCheckingMode = "basic";
            autoSearchPaths = true;
            useLibraryCodeForTypes = true;
          };
        };
      };
    };
  };
  
  # Explicitly no themes defined - let Stylix handle everything
};
}
