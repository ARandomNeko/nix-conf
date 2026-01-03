{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grc
    skim
    lazygit
    zed-editor
    wl-clipboard
  ];

  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      # Secrets and API keys
      if test -f /run/agenix/openrouter
        set -gx OPENROUTER_API_KEY (cat /run/agenix/openrouter)
      end
      if test -f /run/agenix/github
        set -gx GITHUB_TOKEN (cat /run/agenix/github)
      end
      if test -f /run/agenix/twt
        set -gx TWT_TOKEN (cat /run/agenix/twt)
      end

      set -gx NIXPKGS_ALLOW_UNFREE 1
      set -gx NIXPKGS_ALLOW_INSECURE 1
      set -gx EDITOR hx
      set -gx VISUAL hx

      set -g fish_greeting

      # Vi keybindings
      fish_vi_key_bindings

      # Custom binding
      for mode in insert default
        bind -M $mode ctrl-backspace backward-kill-word
        bind -M $mode ctrl-z undo
        bind -M $mode ctrl-b beginning-of-line
        bind -M $mode ctrl-e end-of-line
      end

      # History search with prefix (like nushell)
      bind -M insert up history-prefix-search-backward
      bind -M insert down history-prefix-search-forward

      # Same for normal mode
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

      # Search highlight
      set -g fish_color_search_match --background=normal

      # Plugin settings
      set -Ux fifc_editor hx
      set -U fifc_keybinding \cx
      set -g __done_min_cmd_duration 10000
      set -g sudope_sequence \cs
    '';

    shellAbbrs = {
      z = "zoxide query";
      zi = "zoxide query -i";
    };

    shellAliases = {
      # System
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixremove = "nix-store --gc";
      bloat = "nix path-info -Sh /run/current-system";
      cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
      trimall = "sudo fstrim -va";
      
      # Utilities
      c = "clear";
      q = "exit";
      temp = "cd /tmp/";
      
      # Build
      test-build = "sudo nixos-rebuild test --flake .";
      switch-build = "sudo nixos-rebuild switch --flake .";
      
      # Git
      add = "git add .";
      commit = "git commit";
      push = "git push";
      pull = "git pull";
      diff = "git diff --staged";
      gcld = "git clone --depth 1";
      gitui = "lazygit";
      
      # Eza
      l = "eza -lF --time-style=long-iso --icons";
      ll = "eza -h --git --icons --color=auto --group-directories-first -s extension";
      tree = "eza --tree --icons --tree";
      
      # Bat
      cat = "bat --paging=never";
      
      # Weather
      moon = "curl -s wttr.in/Moon";
      weather = "curl -s wttr.in";
      
      # Misc
      store-path = "readlink (which $argv)";
      us = "systemctl --user";
      rs = "sudo systemctl";
      zed = "zeditor";
      koji = "meteor";

      # Old config compatibility
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      nfu = "nix flake update";
    };

    functions = {
      fcd = ''
        set -l dir (fd --type d | skim | string trim)
        if test -n "$dir"
          cd $dir
        end
      '';
      installed = ''
        nix-store --query --requisites /run/current-system/ | string replace -r '.*?-(.*)' '$1' | sort | uniq | skim
      '';
      installedall = ''
        nix-store --query --requisites /run/current-system/ | skim | wl-copy
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

    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fifc";
        src = pkgs.fishPlugins.fifc.src;
      }
      {
        name = "sudope";
        src = pkgs.fishPlugins.plugin-sudope.src;
      }
    ];
  };

  # Force overwrite existing fish config
  xdg.configFile."fish/config.fish".force = true;
  
  # Remove old atuin config that references missing command
  xdg.configFile."fish/conf.d/atuin.fish" = {
    force = true;
    text = "# atuin disabled - remove this file if you want to use atuin";
  };
}
