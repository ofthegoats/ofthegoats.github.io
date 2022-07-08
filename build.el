(setq backup-directory-alist '(("." .  "~/.emacs.d/backup")))
(setq site-title "ofthegoats' blog")
(setq org-html-validation-link nil
      org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://cdn.simplecss.org/simple.min.css\"/>")
;; TODO replace with own CSS file

;; Load the publishing system
(require 'ox-publish)
(load "~/sources/org-mode-contrib/ox-rss.el")
(require 'ox-rss)
(load "~/sources/htmlize/htmlize.el")
(require 'htmlize)

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "site-html"
             :recursive t
             :exclude (regexp-opt '("index.org" "rss.org" "about.org"))
             :base-directory "./content"
             :publishing-directory "./public"
             :html-link-use-abs-url t
             :html-link-org-files-as-html t
             :publishing-function 'org-html-publish-to-html
             :auto-sitemap t
             :sitemap-filename "index.org"
             :sitemap-title site-title
             :sitemap-style 'list
             :sitemap-sort-files 'anti-chronologically
             :with-creator nil
             :time-stamp-file nil)
       (list "site-static"
             :recursive t
             :base-directory "./content"
             :base-extension "png\\|jpg\\|css"
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment)
       (list "site-rss-feed"
             :base-directory "./content"
             :recursive t
             :exclude (regexp-opt '("index.org" "rss.org" "about.org"))
             :publishing-function 'org-rss-publish-to-rss
             :publishing-directory "./public"
             :rss-extension "xml"
             :html-link-use-abs-url t
             :html-link-org-files-as-html t
             :auto-sitemap t
             :sitemap-filename "rss.org"
             :sitemap-title site-title
             :sitemap-style 'list
             :sitemap-sort-files 'anti-chronologically)
       ))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
