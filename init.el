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
  ;; Show agenda and todo list
  (interactive)
  (org-agenda nil "n")
  (delete-other-windows))

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
;; Highlight current line and show column number
;; (global-hl-line-mode 1)
(column-number-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode 1)
;; Set theme and font
(set-frame-font "CMU Typewriter Text-16")
;; Set Emacs theme
(load-theme 'apropospriate-dark t)
;; Set recenter command behaviour
(setq recenter-positions '(top middle bottom))
;; Disable bell
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
         ("M-y" . counsel-yank-pop))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t) ;; Add recent files into completion list
  (setq ivy-height 15)
  (setq ivy-count-format "")
  (setq ivy-initial-inputs-alist nil))
;; which-key
(use-package which-key
  :ensure t
  :config (which-key-mode 1))
;; Org-mode settings
(use-package org
  :ensure t
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
  (setq org-ellipsis "▼")
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  (setq org-highlight-latex-and-related '(latex))
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")))
  (setq org-image-actual-width nil)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.0))
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.0))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.0))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
   )
  :bind ("C-c a" . show-agenda-all))
(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode)
  (setq org-bullets-bullet-list '("◉" "◎" "✸" "✿")))
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
  (setq dired-listing-switches "-aBhl --group-directories-first")
  (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file ".."))))
;; Mode line
(use-package powerline :ensure t)
(use-package spaceline
  :ensure t
  :after powerline
  :init
  (require 'spaceline-config)
  (spaceline-emacs-theme))
(use-package nyan-mode
  :ensure t
  :init (nyan-mode 1)
  :config (nyan-start-animation))
;; Projectile
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :init (projectile-mode 1))
(use-package counsel-projectile
  :ensure t
  :after projectile
  :init (counsel-projectile-on))
;; Yasnippet
(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))
;; Miscellaneous
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
(use-package whitespace
  :ensure t
  :config
  (setq whitespace-line-column 79)
  (setq whitespace-style '(lines trailing))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'whitespace-mode))
;; RSS reader
(use-package elfeed :ensure t)
;; Keybindings
(global-set-key (kbd "C-c C-f") 'toggle-frame-fullscreen)

;;----------------------------------------------------------------------
;; Programming settings
(setq compilation-read-command nil)
(global-set-key (kbd "C-c C-k") 'compile)
(global-prettify-symbols-mode 1)
(global-subword-mode 1)

(use-package cc-mode
  :ensure t
  :config
  (defun c-setup ()
    (c-set-offset 'innamespace [0])
    (c-set-offset 'inextern-lang [0]))
  (add-hook 'c++-mode-hook 'c-setup)
  (add-hook 'cuda-mode-hook 'c-setup)
  (setq c-default-style "ellemtel")
  (setq c-basic-offset 4))

(add-hook 'after-init-hook 'show-agenda-all)
(add-hook 'after-init-hook 'global-company-mode)
(toggle-frame-fullscreen)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-latex-preview-ltxpng-directory "figs/org/")
 '(package-selected-packages
   (quote
    (dired-sidebar
     kaolin-themes
     creamsody-theme
     ledger-mode
     which-key
     haskell-mode
     counsel-projectile
     projectile
     cuda-mode
     spaceline-all-the-icons
     gruvbox-theme
     markdown-mode
     yasnippet
     use-package
     org-bullets
     nyan-mode
     nord-theme
     magit
     ivy
     go-mode
     exec-path-from-shell
     elfeed
     all-the-icons-dired))))
(put 'dired-find-alternate-file 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
