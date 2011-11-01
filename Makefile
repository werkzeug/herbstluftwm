
include version.mk
include config.mk

# project
SRCDIR = src
SRC = $(wildcard $(SRCDIR)/*.c)
HEADER = $(wildcard $(SRCDIR)/*.h)
OBJ = ${SRC:.c=.o}
TARGET = herbstluftwm
HERBSTCLIENTDOC = doc/herbstclient.txt
HERBSTLUFTWMDOC = doc/herbstluftwm.txt

include rules.mk

all: build-herbstclient doc
clean: clean-herbstclient cleandoc

.PHONY: doc cleandoc install

cleandoc:
	$(call colorecho,RM,doc/herbstclient.1)
	@rm -f doc/herbstclient.1
	$(call colorecho,RM,doc/herbstclient.html)
	@rm -f doc/herbstclient.html
	$(call colorecho,RM,doc/herbstluftwm.1)
	@rm -f doc/herbstluftwm.1
	$(call colorecho,RM,doc/herbstluftwm.html)
	@rm -f doc/herbstluftwm.html

build-herbstclient:
	$(MAKE) -C ipc-client

clean-herbstclient:
	$(MAKE) -C ipc-client clean

doc: doc/herbstclient.1 doc/herbstclient.html doc/herbstluftwm.1 doc/herbstluftwm.html

tar: doc
	tar -czf $(TARFILE) `git ls-files` doc/*.html doc/*.[0-9]

doc/%.1: doc/%.txt
	$(call colorecho,DOC,$@)
	@$(A2X) -f manpage -a "herbstluftwmversion=herbstluftwm $(VERSION)" -a "date=`date +%Y-%m-%d`" $<

doc/%.html: doc/%.txt
	$(call colorecho,DOC,$@)
	@$(ASCIIDOC) $<

install: all
	@echo "==> creating dirs..."
	mkdir -p $(PREFIX)
	mkdir -p $(LICENSEDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(MANDIR)
	mkdir -p $(DOCDIR)
	mkdir -p $(EXAMPLESDIR)
	mkdir -p $(ETCDIR)
	mkdir -p $(ETCDIR)/bash_completion.d/
	mkdir -p $(CONFIGDIR)
	mkdir -p $(ZSHCOMPLETIONDIR)
	@echo "==> copyiing files..."
	install $(TARGET) $(BINDIR)
	install ipc-client/herbstclient $(BINDIR)/
	install -m 644 LICENSE $(LICENSEDIR)
	install -m 644 doc/herbstclient.1 $(MANDIR)/
	install -m 644 doc/herbstluftwm.1 $(MANDIR)/
	install -m 644 doc/herbstclient.html $(DOCDIR)/
	install -m 644 doc/herbstluftwm.html $(DOCDIR)/
	install -m 644 BUGS $(DOCDIR)/
	install -m 755 share/autostart $(CONFIGDIR)/
	install -m 755 share/panel.sh $(CONFIGDIR)/
	install -m 755 share/restartpanels.sh $(CONFIGDIR)/
	install -m 644 share/herbstclient-completion $(ETCDIR)/bash_completion.d/
	install -m 644 share/_herbstclient $(ZSHCOMPLETIONDIR)/
	install -m 644 scripts/README $(EXAMPLESDIR)/
	install -m 755 scripts/*.sh $(EXAMPLESDIR)/

