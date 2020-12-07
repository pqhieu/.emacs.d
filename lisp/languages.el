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

(provide 'languages)
