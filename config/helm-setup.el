(require 'helm-config)
(require 'helm)
(require 'helm-swoop)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)

(setq helm-quick-update nil
      helm-M-x-fuzzy-match t
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

(helm-mode 1)

;; Configure helm-swoop
(global-set-key (kbd "C-s") 'helm-swoop)
(setq helm-swoop-split-with-multiple-windows t
      helm-swoop-split-direction 'split-window-vertically
      helm-swoop-move-to-line-cycle t)
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

(add-to-list 'display-buffer-alist
             `(,(rx bos "*helm" (* not-newline) "*" eos)
               (display-buffer-in-side-window)
               (inhibit-same-window . t)
               (window-height . 0.4)))

(provide 'helm-setup)
