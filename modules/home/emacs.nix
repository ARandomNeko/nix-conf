
{
  pkgs,
  ...
}: {
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      # Core packages
      epkgs.use-package
      # For note-taking and knowledge management
      epkgs.org-roam
      epkgs.org-roam-ui
      epkgs.simple-httpd
      epkgs.websocket
      # For project management and IDE-like features
      epkgs.projectile
      epkgs.treemacs
      epkgs.lsp-mode
      epkgs.lsp-ui
      epkgs.lsp-treemacs
      # Math/Org helpers
      epkgs.org-fragtog
      epkgs.cdlatex
      # Completion & minibuffer UX
      epkgs.corfu
      epkgs.cape
      epkgs.orderless
      epkgs.vertico
      epkgs.marginalia
      epkgs.consult
      epkgs.consult-lsp
      # Dev helpers
      epkgs.magit
      epkgs.editorconfig
      epkgs.direnv
      epkgs.yasnippet
      epkgs.yasnippet-snippets
      # Languages
      epkgs.rustic
      epkgs.nix-mode
      epkgs.typescript-mode
      epkgs.web-mode
      epkgs.json-mode
      epkgs.yaml-mode
      # For which-key integration
      epkgs.which-key
      # For LaTeX support
      epkgs.auctex
    ];
    # Try extraConfig instead of extraInit
    extraConfig = ''
      ;; -*- lexical-binding: t -*-
      
      ;; Initialize package system
      (require 'package)
      (setq package-enable-at-startup nil)
      
      ;; Enable use-package
      (eval-when-compile
        (require 'use-package))
      (setq use-package-always-ensure nil) ; Home Manager handles installation
      
      ;; Enable which-key for better key discovery
      (use-package which-key
        :config
        (which-key-mode))
      
      ;; Basic Org setup
      (use-package org
        :custom
        ;; Keep Org directory in sync with Org-roam directory (set below)
        (org-directory (expand-file-name "~/org-roam-notes"))
        (org-startup-with-latex-preview t)
        (org-startup-with-inline-images t)
        (org-preview-latex-default-process 'dvisvgm)
        :config
        ;; Make agenda scan the whole notes dir
        (setq org-agenda-files (list org-directory))
        ;; Slightly larger LaTeX previews
        (with-eval-after-load 'org
          (plist-put org-format-latex-options :scale 1.4)))

      ;; Auto-toggle LaTeX previews near point (Obsidian-like experience)
      (use-package org-fragtog
        :hook (org-mode . org-fragtog-mode))

      ;; Quick LaTeX editing shortcuts in Org/LaTeX
      (use-package cdlatex
        :hook ((org-mode . turn-on-org-cdlatex)
               (LaTeX-mode . turn-on-cdlatex)))

      (use-package org-roam
        :custom
        (org-roam-directory (file-truename "~/org-roam-notes"))
        ;; Use filetags and properties as tag sources to mimic frontmatter tags
        (org-roam-tag-sources '(prop file))
        :bind (("C-c n l" . org-roam-buffer-toggle)
               ("C-c n f" . org-roam-node-find)
               ("C-c n i" . org-roam-node-insert)
               ("C-c n d" . org-roam-dailies-find-today))
        :config
        (org-roam-db-autosync-mode)

        ;; Capture templates
        (setq org-roam-capture-templates
              '(("n" "default" plain "%?"
                 :if-new (file+head "''${slug}.org"
                                    "#+title: ''${title}\n#+filetags: :inbox:\n")
                 :unnarrowed t)))

        (require 'org-roam-dailies)
        (setq org-roam-dailies-directory "daily/"
              org-roam-dailies-capture-templates
              '(("d" "default" entry
                 "* %<%H:%M> %?"
                 :if-new (file+head "%<%Y-%m-%d>.org"
                                    "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n* Journal\n\n* Tasks\n")))))

      ;; If Emacs is launched with default-directory equal to your notes dir,
      ;; open today's daily note automatically.
      (defun my-notes-open-daily-on-startup ()
        (when (string= (expand-file-name default-directory)
                       (expand-file-name org-directory))
          (ignore-errors (org-roam-dailies-find-today))))
      (add-hook 'emacs-startup-hook #'my-notes-open-daily-on-startup)

      ;; Optional backlink graph in browser: M-x org-roam-ui-mode
      (use-package org-roam-ui
        :after org-roam
        :custom
        (org-roam-ui-sync-theme t)
        (org-roam-ui-follow t)
        (org-roam-ui-update-on-save t)
        (org-roam-ui-open-on-start nil))
      
      (use-package projectile
        :init
        (projectile-mode +1)
        :bind (:map projectile-mode-map
                    ("s-p" . projectile-command-map)
                    ("C-c p" . projectile-command-map)))
      
      (use-package treemacs
        :defer t
        :config
        (treemacs-follow-mode t)
        (treemacs-project-follow-mode t))

      ;; Minibuffer & completion stack
      (use-package vertico
        :init (vertico-mode))
      (use-package marginalia
        :init (marginalia-mode))
      (use-package orderless
        :init
        (setq completion-styles '(orderless basic)
              completion-category-defaults nil
              completion-category-overrides '((file (styles basic partial-completion)))))
      (use-package consult :defer t)

      ;; In-buffer completion UI (works with LSP's capf)
      (use-package corfu
        :init
        (setq corfu-auto t
              corfu-auto-prefix 2
              corfu-preselect-first t
              corfu-quit-no-match t)
        (global-corfu-mode))
      (use-package cape
        :init
        (add-to-list 'completion-at-point-functions #'cape-dabbrev)
        (add-to-list 'completion-at-point-functions #'cape-file))
      
      (use-package lsp-mode
        :commands (lsp lsp-deferred)
        :init
        (setq lsp-keymap-prefix "C-c l"
              lsp-completion-provider :none) ;; use Corfu via capf
        :hook ((prog-mode . lsp-deferred)
               (lsp-mode . lsp-enable-which-key-integration)))
      
      (use-package lsp-ui
        :commands lsp-ui-mode
        :hook (lsp-mode . lsp-ui-mode))

      (use-package lsp-treemacs :after (lsp-mode treemacs))

      ;; Format and organize imports on save when LSP is active
      (defun my-lsp-format-on-save ()
        (when (bound-and-true-p lsp-mode)
          (ignore-errors (lsp-format-buffer))
          (ignore-errors (lsp-organize-imports))))
      (add-hook 'before-save-hook #'my-lsp-format-on-save)

      ;; Snippets
      (use-package yasnippet
        :init (yas-global-mode 1))
      (use-package yasnippet-snippets :after yasnippet)

      ;; Dev helpers
      (use-package magit :defer t)
      (use-package editorconfig :init (editorconfig-mode 1))
      (use-package direnv :init (direnv-mode))

      ;; Languages: major modes + hooks
      (use-package rustic
        :mode "\\.rs\\'"
        :init (setq rustic-lsp-client 'lsp)
        :hook (rustic-mode . lsp-deferred))
      (use-package nix-mode
        :mode "\\.nix\\'"
        :hook (nix-mode . lsp-deferred))
      (use-package typescript-mode
        :mode "\\.ts\\'"
        :hook (typescript-mode . lsp-deferred))
      (use-package web-mode
        :mode ("\\.tsx\\'" "\\.jsx\\'" "\\.html\\'")
        :hook (web-mode . lsp-deferred))
      (use-package json-mode
        :mode "\\.json\\'"
        :hook (json-mode . lsp-deferred))
      (use-package yaml-mode
        :mode "\\.ya?ml\\'")
      
      ;; LaTeX configuration
      (use-package tex
        :defer t
        :config
        (defun my-latex-mode-hook ()
          (setq TeX-electric-math (cons "$" "$"))
          (when (fboundp 'tex-insert-display-math)
            (define-key LaTeX-mode-map (kbd "$") 'tex-insert-display-math)))
        (add-hook 'LaTeX-mode-hook 'my-latex-mode-hook))
      
      ;; UI Configuration
      (setq-default frame-title-format "%b - Emacs")
      (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
      (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
      (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
      (setq inhibit-startup-message t)
    '';
  };
}
