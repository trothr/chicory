#
#
#	  Name: makefile (make rules file)
#		make rules for AutoConf at La Casita with /usr/opt
#	  Date: 2009-Nov-25 (Wed) NORD
#
#

# standard stuff for all apps in this series
PREFIX		=	/usr/opt
#SYSTEM		=	`uname -s`
SYSTEM		=	`./setup --system`

# no default for VRM string
#SC_VRM		=	autoconf-2.65
#SC_VRM		=	autoconf-2.68
SC_VRM		=	autoconf-2.69
APPLID		=	autoconf

# default source directory matches the VRM string
SC_SOURCE	=	$(SC_VRM)

# default build directory matches source directory
SC_BUILDD	=	$(SC_SOURCE)

# no default
SC_URL  =  http://ftp.gnu.org/pub/gnu/$(APPLID)/$(SC_SOURCE).tar.gz \
	http://ftp.gnu.org/pub/gnu/$(APPLID)/$(SC_SOURCE).tar.gz.sig

SC_SOURCE_VERIFY = gpg --verify arc/$(SC_SOURCE).tar.gz.sig
# gpg --keyserver hkp://pgp.mit.edu/ --recv-keys 0xa7a16b4a2527436a

# defaults
SC_FETCH	=	wget --passive-ftp --no-clobber \
					--no-check-certificate $(SC_URL)

# first is default
SC_CONFIG	=	./configure --prefix=$(PREFIX)/$(SC_VRM)

# default
SC_BUILDX	=	$(MAKE)

# default is blank
#SC_FIXUP	=	strip ...

# default
SC_INSTALL	=	$(MAKE) install

SHARED		=	man
STRIPPED	=	
#CUSTOM		=	/sbin/ldconfig

# include $(APPLID).mk

.PHONY : clean distclean custom check help

.SUFFIXES: .mk .src .cfg .exe .ins .inv

_default:	all

all:		_exe
#all:		$(APPLID).exe
		@echo "$(MAKE): $(SC_VRM) now compiled for $(SYSTEM)."
		@echo "$(MAKE): next step is '$(MAKE) install'."

config: 	_cfg
#config: 	$(APPLID).cfg
		@echo "$(MAKE): $(SC_VRM) now configured for $(SYSTEM)."
		@echo "$(MAKE): next step is '$(MAKE)'."

install:	_ins
#install:	$(APPLID).ins
		@echo "$(MAKE): $(SC_VRM) now ready for $(SYSTEM)."
		@echo "$(MAKE): next step is '$(MAKE) clean'."

_src src source :
#source: 	$(APPLID).src
		rm -f  _src src source
		$(MAKE) $(SC_SOURCE)
		test -d $(SC_SOURCE)
		ln -s $(SC_SOURCE) src
		touch _src

_cfg:		_src
		test ! -z "$(SC_SOURCE)"
		test -d $(SC_SOURCE)
		test ! -z "$(SC_BUILDD)"
		@mkdir -p $(SC_BUILDD)
		test -d $(SC_BUILDD)
		if [ -z "$(SC_CONFIG)" ] \
			; then \
		sh -c ' cd $(SC_BUILDD) ; exec ./configure \
				--prefix="$(PREFIX)/$(SC_VRM)" ' \
			; else \
		sh -c ' cd $(SC_BUILDD) ; $(SC_CONFIG) ' \
			; fi
#		sh -c ' cd $(SC_BUILDD) ; exec $(MAKE) clean '
#		sh -c ' cd $(SC_BUILDD) ; exec $(MAKE) depend '
		echo "$(SYSTEM)" > _cfg

_exe:		_cfg
		test ! -z "$(SC_SOURCE)"
		test -d $(SC_SOURCE)
		test ! -z "$(SC_BUILDD)"
		test -d $(SC_BUILDD)
		echo "$(MAKE): checking that config matches target ..."
		test "`cat _cfg`" = "$(SYSTEM)"
		sh -c ' cd $(SC_BUILDD) ; exec $(MAKE) '
		echo "$(SYSTEM)" > _exe

