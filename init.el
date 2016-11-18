;;----------------------------------------------------------------------
;; My Personal Emacs Configuration
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
(package-initialize)
;; Check for use-package and install if needed
(unless (package-installed-p 'use-package)
  (message "`use-package` not found. Installing...")
  (package-refresh-contents)
  (package-install 'use-package))
;; Config use-package
(require 'use-package)
(setq use-package-verbose t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

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
;; Disable backup and autosaving
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
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)
;; Highlight current line and show column number
(column-number-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode 1)
;; Set theme and font
(set-frame-font "Fira Code-13")
;; Start in fullscreen
(set-frame-parameter nil 'fullscreen 'fullboth)

;;----------------------------------------------------------------------
;; User-installed Package Settings
;; Set Emacs theme
(load-theme 'apropospriate-dark t)
;; Modeline config
(use-package spaceline
  :init
  ;; Disable sRGB on Mac OSX to get a sharp look
  (setq ns-use-srgb-colorspace nil)
  (require 'spaceline-config)
  (spaceline-emacs-theme))
(use-package nyan-mode
  :init (nyan-mode 1)
  :config
  (nyan-start-animation))
;; Set up Ivy for completion
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  ;; Add recent files into completion list
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 10)
  (setq ivy-count-format "")
  (setq ivy-initial-inputs-alist nil))
;; Org-mode settings
(use-package org
  :ensure t
  :config
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-files (list "~/Dropbox/Documents/org/general.org"))
  (setq org-ellipsis "▼")
  (global-set-key (kbd "C-c a") 'show-agenda-all))
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode 1))

(defun my-c-setup ()
  (c-set-offset 'innamespace 0))
(add-hook 'c++-mode-hook 'my-c-setup)

(exec-path-from-shell-initialize)

(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
(setq modern-c++-literal-integer nil)

(require 'whitespace)
(setq whitespace-style '(face lines-tail))

(require 'cc-mode)
(setq c-default-style "ellemtel")
(setq c-basic-offset 4)
(add-hook 'prog-mode-hook (lambda() (setq show-trailing-whitespace t)))

(require 'dired )
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))  ; was dired-up-directory
(put 'dired-find-alternate-file 'disabled nil)

(defun dired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (dired-sort))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
