;; Quang-Hieu's personal Emacs configuration
;; Copyright (C) 2015-2020
;;
;; Author: Quang-Hieu Pham <pqhieu1192@gmail.com>
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
(setq use-package-verbose t)

;; Set personal information
(setq user-full-name "Quang-Hieu Pham")
(setq user-mail-address "pqhieu1192@gmail.com")

(setq default-frame-alist
      (append (list '(min-height . 1)  '(height . 45)
                    '(min-width . 40) '(width . 81)
                    '(vertical-scroll-bars . nil)
                    '(internal-border-width . 24)
                    '(tool-bar-lines . 0)
                    '(menu-bar-lines . 0))))
(add-hook 'after-init-hook 'toggle-frame-fullscreen)

;; Disable splash screen, toolbar and scrollbar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)

(setq frame-title-format nil)

(display-time-mode 1)

;; Disable backup and auto-saving
(setq-default make-backup-files nil)
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)

;; Disable blinking cursor
(blink-cursor-mode 0)
(setq-default cursor-type 'bar)

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

;; Highlight corresponding parentheses
(show-paren-mode 1)

;; Handle camel case
(add-hook 'prog-mode-hook #'subword-mode)

;; Use pixel scrolling instead of character scrolling
(pixel-scroll-mode 1)

;; Disable all changes through customize
(setq custom-file (make-temp-file ""))

;; Set default font
(set-face-font 'default "DM Mono-15")
(set-face-font 'fixed-pitch "DM Mono-15")
(set-face-font 'variable-pitch "Concourse T3-17")

(setq x-underline-at-descent-line t)

;; Uniquify buffer names
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator " • ")
;; Rename after killing buffer
(setq uniquify-after-kill-buffer-p t)
;; Ignore special buffers
(setq uniquify-ignore-buffers-re "^\\*")

(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 15)

;; File browsing
(require 'dired)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq delete-by-moving-to-trash nil)
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
(global-set-key (kbd "C-c C-w") #'kill-other-buffers)

(require 'org)
(setq org-ellipsis "⤵")
(setq org-tags-column -77)
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")))
(setq org-todo-keyword-faces '(("NEXT" . "#8abeb7")))
(setq org-global-properties
      '(("Effort_ALL" .
         "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))
(setq org-columns-default-format
      "%50ITEM %2PRIORITY %10Effort(EFFORT){:} %10CLOCKSUM")
(setq org-clock-into-drawer t)
(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(setq org-clock-out-when-done t)
(setq org-pretty-entities t)
(setq org-latex-create-formula-image-program 'dvisvgm)
(setq org-preview-latex-image-directory "/tmp/ltximg")
(setq org-fontify-whole-heading-line t)
(setq org-fontify-done-headline t)
(setq org-fontify-quote-and-verse-blocks t)
(setq org-src-fontify-natively t)
(setq org-deadline-warning-days 7)
(setq org-src-preserve-indentation t)
(setq org-habit-graph-column 60)
(add-to-list 'org-modules 'org-habit t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ledger . t)))

(require 'org-agenda)
(setq org-agenda-span 'week)
(setq org-agenda-files '("~/Documents/agenda.org"))
(setq org-agenda-todo-ignore-scheduled (quote all))
(setq org-agenda-todo-ignore-timestamp (quote all))
(setq org-agenda-tags-column -77)
;; Do not show scheduled/deadline if done
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-hidden-separator "‌‌ ")
(setq org-agenda-block-separator (string-to-char "-"))
(setq org-agenda-sorting-strategy
      '((agenda time-up priority-down habit-down category-keep)
        (todo priority-down category-keep)
        (tags priority-down category-keep)
        (search category-keep)))
(setq org-agenda-custom-commands
      '(("o" "My agenda"
         ((agenda "" ((org-agenda-span 'week)
                      (org-agenda-todo-keyword-format "")
                      (org-agenda-scheduled-leaders '(""))
                      (org-agenda-overriding-header "❱ AGENDA:\n")
                      (org-agenda-current-time-string "◀┈┈┈┈┈┈┈┈ now")
                      (org-agenda-time-grid
                       '((daily today remove-match)
                         (0800 1200 1600 2000) "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))))
          (todo "TODO|NEXT" ((org-agenda-overriding-header "❱ TODO:\n")))))))

(defun org-agenda-show-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "o")
  (delete-other-windows))
(add-hook 'after-init-hook #'org-agenda-show-all)
(global-set-key (kbd "C-c C-a") #'org-agenda-show-all)

;; Load shell environment variables
(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧")))

(use-package org-journal
  :ensure t
  :hook (org-journal-mode . (lambda () (visual-line-mode 0)))
  :bind ("C-c C-j" . org-journal-new-entry)
  :config
  (setq org-journal-file-type 'daily)
  (setq org-journal-enable-agenda-integration t)
  (setq org-journal-date-prefix "#+TITLE: ")
  (setq org-journal-time-prefix "* ")
  (setq org-journal-dir "~/Documents/notes/dailies/")
  (setq org-journal-date-format "%A, %d %B %Y")
  (setq org-journal-carryover-delete-empty-journal 'always)
  (setq org-journal-file-header "#+STARTUP: content\n#+CATEGORY: DAILIES")
  (setq org-journal-skip-carryover-drawers (list "LOGBOOK"))
  (setq org-journal-file-format "%Y%m%d.org"))

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

(use-package elfeed
  :ensure t
  :bind ("C-c C-r" . elfeed)
  :config
  (setq elfeed-feeds
        '(("https://www.reddit.com/.rss?feed=b715b97328a94d3dcbddf4442e2777b95a1a6397&user=CaiCuoc" news)
          ("https://www.jendrikillner.com/tags/weekly/index.xml" graphics)
          ("https://news.ycombinator.com/rss" news)))
  (setq elfeed-search-filter "@1-week-ago +unread "))

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

;; YAML
(use-package yaml-mode :ensure t)

;; Markdown
(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-fontify-code-blocks-natively t))

;; Ledger
(use-package ledger-mode
  :ensure t
  :mode ("\\.dat\\'")
  :config (setq ledger-clear-whole-transactions t))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t))

(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-minor-modes nil))

(with-eval-after-load 'org
  (set-face-attribute 'outline-1 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-2 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-3 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-4 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-5 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-6 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-7 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'outline-8 nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'org-document-title nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'org-headline-done nil :family "Concourse T3" :weight 'normal :height 170)
  (set-face-attribute 'org-todo nil :family "DM Mono" :weight 'normal :height 150)
  (set-face-attribute 'org-done nil :family "DM Mono" :weight 'normal :height 150)
  (set-face-attribute 'ivy-org nil :family "DM Mono" :weight 'normal :height 150)
  (set-face-background 'org-block-begin-line (face-background 'default))
  (set-face-background 'org-block-end-line (face-background 'default))
  (set-face-background 'org-ellipsis (face-background 'default)))

(with-eval-after-load 'font-latex
  (set-face-attribute 'font-latex-sectioning-0-face nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'font-latex-sectioning-1-face nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'font-latex-sectioning-2-face nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'font-latex-sectioning-3-face nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'font-latex-sectioning-4-face nil :family "Concourse T3" :weight 'bold :height 170)
  (set-face-attribute 'font-latex-sectioning-5-face nil :family "Concourse T3" :weight 'bold :height 170))
