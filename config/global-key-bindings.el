(global-set-key (kbd "C-l") 'forward-char)
(global-set-key (kbd "C-j") 'backward-char)
(global-set-key (kbd "C-k") 'next-line)
(global-set-key (kbd "C-i") 'previous-line)
(global-set-key (kbd "C-u") 'beginning-of-line)
(global-set-key (kbd "C-o") 'end-of-line)

(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))

(global-unset-key (kbd "C-x C-s"))
(global-set-key (kbd "s-s") 'save-buffer)

(provide 'global-key-bindings)
