UNAME := $(shell uname -s)

MAKEFILE=Makefile
RELEASE = 0
DISTRIBUTION=unknown

ifeq ($(UNAME),Darwin)
   MAKEFILE=Makefile.osx
else
   RELEASE := $(shell lsb_release -sr)
   DISTRIBUTION := $(shell lsb_release -si)
endif
ifeq ($(RELEASE),11)
   MAKEFILE = Makefile.sles
else ($(DISTRIBUTION),Fedora)
   MAKEFILE = Makefile.Fedora
endif

all:
	echo $(UNAME) $(DISTRIBUTION) $(RELEASE) "=>" $(MAKEFILE)
	cd src && make -f$(MAKEFILE)
	cp src/silkjs .

bootstrap:
	cd src && make -f$(MAKEFILE) bootstrap
	cp src/bootstrap-silkjs .

debug:
	cd src && make -f$(MAKEFILE) debug
	cp src/silkjs .

clean:
	cd src && make -f$(MAKEFILE) clean

realclean:
	cd src && make -f$(MAKEFILE) realclean

install:
	cd src && make -f$(MAKEFILE) install

uninstall:
	cd src && make -f$(MAKEFILE) uninstall

