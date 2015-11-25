(require 'cc-mode)
(setq c-default-style "stroustrup")

(font-lock-add-keywords 'c++-mode '(("constexpr" . font-lock-keyword-face)))

(provide 'c-c++-setup)
