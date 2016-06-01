;;----------------------------------------------------------------------
;; Personal information
(setq user-full-name "Quang-Hieu Pham")
(setq user-mail-address "pqhieu1192@gmail.com")

;; Add package sources
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(setq package-enable-at-startup nil)

(require 'use-package)
(setq use-package-verbose t)

(setq require-final-newline t)

;; Ask "y" or "n" instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Highligt corresponding parentheses
(show-paren-mode t)

;; Show column number
(setq column-number-mode t)

;; Disable init screen and toolbar
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Disable backup files
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Set theme and font
(load-theme 'tao-yin t)
(set-frame-font "Source Code Pro-13")


;;---------- Helm configuration ----------
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

(add-to-list 'load-path "~/.emacs.d/config")
(require 'global-key-bindings)
(require 'cpp-setup)
(require 'prog-setup)
(require 'modeline-setup)
(require 'org-setup)

(defun my-c-setup ()
  (c-set-offset 'innamespace 0))
(add-hook 'c++-mode-hook 'my-c-setup)

(toggle-frame-fullscreen)

(require 'use-package)
(use-package yasnippet
  :diminish 'yas-minor-mode
  :init (yas-global-mode))

(add-hook 'after-init-hook 'show-agenda-all)
(exec-path-from-shell-initialize)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)

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
 '(org-agenda-todo-list-sublevels nil)
 '(subatomic-high-contrast t)
 '(subatomic-more-visible-comment-delimiters t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-type-face ((t (:foreground "#F6F6F6" :underline nil :slant italic :weight bold))))
 '(org-done ((t (:foreground "rosy brown" :weight bold))))
 '(org-level-1 ((t (:foreground "#F9F9F9" :height 1.0))))
 '(org-level-2 ((t (:foreground "#D9D9D9" :height 1.0))))
 '(org-level-3 ((t (:foreground "#C2C2C2" :height 1.0))))
 '(org-meta-line ((t (:foreground "#9D9D9D" :height 1.0))))
 '(org-target ((t (:foreground "white smoke" :slant italic))))
 '(org-todo ((t (:foreground "light blue" :weight bold)))))


(setq font-lock-maximum-decoration 1)
