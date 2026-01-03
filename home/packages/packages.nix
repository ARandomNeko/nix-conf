{
  inputs,
  pkgs,
  ...
}: {
  users.users.ritu.packages = with pkgs; [
    # ===== From Kaku =====
    # messaging
    telegram-desktop
    vesktop

    # misc
    pciutils
    nixos-icons
    ffmpegthumbnailer
    imagemagick
    bun

    fastfetch

    # gnome
    dconf-editor
    file-roller
    gnome-control-center
    gnome-text-editor
    nautilus
    (papers.override {supportNautilus = true;})

    inkscape
    scrcpy

    swww
    openvpn

    # ===== User's Programs =====
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
    gedit
    tuigreet
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
    mgba
    qbittorrent
    wineWowPackages.waylandFull
    winetricks

    # Minecraft/PolyMC support with Wayland-native GLFW
    (prismlauncher.override {
      glfw3-minecraft = glfw3-minecraft;
    })

    jupyter
    zlib
    google-cloud-sdk
    postman
    bind
    nyxt
    cloudflare-warp
    pandoc
    qmk
    vial
    keymapviz
    easyeffects

    # Rust toolchain
    rustc
    cargo
    clippy

    # Haskell toolchain
    stack
    ghc
    haskell.compiler.ghc984
    cabal-install

    # C toolchain
    lldb_20
    clang
    llvm
    libclang
    gcc
    libcxx

    # Java
    zulu
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
    qt6Packages.qt6ct

    # Host-specific packages (desktop)
    audacity
    discord
    nodejs
    obs-studio
  ];
}
