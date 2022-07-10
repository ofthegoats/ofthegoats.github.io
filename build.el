(setq backup-directory-alist '(("." .  "~/.emacs.d/backup")))
(setq site-title "ofthegoats' blog")
(setq org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/stylesheet.css\"/>"
      org-html-head-extra ""
      org-html-head-include-default-style nil
      org-html-head-include-scripts t
      ;; header
      org-html-preamble-format '(("en" "<a class=\"alignleft\" href=\"/\">/home/otg</a>
                                        <a class=\"alignright\" href=\"/about.html\">[about]</a>
                                        <a class=\"alignright\" href=\"/rss.xml\">[rss]</a>"))
      org-html-preamble t
      ;; footer
      org-html-postamble-format '(("en" "Unless otherwise noted, the content of this site is licensed under
                                         <a href=\"https://creativecommons.org/licenses/by-nc-sa/4.0/\">CC BY-NC-SA 4.0</a>"))
      org-html-postamble t
      org-html-validation-link nil
      org-html-use-infojs nil)

;; credit https://gitlab.com/to1ne/blog/blob/master/elisp/publish.el#L200-204
(defun otg/org-rss-publish-to-rss (plist filename pub-dir)
  "Publish RSS with PLIST, only when FILENAME is 'rss.org'.
   PUB-DIR is when the output will be placed."
  (if (equal "rss.org" (file-name-nondirectory filename))
      (org-rss-publish-to-rss plist filename pub-dir)))


(defun otg/sitemap-publish-format (title list)
  "Default site map, as a string.
   TITLE is the title of the site map.
   LIST is an internal representation for the files to include,
   as returned by `org-list-to-lisp'.
   PROJECT is the current project."
  (concat "#+TITLE: " title "\n"
          "#+ATTR_HTML: :class sitemap\n"
	        (org-list-to-org list)))

(defun otg/sitemap-publish-entry-format (entry style project)
  "My format for site map ENTRY, as a string.
   ENTRY is a file name. STYLE is the style of the sitemap.
   PROJECT is the current project."
  (cond ((not (directory-name-p entry))
	       (format "** [[file:%s][%s]] (posted/edited %s)"
		             entry
		             (org-publish-find-title entry project)
                 (format-time-string "%d.%m.%y" (org-publish-find-date entry project))))
	      ((eq style 'tree)
	       ;; Return only last subdir.
	       (file-name-nondirectory (directory-file-name entry)))
	      (t entry)))

;; Load the publishing system
(require 'ox-publish)
(load-file "./scripts/ox-rss.el")
(require 'ox-rss)
(load-file "./scripts/htmlize.el")
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
             :sitemap-format-entry 'otg/sitemap-publish-entry-format
             :sitemap-function 'otg/sitemap-publish-format
             :with-creator nil
             :section-numbers nil
             :time-stamp-file nil)
       (list "site-about"
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
             :exclude ".*"
             :include ["about.org"])
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
             :publishing-function 'otg/org-rss-publish-to-rss
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
