#
# Makefile for French Python Documentation
# Here is what you can do:
# - make # To git pull, build HTML, and HTML index for the current doc, nice to work
# - make build # To just build local HTML
# - make msgmerge # To merge pot from upstream
# - make rsync # To send generated doc to afpy.org
#
# All (build, msgmerge, and rsync) have theyr _all counterparts to
# apply them to all versions:
#
# - make build_all
# - make msgmerge_all
# - make rsync_all
#
# Note that rsync depends on build, so running `make rsync_all` is
# nice to update the afpy server.
#
# Also, all commands can accept a RELEASE parameter, like:
#
# - make build RELEASE=2.7  # 3.5 is the default
# - make msgmerge RELEASE=2.7  # 3.5 is the default
# - make rsync RELEASE=2.7  # 3.5 is the default
#
# And finally, for the day we'll want to also build PDF and so on:
#
# - make build_all MODE=autobuild-stable
#
# Or, to build + rsync on afpy.org, as rsync depends on build, simply run:
#
# - make rsync_all MODE=autobuild-stable
#
# Modes are: autobuild-stable, autobuild-dev, and autobuild-html,
# documented in gen/src/3.5/Doc/Makefile as we're only delegating the
# real work to the Python Doc Makefile.
#
# We're not compiling 3.2, it's too old, don't even have
# autobuild-html, use an old version of sphinx-doc using the
# deprecated sphinx.ext.refcounting so fsck it, I just don't want to
# have 'if's everywhere for its compatibility.

# May be overriden by calling make RELEASE=2.7
RELEASE := 3.5
RELEASES := 2.7 3.3 3.4 3.5

# May be overriden by calling make MODE=autobuild-stable for a full build
MODE := autobuild-dev-html

PATCHES := $(wildcard scripts/patches/$(RELEASE)/*.patch)

PO_FILES := $(wildcard $(RELEASE)/*.po)
MO_FILES := $(addprefix gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/,$(patsubst %.po,%.mo,$(notdir $(PO_FILES))))

HAS_PDFLATEX := $(shell which pdflatex)
HAS_SVN := $(shell which svn)
HAS_TILDE_IN_PATH := $(shell echo "$(PATH)" | grep -c '~')

.PHONY: $(RELEASES) $(PATCHES) all build_all msgmerge_all rsync_all pull requirements build

all: pull build index_page

build_all: RULE=build
build_all: $(RELEASES)

msgmerge_all: RULE=msgmerge
msgmerge_all: $(RELEASES)

rsync_all: RULE=rsync
rsync_all: $(RELEASES)

$(RELEASES):
	$(MAKE) $(RULE) RELEASE=$@ MODE=$(MODE)

gen/src/%/:
	git clone --depth 1 --branch "$(RELEASE)" https://github.com/python/cpython.git $@

requirements:
	pip3 -q install --user -r scripts/requirements.txt
	patch --batch -s ~/.local/lib/python3.5/site-packages/polib.py scripts/patches/polib.patch >/dev/null || :
ifneq ($(HAS_TILDE_IN_PATH),0)
	$(error "You have a '~' in your $$PATH, sh don't support it.")
endif
ifeq ($(MODE),autobuild-stable)
ifndef HAS_PDFLATEX
	$(error "You need to install pdflatex, typically apt-get install texlive-full")
endif
endif
ifeq ($(RELEASE),3.3)
ifndef HAS_SVN
	$(error "You need to install svn to build 3.3, typically apt-get install subversion")
endif
endif

pull: gen/src/$(RELEASE)/
	git -C gen/src/$(RELEASE) pull --ff-only

$(PATCHES):
	[ -f gen/src/$(RELEASE)/$(notdir $@) ] || ( \
	    cp $@ gen/src/$(RELEASE)/$(notdir $@) && \
	    git -C gen/src/$(RELEASE) apply $(notdir $@))

gen/src/%/mo/fr/LC_MESSAGES/:
	mkdir -p $@

$(MO_FILES): gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/%.mo: $(RELEASE)/%.po gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/
	msgfmt $< -o $@

build: requirements pull gen/src/$(RELEASE)/ $(PATCHES) $(MO_FILES)
ifeq ($(RELEASE)$(MODE),3.3autobuild-dev-html)
	$(MAKE) -C gen/src/$(RELEASE)/Doc/ autobuild-html
else
	$(MAKE) -C gen/src/$(RELEASE)/Doc/ $(MODE)
endif

rsync: build
	# You'll need your ssh public key to be in afpy.org:/home/pythondoc/.ssh/authorized_keys
	rsync -a --delete-delay gen/src/$(RELEASE)/Doc/build/html/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)
	rsync -a gen/src/$(RELEASE)/Doc/dist/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)/archives/

index_page:
	markdown scripts/index.md | sed '/%s/{r /dev/stdin\
	 d}' scripts/index.tpl > www/index.html

clean:
	rm -fr gen

msgmerge:
	mkdir -p $(RELEASE)/
	cd gen/src/$(RELEASE) && sphinx-build -Q -b gettext Doc pot/
	for POT in gen/src/$(RELEASE)/pot/*; \
	do \
	    PO="$$(basename $${POT%.pot}.po)"; \
	    if [ -f "$(RELEASE)/$$PO" ]; \
	    then \
	        msgmerge -U "$(RELEASE)/$$PO" "$$POT"; \
	    else \
	        msgcat -o "$(RELEASE)/$$PO" "$$POT"; \
	    fi \
	done
	@echo "You may commit this by using git commit -u -m '$(RELEASE): merge pot files'"
