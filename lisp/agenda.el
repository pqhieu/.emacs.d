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

(defun org-agenda-show-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "o")
  (delete-other-windows))

(use-package org
  :hook (after-init . org-agenda-show-all)
  :config
  (require 'org)
  (setq org-ellipsis "⤵")
  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")))
  (setq org-todo-keyword-faces '(("NEXT" . "#8abeb7")))
  (setq org-tags-column -77)
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
  (setq org-src-preserve-indentation t))

(use-package org-agenda
  :bind ("C-c a" . org-agenda-show-all)
  :config
  (setq org-agenda-files '("~/Documents/agenda.org" "~/Documents/notes/dailies/"))
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-tags-column -77)
  ;; Do not show scheduled/deadline if done
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-hidden-separator "‌‌ ")
  (setq org-agenda-block-separator (string-to-char "-"))
  (setq org-agenda-custom-commands
        '(("o" "My agenda"
           ((tags "+TODO=\"TODO\"" ((org-agenda-overriding-header "❱ TODAY:\n")
                                    (org-agenda-todo-keyword-format "")))
            (agenda "" ((org-agenda-span 'week)
                        (org-agenda-todo-keyword-format "")
                        (org-agenda-overriding-header "❱ AGENDA:\n")
                        (org-agenda-current-time-string "◀┈┈┈┈┈┈┈┈ now")
                        (org-agenda-time-grid '((daily today) (0800 1200 1600 2000) "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))))
            (tags "+TODO=\"NEXT\"" ((org-agenda-overriding-header "❱ TO DO:\n")
                                    (org-agenda-todo-keyword-format ""))))))))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧")))

(use-package org-roam
  :ensure t
  :hook (after-init . org-roam-mode)
  :bind (("C-c d" . org-roam-dailies-find-today)
         ("C-c n" . org-roam-find-file))
  :config
  (setq org-roam-directory "~/Documents/notes")
  (setq org-roam-dailies-directory "dailies/")
  (setq org-roam-dailies-capture-templates
        '(("d" "daily" plain (function org-roam-capture--get-point) ""
           :immediate-finish t
           :file-name "dailies/%<%Y%m%d>"
           :head "#+STARTUP: content\n#+CATEGORY: DAILIES\n#+TITLE: %<%A, %d %B %Y>"))))

(provide 'agenda)
