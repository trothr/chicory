#
#
#	  Name: makefile ('make' rules file)
#		make rules for C3270 at La Casita with /usr/opt
#	  Date: 2006-Mar-02 (Thu)
#
#		This makefile is intended to reside "above" the
#		package source tree,  which is otherwise unmodified
#		from the distribution  (except for published patches),
#		and allows automatic coexistence of builds for
#		different hardware and O/S combinations.
#
#

PREFIX		=		/usr/opt
APPVER		=		c3270-3.3
#SYSTEM		:=		`uname -s`
SYSTEM		:=		`./setup --system`
PREREQ		=		
SOURCE		=		$(APPVER)
# http://easynews.dl.sourceforge.net/sourceforge/x3270/c3270-3.3.5p4.tgz
# http://superb-east.dl.sourceforge.net/sourceforge/x3270/c3270-3.3.5p4.tgz
#      http://umn.dl.sourceforge.net/sourceforge/x3270/c3270-3.3.5p4.tgz
SOURCE_URL	=		\
     http://voxel.dl.sourceforge.net/sourceforge/x3270/c3270-3.3.5p4.tgz
UGROUP		=		linux390
CONFIGOPTS	=		
#				--with-ssl=/usr/opt/openssl
STRIPPABLE	=		bin/c3270 bin/x3270if bin/pr3287


#
# Hopefully, given the substitutions above, what follows is
# largely static from one package to the next and over time.
#

########################################################################

default:	_exe
		@echo " "
		@echo "$(MAKE): '$(APPVER)' now compiled for '$(SYSTEM)'."
		@echo "$(MAKE): next step is '$(MAKE) install'."
		@echo " "

config: 	_cfg
		@echo " "
		@echo "$(MAKE): '$(APPVER)' now configured for '$(SYSTEM)'."
		@echo "$(MAKE): next step is '$(MAKE)'."
		@echo " "

install:	_ins
		@echo " "
		@echo "$(MAKE): '$(APPVER)' now ready for '$(SYSTEM)'."
#		@echo "$(MAKE): next step is '$(MAKE) clean'."
		@echo "$(MAKE): next step is '/sww/$(APPVER)/setup'."
		@echo " "

########################################################################

#
# extract the source
source _src src :
		$(MAKE) $(SOURCE)

#
# configure this package for build/compile on this platform
_cfg:		_src
		@rm -f _cfg
		test -d $(SOURCE)
#		test -d $(PREFIX) ; test -w $(PREFIX)
		@echo "$(MAKE): configuring '$(APPVER)' for '$(SYSTEM)' ..."
		sh -c ' cd $(SOURCE) ; exec ./configure \
			--prefix=$(PREFIX)/$(APPVER) $(CONFIGOPTS) \
				--without-readline '
		-sh -c ' cd $(SOURCE) ; exec $(MAKE) clean '
#		sh -c ' cd $(SOURCE) ; exec $(MAKE) depend '
		echo "$(SYSTEM)" > _cfg

#
# make the executables for this package
_exe:		_cfg
		@rm -f _exe
		@echo "$(MAKE): checking that config matches target ..."
		test "`cat _cfg`" = "$(SYSTEM)"
		@echo "$(MAKE): compiling '$(APPVER)' for '$(SYSTEM)' ..."
		sh -c ' cd $(SOURCE) ; exec $(MAKE) '
		echo "$(SYSTEM)" > _exe

#
# make this package installable
# (See notes.  This does NOT actually install it locally.)
_ins:		_exe
		@rm -f _ins
		@echo "$(MAKE): checking that build matches target ..."
		test "`cat _exe`" = "$(SYSTEM)"
		@echo "$(MAKE): checking that '$(APPVER)' is not yet built for '$(SYSTEM)' ..."
		test ! -d $(SYSTEM)
		test ! -f $(SYSTEM)
		@echo "$(MAKE): checking that staging is safe to use ..."
		test -d $(PREFIX) ; test -w $(PREFIX)
		test ! -d $(PREFIX)/$(APPVER)
		test ! -h $(PREFIX)/$(APPVER)
		@echo "$(MAKE): post-building '$(APPVER)' for '$(SYSTEM)' ..."
		mkdir $(SYSTEM)
		sh -c ' cd $(SYSTEM) ; exec \
			ln -s `pwd` $(PREFIX)/$(APPVER) '
		sh -c ' cd $(SOURCE) ; exec $(MAKE) install ' \
			| tee install.log
		rm $(PREFIX)/$(APPVER)
		if [ ! -z "$(STRIPPABLE)" ] ; then sh -c \
			' cd $(SYSTEM) ; exec strip $(STRIPPABLE) ' ; fi
		mv install.log $(SYSTEM)/.
		echo "$(SYSTEM)" > _ins

