{pkgs, nixpkgs-unstable, ...}: {
  programs = {
    firefox.enable = true; # Firefox is not installed by default
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    virt-manager.enable = true;
    mtr.enable = true;
    adb.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin  # Better media support for drag and drop
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    amfora # Fancy Terminal Browser For Gemini Protocol
    appimage-run # Needed For AppImage Support
    brave # Brave Browser
    brightnessctl # For Screen Brightness Control
    cmatrix # Matrix Movie Effect In Terminal
    cowsay # Great Fun Terminal Program
    docker-compose # Allows Controlling Docker From A Single File
    duf # Utility For Viewing Disk Usage In Terminal
    eza # Beautiful ls Replacement
    ffmpeg # Terminal Video / Audio Editing
    file-roller # Archive Manager
    gedit # Simple Graphical Text Editor
    # gimp # Great Photo Editor
    greetd.tuigreet # The Login Manager (Sometimes Referred to As Display Manager)
    hyprpicker
    imv
    inxi
    killall
    libnotify
    libvirt
    lm_sensors
    lolcat
    lshw
    lxqt.lxqt-policykit
    
    # Drag and drop support packages
    xdg-utils          # Essential for desktop integration
    shared-mime-info   # MIME type handling
    desktop-file-utils # Desktop file utilities
    meson
    mpv
    ncdu
    ninja
    nixfmt-rfc-style
    pavucontrol
    pciutils
    picard
    pkg-config
    playerctl
    ripgrep
    socat
    unrar
    unzip
    usbutils
    v4l-utils
    virt-viewer
    wget
    ytmdl
    pipes
    direnv

    # Custom list of core packages
    obsidian
    vscode
    nix-direnv
    cider
    libreoffice-qt
    lutris
    olive-editor
    mgba
    qbittorrent
    wineWowPackages.waylandFull
    winetricks
    jupyter
    zlib
    google-cloud-sdk
    postman
    bind
    nyxt
    cloudflare-warp
    gemini-cli
    pandoc
    nix-direnv
    qmk
    vial
    keymapviz
    unstable.opencode    
    unstable.claude-code
                   
    # Rust toolchain
    rustc         # Rust compiler
    cargo         # Rust package manager 
    clippy        # Rust linting tool

    # Haskell toolchain      
    stack
    ghc
    haskell.compiler.ghc982
    cabal-install

    # C toolchain
    lldb_20 
    clang
    llvm
    libclang
    gcc

    # Java
    zulu23
    eclipses.eclipse-java

    # Python toolchain
    python3

    # SQL
    mysql84
    sqlcl
      
    # LSPs 
    rust-analyzer  # Rust LSP 
    clang-tools    # Includes clangd for C/C++
    jdt-language-server  # Java LSP 
    pyright        # Python LSP 
    nil            # Nix LSP 
    haskell-language-server # Haskell LSP 
    typescript-language-server  # TypeScript LSP
    vscode-langservers-extracted  # HTML, CSS, JSON, ESLint LSPs
    svelte-language-server  # Svelte/SvelteKit LSP
    tailwindcss-language-server  # Tailwind CSS LSP

    # Additional LSP dependencies
    nodejs_20      # Needed for pyright and other LSP servers
    python3Packages.python-lsp-server  # Alternative Python LSP
  ];
}
