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
(column-number-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode 1)
;; Set theme and font
(set-frame-font "Fira Code-14")
;; Set Emacs theme
(load-theme 'gruvbox-dark-hard t)
;; Set recenter command behaviour
(setq recenter-positions '(top middle bottom))

;;----------------------------------------------------------------------
;; User-installed Package Settings
;; Ivy
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
  :init
  (setq org-agenda-span 'day)
  (setq org-agenda-tags-column -100)
  (setq org-tags-column -79)
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-files (list "~/Dropbox/gtd.org"))
  (setq org-ellipsis "▼")
  (setq org-pretty-entities t)
  (setq org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")))
  :bind ("C-c a" . show-agenda-all))
(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))
;; Magit
(use-package magit
  :ensure t
  :init
  (if (eq system-type 'darwin)
      (setq-default with-editor-emacsclient-executable
                    "/usr/local/bin/emacsclient"))
  :bind ("C-c g" . magit-status))
;; Dired
(use-package all-the-icons
  :after cl tramp
  :ensure t)
(use-package all-the-icons-dired
  :ensure t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
  (add-hook 'dired-mode-hook 'auto-revert-mode)
  (if (eq system-type 'gnu/linux)
    (setq dired-listing-switches "-aBhl  --group-directories-first")))
;; Mode line
(use-package powerline :ensure t)
(use-package spaceline :ensure t :after powerline)
(use-package nyan-mode
  :ensure t
  :init (nyan-mode 1)
  :config (nyan-start-animation))
(use-package spaceline-all-the-icons
  :after spaceline nyan-mode
  :config
  (spaceline-all-the-icons-theme)
  (setq inhibit-compacting-font-caches t)
  (setq spaceline-all-the-icons-hide-long-buffer-path t)
  (setq spaceline-all-the-icons-separator-type (quote arrow))
  (spaceline-toggle-all-the-icons-fullscreen-on)
  (spaceline-toggle-all-the-icons-buffer-position-on))
;; Projectile
(use-package projectile
  :ensure t
  :init (projectile-mode 1))
(use-package counsel-projectile
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
  (setq whitespace-style '(trailing))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'whitespace-mode))
;; RSS reader
(use-package elfeed
  :ensure t
  :init
  (setq elfeed-feeds '(("http://pragmaticemacs.com/feed/" blog emacs)
                       ("http://irreal.org/blog/?feed=rss2" blog emacs)
                       ("https://jeremykun.com/feed/" blog math)))
  (setq-default elfeed-search-filter "+unread")
  :bind ("C-c w" . elfeed))
;; Calender & Diary
(use-package calendar
  :ensure t
  :config
  (setq diary-file "~/Dropbox/diary")
  (setq calendar-mark-diary-entries-flag t)
  (add-hook 'diary-display-hook 'diary-fancy-display-mode)
  :bind ("C-c c" . calendar))
;; Keybindings
(global-set-key (kbd "C-c f") 'toggle-frame-fullscreen)


;;----------------------------------------------------------------------
;; Programming settings
(global-prettify-symbols-mode 1)
(global-subword-mode 1)
(setq-default electric-indent-inhibit t)

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

(toggle-frame-fullscreen)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (creamsody-theme
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#504945" :foreground "#d5c4a1" :box (:line-width 1 :color "grey75" :style released-button))))))
