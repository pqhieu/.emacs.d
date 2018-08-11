;;----------------------------------------------------------------------
;; My Personal Emacs Configuration
;;
;; Copyright (C) 2015-2017  Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; Author: Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; I will try to keep it clean and well-documented as much as possible,
;; but sometimes the laziness just get me...
;; I won't guarantee it will work on any computer or any Emacs version,
;; and will not hold any responsibility for it.

;;----------------------------------------------------------------------
;; Package Initialisation
;; Start Emacs package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize nil)
;; Check for use-package and install if needed
(unless (package-installed-p 'use-package)
  (message "`use-package` not found. Installing...")
  (package-refresh-contents)
  (package-install 'use-package))
;; Config use-package
(require 'use-package)
(setq use-package-verbose t)
(require 'cl)

;;----------------------------------------------------------------------
;; User-defined Functions
(defun show-agenda-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "n")
  (delete-other-windows))
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;;----------------------------------------------------------------------
;; General Settings
;; Set personal information
(setq user-full-name "Quang-Hieu Pham")
(setq user-mail-address "pqhieu1192@gmail.com")
;; Disable backup and auto-saving
(setq-default make-backup-files nil)
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)
;; Set tab width and its behaviour
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-always-indent 'complete)
(setq-default fill-column 80)
;; Insert new line at EOF when save
(setq-default require-final-newline t)
(fset 'yes-or-no-p 'y-or-n-p)

;;----------------------------------------------------------------------
;; Display Settings
;; Disable splash screen, toolbar and scrollbar
(tool-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(display-time-mode 1)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)
;; Show column number
(column-number-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode 1)
;; Set theme and font
(set-frame-font "SF Mono-20")
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-tomorrow-night t)
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t))
;; Set recenter command behaviour
(setq recenter-positions '(top middle bottom))
;; Enable bell
(setq visible-bell t)
;; Reduce cursor movement lag
(setq auto-window-vscroll nil)

;;----------------------------------------------------------------------
;; User-installed Package Settings
(use-package diminish :ensure t)
;; Ivy
(use-package counsel :ensure t)
(use-package swiper
  :ensure t
  :diminish ivy-mode
  :bind (("C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-M-i" . complete-symbol)
         ("C-." . counsel-imenu)
         ("C-c 8" . counsel-unicode-char)
         ("C-c v" . ivy-push-view)
         ("C-c V" . ivy-pop-view)
         ("C-c s" . counsel-git-grep)
         ("C-h v" . counsel-describe-variable)
         ("C-h f" . counsel-describe-function)
         ("M-y" . counsel-yank-pop))
  :config
  (ivy-mode 1)
  (setq ivy-count-format "[%d/%d] ")
  (setq ivy-use-virtual-buffers t) ;; Add recent files into completion list
  (setq ivy-use-selectable-prompt t)
  (setq ivy-height 15)
  (setq ivy-dynamic-exhibit-delay-ms 200)
  (setq ivy-switch-buffer-faces-alist nil)
  (setq ivy-initial-inputs-alist nil))
(use-package ivy-xref
  :ensure t
  :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))
;; which-key
(use-package which-key
  :diminish which-key-mode
  :ensure t
  :config (which-key-mode 1))
;; Org-mode settings
(use-package org
  :ensure t
  :bind ("C-c a" . show-agenda-all)
  :config
  (setq org-agenda-span 'week)
  (setq org-src-fontify-natively t)
  (setq org-agenda-tags-column -120)
  (setq org-tags-column -120)
  (setq org-log-into-drawer t)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-files (list "~/Dropbox"))
  (setq org-latex-preview-ltxpng-directory "figs/org/")
  (setq org-ellipsis "▿")
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  (setq org-highlight-latex-and-related '(latex))
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")))
  (setq org-image-actual-width nil)
  (setq org-habit-graph-column 80)
  (setq org-agenda-repeating-timestamp-show-all nil)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.0)))
(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode)
  (setq org-bullets-bullet-list '("◉" "◎" "●" "✸")))
;; Magit
(use-package magit
  :ensure t
  :init
  (if (eq system-type 'darwin)
      (setq-default with-editor-emacsclient-executable
                    "/usr/local/bin/emacsclient"))
  :bind ("C-c g" . magit-status))
;; Dired
(use-package dired
  :config
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (if (eq system-type 'gnu/linux)
      (setq dired-listing-switches "-aBhl --group-directories-first"))
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file ".."))))
;; Modeline
(use-package powerline
  :ensure t
  :config
  (setq ns-use-srgb-colorspace nil))
(use-package doom-modeline
  :ensure t
  :defer t
  :hook (after-init . doom-modeline-init))
;; Beacon
(use-package beacon
  :ensure t
  :diminish beacon-mode
  :init (beacon-mode 1))
;; Miscellaneous
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
(use-package whitespace
  :ensure t
  :diminish whitespace-mode
  :config
  (setq whitespace-line-column 79)
  (setq whitespace-style '(lines trailing))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'whitespace-mode))
;; Autocompletion server
(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-highlight-symbol-at-point nil))
(use-package company-lsp
  :ensure t
  :config
  (push 'company-lsp company-backends))
(use-package cquery
  :ensure t
  :config
  (add-hook 'c-mode-hook (lambda() (lsp-cquery-enable)))
  (add-hook 'c++-mode-hook (lambda() (lsp-cquery-enable)))
  (setq cquery-cache-dir ".cache/")
  (setq cquery-sem-highlight-method 'font-lock))
;; Keybindings
(global-set-key (kbd "C-c w") 'kill-other-buffers)
(global-set-key (kbd "C-c f") 'toggle-frame-fullscreen)
(global-set-key (kbd "C-c k") 'compile)

;;----------------------------------------------------------------------
;; Programming settings
(setq compilation-read-command nil)
;; Subword
(use-package subword
  :ensure t
  :diminish subword-mode
  :config
  (global-subword-mode 1))
(global-auto-revert-mode 1)
;; C/C++ mode
(use-package cc-mode
  :ensure t
  :config
  (defun c-setup ()
    (c-set-offset 'innamespace [0])
    (c-set-offset 'inextern-lang [0]))
  (add-hook 'c++-mode-hook 'c-setup)
  (add-hook 'c-mode-hook 'c-setup)
  (add-hook 'cuda-mode-hook 'c-setup)
  (setq c-default-style "ellemtel")
  (setq c-basic-offset 4))
;; Company
(use-package company
  :ensure t
  :config
  (setq company-transformers nil)
  (setq company-lsp-async t)
  (setq company-lsp-cache-candidates nil)
  (setq company-idle-delay 0.1)
  (global-company-mode))
;; Show your agenda and make Emacs go fullscreen
(add-hook 'after-init-hook 'show-agenda-all)
(toggle-frame-fullscreen)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-modules
   (quote
    (org-bbdb
     org-bibtex
     org-docview
     org-gnus
     org-habit
     org-info
     org-irc
     org-mhe
     org-rmail
     org-w3m)))
 '(package-selected-packages
   (quote
    (doom-modeline
     ivy-xref
     which-key
     use-package
     org-bullets
     markdown-mode
     magit
     glsl-mode
     exec-path-from-shell
     doom-themes
     diminish
     cuda-mode
     cquery
     company-lsp
     beacon))))
