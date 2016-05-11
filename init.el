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
(load-theme 'danneskjold t)
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

(require 'use-package)
(use-package yasnippet
  :diminish 'yas-minor-mode
  :init (yas-global-mode))

(add-hook 'after-init-hook 'show-agenda-all)
(exec-path-from-shell-initialize)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(toggle-frame-fullscreen)
