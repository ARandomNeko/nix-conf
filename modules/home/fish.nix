{pkgs, lib, ...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      set -gx NIXPKGS_ALLOW_UNFREE 1
      set -gx NIXPKGS_ALLOW_INSECURE 1
      set -gx EDITOR hx
      set -gx VISUAL hx

      set -g fish_greeting

      # Vi keybindings
      fish_vi_key_bindings

      # Custom bindings
      for mode in insert default
        bind -M $mode ctrl-backspace backward-kill-word
        bind -M $mode ctrl-z undo
        bind -M $mode ctrl-b beginning-of-line
        bind -M $mode ctrl-e end-of-line
      end

      # History search with prefix
      bind -M insert up history-prefix-search-backward
      bind -M insert down history-prefix-search-forward
      bind -M default up history-prefix-search-backward
      bind -M default down history-prefix-search-forward

      # Cursor shapes per mode
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block

      # Syntax colors
      set -g fish_color_autosuggestion brblack
      set -g fish_color_command blue
      set -g fish_color_error red
      set -g fish_color_param normal
      set -g fish_color_search_match --background=normal

      # Plugin settings
      set -Ux fifc_editor hx
      set -U fifc_keybinding \cx
      set -g __done_min_cmd_duration 10000
      set -g sudope_sequence \cs
    '';

    shellAliases = {
      # Nix
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixremove = "nix-store --gc";
      bloat = "nix path-info -Sh /run/current-system";
      cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
      trimall = "sudo fstrim -va";

      # General
      c = "clear";
      q = "exit";
      temp = "cd /tmp/";

      # Git
      add = "git add .";
      commit = "git commit";
      push = "git push";
      pull = "git pull";
      diff = "git diff --staged";
      gcld = "git clone --depth 1";
      gitui = "lazygit";

      # File listing (eza)
      l = "eza -lF --time-style=long-iso --icons";
      ll = "eza -h --git --icons --color=auto --group-directories-first -s extension";
      tree = "eza --tree --icons --tree";

      # Utils
      cat = "${pkgs.bat}/bin/bat --paging=never";
      moon = "${pkgs.curlMinimal}/bin/curl -s wttr.in/Moon";
      weather = "${pkgs.curlMinimal}/bin/curl -s wttr.in";

      # Systemctl
      us = "systemctl --user";
      rs = "sudo systemctl";
    };

    functions = {
      fcd = ''
        set -l dir (fd --type d | sk | string trim)
        if test -n "$dir"
          cd $dir
        end
      '';

      installed = ''
        nix-store --query --requisites /run/current-system/ | string replace -r '.*?-(.*)' '$1' | sort | uniq | sk
      '';

      installedall = ''
        nix-store --query --requisites /run/current-system/ | sk | wl-copy
      '';

      fm = ''
        set -l tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file $tmp
        set -l cwd (cat $tmp)
        if test -n "$cwd" -a "$cwd" != "$PWD"
          cd $cwd
        end
        rm -f $tmp
      '';

      gitgrep = ''
        git ls-files | rg $argv
      '';
    };

    shellAbbrs = {
      z = "zoxide query";
      zi = "zoxide query -i";
    };
  };

  home.packages = with pkgs; [
    fish
    grc
    fd
    skim
    eza
    zoxide
  ];
}