#
# make this package installable
# (See notes.  This does NOT actually install it locally.)
_ins:		_exe
		test ! -z "$(SC_BUILDD)"
		test -d $(SC_BUILDD)
		echo "$(MAKE): checking that build matches target ..."
		test "`cat _exe`" = "$(SYSTEM)"
		test -d $(PREFIX)
		test ! -d $(PREFIX)/$(SC_VRM)
		rm -f $(PREFIX)/$(SC_VRM)
		test ! -d $(SYSTEM)
		rm -f $(SYSTEM)
		mkdir $(SYSTEM)
		sh -c ' cd $(SYSTEM) ; exec \
			ln -s `pwd` $(PREFIX)/$(SC_VRM) '
		sh -c ' cd $(SC_BUILDD) ; exec $(MAKE) install ' \
			2>&1 | tee $(SYSTEM)/install.log
		echo "$(SYSTEM)" > _ins
		rm $(PREFIX)/$(SC_VRM)
		if [ ! -z "$(SC_FIXUP)" ] ; then \
			sh -c " cd $(SYSTEM) ; $(SC_FIXUP) " ; fi

$(SC_SOURCE):	makefile arc/$(SC_SOURCE).tar.gz
		rm -f src _src
		rm -rf $(SC_SOURCE)
		tar xzf arc/$(SC_SOURCE).tar.gz
		test -d $(SC_SOURCE)
		ln -s $(SC_SOURCE) src
		if [ ! -x $(SC_SOURCE)/configure \
			-a -x $(SC_SOURCE)/config ] ; then \
			ln -s config $(SC_SOURCE)/configure ; fi
		if [ ! -x $(SC_SOURCE)/configure \
			-a -x $(SC_SOURCE)/Configure ] ; then \
			ln -s Configure $(SC_SOURCE)/configure ; fi
		touch $(SC_SOURCE)
		echo "$(SYSTEM)" > _src

archive:	arc/$(SC_VRM).tar.gz

arc/$(SC_SOURCE).tar.gz:
#		@test ! -z "$(APPLID)"
#		@echo "$(MAKE): need source for '$(APPLID)' ..."
		@test ! -z "$(SC_VRM)"
		@echo "$(MAKE): downloading '$(SC_VRM)' source ..."
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_URL)"
		@rm -f arc/$(SC_SOURCE).tar.gz
		@mkdir -p arc
		@test -d arc
		sh -c ' cd arc ; $(SC_FETCH) '
		@test -s arc/$(SC_SOURCE).tar.gz

sys:		_ins
		rm -f sys
		ln -s $(SYSTEM) sys
		touch sys

#all:		$(SHARED) $(CUSTOM)

shared:		$(SHARED)

$(SHARED):	_ins
		test -d $(SYSTEM)
		rm -f _shr
		sh -c ' cd $(SYSTEM) ; exec \
			find $(SHARED) -type f -print ' > _shr
		for D in $(SHARED) ; do mkdir -p $$D ; done
		for F in `cat _shr` ; do \
			echo new -d $(SYSTEM)/$$F $$F ; \
			new -d $(SYSTEM)/$$F $$F ; \
			done
		for D in $(SHARED) ; do \
			rm -r $(SYSTEM)/$$D ; \
			ln -s ../$$D $(SYSTEM)/. ; \
			touch $(SYSTEM)/$$D ; \
			done
		rm _shr

custom: 	$(CUSTOM)

#
#
verify:
		$(SC_SOURCE_VERIFY)

#
#
clean:
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_BUILDD)"
#		# do not remove .src, _src, or src here
		rm -f $(SC_VRM).cfg _cfg \
			$(SC_VRM).exe _exe \
			$(SC_VRM).ins _ins
#		# do not remove .mk or .inv
		if [ -d $(SC_BUILDD) ] ; then \
			sh -c ' cd $(SC_BUILDD) ; \
				exec $(MAKE) clean ' ; fi

distclean:
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_BUILDD)"
		@test ! -z "$(SC_SOURCE)"
		rm -f src $(SC_VRM).src _src \
			$(SC_VRM).cfg _cfg \
			$(SC_VRM).exe _exe \
			$(SC_VRM).ins _ins
