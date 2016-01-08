(defun show-agenda-all ()
  ;; Show agenda and todo list
  (interactive)
  (org-agenda nil "n")
  (delete-other-windows))

(global-set-key (kbd "C-c a") 'show-agenda-all)

(provide 'global-key-bindings)
