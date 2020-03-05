;;----------------------------------------------------------------------
;; My personal Emacs configuration
;;
;; Copyright (C) 2015-2020
;;
;; Author: Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; I will try to keep it clean and well-documented as much as possible,
;; but sometimes the laziness just get me...
;; I won't guarantee it will work on any computer or any Emacs version,
;; and will not hold any responsibility for it.

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
(use-package diminish :ensure t)

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
(setq-default fill-column 79)
;; Insert new line at EOF when save
(setq-default require-final-newline t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq custom-file (make-temp-file ""))
(setq display-time-day-and-date t)

;; Disable splash screen, toolbar and scrollbar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(display-time-mode 1)
(setq-default cursor-type 'bar)
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
(set-frame-font "SF Mono:pixelsize=13:weight=semi-bold:slant=normal:width=normal:spacing=100:scalable=true")
;; Set theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-org-config)
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
  (set-face-attribute 'font-lock-doc-face nil :slant 'italic)
  (set-face-attribute 'font-lock-preprocessor-face nil :slant 'italic))
;; Auto-revert buffers
(global-auto-revert-mode 1)
(global-linum-mode 1)

(defun org-agenda-show-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "n")
  (delete-other-windows))
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)))
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
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-use-virtual-buffers t) ;; Add recent files into completion list
  (setq ivy-use-selectable-prompt t)
  (setq ivy-display-style 'fancy)
  (setq ivy-height 15)
  (setq ivy-switch-buffer-faces-alist nil) ;; Remove '^' at the beginning
  (setq ivy-initial-inputs-alist nil)
  (setq counsel-find-file-ignore-regexp "\\(?:^Icon?\\)"))
(use-package ivy-bibtex
  :ensure t
  :bind (("C-c b" . ivy-bibtex))
  :config
  (setq bibtex-completion-bibliography '("~/Dropbox/main.bib"))
  (setq bibtex-completion-notes-symbol "✎")
  (setq bibtex-completion-cite-prompt-for-optional-arguments nil)
  (setq bibtex-completion-format-citation-functions
        '((org-mode . bibtex-completion-format-citation-org-title-link-to-PDF)
          (latex-mode . bibtex-completion-format-citation-cite)
          (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
          (default . bibtex-completion-format-citation-default)))
  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-citation))

(use-package org
  :config
  (setq org-ellipsis "⤵")
  (setq org-pretty-entities t)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")))
  (setq org-todo-keyword-faces '(("NEXT" . "#8abeb7")))
  (setq org-tags-column -77)
  ;; global effort estimate values
  (setq org-global-properties
        '(("Effort_ALL" .
           "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))
  ;; Set default column view headings: Task Priority Effort Clock_Summary
  (setq org-columns-default-format "%50ITEM %2PRIORITY %10Effort(EFFORT){:} %10CLOCKSUM")
  (setq org-clock-into-drawer t)
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate)
  (setq org-clock-out-when-done t)
  (set-face-background 'org-level-1 (face-background 'default))
  (set-face-background 'org-block-begin-line (face-background 'default))
  (set-face-background 'org-block-end-line (face-background 'default))
  (set-face-background 'org-ellipsis (face-background 'default)))
(use-package org-agenda
  :bind ("C-c a" . org-agenda-show-all)
  :config
  (setq org-agenda-files (list "~/Dropbox/todo.org"))
  (setq org-agenda-span 'week)
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-tags-column -77)
  ;; do not show scheduled/deadline if done
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  ;; do not show repeating task
  (setq org-agenda-repeating-timestamp-show-all nil)
  (setq org-agenda-sorting-strategy
        '((agenda todo-state-up priority-down))))
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode)
  :init
  (setq org-bullets-bullet-list '("⓵" "⓶" "⓷" "⓸" "⓹" "⓺" "⓻" "⓼")))

(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status))
(use-package dired
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t)
  ;; reuse dired buffer
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ;; remember to install coreutils on OSX
  (if (eq system-type 'darwin)
      (setq insert-directory-program "gls" dired-use-ls-dired t))
  (setq dired-listing-switches "-aFhlv --group-directories-first"))
(use-package beacon
  :ensure t
  :diminish beacon-mode
  :init (beacon-mode 1))
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-init)
  :config
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-buffer-file-name-style 'auto))
(use-package ledger-mode
  :ensure t
  :mode ("\\.dat\\'")
  :config
  (setq ledger-clear-whole-transactions t))

(use-package whitespace
  :ensure t
  :diminish whitespace-mode
  :config
  (setq whitespace-style (quote (face trailing tab-mark)))
  ;; delete trailing whitespace when save
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'whitespace-mode))
(use-package cc-mode
  :config
  (defun c-setup ()
    (c-set-offset 'innamespace [0])
    (c-set-offset 'inextern-lang [0]))
  (add-hook 'c-mode-common-hook 'c-setup)
  (setq c-default-style "linux")
  (setq c-basic-offset 4)
  (add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))
  (add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode)))
(use-package clang-format :ensure t)
(use-package glsl-mode :ensure t)
(use-package yaml-mode :ensure t)
(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-fontify-code-blocks-natively t))
(use-package subword
  :ensure t
  :diminish subword-mode
  :config
  (global-subword-mode 1))
(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :config
  (setq highlight-indent-guides-method 'character)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  ;; disable prompt when adding local variables
  (setq enable-local-variables :all)
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0.5)
  (setq company-backends (delete 'company-semantic company-backends))
  (define-key c-mode-map  (kbd "C-<return>") 'company-complete)
  (define-key c++-mode-map  (kbd "C-<return>") 'company-complete)
  (add-hook 'after-init-hook 'global-company-mode))

(use-package latex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  ;; more sensible wrapping when writing
  (add-hook 'LaTeX-mode-hook 'visual-line-mode))

(global-set-key (kbd "C-c w") 'kill-other-buffers)
(global-set-key (kbd "C-c f") 'toggle-frame-fullscreen)

;; Show your agenda and make Emacs go fullscreen
(add-hook 'after-init-hook 'org-agenda-show-all)
(toggle-frame-fullscreen)
