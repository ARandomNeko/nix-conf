{pkgs, ...}: let
  formatters = {
    alejandra = "${pkgs.alejandra}/bin/alejandra";
    biome = "${pkgs.biome}/bin/biome";
    oxfmt = "${pkgs.oxfmt}/bin/oxfmt";
    shfmt = "${pkgs.shfmt}/bin/shfmt";
  };

  languageServers = {
    astro-ls = "${pkgs.astro-language-server}/bin/astro-ls";
    biome = "${pkgs.biome}/bin/biome";
    marksman = "${pkgs.marksman}/bin/marksman";
    nil = "${pkgs.nil}/bin/nil";
    tailwindcss = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
    volar = "${pkgs.vue-language-server}/bin/vue-language-server";
    # User's additional LSPs
    rust-analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    clangd = "${pkgs.clang-tools}/bin/clangd";
    jdtls = "${pkgs.jdt-language-server}/bin/jdtls";
    pyright = "${pkgs.pyright}/bin/pyright-langserver";
    typescript-language-server = "${pkgs.typescript-language-server}/bin/typescript-language-server";
    vscode-html-language-server = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
    vscode-css-language-server = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
    svelteserver = "${pkgs.svelte-language-server}/bin/svelteserver";
    haskell-language-server = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
  };
in
  (pkgs.formats.toml {}).generate "languages.toml" {
    language = [
      # ===== User's language configs =====
      {
        name = "rust";
        auto-format = true;
        language-servers = ["rust-analyzer"];
      }
      {
        name = "cpp";
        auto-format = true;
        language-servers = ["clangd"];
      }
      {
        name = "c";
        auto-format = true;
        language-servers = ["clangd"];
      }
      {
        name = "java";
        auto-format = true;
        language-servers = ["jdtls"];
      }
      {
        name = "python";
        auto-format = true;
        language-servers = ["pyright"];
      }
      {
        name = "svelte";
        auto-format = true;
        language-servers = ["svelteserver" "tailwindcss"];
      }
      {
        name = "haskell";
        auto-format = true;
        language-servers = ["haskell-language-server"];
      }
      # ===== Kaku's language configs =====
      {
        name = "bash";
        auto-format = true;
        formatter = {
          command = formatters.shfmt;
          args = ["-i" "2"];
        };
      }
      {
        name = "yaml";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.yaml"];
        };
      }
      {
        name = "astro";
        auto-format = true;
        formatter = {
          command = formatters.biome;
          args = ["format" "--stdin-file-path" "a.astro"];
        };
        language-servers = ["astro-ls" "tailwindcss"];
      }
      {
        name = "javascript";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.js"];
        };
        language-servers = ["typescript-language-server" "tailwindcss"];
      }
      {
        name = "json";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.json"];
        };
        language-servers = ["biome"];
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.jsx"];
        };
        language-servers = ["typescript-language-server" "tailwindcss"];
      }
      {
        name = "markdown";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.md"];
        };
        language-servers = ["marksman"];
      }
      {
        name = "typescript";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.ts"];
        };
        language-servers = ["typescript-language-server" "tailwindcss"];
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.tsx"];
        };
        language-servers = ["typescript-language-server" "tailwindcss"];
      }
      {
        name = "css";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.css"];
        };
        language-servers = ["vscode-css-language-server" "tailwindcss"];
      }
      {
        name = "html";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.html"];
        };
        language-servers = ["vscode-html-language-server" "tailwindcss"];
      }
      {
        name = "vue";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.vue"];
        };
        language-servers = ["volar" "tailwindcss"];
      }
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = formatters.alejandra;
          args = ["-q"];
        };
        language-servers = ["nil"];
      }
    ];

    language-server = {
      # ===== User's LSP configs =====
      rust-analyzer = {
        command = languageServers.rust-analyzer;
        config = {
          cargo = {
            buildScripts.enable = true;
            allFeatures = true;
          };
          procMacro.enable = true;
          completion = {
            addCallArgumentSnippets = true;
            addCallParenthesis = true;
          };
          diagnostics.enable = true;
          check.command = "clippy";
        };
      };
      clangd = {
        command = languageServers.clangd;
        args = ["--background-index" "--clang-tidy" "--completion-style=bundled" "--header-insertion=iwyu"];
      };
      jdtls = {
        command = languageServers.jdtls;
        args = ["-data" "/tmp/jdtls-workspace"];
        config.java.completion.enabled = true;
      };
      pyright = {
        command = languageServers.pyright;
        args = ["--stdio"];
        config.python.analysis = {
          typeCheckingMode = "basic";
          autoSearchPaths = true;
          useLibraryCodeForTypes = true;
        };
      };
      typescript-language-server = {
        command = languageServers.typescript-language-server;
        args = ["--stdio"];
        config.typescript.inlayHints = {
          includeInlayParameterNameHints = "all";
          includeInlayParameterNameHintsWhenArgumentMatchesName = false;
          includeInlayFunctionParameterTypeHints = true;
          includeInlayVariableTypeHints = true;
          includeInlayPropertyDeclarationTypeHints = true;
          includeInlayFunctionLikeReturnTypeHints = true;
          includeInlayEnumMemberValueHints = true;
        };
      };
      vscode-html-language-server = {
        command = languageServers.vscode-html-language-server;
        args = ["--stdio"];
        config.html = {
          validate = true;
          completion.attributeDefaultValue = "doublequotes";
        };
      };
      vscode-css-language-server = {
        command = languageServers.vscode-css-language-server;
        args = ["--stdio"];
        config.css = {
          validate = true;
          completion = {
            completePropertyWithSemicolon = true;
            triggerPropertyValueCompletion = true;
          };
        };
      };
      svelteserver = {
        command = languageServers.svelteserver;
        args = ["--stdio"];
        config.svelte.plugin = {
          typescript = {
            enable = true;
            diagnostics.enable = true;
          };
          css = {
            enable = true;
            diagnostics.enable = true;
          };
        };
      };
      haskell-language-server = {
        command = languageServers.haskell-language-server;
        args = ["--lsp"];
      };
      # ===== Kaku's LSP configs =====
      astro-ls = {
        command = languageServers.astro-ls;
        args = ["--stdio"];
      };
      biome = {
        command = languageServers.biome;
        args = ["lsp-proxy"];
      };
      nil = {
        command = languageServers.nil;
        config.nil.formatting.command = [formatters.alejandra "-q"];
      };
      marksman = {
        command = languageServers.marksman;
      };
      tailwindcss = {
        command = languageServers.tailwindcss;
        args = ["--stdio"];
        config.tailwindCSS = {
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
          classAttributes = ["class" "className" "classList" "ngClass"];
        };
      };
      volar = {
        command = languageServers.volar;
        args = ["--stdio"];
      };
    };
  }
