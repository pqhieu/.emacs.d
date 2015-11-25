(require 'company)
(require 'cc-mode)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(define-key c-mode-map (kbd "C-<return>") 'company-complete)
(define-key c++-mode-map (kbd "C-<return>") 'company-complete)

(provide 'company-setup)

