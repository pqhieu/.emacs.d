(require 'company)
(require 'cc-mode)
(require 'diminish)

(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(setq company-idle-delay 0.0)
(define-key c-mode-map (kbd "C-<return>") 'company-complete)
(define-key c++-mode-map (kbd "C-<return>") 'company-complete)

(diminish 'company-mode "Ⓒ")

(provide 'company-setup)
