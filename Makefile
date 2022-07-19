rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

pubdir=public
srcdir=content

org=$(call rwildcard,$(srcdir),*.org)
html=$(org:$(srcdir)/%.org=$(pubdir)/%.html)

.PHONY: all clean serve publish

all: $(html) $(pubdir)/.nojekyll

clean:
	rm -rf $(pubdir)

serve:
	python3 -m http.server -d $(pubdir)

publish:
	git add public
	git status
	git commit
	git subtree split --prefix public --branch gh-pages
	git push origin/gh-pages gh-pages

$(html): $(org)
	emacs -Q --script ./build.el

$(pubdir)/.nojekyll:
	touch $(pubdir)/.nojekyll
