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

;;----------------------------------------------------------------------
;; Display Settings
;; Disable splash screen, toolbar and scrollbar
(tool-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(display-time-mode 1)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)
;; Highlight current line and show column number
(column-number-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode 1)
;; Set theme and font
(set-frame-font "Source Code Pro-14")

;;----------------------------------------------------------------------
;; User-installed Package Settings
;; Set Emacs theme
(load-theme 'gruvbox-dark-hard t)
;; Modeline
(use-package nyan-mode
  :ensure t
  :init (nyan-mode 1)
  :config (nyan-start-animation))

;; Ivy
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
  (setq org-agenda-tags-column -100)
  (setq org-tags-column -79)
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-files (list "~/Dropbox/gtd.org"))
  (setq org-ellipsis "▼")
  (setq org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")))
  :bind ("C-c a" . show-agenda-all))
(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))

;; Magit
(use-package magit
  :ensure t
  :init
  (if (eq system-type 'darwin)
      (setq-default with-editor-emacsclient-executable
                    "/usr/local/bin/emacsclient"))
  :bind ("C-c g" . magit-status))

;; Dired
(use-package all-the-icons
  :ensure t
  :init
  (require 'cl)
  (require 'tramp))
(use-package all-the-icons-dired
  :ensure t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
  (add-hook 'dired-mode-hook 'auto-revert-mode))
(use-package spaceline)
(use-package spaceline-all-the-icons
  :after spaceline
  :config (spaceline-all-the-icons-theme))
(if (eq system-type 'gnu/linux)
    (setq dired-listing-switches "-aBhl  --group-directories-first"))

;; Miscellaneous
(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))
(use-package whitespace
  :ensure t
  :config
  (setq whitespace-style '(trailing))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'whitespace-mode))

(use-package elfeed
  :ensure t
  :init
  (setq elfeed-feeds '(("http://pragmaticemacs.com/feed/" blog emacs)
                       ("http://irreal.org/blog/?feed=rss2" blog emacs)
                       ("https://jeremykun.com/feed/" blog math)
                       ("http://emacsredux.com/atom.xml" blog emacs)
                       ("http://oremacs.com/atom.xml" blog emacs)
                       ("http://www.hieuthi.com/blog/feed.xml" blog)))
  (setq-default elfeed-search-filter "+unread")
  :bind ("C-c w" . elfeed))

(use-package calendar
  :ensure t
  :config
  (setq diary-file "~/Dropbox/diary")
  (setq calendar-mark-diary-entries-flag t)
  (add-hook 'diary-display-hook 'diary-fancy-display-mode)
  :bind ("C-c c" . calendar))

;; Keybindings
(global-set-key (kbd "C-c f") 'toggle-frame-fullscreen)


;;----------------------------------------------------------------------
;; Programming settings
(global-prettify-symbols-mode 1)
(global-subword-mode 1)

(use-package cc-mode
  :ensure t
  :config
  (defun c-setup () (c-set-offset 'innamespace [0]))
  (add-hook 'c++-mode-hook 'c-setup)
  (setq c-default-style "stroustrup")
  (setq c-basic-offset 4))

(toggle-frame-fullscreen)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (haskell-mode
     counsel-projectile
     projectile
     cuda-mode
     spaceline-all-the-icons
     gruvbox-theme
     markdown-mode
     yasnippet
     use-package
     org-bullets
     nyan-mode
     nord-theme
     magit
     ivy
     go-mode
     exec-path-from-shell
     elfeed
     all-the-icons-dired)))
 '(spaceline-all-the-icons-hide-long-buffer-path t)
 '(spaceline-all-the-icons-icon-set-sun-time (quote sun/moon))
 '(spaceline-all-the-icons-separator-type (quote arrow)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#504945" :foreground "#d5c4a1" :box (:line-width 1 :color "grey75" :style released-button))))))
