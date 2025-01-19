#
#         Name: makefile ('make' rules file)
#               make rules for XMITMSGX at La Casita brewed with Chicory
#         Date: 2024-10-13 (Sun) for release 2.1.6, Regina, ooRexx, RPM
#
#               This makefile is intended to reside "above" the
#               package source tree, which is otherwise unmodified
#               from the distribution (except for published patches),
#               and allows automatic coexistence of builds for
#               different hardware and O/S combinations.
#

# standard stuff for all apps in this series
PREFIX		=	/usr/opt

# no default for VRM string
APPLID		=	xmitmsgx
SC_APV		=	2.1.7
SC_VRM		=	$(APPLID)-$(SC_APV)

# default source directory matches the VRM string
SC_SOURCE	=	$(SC_VRM)

# improved fetch and extract logic, variable compression ...
SC_ARC		=	tar.gz
#SC_ARC		=	tar.bz2
#SC_ARC		=	tar.xz
#SC_ARC		=	tar.lz

# varying extract commands to match compression ...
#SC_TAR		=	tar xzf
SC_TAR		=	(gunzip -f | tar xf -) <
#SC_TAR		=	tar xjf
#SC_TAR		=	(bzcat - | tar xf -) <
#SC_TAR		=	tar xJf
#SC_TAR		=	(xzcat - | tar xf -) <
#SC_TAR		=	tar --lzip -xf
#SC_TAR		=	(lzip -d | tar xf -) <

# where to find the source on the internet (no default)
SC_URL		=	\
	   http://www.casita.net/pub/xmitmsgx/$(SC_SOURCE).$(SC_ARC) \
	   http://www.casita.net/pub/xmitmsgx/$(SC_SOURCE).$(SC_ARC).asc

SC_SOURCE_VERIFY = gpg --verify arc/$(SC_SOURCE).$(SC_ARC).asc
#gpg --keyserver hkp://pool.sks-keyservers.net/ --recv-keys 0x96af6544edf138d9

#
SC_FETCH	=	wget --passive-ftp --no-clobber \
				--no-check-certificate $(SC_URL)
SC_CONFIG	=	./configure --prefix=$(PREFIX)/$(SC_VRM)
#				--enable-static --disable-shared
SC_INSTALL	=	$(MAKE) install
#SC_INSTALL	=	$(MAKE) PREFIX=$(PREFIX)/$(SC_VRM) install

# default for this is blank, varies widely per package
SC_FIXUP	=	strip bin/xmitmsg bin/xmiterr
#	sed -i 's~$(PREFIX)/$(SC_VRM)~$(PREFIX)/$(APPLID)~g' lib/pkgconfig/*.pc

#
# default "system" string is generated by the 'setup' script
#SYSTEM		=		`uname`
#SYSTEM		=		`uname -s`
SYSTEM		=		`./setup --system`

#
# default build executable or command is 'make'
SC_BUILDX	=		$(MAKE)

#
# default build directory matches source directory
SC_BUILDD	=		$(SC_SOURCE)

# historical
SHARED		=	man
REQ		=	package-v.r.m

########################################################################

#
# Hopefully, given the substitutions above, what follows is
# largely static from one package to the next and over time.
#

# include $(APPLID).mk

.PHONY:		clean distclean check help

.SUFFIXES:	.mk .src .cfg .exe .ins .inv

_default:	default

all:		default

default:	_exe
#default:	$(APPLID).exe
		@echo " "
		@echo "$(MAKE): '$(SC_VRM)' now compiled for '$(SYSTEM)'."
		@echo "$(MAKE): next step is '$(MAKE) install'."
		@echo " "

config: 	_cfg
#config:	$(APPLID).cfg
		@echo " "
		@echo "$(MAKE): '$(SC_VRM)' now configured for '$(SYSTEM)'."
		@echo "$(MAKE): next step is '$(MAKE)'."
		@echo " "

install:	_ins
#install:	$(APPLID).ins
		@echo " "
		@echo "$(MAKE): '$(SC_VRM)' now ready for '$(SYSTEM)'."
		@echo "$(MAKE): next step is '$(MAKE) clean' or '$(MAKE) distclean'."
		@echo " "

