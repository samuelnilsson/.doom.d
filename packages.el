(package! verb)
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
(package! guess-language)
(package! mermaid-mode)
(package! mermaid-ts-mode)
(package! ob-mermaid)
(package! org-super-agenda)
(unless (string= "" (getenv "DOOM_CALDAV_SERVER"))
  (package! org-caldav))
(unless (string= "" (getenv "DOOM_JIRA_URL"))
  (package! org-jira))
