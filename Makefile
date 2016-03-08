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
# - make build RELEASE=2.7
# - make msgmerge RELEASE=2.7
# - make rsync RELEASE=2.7
#
# And finally, for the day we'll want to also build PDF and so on, we
# already have the MODE parameter, used for build and rsync:
#
# - make build_all MODE=autobuild-stable
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
RELEASE=3.5
RELEASES=2.7 3.3 3.4 3.5

# May be overriden by calling make MODE=autobuild-stable for a full build
MODE=autobuild-html

PATCHES=$(wildcard scripts/patches/$(RELEASE)/*.patch)

PO_FILES=$(wildcard $(RELEASE)/*.po)
MO_FILES=$(addprefix gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/,$(patsubst %.po,%.mo,$(notdir $(PO_FILES))))

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
	patch --batch -s ~/.local/lib/python3.5/sites-packages/polib.py scripts/patches/polib.patch || :

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

build: requirements gen/src/$(RELEASE)/ $(PATCHES) $(MO_FILES)
	$(MAKE) -C gen/src/$(RELEASE)/Doc/ $(MODE)

rsync: build
	# You'll need your ssh public key to be in afpy.org:/home/pythondoc/.ssh/authorized_keys
	rsync -a --delete-delay gen/src/$(RELEASE)/Doc/build/html/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)
	rsync -a gen/src/$(RELEASE)/Doc/dist/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)/archives/
	# We're reloading apache, else it misses the index.html and whines with directory listing permission denied
	ssh pythondoc@afpy.org sudo /usr/sbin/service apache2 reload

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