#
# extract the source
_src src source :
#source:	$(APPLID).src
		rm -f  _src src source $(APPLID).src
		$(MAKE) $(SC_SOURCE)
		test -d $(SC_SOURCE)
		ln -sf $(SC_SOURCE) src
		touch _src

#
_cfg:		_src
#config:	$(APPLID).cfg
		rm -f  _cfg $(APPLID).cfg
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

#
# make the executables for this package
_exe:		_cfg
#default:	$(APPLID).exe
		rm -f  _exe $(APPLID).exe
		test ! -z "$(SC_SOURCE)"
		test -d "$(SC_SOURCE)"
		test ! -z "$(SC_BUILDD)"
		test -d $(SC_BUILDD)
		echo "$(MAKE): checking that config matches target ..."
		test "`cat _cfg`" = "$(SYSTEM)"
		@echo "$(MAKE): compiling '$(SC_VRM)' for '$(SYSTEM)' ..."
		sh -c ' cd $(SC_BUILDD) ; $(SC_BUILDX) '
		echo "$(SYSTEM)" > _exe

#
# make this package installable
# (See notes.  This does NOT actually install it locally.)
_ins:		_exe
#install:	$(APPLID).ins
		rm -f  _ins $(APPLID).ins
		test -d "$(SC_SOURCE)"
		echo "$(MAKE): checking that build matches target ..."
		test "`cat _exe`" = "$(SYSTEM)"
#
		@echo "$(MAKE): checking that staging is safe to use ..."
		test -d $(PREFIX) ; test -w $(PREFIX)
#		rm -f "$(PREFIX)/$(SC_VRM)"
		test ! -d "$(PREFIX)/$(SC_VRM)"
		test ! -h "$(PREFIX)/$(SC_VRM)"
#
		@echo "$(MAKE): checking that '$(SC_VRM)' is not yet built for '$(SYSTEM)' ..."
		test ! -d "$(SYSTEM)"
		rm -f $(SYSTEM)
		mkdir "$(SYSTEM)"
		sh -c ' cd "$(SYSTEM)" ; exec \
			ln -s `pwd` "$(PREFIX)/$(SC_VRM)" '
#
		@echo "$(MAKE): post-building '$(SC_VRM)' for '$(SYSTEM)' ..."
		sh -c ' cd $(SC_BUILDD) ; $(SC_INSTALL) ' \
			2>&1 | tee install.log
		echo "$(SYSTEM)" > _ins
		rm "$(PREFIX)/$(SC_VRM)"
		if [ ! -z "$(SC_FIXUP)" ] ; then \
			sh -c " cd $(SYSTEM) ; $(SC_FIXUP) " ; fi
		mv install.log $(SYSTEM)/.


#
#
verify: 	arc/$(SC_SOURCE).$(SC_ARC)
		$(SC_SOURCE_VERIFY)

#
#
clean:
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_BUILDD)"
#		# do not remove .src, _src, or src here
		rm -f core a.out *.o *.a CEEDUMP* \
			$(SC_VRM).cfg _cfg \
			$(SC_VRM).exe _exe \
			$(SC_VRM).ins _ins
#		# do not remove .mk or .inv
		if [ -d $(SC_BUILDD) ] ; then \
			sh -c ' cd $(SC_BUILDD) ; \
				exec $(MAKE) clean ' ; fi
#		rm -f "$(PREFIX)/$(SC_VRM)"


#
# restore sources as from distribution
distclean:
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_BUILDD)"
		@test ! -z "$(SC_SOURCE)"
		rm -f _ins _exe _cfg core a.out *.o *.a CEEDUMP* \
			$(SC_VRM).src _src src source \
			$(SC_VRM).cfg _cfg \
			$(SC_VRM).exe _exe \
			$(SC_VRM).ins _ins
#		# do not remove .mk or .inv
		rm -rf $(SC_BUILDD) $(SC_SOURCE) $(SC_VRM)
		rm -f "$(PREFIX)/$(SC_VRM)"
#		find . -type f -print | grep ':' | xargs -f rm
#		find . -type f -print | grep ';' | xargs -f rm

#
# (see 'make distclean')
veryclean:	distclean

