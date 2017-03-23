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
;; Disable backup and auto-saving
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
;; Miscellaneous
(setq-default with-editor-emacsclient-executable "emacsclient-snapshot")

;;----------------------------------------------------------------------
;; Display Settings
;; Disable splash screen, toolbar and scrollbar
(tool-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(display-time-mode 1)
(global-subword-mode 1)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)
;; Highlight current line and show column number
(column-number-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode 1)
;; Set theme and font
(set-frame-font "Anonymous Pro-14")
;; Fancy symbols
(global-prettify-symbols-mode 1)

;;----------------------------------------------------------------------
;; User-installed Package Settings
;; Set Emacs theme
(load-theme 'spacemacs-light t)
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
;; Set up Ivy
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t) ;; Add recent files into completion list
  (setq ivy-height 15)
  (setq ivy-count-format "")
  (setq ivy-initial-inputs-alist nil))
;; Org-mode settings
(use-package org
  :ensure t
  :init
  (add-hook 'org-mode-hook 'yas-minor-mode-on)
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-files (list "~/Dropbox/gtd.org"))
  (setq org-ellipsis "▼")
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")
                            (sequence "NEXT(n)" "|" "CANCELED(c)")))
  :bind ("C-c a" . show-agenda-all)
  :config
  (font-lock-add-keywords
   'org-mode
   `(("^\\*+ \\(TODO\\) "
      (1 (progn (compose-region (match-beginning 1) (match-end 1) "⚑") nil)))
     ("^\\*+ \\(NEXT\\) "
      (1 (progn (compose-region (match-beginning 1) (match-end 1) "⚐")) nil))
     ("^\\*+ \\(CANCELED\\) "
      (1 (progn (compose-region (match-beginning 1) (match-end 1) "✘") nil)))
     ("^\\*+ \\(DONE\\) "
      (1 (progn (compose-region (match-beginning 1) (match-end 1) "✔") nil))))))
(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))
;; Magit
(use-package magit
  :ensure t
  :config)
(use-package hydra
  :ensure t
  :init
  (defhydra hydra-magit (:color blue :hint nil)
  "
^Magit^             ^Actions^
^^^^^^^------------------------------
_s_: status         _c_: commit
_d_: diff           _u_: push
_l_: log            _p_: pull
"
  ("s" magit-status)
  ("d" magit-diff)
  ("l" magit-log-all)
  ("c" magit-commit)
  ("u" magit-push)
  ("p" magit-pull)
  ("q" quit-window "quit" :color red))
  :bind ("C-c g" . hydra-magit/body))
;; Miscellaneous
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
(use-package whitespace
  :ensure t
  :config
  (setq whitespace-style '(face lines-tail))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook (lambda() (setq show-trailing-whitespace t))))
;; Keybindings
(use-package bind-key
  :ensure t
  :config
  (bind-key "C-c C-f" 'toggle-frame-fullscreen))
;;----------------------------------------------------------------------
;; Programming settings
(use-package cc-mode
  :ensure t
  :config
  (setq c-default-style "ellemtel")
  (setq c-basic-offset 4))
(global-subword-mode 1)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (use-package spacemacs-theme spaceline spacegray-theme rtags org-bullets nyan-mode magit ivy hydra exec-path-from-shell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
