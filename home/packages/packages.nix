{
  inputs,
  pkgs,
  ...
}:
{
  users.users.ritu.packages = with pkgs; [
    # ===== Kaku defaults =====
    telegram-desktop
    vesktop
    pciutils
    nixos-icons
    ffmpegthumbnailer
    imagemagick
    bun
    fastfetch
    dconf-editor
    file-roller
    gnome-control-center
    gnome-text-editor
    nautilus
    (papers.override { supportNautilus = true; })
    inkscape
    scrcpy
    swww
    openvpn

    # ===== User's programs =====
    # Core utilities
    amfora
    appimage-run
    brave
    google-chrome
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
    powertop
    acpi
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
    (prismlauncher.override { glfw3-minecraft = glfw3-minecraft; })
    jupyter
    zlib
    google-cloud-sdk
    postman
    bind
    nyxt
    cloudflare-warp
    pandoc
    # qmk vial keymapviz - disabled due to dfu-programmer C23 build issue
    easyeffects

    # Toolchains
    rustc
    cargo
    clippy
    rust-analyzer
    stack
    ghc
    cabal-install
    haskell-language-server
    lldb_20
    clang
    llvm
    libclang
    gcc
    libcxx
    clang-tools
    zulu
    python3
    uv
    pyright
    mysql84
    sqlcl
    nil
    typescript-language-server
    vscode-langservers-extracted
    svelte-language-server
    tailwindcss-language-server
    jdt-language-server
    nodejs_20

    # Desktop apps
    audacity
    discord
    obs-studio
    qt6Packages.qt6ct

    # XWayland
    xwayland-satellite

    # Vibecoding
    antigravity-fhs
    gemini-cli-bin
    code-cursor-fhs
  ];

  # Stylix theming
  stylix = {
    enable = true;
    image = ../../wallpapers/adrien-olichon-RCAhiGJsUUE-unsplash.jpg;
    base16Scheme = {
      base00 = "100F0F";
      base01 = "1C1B1A";
      base02 = "343331";
      base03 = "575653";
      base04 = "878580";
      base05 = "CECDC3";
      base06 = "CECDC3";
      base07 = "CECDC3";
      base08 = "D14D41";
      base09 = "DA702C";
      base0A = "D0A215";
      base0B = "879A39";
      base0C = "3AA99F";
      base0D = "4385BE";
      base0E = "8B7EC8";
      base0F = "CE5D97";
      name = "flexoki";
    };
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
