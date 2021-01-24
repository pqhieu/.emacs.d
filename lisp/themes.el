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
  (set-face-attribute 'org-todo nil :family "Rec Mono Semicasual" :weight 'normal :height 150)
  (set-face-attribute 'org-done nil :family "Rec Mono Semicasual" :weight 'normal :height 150)
  (set-face-attribute 'ivy-org nil :family "Rec Mono Semicasual" :weight 'normal :height 150)
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

(provide 'themes)
