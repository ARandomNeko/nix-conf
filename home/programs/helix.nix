{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Text editors
    helix

    # LSP servers
    nil # Nix
    rust-analyzer # Rust
    rustc
    cargo
    clippy
    haskell-language-server # Haskell
    ghc
    cabal-install
    tailwindcss-language-server # Tailwind
    typescript-language-server # JS/TS
    nodePackages.typescript
    nodejs
    pyright # Python
    python314
    uv
    svelte-language-server # Svelte
    angular-language-server
    nodePackages."@angular/cli"
    vscode-langservers-extracted # HTML, CSS, JSON, ESLint
    nodePackages.prettier # Formatter
  ];

  # Helix configuration
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        true-color = true;
        soft-wrap.enable = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "▏";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        file-picker = {
          hidden = false;
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
            "read-only-indicator"
          ];
          right = [
            "diagnostics"
            "version-control"
            "selections"
            "position"
            "position-percentage"
            "file-type"
          ];
          separator = ">";
          mode = {
            normal = "Normal";
            insert = "Insert";
            select = "Visual";
          };
        };
      };
      keys.normal = {
        space.space = "file_picker";
        space.f = "file_picker_in_current_buffer_directory";
        space.b = "buffer_picker";
        space.s = "symbol_picker";
      };

      keys.insert = {
        "C-space" = "completion";
        "C-h" = "move_char_left"; # Ctrl + vim keys to move around in insert mode
        "C-j" = "move_line_down";
        "C-k" = "move_line_up";
        "C-l" = "move_char_right";
        "j" = {
          "k" = "normal_mode";
        };
      };
    };
    languages = {
      language-server = {
        nil = {
          command = "nil";
        };

        rust-analyzer = {
          command = "rust-analyzer";
          config.check.command = "clippy";
        };
        haskell-language-server = {
          command = "haskell-language-server-wrapper";
          args = [ "--lsp" ];
        };
        tailwindcss-ls = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };
        typescript-language-server = {
          command = "typescript-language-server";
          args = [ "--stdio" ];
        };
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
        svelte-ls = {
          command = "svelteserver";
          args = [ "--stdio" ];
        };
        angular-ls = {
          command = "ngserver";
          args = [
            "--stdio"
            "--tsProbeLocations"
            ""
            "--ngProbeLocations"
            ""
          ];
        };
      };
      language = [
        {
          name = "nix";
          language-servers = [ "nil" ];
          formatter.command = "nixfmt";
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          auto-format = true;
        }
        {
          name = "haskell";
          language-servers = [ "haskell-language-server" ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [
            "typescript-language-server"
            "tailwindcss-ls"
          ];
          formatter.command = "prettier";
          formatter.args = [
            "--parser"
            "javascript"
          ];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [
            "angular-ls"
            "typescript-language-server"
            "tailwindcss-ls"
          ];
          formatter.command = "prettier";
          formatter.args = [
            "--parser"
            "typescript"
          ];
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [ "pyright" ];
          auto-format = true;
        }
        {
          name = "svelte";
          language-servers = [
            "svelte-ls"
            "tailwindcss-ls"
          ];
          formatter.command = "prettier";
          formatter.args = [
            "--parser"
            "svelte"
          ];
          auto-format = true;
        }
        {
          name = "html";
          language-servers = [
            "angular-ls"
            "tailwindcss-ls"
          ];
          formatter.command = "prettier";
          formatter.args = [
            "--parser"
            "html"
          ];
          auto-format = true;
        }
        {
          name = "css";
          language-servers = [ "tailwindcss-ls" ];
          formatter.command = "prettier";
          formatter.args = [
            "--parser"
            "css"
          ];
          auto-format = true;
        }
      ];
    };
  };
}
