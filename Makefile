prefix=/usr/local

all:
	@echo "usage: make install"
	@echo "       make uninstall"

install:
	install -m 0755 git-check.perl $(prefix)/bin/git-check

uninstall:
	test -d  $(prefix)/bin && cd $(prefix)/bin && rm -f $(prefix)/bin/git-check