#
#
$(SC_SOURCE):	makefile arc/$(SC_SOURCE).$(SC_ARC)
		rm -f src _src ; rm -rf $(SC_SOURCE)
		$(SC_TAR) arc/$(SC_SOURCE).$(SC_ARC)
		test -d $(SC_SOURCE)
		ln -s $(SC_SOURCE) src
		@sh -c ' ls arc/$(SC_SOURCE).patch* 2> /dev/null ; : ' \
		  | awk '{print "sh ../" $$0}' \
		  | sh -c ' cd $(SC_SOURCE) ; exec sh -x '
		if [ ! -x $(SC_SOURCE)/configure \
			-a -x $(SC_SOURCE)/config ] ; then \
			ln -s config $(SC_SOURCE)/configure ; fi
		if [ ! -x $(SC_SOURCE)/configure \
			-a -x $(SC_SOURCE)/Configure ] ; then \
			ln -s Configure $(SC_SOURCE)/configure ; fi
		touch $(SC_SOURCE)/. _src
		echo "$(SYSTEM)" > _src
#
		find $(SC_SOURCE) -type f -print \
			| grep -v ' ' | xargs chmod u+w
		find $(SC_SOURCE) -type d -print \
			| grep -v ' ' | xargs chmod u+wx

#
#
patched:
		test -d "$(SC_SOURCE)"
		sh -c ' cd "$(SC_SOURCE)" ; exec ../patch.sh ../arc/*.diff '

#
#
archive:	arc/$(SC_SOURCE).$(SC_ARC)

#
# retrieve source from Internet
arc/$(SC_SOURCE).$(SC_ARC):
#		@test ! -z "$(APPLID)"
#		@echo "$(MAKE): need source for '$(APPLID)' ..."
		@test ! -z "$(SC_VRM)"
		@echo "$(MAKE): downloading '$(SC_VRM)' source ..."
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_URL)"
		@rm -f arc/$(SC_SOURCE).$(SC_ARC)
		@mkdir -p arc
		@test -d arc
		sh -c ' cd arc ; $(SC_FETCH) '
		@test -s arc/$(SC_SOURCE).$(SC_ARC)
#		@test -s arc/$(SC_VRM).$(SC_ARC)

sys:		_ins
		rm -f sys
		ln -s $(SYSTEM) sys
		touch sys

#
#
shared:		$(SHARED)

#
#
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

#
#
check:
		@echo "$(MAKE): ... checking ..."
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_BUILDD)"
#		@echo "APPLID=$(APPLID) ; VRM=$(SC_VRM)"
		@echo "VRM=$(SC_VRM)"
		@echo "$(MAKE): ... checking done"

#
#
$(APPLID).src:	arc/$(SC_SOURCE).$(SC_ARC)
		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@rm -f $(SC_VRM).src $(APPLID).src
		@echo "$(MAKE): [re]making the source tree ..."
		rm -rf $(SC_SOURCE) $(SC_VRM)
		$(SC_TAR) arc/$(SC_SOURCE).$(SC_ARC)
		test -d $(SC_SOURCE)
		@chmod -R +w $(SC_SOURCE)
#		touch $(SC_VRM).src $(APPLID).src
		touch $(APPLID).src

#
#
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

#
#
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

#
#
$(APPLID).ins:	$(APPLID).exe
		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		@test ! -z "$(SC_BUILDD)"
		@test ! -z "$(SC_INSTALL)"
		@rm -f $(SC_VRM).ins $(APPLID).ins
		test -d "$(SC_BUILDD)"
		sh -c ' cd $(SC_BUILDD) ; $(SC_INSTALL) '
#		rm -rf $(SC_SOURCE) $(SC_BUILDD)
#		find / /usr -xdev -newer $(APPLID).exe > $(APPLID).inv
		touch $(APPLID).ins
	     if [ ! -z "$(SC_FIXUP)" ] ; then sh -c " $(SC_FIXUP) " ; fi

#
#
help:
	@echo "The makefile in this directory has the following targets:"
	@echo " "
	@echo "        (default) +++++ build binaries for '$(SC_VRM)'"
	@echo "        config ++++++++ configure for this OS & HW"
	@echo "        install +++++++ copy binaries to platform sub-dir"
	@echo "                      + (does NOT perform actual install)"
	@echo "        clean +++++++++ remove intermediate cruft"
	@echo "        distclean +++++ remove source"
	@echo "                      + restore source from archive(s)"
	@echo "                      + apply patches"
	@echo " "


