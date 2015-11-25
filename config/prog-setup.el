(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default tab-always-indent 'complete)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'prog-setup)