#		# do not remove .mk or .inv
		rm -rf $(SC_BUILDD)
		rm -rf $(SC_SOURCE)
#		rm -f "$(PREFIX)/$(SC_VRM)"

check:
		@echo "$(MAKE): ... checking ..."
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_BUILDD)"
#		@echo "APPLID=$(APPLID) ; VRM=$(SC_VRM)"
		@echo "VRM=$(SC_VRM)"
		@echo "$(MAKE): ... checking done"

help:
		@echo "Try one of the following:"
		@echo " "
		@echo "	(default) - build binaries for $(SC_VRM)"
		@echo "	install --- set-up for later installation"
		@echo "	clean ----- remove intermediate cruft"
		@echo " "



$(APPLID).ins:	$(APPLID).exe
		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_BUILDD)"
		@test ! -z "$(SC_INSTALL)"
		@rm -f $(SC_VRM).ins $(APPLID).ins
		test -d "$(SC_BUILDD)"
		sh -c ' cd $(SC_BUILDD) ; $(SC_INSTALL) '
	     if [ ! -z "$(SC_FIXUP)" ] ; then sh -c " $(SC_FIXUP) " ; fi
		rm -rf $(SC_SOURCE) $(SC_BUILDD)
#		find / /usr -xdev -newer $(APPLID).exe > $(APPLID).inv
#		touch $(SC_VRM).ins $(APPLID).ins
		touch $(APPLID).ins

$(APPLID).exe:	$(APPLID).cfg
		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_BUILDD)"
		@test ! -z "$(SC_BUILDX)"
		@rm -f $(SC_VRM).exe $(APPLID).exe
		test -d "$(SC_BUILDD)"
		sh -c ' cd $(SC_BUILDD) ; $(SC_BUILDX) '
#		touch $(SC_VRM).exe $(APPLID).exe
		touch $(APPLID).exe

$(APPLID).cfg:	$(APPLID).src
		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_BUILDD)"
		@test ! -z "$(SC_CONFIG)"
		@rm -f $(SC_VRM).cfg $(APPLID).cfg
		test -d "$(SC_BUILDD)"
		sh -c ' cd $(SC_BUILDD) ; $(SC_CONFIG) '
#		touch $(SC_VRM).cfg $(APPLID).cfg
		touch $(APPLID).cfg

$(APPLID).src:	arc/$(SC_VRM).tar.gz
		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@rm -f $(SC_VRM).src $(APPLID).src
		@echo "$(MAKE): [re]making the source tree ..."
		rm -rf $(SC_SOURCE) $(SC_VRM)
		tar xzf arc/$(SC_VRM).tar.gz
		test -d $(SC_SOURCE)
		@chmod -R +w $(SC_SOURCE)
#		touch $(SC_VRM).src $(APPLID).src
		touch $(APPLID).src


#$(APPLID).ins:  $(APPLID).exe
#		@test ! -z "$(APPLID)"
#		@test ! -z "$(SC_VRM)"
#		@test ! -z "$(SC_BUILDD)"
#		@test ! -z "$(SC_INSTALL)"
#		@test ! -d $(SYSTEM)
#		@test ! -d $(PREFIX)/$(SC_VRM)
#		@rm -f $(SC_VRM).ins $(APPLID).ins
#		test -d $(PREFIX)
#		@test -w $(PREFIX)
#		rm -f $(SYSTEM) $(PREFIX)/$(SC_VRM)
#		mkdir $(SYSTEM)
#		sh -c ' cd $(SYSTEM) ; exec \
#			ln -s `pwd` $(PREFIX)/$(SC_VRM) '
#		@test -d $(PREFIX)/$(SC_VRM)/.
#		sh -c ' cd $(SC_BUILDD) ; exec $(SC_INSTALL) '
#		@rm $(PREFIX)/$(SC_VRM)
#		touch $(SC_VRM).ins $(APPLID).ins
#		touch $(APPLID).ins


