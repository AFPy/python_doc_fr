#
# Makefile for French Python Documentation
# Here is what you can do:
# - make # To git pull, build HTML, and HTML index for the current doc, nice to work
# - make build # To just build local HTML
# - make msgmerge # To merge pot from upstream
# - make rsync # To send generated doc to afpy.org
#
# All (build, msgmerge, and rsync) have their _all counterparts to
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
# - make build RELEASE=2.7  # 3.6 is the default
# - make msgmerge RELEASE=2.7  # 3.6 is the default
# - make rsync RELEASE=2.7  # 3.6 is the default
#
# And finally, for the day we'll want to also build PDF and so on:
#
# - make build_all MODE=autobuild-dev
#
# Or, to build + rsync on afpy.org, as rsync depends on build, simply run:
#
# - make rsync_all
#
# Modes are: autobuild-stable, autobuild-dev, and autobuild-html,
# documented in gen/src/3.6/Doc/Makefile as we're only delegating the
# real work to the Python Doc Makefile.
#

# May be overriden by calling make RELEASE=2.7
RELEASE := 3.6
RELEASES := 2.7 3.5 3.6

# May be overriden by calling make MODE=autobuild-stable for a full build
MODE := autobuild-dev-html

PO_FILES := $(patsubst $(RELEASE)/%,%,$(wildcard $(RELEASE)/*.po $(RELEASE)/*/*.po))
MO_FILES := $(addprefix gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/,$(patsubst %.po,%.mo,$(PO_FILES)))

CPYTHON_DOCS := $(addsuffix /Doc/,$(addprefix gen/src/,$(RELEASES)))
CPYTHON_POTS := $(subst /Doc/,/pot/,$(CPYTHON_DOCS))

.PHONY: all
all: pull build www/index.html


.tx/config:
	mkdir -p .tx/
	./scripts/gen_tx_config.py .tx/config


gen/src/%/pot/: gen/src/%/Doc/
	cd gen/src/$* && sphinx-build -Q -b gettext -D gettext_compact=0 Doc pot/


gen/src/%/Doc/:
	git clone --depth 1 --branch "$*" https://github.com/python/cpython.git $(subst /Doc/,,$@)


$(MO_FILES): gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/%.mo: $(RELEASE)/%.po
	mkdir -p $(dir $@)
	msgfmt $< -o $@


www/index.html:
	markdown_py scripts/index.md | sed '/%s/{r /dev/stdin\
	 d}' scripts/index.tpl > www/index.html



## Scripts:

.PHONY: build_all
build_all: RULE=build
build_all: $(RELEASES)


.PHONY: msgmerge_all
msgmerge_all: RULE=msgmerge
msgmerge_all: $(RELEASES)


.PHONY: rsync_all
rsync_all: RULE=rsync
rsync_all: $(RELEASES)


.PHONY: requirements
requirements:
	./scripts/check_requirements.sh pdflatex gettext


.PHONY: $(RELEASES)
$(RELEASES):
	$(MAKE) $(RULE) RELEASE=$@ MODE=$(MODE)


.PHONY: pull
pull:
	mkdir -p gen/src/$(RELEASE)/
	git -C gen/src/$(RELEASE) pull --ff-only


.PHONY: clean
clean:
	rm -fr gen


.PHONY: build
build: requirements pull gen/src/$(RELEASE)/Doc/ $(MO_FILES)
	$(MAKE) -C gen/src/$(RELEASE)/Doc/ SPHINXOPTS='-D locale_dirs=../mo -D language=fr -D gettext_compact=0' $(MODE)
	@echo "Doc translated in gen/src/$(RELEASE)/Doc/build/html/"


.PHONY: rsync
rsync:
	$(MAKE) build MODE=autobuild-dev
	# You'll need your ssh public key to be in afpy.org:/home/pythondoc/.ssh/authorized_keys
	rsync -a --delete-delay gen/src/$(RELEASE)/Doc/build/html/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)
	rsync -a gen/src/$(RELEASE)/Doc/dist/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)/archives/


.PHONY: msgmerge
msgmerge: gen/src/$(RELEASE)/Doc/pot/
	scripts/bulk-msgmerge.sh gen/src/$(RELEASE)/pot/ $(RELEASE)/
	@echo "You may commit this by using git commit -u -m '$(RELEASE): merge pot files'"


.PHONY: txpull
txpull: .tx/config
	-tx pull --skip
	./scripts/replicate_translations.py --files $(shell find .tx/ -name '*.po') $(shell find $(RELEASE)/ -name '*.po')


.PHONY: txpush
txpush: .tx/config $(CPYTHON_POTS)
	-tx push -s --skip
	cp -a $(RELEASES) .tx/
	-tx push -t --skip
