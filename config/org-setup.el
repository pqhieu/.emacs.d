(setq org-agenda-files (list "~/.emacs.d/org/work.org"
                             "~/.emacs.d/org/study.org"
                             "~/.emacs.d/org/code.org"
                             "~/.emacs.d/org/personal.org"
                             "~/.emacs.d/org/misc.org"))

(setq org-agenda-show-log t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(provide 'org-setup)
