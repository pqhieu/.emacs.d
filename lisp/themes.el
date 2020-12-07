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
  :after org
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (setq doom-gruvbox-dark-variant "hard")
  (load-theme 'doom-gruvbox t)
  (doom-themes-org-config)
  (set-face-background 'org-block-begin-line (face-background 'default))
  (set-face-background 'org-block-end-line (face-background 'default))
  (set-face-background 'org-ellipsis (face-background 'default)))

(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-minor-modes nil))

(provide 'themes)