#
#
$(SOURCE):	arc/$(SOURCE).tar.gz
		@rm -rf $(SOURCE) ; rm -f src _src
		sh -c ' for F in arc/*.tar.gz ; do \
			zcat $$F | tar xf - ; done '
		test -d $(SOURCE)
#		@rm -f arc/*.applied
#		sh -c ' cd $(SOURCE) ; exec ../repatch.sh ../arc/*.diff '
		@rm -f testfile
		find $(SOURCE) -type f -print \
			| grep -v ' ' | xargs chmod u+w
		find $(SOURCE) -type d -print \
			| grep -v ' ' | xargs chmod u+wx
#		find $(SOURCE) -type d -print \
#			| grep -v ' ' | xargs chgrp $(UGROUP)
#		find $(SOURCE) -type d -print \
#			| grep -v ' ' | xargs chmod g+w
#		rm -f $(PREFIX)/$(APPVER)
		ln -s $(SOURCE) src
#		rm -f $(SOURCE)/config.cache
		touch $(SOURCE)/. _src

#
# retrieve source from Internet
arc/$(SOURCE).tar.gz:
		@test ! -z "$(SOURCE_URL)"
		wget --quiet --passive-ftp --no-clobber $(SOURCE_URL)
#		@test -s $(SOURCE).tar.gz
		@mkdir -p arc
#		mv $(SOURCE).tar.gz arc/.
		mv *.tgz arc/.
		ln -s c3270-3.3.5p4.tgz arc/$(SOURCE).tar.gz

#
# make this package clean enough to re-compile
clean:
		rm -f testfile
		rm -f _ins _exe _cfg core a.out *.o *.a CEEDUMP* \
			$(SOURCE)/core $(SOURCE)/a.out \
			$(SOURCE)/*.o $(SOURCE)/*.a $(SOURCE)/CEEDUMP*
		-if [ -d $(SOURCE) ] ; then \
			sh -c ' cd $(SOURCE) ; exec $(MAKE) clean ' ; fi
# NO!		rm -f $(PREFIX)/$(APPVER)
		rm -f $(SOURCE)/config.cache

#
# restore sources as from distribution
distclean:
		rm -rf $(SOURCE) ; rm -f src _src
		$(MAKE) clean
		@touch "temp:file"
		find . -type f -print | grep ':' | xargs rm
		@touch "temp;file"
		find . -type f -print | grep ';' | xargs rm

#
# (see 'make distclean')
veryclean:	distclean

#
# make this package ready for distribution
dist:
		- $(MAKE) clean
		sitepack .

#
# re-load from the Internet distribution point (if any)
reload:
		webcat -i $(APPVER).tar.gz | gzcat | tar xf -

#
# make this package ready for multi-platform sharing
merged:
		sh -c ' exec ./mkmerged.sh '

# -------------------------------------------------------------------- #
#  We use a test file (called "testfile") to determine if the ID
#  running this 'make' has permission to write to this directory ...
testfile:	makefile
		@echo "$(MAKE): Checking that you have write access to this directory ..."
		test -w .
		@rm -f testfile
		@touch testfile
		@echo "$(MAKE): Checking that your group identity is '$(UGROUP)' ..."
		@id | awk -F'(' '{print $$3}' \
			| awk -F')' '{print $$1}' > testfile
		@test `cat testfile` = "$(UGROUP)"
		@echo "$(MAKE): Checking that your umask setting is 002 ..."
		@umask | sed 's/^0//' | sed 's/^0//' \
			| sed 's/^0//' > testfile
		@test `cat testfile` = "2"
		@rm testfile
		@echo "$(MAKE): All of the above items look correct. Very good."
		@echo " "

help:
	@echo "The makefile in this directory has the following targets:"
	@echo " "
	@echo "        (default) +++++ build binaries"
	@echo "        config ++++++++ configure for this OS & HW"
	@echo "        install +++++++ copy binaries to platform sub-dir"
	@echo "                      + (does NOT perform actual install)"
	@echo "        distclean +++++ remove source"
	@echo "                      + restore source from archive(s)"
	@echo "                      + apply patches"
	@echo " "


