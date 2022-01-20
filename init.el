;; Quang-Hieu's personal Emacs configuration
;; Copyright (C) 2015-2021
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
(setq use-package-always-defer nil)
(setq use-package-always-ensure nil)
(setq use-package-expand-minimally nil)
(setq use-package-minimum-reported-time 0)
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
(setq-default cursor-type 'hbar)

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
(set-face-font 'default "Iosevka Custom-13")
(set-face-font 'fixed-pitch "Iosevka Custom-13")
(set-face-font 'variable-pitch "ETBembo-14")
(if (fboundp 'mac-auto-operator-composition-mode)
    (mac-auto-operator-composition-mode))

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
(global-set-key (kbd "C-c w") #'kill-other-buffers)

(require 'org)
(setq org-ellipsis "↷")
(setq org-tags-column -77)
(setq org-adapt-indentation t)
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)")))
(setq org-hide-emphasis-markers t)
(setq org-hide-leading-stars t)
(setq org-pretty-entities t)
(setq org-pretty-entities-include-sub-superscripts nil)
(setq org-clock-into-drawer t)
(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(setq org-clock-out-when-done t)
(setq org-preview-latex-image-directory "/tmp/ltximg")
(setq org-fontify-whole-heading-line t)
(setq org-fontify-done-headline t)
(setq org-fontify-quote-and-verse-blocks t)
(setq org-deadline-warning-days 7)
(setq org-src-fontify-natively t)
(setq org-src-preserve-indentation t)
(setq org-src-window-setup 'other-window)
(setq org-habit-graph-column 70)
(setq org-habit-preceding-days 13)
(setq org-habit-following-days 1)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+")))
;; Increase sub-item indentation
(setq org-list-indent-offset 1)
(add-to-list 'org-modules 'org-habit t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ledger . t)))

(defun prettify-org-keywords ()
  (interactive)
  "Beautify org mode keywords."
  (setq prettify-symbols-alist
        (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                '(("#+header:" . "☰")
                  ("#+begin_src" . "╦")
                  ("#+end_src" . "╩")
                  ("#+begin_comment" . "✎")
                  ("#+end_comment" . "✎")
                  ("#+begin_quote" . "»")
                  ("#+end_quote" . "«")
                  ("[ ]" . "")
                  ("[X]" . "")
                  ("SCHEDULED:" . "")
                  ("DEADLINE:" . "")
                  ("CLOSED:" . ""))))
  (prettify-symbols-mode 1))
(add-hook 'org-mode-hook #'prettify-org-keywords)
(add-hook 'org-mode-hook #'variable-pitch-mode)
(add-hook 'org-mode-hook #'org-indent-mode)

(require 'org-agenda)
(setq org-agenda-span 'week)
(setq org-agenda-start-on-weekday 0)
(setq org-agenda-files '("~/Documents/todo.org"))
(setq org-agenda-todo-ignore-scheduled (quote all))
(setq org-agenda-todo-ignore-timestamp (quote all))
(setq org-agenda-tags-column -77)
;; Do not show scheduled/deadline if done
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-show-future-repeats 'next)
(setq org-agenda-hidden-separator "‌‌ ")
(setq org-agenda-block-separator (string-to-char "-"))
(setq org-fontify-done-headline nil)
(setq org-agenda-sorting-strategy
      '((agenda time-up todo-state-up priority-down habit-down category-keep)
        (todo todo-state-up priority-down category-keep)
        (tags priority-down category-keep)
        (search category-keep)))
(setq org-agenda-custom-commands
      '(("o" "My agenda"
         ((agenda "" ((org-agenda-span 'week)
                      (org-agenda-overriding-header "❱ AGENDA:\n")
                      (org-agenda-current-time-string "┈┈┈┈ now ┈┈┈┈")
                      (org-agenda-time-grid
                       '((daily today remove-match)
                         (0800 1200 1600 2000) "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))))
          (todo "TODO|READ|NEXT" ((org-agenda-overriding-header "❱ TODO:\n")))))))

(defun org-agenda-show-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "o")
  (delete-other-windows))
(add-hook 'after-init-hook #'org-agenda-show-all)
(global-set-key (kbd "C-c a") #'org-agenda-show-all)

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧"))
  (setq org-superstar-prettify-item-bullets t)
  (setq org-superstar-item-bullet-alist
        '((?* . ?•)
          (?+ . ?•)
          (?- . ?•)))
  (setq inhibit-compacting-font-caches t))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoentities t))

(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

(use-package deft
  :ensure t
  :init
  (setq deft-extensions '("org" "md" "txt"))
  (setq deft-directory "~/Documents/notes")
  (setq deft-auto-save-interval 0)
  (setq deft-use-filename-as-title t))

(use-package zetteldeft
  :ensure t
  :after deft
  :config (zetteldeft-set-classic-keybindings)
  :init
  (setq zetteldeft-id-format "%Y%m%d%H%M%S")
  (setq zetteldeft-id-regex "[0-9]\\{14\\}"))

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

(use-package elfeed
  :ensure t
  :bind ("C-c f" . elfeed)
  :config
  (setq elfeed-feeds
        '(("https://www.reddit.com/.rss?feed=b715b97328a94d3dcbddf4442e2777b95a1a6397&user=CaiCuoc&limit=25" news)
          ("https://www.inference.vc/rss/" blog ml)
          ("https://ciechanow.ski/atom.xml" blog)
          ("https://www.aaronsw.com/2002/feeds/pgessays.rss" blog tech)
          ("https://lilianweng.github.io/lil-log/feed.xml" blog ml)
          ("https://news.ycombinator.com/rss" news tech)))
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

(use-package modus-themes
  :ensure t
  :config
  (setq modus-themes-bold-constructs t)
  (setq modus-themes-slanted-constructs nil)
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-faint-syntax t)
  (setq modus-themes-fringes nil)
  (setq modus-themes-headings '((t . (variable-pitch rainbow))))
  (setq modus-themes-org-agenda
        '((header-block . (variable-pitch))
          (header-date . (grayscale bold-all))
          (scheduled . rainbow)
          (habit . simplified)))
  (load-theme 'modus-operandi t))

(use-package doom-modeline
   :ensure t
   :config
   (doom-modeline-mode 1)
   (setq doom-modeline-major-mode-icon t)
   (setq doom-modeline-minor-modes nil)
   (setq doom-modeline-buffer-file-name-style 'relative-from-project))

(require 'org-indent)
(with-eval-after-load 'org
  (set-face-attribute 'org-indent nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-block nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-code nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-special-keyword nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-property-value nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-table nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-tag nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-todo nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-done nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'ivy-org nil :family "Iosevka Custom" :weight 'normal :height 130)
  (set-face-attribute 'org-priority nil :family "Iosevka Custom" :height 130))
