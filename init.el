;;----------------------------------------------------------------------
;; My Personal Emacs Configuration
;;
;; Copyright (C) 2015-2019  Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; Author: Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; I will try to keep it clean and well-documented as much as possible,
;; but sometimes the laziness just get me...
;; I won't guarantee it will work on any computer or any Emacs version,
;; and will not hold any responsibility for it.

;;----------------------------------------------------------------------
;; Package initialisation
;; Start Emacs package manager
(require 'package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
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
(use-package diminish :ensure t)

;;----------------------------------------------------------------------
;; General settings
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
(setq custom-file (make-temp-file ""))

;;----------------------------------------------------------------------
;; Display settings
;; Disable splash screen, toolbar and scrollbar
(menu-bar-mode 0)
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
;; Highlight corresponding parentheses
(show-paren-mode 1)
;; Disable bell
(setq ring-bell-function 'ignore)
;; Set font
(set-frame-font "Monaco-13")
;; Set theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (doom-themes-org-config)
  (load-theme 'doom-tomorrow-night t))
;; Auto-revert buffers
(global-auto-revert-mode 1)

;;----------------------------------------------------------------------
;; User-defined functions
(defun org-agenda-show-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "n")
  (delete-other-windows))

;;----------------------------------------------------------------------
;; User-installed package settings
;; Swiper
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)))
;; Ivy
(use-package counsel
  :ensure t
  :diminish ivy-mode
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c 8" . counsel-unicode-char)
         ("C-c s" . counsel-git-grep)
         ("C-h v" . counsel-describe-variable)
         ("C-h f" . counsel-describe-function)
         ("M-y" . counsel-yank-pop))
  :config
  (ivy-mode 1)
  (setq ivy-count-format "[%d/%d] ")
  (setq ivy-use-selectable-prompt t)
  (setq ivy-height 15)
  (setq ivy-switch-buffer-faces-alist nil) ;; remove '^' at the beginning
  (setq ivy-initial-inputs-alist nil))
;; Org
(use-package org
  :bind ("C-c a" . org-agenda-show-all)
  :config
  (setq org-ellipsis "▿")
  (setq org-pretty-entities t)
  (setq org-agenda-files (list "~/Dropbox/todo.org"))
  (setq org-agenda-span 'week)
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  ;; do not show scheduled/deadline if done
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  ;; do not show repeating task
  (setq org-agenda-repeating-timestamp-show-all nil))
;; Org-bullets
(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-bullet-list '("◉" "◎" "●"))
  (add-hook 'org-mode-hook 'org-bullets-mode))
;; Magit
(use-package magit
  :ensure t
  :defer t
  :bind ("C-c g" . magit-status))
;; Dired
(use-package dired
  :config
  ;; reuse dired buffer
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ;; remember to install coreutils on OSX
  (if (eq system-type 'darwin)
      (setq insert-directory-program "gls" dired-use-ls-dired t)))
  (setq dired-listing-switches "-aBhlF --group-directories-first")
;; Beacon - highlight current line
(use-package beacon
  :ensure t
  :diminish beacon-mode
  :init (beacon-mode 1))
;; Add executable path
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
;; Modeline
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-init)
  :config
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-buffer-file-name-style 'relative-from-project))
;; Accounting
(use-package ledger-mode
  :ensure t
  :mode ("\\.dat\\'")
  :config
  (setq ledger-clear-whole-transactions t)
  (setq ledger-reports
        (quote (("bal" "%(binary) -R -f %(ledger-file) bal")
                ("reg" "%(binary) -R -f %(ledger-file) reg")
                ("budget" "%(binary) -f %(ledger-file) bal ^assets:budget")
                ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
                ("account" "%(binary) -f %(ledger-file) reg %(account)")))))

;;----------------------------------------------------------------------
;; Programming settings
;; Whitespace
(use-package whitespace
  :ensure t
  :diminish whitespace-mode
  :config
  (setq whitespace-style (quote (face trailing tab-mark)))
  ;; delete trailing whitespace when save
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'whitespace-mode))
;; C/C++
(use-package cc-mode
  :config
  (defun c-setup ()
    (c-set-offset 'innamespace [0])
    (c-set-offset 'inextern-lang [0]))
  (add-hook 'c-mode-common-hook 'c-setup)
  (setq c-default-style "ellemtel")
  (setq c-basic-offset 4))

;; Show your agenda and make Emacs go fullscreen
(add-hook 'after-init-hook 'org-agenda-show-all)
(toggle-frame-fullscreen)
