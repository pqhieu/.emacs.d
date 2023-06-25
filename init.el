;; Personal Emacs configuration
;; Copyright (C) 2015-2022
;;
;; Author: Pham Quang Hieu <pqhieu1192@gmail.com>
;;
;; License:
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; Reduce the frequency of garbage collection by making it happen on
;; each 100MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 100000000)
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun idle-garbage-collect ()
  "Reset gc-cons-threshold"
  (setq gc-cons-threshold 800000)
  (defun idle-garbage-collect ()
    (garbage-collect)))
(add-hook 'focus-out-hook #'idle-garbage-collect)

(add-to-list 'load-path "~/.emacs.d/lisp")

;; Start Emacs package manager
(require 'package)
;; Initialize installed packages
(setq package-enable-at-startup t)
;; Allow loading from the package cache
(setq package-quickstart t)
;; Do not resize the frame at this early stage.
(setq frame-inhibit-implied-resize t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Check for use-package and install if needed
(unless (package-installed-p 'use-package)
  (message "`use-package` not found. Installing...")
  (package-refresh-contents)
  (package-install 'use-package))
;; Config use-package
(require 'use-package)
(require 'bind-key)
(setq use-package-always-defer nil)
(setq use-package-always-ensure nil)
(setq use-package-expand-minimally nil)
(setq use-package-minimum-reported-time 0)
(setq use-package-verbose t)

;; Set personal information
(setq user-full-name "Pham Quang Hieu")
(setq user-mail-address "pqhieu1192@gmail.com")

(setq default-frame-alist
      (append (list '(min-height . 1)  '(height . 60)
                    '(min-width . 40) '(width . 100)
                    '(vertical-scroll-bars . nil)
                    '(internal-border-width . 24)
                    '(tool-bar-lines . 0)
                    '(menu-bar-lines . 0))))

;; Disable splash screen, toolbar and scrollbar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)

(setq frame-title-format nil)
(setq ns-use-proxy-icon nil)

(display-time-mode 1)

;; Disable backup and auto-saving
(setq-default make-backup-files nil)
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Disable blinking cursor
(blink-cursor-mode 1)
(setq-default cursor-type 'box)

;; Disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; Set tab width and its behavior
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default fill-column 80)
(setq-default tab-always-indent 'complete)
(setq-default truncate-lines t)

;; Insert new line at EOF when save
(setq-default require-final-newline t)

(fset 'yes-or-no-p 'y-or-n-p)

;; Show line and column numbers in mode line
(line-number-mode 1)
(column-number-mode 1)

;; Revert buffers automatically
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Highlight corresponding parentheses
(show-paren-mode 1)

;; Handle camel case
(add-hook 'prog-mode-hook #'subword-mode)

;; Use pixel scrolling instead of character scrolling
(pixel-scroll-mode 1)
(setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
(setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines
(setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event
(setq mouse-wheel-progressive-speed nil) ; Progressive speed is too fast for me

;; Enable line numbers
(add-hook 'prog-mode-hook 'linum-mode)

;; Disable all changes through customize
(setq custom-file (make-temp-file ""))

;; Set default font
(set-face-attribute 'default nil :font "JetBrains Mono 14")
(set-face-attribute 'fixed-pitch nil :font "JetBrains Mono 14")
(set-face-attribute 'variable-pitch nil :family "Concourse 4" :height 160)
(setq x-underline-at-descent-line nil)

;; Uniquify buffer names
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator " • ")
;; Rename after killing buffer
(setq uniquify-after-kill-buffer-p t)
;; Ignore special buffers
(setq uniquify-ignore-buffers-re "^\\*")

(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 15)

(setq bibtex-dialect 'biblatex)
(setq bibtex-entry-format '(realign numerical-fields last-comma required-fields sort-fields))
(add-hook 'bibtex-mode-hook
          (lambda () (setq fill-column 999999)))

;; File browsing
(require 'dired)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq delete-by-moving-to-trash t)
(setq dired-dwim-target t)
;; Reuse current buffer by pressing 'a'
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "^")
  (lambda () (interactive) (find-alternate-file "..")))
;; Remember to install coreutils on OSX
(if (eq system-type 'darwin)
    (setq insert-directory-program "gls" dired-use-ls-dired t))
(setq dired-listing-switches "-aFhlv --group-directories-first")
(require 'dired-x)

(require 'whitespace)
(setq whitespace-line-column 120)
(setq whitespace-style '(face tabs trailing lines-tail empty))
;; Delete trailing whitespace when save
(add-hook 'before-save-hook #'whitespace-cleanup)
(add-hook 'programming-mode-hook #'whitespace-mode)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))
(global-set-key (kbd "C-c w") #'kill-other-buffers)

(require 'org)
(setq org-ellipsis "▼")
(setq org-tags-column -77)
(setq org-adapt-indentation nil)
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)")))
(setq org-hide-emphasis-markers t)
(setq org-hide-leading-stars t)
(setq org-pretty-entities t)
(setq org-pretty-entities-include-sub-superscripts nil)
(setq org-clock-into-drawer t)
(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(setq org-clock-out-when-done nil)
(setq org-preview-latex-image-directory "/tmp/ltximg")
(setq org-format-latex-options (plist-put org-format-latex-options :scale 0.9))
(add-to-list 'org-latex-packages-alist '("euler-digits,euler-hat-accent" "eulervm" t))
(setq org-fontify-whole-heading-line nil)
(setq org-fontify-done-headline nil)
(setq org-fontify-quote-and-verse-blocks t)
(setq org-deadline-warning-days 7)
(setq org-src-fontify-natively nil)
(setq org-src-preserve-indentation nil)
(setq org-edit-src-content-indentation 0)
(setq org-src-window-setup 'other-window)
(setq org-habit-graph-column 70)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-image-actual-width t)
(setq org-hierarchical-todo-statistics nil)
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+")))
(setq org-confirm-babel-evaluate nil)
;; Increase sub-item indentation
(setq org-list-indent-offset 1)
(setq org-outline-path-complete-in-steps nil)
(setq org-columns-skip-archived-trees t)
(add-to-list 'org-modules 'org-habit t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (R . t)
   (ledger . t)))
(setq org-confirm-babel-evaluate nil)
(add-hook 'org-babel-after-execute-hook #'org-display-inline-images)

(setq mixed-pitch-set-height t)
(add-hook 'org-mode-hook #'mixed-pitch-mode)
(add-hook 'markdown-mode #'mixed-pitch-mode)
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'elfeed-show-mode #'visual-line-mode)

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoentities t))

(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

;; Load shell environment variables
(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status)
  :init
  ;; Have magit-status go full screen and quit to previous configuration
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defadvice magit-quit-window (after magit-restore-screen activate)
    (jump-to-register :magit-fullscreen)))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-count-format "(%d/%d) ")
  ;; Add recent files into completion list
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-use-selectable-prompt t)
  (setq ivy-display-style 'fancy)
  (setq ivy-height 15))

(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode 1)
  (setq ivy-rich-path-style 'abbrev)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))

(use-package counsel
  :after ivy
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c l" . counsel-locate)
         ("C-c 8" . counsel-unicode-char)
         ("C-c s" . counsel-git-grep)
         ("C-h v" . counsel-describe-variable)
         ("C-h f" . counsel-describe-function)
         ("M-y" . counsel-yank-pop))
  :config (setq counsel-find-file-ignore-regexp "\\(?:^Icon?\\)"))

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode t))

(use-package company-posframe
  :ensure t
  :config
  (setq company-posframe-show-indicator nil)
  (setq company-tooltip-minimum-width 40)
  (company-posframe-mode t))

(defun elfeed-scroll-up-command (&optional arg)
  "Scroll up or go to next feed item in Elfeed"
  (interactive "^P")
  (let ((scroll-error-top-bottom nil))
    (condition-case-unless-debug nil
        (scroll-up-command arg)
      (error (elfeed-show-next)))))

(defun elfeed-scroll-down-command (&optional arg)
  "Scroll up or go to next feed item in Elfeed"
  (interactive "^P")
  (let ((scroll-error-top-bottom nil))
    (condition-case-unless-debug nil
        (scroll-down-command arg)
      (error (elfeed-show-prev)))))

(use-package elfeed
  :ensure t
  :bind ("C-c f" . elfeed)
  :config
  (define-key elfeed-show-mode-map (kbd "SPC") 'elfeed-scroll-up-command)
  (define-key elfeed-show-mode-map (kbd "S-SPC") 'elfeed-scroll-down-command)
  (setq elfeed-search-filter "@1-week-ago +unread "))

(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-tree-id "@elfeed")
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org")))

(use-package elfeed-tube
  :ensure t
  :config
  (elfeed-tube-setup))

;; C/C++
(use-package cc-mode
  :config
  (defun c-setup ()
    (c-set-offset 'innamespace [0])
    (c-set-offset 'inextern-lang [0]))
  (add-hook 'c-mode-common-hook 'c-setup)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (add-hook (make-local-variable 'before-save-hook)
                        'clang-format-buffer)))
  (setq c-default-style "linux")
  (setq c-basic-offset 4))
(use-package clang-format :ensure t)

;; LaTeX
(use-package latex
  :ensure auctex
  :config
  (setq TeX-auto-save nil)
  (setq TeX-parse-self nil)
  (setq font-latex-script-display (quote (nil))))

;; Markdown
(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-fontify-code-blocks-natively t))

;; Ledger
(use-package ledger-mode
  :ensure t
  :mode ("\\.dat\\'")
  :config
  (setq ledger-clear-whole-transactions t)
  (setq ledger-default-date-format "%Y-%m-%d"))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-buffer-file-name-style 'buffer-name)
  (setq doom-modeline-icon nil))

;; Add frame borders and window dividers
(modify-all-frames-parameters
 '((right-divider-width . 40)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

(setq org-auto-align-tags t
      org-tags-column 0
      org-catch-invisible-edits 'show-and-error
      org-special-ctrl-a/e t
      org-insert-heading-respect-content t)

(require 'org-modern)
(setq org-modern-list '((?- . "•") (?* . "•") (?+ . "‣")))
(setq org-modern-star '("①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧"))
(setq org-modern-table nil)
(setq org-modern-keyword nil)
(setq org-modern-block-fringe t)
(setq org-modern-block-name t)
(global-org-modern-mode)

(with-eval-after-load 'org-modern
  (set-face-attribute 'org-document-title nil :family "Concourse 4 Caps" :height 160)
  (set-face-attribute 'org-level-1 nil :family "Concourse 4" :height 160)
  (set-face-attribute 'org-level-2 nil :family "Concourse 4" :height 160)
  (set-face-attribute 'markdown-header-face-1 nil :family "Concourse 4" :height 160)
  (set-face-attribute 'markdown-header-face-2 nil :family "Concourse 4" :height 160)
  (set-face-attribute 'org-quote nil :family "Concourse 4" :height 160)
  (set-face-attribute 'org-special-keyword nil :font "JetBrains Mono 14")
  (set-face-attribute 'org-drawer nil :font "JetBrains Mono 14")
  (set-face-attribute 'org-property-value nil :font "JetBrains Mono 14")
  (set-face-attribute 'markdown-url-face nil :font "JetBrains Mono 14")
  (set-face-attribute 'org-ellipsis nil :font "JetBrains Mono 14")
  (set-face-attribute 'org-modern-label nil :font "JetBrains Mono 13"))

(use-package deft
  :ensure t
  :init
  (global-set-key (kbd "C-c d") #'deft)
  (setq deft-extensions '("org"))
  (setq deft-default-extension "org")
  (setq deft-directory "~/Workspace/notes")
  (setq deft-use-filename-as-title nil)
  (setq deft-auto-save-interval 0)
  (setq deft-strip-title-regexp "\\(?:^%+\\|^#\\+title: *\\|^[#* ]+\\|-\\*-[[:alpha:]]+-\\*-\\|^Title:[	 ]*\\|#+$\\)")
  (setq deft-strip-summary-regexp "\\([
	]\\|^#\\+[[:lower:]_]+:.*$\\)")
  (setq deft-recursive t))

(require 'denote)
(require 'denote-org-dblock)
;; Remember to check the doc strings of those variables.
(setq denote-directory (expand-file-name "~/Workspace/notes"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-file-type nil) ; Org is the default, set others here
(setq denote-prompts '(title))

;; Read this manual for how to specify `denote-templates'.  We do not
;; include an example here to avoid potential confusion.

;; We allow multi-word keywords by default.  The author's personal
;; preference is for single-word keywords for a more rigid workflow.
(setq denote-allow-multi-word-keywords t)

(setq denote-date-format nil) ; read doc string

;; By default, we fontify backlinks in their bespoke buffer.
(setq denote-link-fontify-backlinks t)

;; Also see `denote-link-backlinks-display-buffer-action' which is a bit
;; advanced.

;; If you use Markdown or plain text files (Org renders links as buttons
;; right away)
(add-hook 'find-file-hook #'denote-link-buttonize-buffer)

;; Generic (great if you rename files Denote-style in lots of places):
(add-hook 'dired-mode-hook #'denote-dired-mode)

;; Denote DOES NOT define any key bindings.  This is for the user to
;; decide.  For example:
(let ((map global-map))
  (define-key map (kbd "C-c n d") #'list-denotes)
  (define-key map (kbd "C-c n n") #'denote)
  (define-key map (kbd "C-c n N") #'denote-type)
  (define-key map (kbd "C-c n s") #'denote-subdirectory)
  (define-key map (kbd "C-c n t") #'denote-template)
  ;; If you intend to use Denote with a variety of file types, it is
  ;; easier to bind the link-related commands to the `global-map', as
  ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
  ;; `markdown-mode-map', and/or `text-mode-map'.
  (define-key map (kbd "C-c n i") #'denote-link) ; "insert" mnemonic
  (define-key map (kbd "C-c n I") #'denote-link-add-links)
  (define-key map (kbd "C-c n b") #'denote-link-backlinks)
  ;; Note that `denote-rename-file' can work from any context, not just
  ;; Dired bufffers.  That is why we bind it here to the `global-map'.
  (define-key map (kbd "C-c n r") #'denote-rename-file)
  (define-key map (kbd "C-c n R") #'denote-rename-file-using-front-matter))

;; Key bindings specifically for Dired.
(let ((map dired-mode-map))
  (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
  (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-marked-files)
  (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter))
