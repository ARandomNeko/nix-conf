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
    {
      name = "typescript";
      auto-format = true;
      language-servers = [ "typescript-language-server" "tailwindcss-language-server" ];
    }
    {
      name = "javascript";
      auto-format = true;
      language-servers = [ "typescript-language-server" "tailwindcss-language-server" ];
    }
    {
      name = "html";
      auto-format = true;
      language-servers = [ "vscode-html-language-server" "tailwindcss-language-server" ];
    }
    {
      name = "css";
      auto-format = true;
      language-servers = [ "vscode-css-language-server" "tailwindcss-language-server" ];
    }
    {
      name = "svelte";
      auto-format = true;
      language-servers = [ "svelteserver" "tailwindcss-language-server" ];
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
    
    typescript-language-server = {
      command = "typescript-language-server";
      args = [ "--stdio" ];
      config = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = false;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayEnumMemberValueHints = true;
          };
        };
      };
    };
    
    vscode-html-language-server = {
      command = "vscode-html-language-server";
      args = [ "--stdio" ];
      config = {
        html = {
          validate = true;
          completion = {
            attributeDefaultValue = "doublequotes";
          };
        };
      };
    };
    
    vscode-css-language-server = {
      command = "vscode-css-language-server";
      args = [ "--stdio" ];
      config = {
        css = {
          validate = true;
          completion = {
            completePropertyWithSemicolon = true;
            triggerPropertyValueCompletion = true;
          };
        };
      };
    };
    
    svelteserver = {
      command = "svelteserver";
      args = [ "--stdio" ];
      config = {
        svelte = {
          plugin = {
            typescript = {
              enable = true;
              diagnostics = {
                enable = true;
              };
            };
            css = {
              enable = true;
              diagnostics = {
                enable = true;
              };
            };
          };
        };
      };
    };
    
    tailwindcss-language-server = {
      command = "tailwindcss-language-server";
      args = [ "--stdio" ];
      config = {
        tailwindCSS = {
          validate = true;
          lint = {
            enable = true;
            invalidApply = "error";
            invalidConfigPath = "error";
            invalidScreen = "error";
            invalidTailwindDirective = "error";
            invalidVariant = "error";
            recommendedVariantOrder = "warning";
          };
          classAttributes = [ "class" "className" "classList" "ngClass" ];
        };
      };
    };
  };
  
};
}
