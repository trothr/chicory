#
#
#	  Name: makefile (make rules file)
#		make rules for DASH for /usr/opt
#	  Date: 2012-Feb-24 (Friday) for NORD and for COLUG
#
#


# no default
APPLID		=	dash
SC_VRM		=	dash-0.5.9.1
SC_URL		=	\
 http://gondor.apana.org.au/~herbert/dash/files/$(SC_VRM).tar.gz \
 http://gondor.apana.org.au/~herbert/dash/files/$(SC_VRM).tar.gz.sha1sum

# defaults
SC_SOURCE	=	$(SC_VRM)
PREFIX		=	/usr/opt
SYSTEM		=	`./setup --system`
SC_BUILDD	=	$(SC_SOURCE)

# defaults

SC_FETCH	=	wget --passive-ftp --no-clobber $(SC_URL)
#SC_FETCH_BZ	=	wget --passive-ftp --no-clobber $(SC_URL) ; \
#		bzcat $(SC_VRM).tar.bz2 | gzip > $(SC_VRM).tar.gz ; \
#			touch -r $(SC_VRM).tar.bz2 $(SC_VRM).tar.gz

SC_CONFIG	=	./configure --prefix=$(PREFIX)/$(SC_VRM)

SC_BUILD	=	$(MAKE)

SC_FIXUP	=	strip bin/dash

SC_INSTALL	=	$(MAKE) install


.PHONY : clean distclean custom check help

.SUFFIXES: .mk .src .cfg .exe .ins .inv


_default:  _exe
	@echo "$(MAKE): $(SC_VRM) now compiled for $(SYSTEM)."
	@echo "$(MAKE): next step is '$(MAKE) install'."

source:  _src

config:  _cfg
	@echo "$(MAKE): $(SC_VRM) now configured for $(SYSTEM)."
	@echo "$(MAKE): next step is '$(MAKE)'."

install:  _ins
	@echo "$(MAKE): $(SC_VRM) now ready for $(SYSTEM)."
	@echo "$(MAKE): next step is '$(MAKE) clean'."

#
# fetch, if needed, and explode package source
_src:
	@$(MAKE) $(SC_SOURCE)
	@test -d $(SC_SOURCE)
	@rm -f _src src source
	ln -s $(SC_SOURCE) src
	@touch _src src/.
	@sync

#
# configure for this platform
_cfg:  _src
	@test ! -z "$(SC_CONFIG)"
	@test ! -z "$(SC_SOURCE)"
	@test -d $(SC_SOURCE)
	sh -c ' cd $(SC_SOURCE) ; $(SC_CONFIG) '
#	sh -c ' cd $(SC_SOURCE) ; exec $(MAKE) clean '
#	sh -c ' cd $(SC_SOURCE) ; exec $(MAKE) depend '
	@echo "$(SYSTEM)" > _cfg

#
# build it
_exe:  _cfg
#	@test ! -z "$(SC_SOURCE)"
#	@test -d $(SC_SOURCE)
	@test ! -z "$(SC_BUILDD)"
	@test -d $(SC_BUILDD)
	@test ! -z "$(SC_BUILD)"
	echo "$(MAKE): checking that config matches target ..."
	test "`cat _cfg`" = "$(SYSTEM)"
#	sh -c ' cd $(SC_SOURCE) ; $(SC_BUILD) '
	sh -c ' cd $(SC_BUILDD) ; $(SC_BUILD) '
	echo "$(SYSTEM)" > _exe

#
# make this package installable
# (See notes.  This does NOT actually install it locally.)
_ins:  _exe
	echo "$(MAKE): checking that build matches target ..."
	test "`cat _exe`" = "$(SYSTEM)"
	test -d $(PREFIX)
	test ! -d $(PREFIX)/$(SC_VRM)
	rm -f $(PREFIX)/$(SC_VRM)
	test ! -d $(SYSTEM)
	rm -f $(SYSTEM)
	mkdir $(SYSTEM)
	sh -c ' cd $(SYSTEM) ; exec ln -s `pwd` $(PREFIX)/$(SC_VRM) '
	sh -c ' cd $(SC_BUILDD) ; $(SC_INSTALL) ' \
		2>&1 | tee $(SYSTEM)/install.log
	echo "$(SYSTEM)" > _ins
	rm $(PREFIX)/$(SC_VRM)
	if [ ! -z "$(SC_FIXUP)" ] ; then \
	  sh -c ' cd $(SYSTEM) ; $(SC_FIXUP) ' ; fi

#
$(SC_SOURCE):  makefile arc/$(SC_SOURCE).tar.gz
	@rm -rf $(SC_SOURCE)
	tar xzf arc/$(SC_SOURCE).tar.gz
	@test -d $(SC_SOURCE)

#
arc/$(SC_SOURCE).tar.gz:
	@test ! -z "$(SC_SOURCE)"
	@test ! -z "$(SC_FETCH)"
	@test ! -z "$(SC_URL)"
	@echo "$(MAKE): downloading '$(SC_VRM)' source ..."
	@mkdir -p arc
	sh -c ' cd arc ; $(SC_FETCH) '
	@test -s arc/$(SC_SOURCE).tar.gz

#
check:
		@echo "$(MAKE): ... checking ..."
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
#		@echo "APPLID=$(APPLID) ; VRM=$(SC_VRM)"
		@echo "VRM=$(SC_VRM)"
		@echo "$(MAKE): ... checking done"

#
clean:
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
#		# do not remove .src, _src, or src here
		rm -f $(SC_VRM).cfg _cfg \
			$(SC_VRM).exe _exe \
			$(SC_VRM).ins _ins
#		# do not remove .mk or .inv
		if [ -d $(SC_SOURCE) ] ; then \
			sh -c ' cd $(SC_SOURCE) ; \
				exec $(MAKE) clean ' ; fi

#
distclean:
#		@test ! -z "$(APPLID)"
		@test ! -z "$(SC_VRM)"
		@test ! -z "$(SC_SOURCE)"
		rm -f src $(SC_VRM).src _src \
			$(SC_VRM).cfg _cfg \
			$(SC_VRM).exe _exe \
			$(SC_VRM).ins _ins
#		# do not remove .mk or .inv
		rm -rf $(SC_SOURCE)
#		rm -f "$(PREFIX)/$(SC_VRM)"

#
help:
		@echo "Try one of the following:"
		@echo " "
		@echo "	(default) - build binaries for $(SC_VRM)"
		@echo "	install --- set-up for later installation"
		@echo "	clean ----- remove intermediate cruft"
		@echo " "




