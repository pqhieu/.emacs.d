(require 'company)
(require 'cc-mode)

(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(setq company-idle-delay 0.0)
(define-key c-mode-map (kbd "C-<return>") 'company-complete)
(define-key c++-mode-map (kbd "C-<return>") 'company-complete)

(provide 'company-setup)
