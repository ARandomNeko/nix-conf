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
    svelte-language-server # Svelte
    vscode-langservers-extracted # HTML, CSS, JSON, ESLint
    nodePackages.prettier # Formatter
  ];

  # Helix configuration
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "noctalia";
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
      };
      keys.normal = {
        space.space = "file_picker";
        space.f = "file_picker_in_current_buffer_directory";
        space.b = "buffer_picker";
        space.s = "symbol_picker";
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
          language-servers = [ "tailwindcss-ls" ];
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
