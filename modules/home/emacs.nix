
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
      # For project management and IDE-like features
      epkgs.projectile
      epkgs.treemacs
      epkgs.lsp-mode
      epkgs.lsp-ui
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
      
      (use-package org-roam
        :custom
        (org-roam-directory (file-truename "~/org-roam-notes"))
        :bind (("C-c n l" . org-roam-buffer-toggle)
               ("C-c n f" . org-roam-node-find)
               ("C-c n i" . org-roam-node-insert)
               ("C-c n d" . org-roam-dailies-find-today))
        :config
        (org-roam-db-autosync-mode)
        (require 'org-roam-dailies)
        (setq org-roam-dailies-capture-templates
              '(("d" "default" entry
                 "* %?"
                 :target (file+head "%<%Y-%m-%d>.org"
                                    "#+title: %<%Y-%m-%d>\n")))))
      
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
      
      (use-package lsp-mode
        :commands (lsp lsp-deferred)
        :init
        (setq lsp-keymap-prefix "C-c l")
        :hook ((prog-mode . lsp-deferred)
               (lsp-mode . lsp-enable-which-key-integration)))
      
      (use-package lsp-ui
        :commands lsp-ui-mode)
      
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
