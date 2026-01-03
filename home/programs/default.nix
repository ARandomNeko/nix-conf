{pkgs, ...}: {
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    # Text editors
    helix

    # File management
    yazi

    # Media
    mpv
    imv
    zathura

    # System monitoring
    btop

    # Utilities
    ripgrep
    fd
    eza
    bat
    fzf
    jq
    trashy

    # Archive
    unzip
    zip
    p7zip

    # Networking
    wget
    curl
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
        rulers = [80 120];
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
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
  };

  # btop configuration
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      vim_keys = true;
    };
  };

  # mpv configuration
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
      volume = 70;
    };
  };

  # Zathura PDF viewer
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
    };
  };

  # imv image viewer
  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "000000";
        fullscreen = false;
      };
    };
  };
}


