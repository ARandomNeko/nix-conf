{pkgs, nixpkgs-unstable, ...}: {
  programs = {
    firefox.enable = true;
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
        thunar-media-tags-plugin
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
    # Niri compositor
    niri
    # fuzzel removed - DMS provides the launcher
    
    # Core utilities
    amfora
    appimage-run
    brave
    brightnessctl
    cmatrix
    cowsay
    docker-compose
    duf
    eza
    ffmpeg
    file-roller
    gedit
    greetd.tuigreet
    imv
    inxi
    killall
    libnotify
    libvirt
    lm_sensors
    lolcat
    lshw
    lxqt.lxqt-policykit
    
    # Power management and system tools
    powertop
    acpi
    systemd
    
    # Drag and drop support packages
    xdg-utils
    xdg-desktop-portal
    shared-mime-info
    desktop-file-utils
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
    solaar
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
    # Minecraft/PolyMC support
    # Using PrismLauncher with Wayland-patched GLFW for native Wayland support
    (prismlauncher.override {
      glfw3-minecraft = glfw-wayland-minecraft;  # Use Wayland-native GLFW
    })
    
    jupyter
    zlib
    google-cloud-sdk
    postman
    bind
    nyxt
    cloudflare-warp
    unstable.gemini-cli
    pandoc
    nix-direnv
    qmk
    vial
    keymapviz
    unstable.opencode    
    unstable.claude-code
    easyeffects
    unstable.code-cursor-fhs               
    unstable.codex
    unstable.antigravity-fhs        
    # Rust toolchain
    rustc
    cargo
    clippy
    unstable.rust-script
    
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
    libcxx

    # Java
    zulu23
    eclipses.eclipse-java

    # Python toolchain
    python3
    uv
    
    # SQL
    mysql84
    sqlcl
      
    # LSPs 
    rust-analyzer
    clang-tools
    jdt-language-server
    pyright
    nil
    haskell-language-server
    typescript-language-server
    vscode-langservers-extracted
    svelte-language-server
    tailwindcss-language-server

    # Additional LSP dependencies
    nodejs_20
    python3Packages.python-lsp-server
  ];
}

