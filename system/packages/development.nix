{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Editors
    helix

    # Nix
    nil
    nixfmt

    # Rust
    rust-analyzer
    rustc
    cargo
    clippy

    # Haskell
    haskell-language-server
    ghc
    cabal-install

    # Web
    nodejs
    typescript
    typescript-language-server
    tailwindcss-language-server
    svelte-language-server
    angular-language-server
    vscode-langservers-extracted
    prettier

    # Python
    pyright
    python314
    uv
  ];
}
