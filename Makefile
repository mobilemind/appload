#!/usr/bin/make -f

##
# appload PROJECT
PROJ := appload

# directories/paths
COMMONLIB := $$HOME/common/lib

# macros/utils
VERSION := $(shell head -1 src/VERSION)
HTMLCOMPRESSORPATH := $(shell [[ 'cygwin' == $$OSTYPE ]] && echo "`cygpath -w $(COMMONLIB)`\\" || echo "$(COMMONLIB)")
HTMLCOMPRESSOR := 'htmlcompressor-1.5.3.jar'
COMPRESSOPTIONS := -t html -c utf-8 --remove-quotes --remove-intertag-spaces --remove-surrounding-spaces min  --preserve-semi --compress-js
TIDY := $(shell hash tidy-html5 2>/dev/null && echo 'tidy-html5' || (hash tidy 2>/dev/null && echo 'tidy' || exit 1))
JSL := $(shell hash jsl 2>/dev/null && echo 'jsl' || exit 1)
GRECHO := $(shell hash grecho &> /dev/null && echo 'grecho' || echo 'printf')
REPLACETOKENS = perl -pi -e 's/_MmVERSION_/$(VERSION)/g;s/_MmBUILDDATE_/$(shell date)/g;' $@

.PHONY: IMG deploy clean

# replace tokens, then check with tidy & jsl (JavaScript Lint)
default: web/appload.htm web/appload.manifest web/appload-examples.htm web/appload.htm.gz web/appload-examples.htm.gz $(VERSIONTXT) | IMG
	@$(GRECHO) '\nmake $(PROJ):' 'Done.\n'

web/%.htm: src/%.htm
	@[ -f '$(HTMLCOMPRESSORPATH)/$(HTMLCOMPRESSOR)' ] || ! echo "ERROR: missing $(HTMLCOMPRESSORPATH)/$(HTMLCOMPRESSOR)"
	@java -jar '$(HTMLCOMPRESSORPATH)/$(HTMLCOMPRESSOR)' $(COMPRESSOPTIONS) -o web/ $^
	@echo "$@: validate with $(TIDY) and $(JSL)"
	@$(REPLACETOKENS)
	@$(TIDY) -eq $@ || [[ $$? -lt 2 ]]
	@$(JSL) -process $@ -nologo -nofilelisting -nosummary || [[ $$? -lt 2 ]]

web/%.gz: web/%
	@printf "\n$^: compress with gzip to $@\n"
	@cp -fp $^ $^.tmp && gzip -9 $^ && mv -f $^.tmp $^

web/%.manifest: src/%.manifest
	@printf "\ncreate $@\n"
	@cp -fpv $^ $@ && $(REPLACETOKENS)

IMG:
	@rsync -uptv src/img/*.* web/img

# deploy
deploy: default
	@printf "\n\tDeploy to: http://$$MYSERVER/me/appload.htm, http://$$MYSERVER/me/appload-examples.htm\n"
	@rsync -pt web/appload-examples.htm.gz "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/appload-examples.htm"
	@rsync -pt web/appload-examples.htm.gz "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/appload-examples.html"
	@rsync -ptv web/appload.htm.gz "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/appload.htm"
	@rsync -ptv web/appload.manifest "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me"
	@rsync -pt web/img/*.* "$$MYUSER@$$MYSERVER:$$MYSERVERHOME/me/img"
	@$(GRECHO) '\nmake $(PROJ):' "Deployed appload v$(VERSION) to http://$$MYSERVER/me/appload.htm\n"

clean:
	rm -Rf web/*
