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
      # Color theme - uses terminal colors (inherits from matugen/ghostty)
      let base_theme = {
        separator: dark_gray
        leading_trailing_space_bg: { attr: n }
        header: green_bold
        empty: blue
        bool: light_cyan
        int: light_green
        filesize: cyan
        duration: light_cyan
        date: purple
        range: yellow
        float: light_green
        string: green
        nothing: light_gray
        binary: purple
        cell_path: cyan
        row_index: green_bold
        record: white
        list: cyan
        block: blue
        hints: dark_gray
        search_result: { bg: yellow, fg: black }
        shape_and: purple_bold
        shape_binary: purple_bold
        shape_block: blue_bold
        shape_bool: light_cyan
        shape_closure: green_bold
        shape_custom: green
        shape_datetime: cyan_bold
        shape_directory: cyan
        shape_external: light_blue
        shape_externalarg: green
        shape_external_resolved: light_purple_bold
        shape_filepath: cyan
        shape_flag: blue_bold
        shape_float: purple_bold
        shape_garbage: { fg: white, bg: red, attr: b }
        shape_glob_interpolation: cyan_bold
        shape_globpattern: cyan_bold
        shape_int: purple_bold
        shape_internalcall: cyan_bold
        shape_keyword: cyan_bold
        shape_list: cyan_bold
        shape_literal: blue
        shape_match_pattern: green
        shape_matching_brackets: { attr: u }
        shape_nothing: light_cyan
        shape_operator: yellow
        shape_or: purple_bold
        shape_pipe: purple_bold
        shape_range: yellow_bold
        shape_record: cyan_bold
        shape_redirection: purple_bold
        shape_signature: green_bold
        shape_string: green
        shape_string_interpolation: cyan_bold
        shape_table: blue_bold
        shape_variable: purple
        shape_vardecl: purple
        shape_raw_string: light_purple
      }

      $env.config = {
        show_banner: false
        edit_mode: vi
        color_config: $base_theme

        cursor_shape: {
          vi_insert: line
          vi_normal: block
        }

        # Styled table rendering
        table: {
          mode: rounded
          index_mode: always
          show_empty: true
          padding: { left: 1, right: 1 }
          trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
          }
          header_on_separator: false
        }

        # Footer for long outputs
        footer_mode: 25

        # Highlight matched text in search
        highlight_resolved_externals: true

        # Styled error/warning display
        error_style: fancy

        keybindings: [
          # Accept inline suggestion with right arrow (fish-like)
          {
            name: complete_hint
            modifier: none
            keycode: right
            mode: [emacs, vi_insert]
            event: { send: historyhintcomplete }
          }
          # Accept one word of hint with ctrl+right
          {
            name: complete_hint_word
            modifier: control
            keycode: right
            mode: [emacs, vi_insert]
            event: { send: historyhintwordcomplete }
          }
          {
            name: history_prefix_search_backward
            modifier: none
            keycode: up
            mode: [emacs, vi_insert, vi_normal]
            event: { send: up }
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
            event: { edit: undo }
          }
          {
            name: move_to_line_start
            modifier: control
            keycode: char_b
            mode: [emacs, vi_insert]
            event: { edit: movetolinestart }
          }
          {
            name: move_to_line_end
            modifier: control
            keycode: char_e
            mode: [emacs, vi_insert]
            event: { edit: movetolineend }
          }
        ]

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: fuzzy
          external: {
            enable: true
            completer: null
          }
        }

        history: {
          max_size: 100000
          sync_on_enter: true
          file_format: sqlite
          isolation: false
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
