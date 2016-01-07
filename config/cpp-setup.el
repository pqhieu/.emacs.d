(require 'cc-mode)
(setq c-default-style "stroustrup")

(font-lock-add-keywords 'c++-mode '(("constexpr" . font-lock-keyword-face)))
(font-lock-add-keywords 'c++-mode '(("nullptr" . font-lock-keyword-face)))

(provide 'cpp-setup)
