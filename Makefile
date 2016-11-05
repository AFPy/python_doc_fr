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
RELEASES := 2.7 3.4 3.5 3.6

# May be overriden by calling make MODE=autobuild-stable for a full build
MODE := autobuild-dev-html

PO_FILES := $(wildcard $(RELEASE)/*.po)
MO_FILES := $(addprefix gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/,$(patsubst %.po,%.mo,$(notdir $(PO_FILES))))

.PHONY: $(RELEASES) all build_all msgmerge_all rsync_all pull requirements build

all: pull build index_page

.tx/config:
	mkdir -p .tx/
	./scripts/gen_tx_config.py .tx/config

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
	python3 -m pip -q install --user -r scripts/requirements.txt
	./scripts/check_requirements.sh svn pdflatex markdown gettext

pull: gen/src/$(RELEASE)/
	git -C gen/src/$(RELEASE) pull --ff-only

gen/src/%/mo/fr/LC_MESSAGES/:
	mkdir -p $@

$(MO_FILES): gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/%.mo: $(RELEASE)/%.po gen/src/$(RELEASE)/mo/fr/LC_MESSAGES/
	msgfmt $< -o $@

build: requirements pull gen/src/$(RELEASE)/ $(MO_FILES)
	$(MAKE) -C gen/src/$(RELEASE)/Doc/ SPHINXOPTS='-D locale_dirs=../mo -D language=fr' $(MODE)
	@echo "Doc translated in gen/src/$(RELEASE)/Doc/build/html/"

rsync:
	$(MAKE) build MODE=autobuild-dev
	# You'll need your ssh public key to be in afpy.org:/home/pythondoc/.ssh/authorized_keys
	rsync -a --delete-delay gen/src/$(RELEASE)/Doc/build/html/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)
	rsync -a gen/src/$(RELEASE)/Doc/dist/ pythondoc@afpy.org:/home/pythondoc/www/$(RELEASE)/archives/

index_page:
	markdown scripts/index.md | sed '/%s/{r /dev/stdin\
	 d}' scripts/index.tpl > www/index.html

clean:
	rm -fr gen

msgmerge: gen/src/$(RELEASE)/
	cd gen/src/$(RELEASE) && sphinx-build -Q -b gettext -D gettext_compact=0 Doc pot/
	scripts/bulk-msgmerge.sh gen/src/$(RELEASE)/pot/ $(RELEASE)/
	@echo "You may commit this by using git commit -u -m '$(RELEASE): merge pot files'"

txpull: .tx/config
	-tx pull --skip
	./scripts/replicate_translations.py --files $(shell find .tx/ -name '*.po') $(shell find $(RELEASE)/ -name '*.po')

txpush: .tx/config
	cp -a $(RELEASE) .tx/
	-tx push -t --skip
