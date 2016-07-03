;;----------------------------------------------------------------------
;; My Personal Emacs Configuration
;;
;; I will try to keep it clean and well-documented as much as possible,
;; but sometimes the laziness just get me...
;; I don't guarantee it will work on any computer or any Emacs version,
;; and will not hold any responsibilities for it.
;; Current init time: 2.0 seconds (still acceptable)

;;----------------------------------------------------------------------
;; Package Initialisation
;; Start Emacs package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
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
;; General Settings
;; Set personal information
(setq user-full-name "Quang-Hieu Pham")
(setq user-mail-address "pqhieu1192@gmail.com")
;; Disable backup files and auto save
;; I like to live dangerously
(setq-default make-backup-files nil)
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)
;; Set tab width and its behaviour
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-always-indent 'complete)
;; Insert new line at EOF when save
(setq-default require-final-newline t)
;; Ask the real question: 'y' or 'n'
(fset 'yes-or-no-p 'y-or-n-p)
;; Start in fullscreen
(set-frame-parameter nil 'fullscreen 'fullboth)

;;----------------------------------------------------------------------
;; Display Settings
;; Disable splash screen, toolbar and scrollbar
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)
;; Highlight current line and show column number
(column-number-mode 1)
;; (global-hl-line-mode 1)
;; Uniquify buffer names
(setq-default uniquify-buffer-name-style 'forward)
;; Highligt corresponding parentheses
(show-paren-mode t)
;; Set theme and font
(set-frame-font "Source Code Pro-13")
(load-theme 'oldlace t)
;; (use-package tao-theme
;;   :ensure t
;;   :init (load-theme 'tao-yin t))
;; ;; TODO: Directly change these stuff instead of using Custom
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-meta-line ((t (:height 1.0))))
 '(org-scheduled-today ((t (:height 1.0)))))
;;  '(org-target ((t (:foreground "white smoke" :slant italic)))))

;;----------------------------------------------------------------------
;; Helm Settings
(use-package helm
  :ensure t
  :diminish (helm-mode . "Ⓗ")
  :init
  (require 'helm-config)
  (require 'helm)
  (bind-key "<tab>" 'helm-execute-persistent-action helm-map)
  (helm-mode)
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-mini)
	 ("C-s" . helm-swoop)))

(defun my-c-setup ()
  (c-set-offset 'innamespace 0))
(add-hook 'c++-mode-hook 'my-c-setup)

(use-package yasnippet
  :diminish 'yas-minor-mode
  :init (yas-global-mode))

(add-hook 'after-init-hook 'show-agenda-all)
(exec-path-from-shell-initialize)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
(setq modern-c++-literal-integer nil)

(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-todo-ignore-scheduled (quote all))
 '(org-agenda-todo-ignore-timestamp (quote all))
 '(org-agenda-todo-list-sublevels nil)
 '(powerline-default-separator (quote wave)))


(setq font-lock-maximum-decoration 1)
(require 'cc-mode)
(setq c-default-style "stroustrup")
(add-hook 'prog-mode-hook (lambda() (setq show-trailing-whitespace t)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq ns-use-srgb-colorspace nil)
(require 'spaceline-config)
(spaceline-emacs-theme)

(require 'nyan-mode)
(nyan-mode t)
(setq org-agenda-files (list "~/Dropbox/Documents/org/gtd.org"))

(setq org-agenda-show-log t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-timestamp-if-done t)
(setq org-agenda-start-on-weekday nil)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(defun show-agenda-all ()
  ;; Show agenda and todo list
  (interactive)
  (org-agenda nil "n")
  (delete-other-windows))

(global-set-key (kbd "C-c a") 'show-agenda-all)

(setq helm-quick-update nil
      helm-split-window-in-side-p t
      helm-M-x-fuzzy-match t
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)
(setq helm-swoop-split-with-multiple-windows t
      helm-swoop-split-direction 'split-window-vertically
      helm-swoop-move-to-line-cycle t)
;; (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
;; (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

(add-to-list 'display-buffer-alist
             `(,(rx bos "*helm" (* not-newline) "*" eos)
               (display-buffer-in-side-window)
               (inhibit-same-window . t)
               (window-height . 0.4)))
