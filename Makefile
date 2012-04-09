#!/usr/bin/make -f

##
# appload PROJECT
##

# directories/paths
SRCDIR := src
COMMONLIB := $$HOME/common/lib
WEBDIR := web
#files
VERSIONTXT := src/VERSION
# macros/utils
MMBUILDDATE := _MmBUILDDATE_
BUILDDATE := $(shell date)
MMVERSION := _MmVERSION_
VERSION := $(shell head -1 $(VERSIONTXT))
HTMLCOMPRESSORJAR := htmlcompressor-1.5.2.jar
HTMLCOMPRESSORPATH := $(shell [[ 'cygwin' == $$OSTYPE ]] && echo "`cygpath -w $(COMMONLIB)`\\" || echo "$(COMMONLIB)/")
HTMLCOMPRESSOR := java -jar '$(HTMLCOMPRESSORPATH)$(HTMLCOMPRESSORJAR)'
COMPRESSOPTIONS := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min  --preserve-semi --compress-js
TIDY := $(shell hash tidy-html5 2>/dev/null && echo 'tidy-html5' || (hash tidy 2>/dev/null && echo 'tidy' || exit 1))
JSL := $(shell hash jsl 2>/dev/null && echo 'jsl' || exit 1)
GRECHO = $(shell hash grecho &> /dev/null && echo 'grecho' || echo 'printf')
REPLACETOKENS = perl -p -i -e 's/$(MMVERSION)/$(VERSION)/g;' $@; perl -p -i -e 's/$(MMBUILDDATE)/$(BUILDDATE)/g;' $@

# replace tokens, then check with tidy & jsl (JavaScript Lint)
default: web/appload.htm web/appload-examples.htm web/appload.htm.gz web/appload-examples.htm.gz $(VERSIONTXT)
	@$(GRECHO) '\nmake:' 'Done.'

web/%.htm: src/%.htm
	@(echo; \
		echo "$^: compress with $(HTMLCOMPRESSORJAR) to $@"; \
		$(HTMLCOMPRESSOR) $(COMPRESSOPTIONS) -o web/ $^; \
		echo "$@: validate with $(TIDY) and $(JSL)"; \
		$(REPLACETOKENS); \
		$(TIDY) -eq $@ || [[ $$? -lt 2 ]]; \
		$(JSL) -process $@ -nologo -nofilelisting -nosummary || [[ $$? -lt 2 ]]; \
	)

web/%.gz: web/%
		@(printf "\n$^: compress with gzip to $@\n"; \
			cp -fp $^ $^.tmp && gzip -9 $^ && mv -f $^.tmp $^ ; \
		)

# deploy
.PHONY: deploy
deploy: default
	@(printf "\n\tDeploy to: $$MYSERVER/me\n"; \
		scp -2Bp web/appload.htm.gz "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/appload.htm" && \
		scp -2Bp web/appload-examples.htm.gz "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/appload-examples.htm"; \
		scp -2Bp web/appload-examples.htm.gz "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/appload-examples.html" && \
		$(GRECHO) '\nmake:' "Deployed $(PROJ) to $$MYSERVER/me\n" \
	)

.PHONY: clean
clean:
	rm -f $(WEBDIR)/*
