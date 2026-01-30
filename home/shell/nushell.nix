{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
    zed-editor
    wl-clipboard
  ];

  programs.nushell = {
    enable = true;

    envFile.text = ''
      # Secrets and API keys
      if ("/run/agenix/openrouter" | path exists) {
        $env.OPENROUTER_API_KEY = (open /run/agenix/openrouter | str trim)
      }
      if ("/run/agenix/github" | path exists) {
        $env.GITHUB_TOKEN = (open /run/agenix/github | str trim)
      }
      if ("/run/agenix/twt" | path exists) {
        $env.TWT_TOKEN = (open /run/agenix/twt | str trim)
      }

      $env.NIXPKGS_ALLOW_UNFREE = "1"
      $env.NIXPKGS_ALLOW_INSECURE = "1"
      $env.EDITOR = "hx"
      $env.VISUAL = "hx"
    '';

    configFile.text = ''
      $env.config = {
        show_banner: false
        edit_mode: vi
        
        cursor_shape: {
          vi_insert: line
          vi_normal: block
        }

        keybindings: [
          {
            name: history_prefix_search_backward
            modifier: none
            keycode: up
            mode: [emacs, vi_insert, vi_normal]
            event: { send: historyhintcomplete }
          }
          {
            name: history_prefix_search_forward
            modifier: none
            keycode: down
            mode: [emacs, vi_insert, vi_normal]
            event: { send: down }
          }
          {
            name: undo
            modifier: control
            keycode: char_z
            mode: [emacs, vi_insert]
            event: { send: undo }
          }
          {
            name: move_to_line_start
            modifier: control
            keycode: char_b
            mode: [emacs, vi_insert]
            event: { send: movetolinestart }
          }
          {
            name: move_to_line_end
            modifier: control
            keycode: char_e
            mode: [emacs, vi_insert]
            event: { send: movetolineend }
          }
        ]

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
        }

        history: {
          max_size: 10000
          sync_on_enter: true
          file_format: "plaintext"
        }
      }

      # System aliases
      alias cleanup = sudo nix-collect-garbage --delete-older-than 1d
      alias listgen = sudo nix-env -p /nix/var/nix/profiles/system --list-generations
      alias nixremove = nix-store --gc
      alias bloat = nix path-info -Sh /run/current-system
      alias cleanram = sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'
      alias trimall = sudo fstrim -va

      # Utilities
      alias c = clear
      alias q = exit
      alias temp = cd /tmp/

      # Build
      alias test-build = sudo nixos-rebuild test --flake .
      alias switch-build = sudo nixos-rebuild switch --flake .

      # Git
      alias add = git add .
      alias commit = git commit
      alias push = git push
      alias pull = git pull
      alias diff = git diff --staged
      alias gcld = git clone --depth 1
      alias gitui = lazygit
      alias g = git
      alias gs = git status
      alias ga = git add
      alias gc = git commit
      alias gp = git push
      alias gl = git log --oneline --graph

      # Eza
      alias l = eza -lF --time-style=long-iso --icons
      alias ll = eza -h --git --icons --color=auto --group-directories-first -s extension
      alias tree = eza --tree --icons --tree

      # Bat
      alias cat = bat --paging=never

      # Weather
      alias moon = curl -s wttr.in/Moon
      alias weather = curl -s wttr.in

      # Services
      alias us = systemctl --user
      alias rs = sudo systemctl
      alias zed = zeditor
      alias koji = meteor

      # Nix shortcuts
      alias nrs = sudo nixos-rebuild switch --flake .
      alias nrt = sudo nixos-rebuild test --flake .
      alias nfu = nix flake update

      # Functions
      def fcd [] {
        let dir = (fd --type d | fzf | str trim)
        if ($dir | is-not-empty) {
          cd $dir
        }
      }

      def installed [] {
        nix-store --query --requisites /run/current-system/ 
          | lines 
          | each { |it| $it | parse -r '.*?-(?P<name>.*)' | get name? | default $it }
          | flatten
          | uniq
          | sort
          | to text
          | fzf
      }

      def fm [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXX")
        yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp | str trim)
        if ($cwd | is-not-empty) and ($cwd != $env.PWD) {
          cd $cwd
        }
        rm -f $tmp
      }

      def gitgrep [pattern: string] {
        git ls-files | rg $pattern
      }
    '';
  };
}

