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
;; (setq-default line-spacing 0.1)

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
(global-set-key (kbd "C-c w") #'kill-other-buffers)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ledger . t)))

(add-hook 'after-init-hook #'toggle-frame-fullscreen)

(provide 'defaults)
