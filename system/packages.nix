{ pkgs, ... }:
{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    wget
    curl
    unzip
    zip
    ripgrep
    fd
    eza
    bat
    fzf
    jq
    sshfs

    # System tools
    htop
    btop
    procps
    matugen
    fastfetch
    pciutils
    usbutils
    lshw
    stress
    openssl

    # System packages
    obsidian
    prismlauncher
    steam
    komikku
    kicad

    # Development
    gcc
    gnumake
    gcc-arm-embedded
    qemu
    libclang
    google-cloud-sdk
    lldb

    # AI tools
    gemini-cli-bin
    code-cursor-fhs
    opencode
    antigravity-fhs

    # Fonts
    nerd-fonts.jetbrains-mono
    inter
    roboto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Font configurationyy
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Inter" ];
      serif = [ "Roboto" ];
    };
  };
}
