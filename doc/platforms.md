# Chicory Platforms

Chicory identifies platforms by operating system name
and hardware architecture. Those two indicators are usually sufficient
to describe a unique execution environment.

Chicory uses `uname` to identify the host platform
because `uname` is included with all current major POSIX implementations.
The OS name is usually taken as-is from `uname -s`. (One exception
is true SCO for which `uname -s` is the hostname.) The hardware is
often taken from `uname -m` but sometimes from `uname -p` and
frequently requires some normalization. (For example, Chicory will
roll together 32-bit ix86 variants as "i386" unless the finer-grained
name is required.)

The following platforms are viable as of time of writing.

* AIX-powerpc (GCC, IBM XL C)
* AIX-powerpc64, bimodal
* CYGWIN-i386
* CYGWIN-x86_64
* Darwin-i386 (GCC)
* Darwin-x86_64 (GCC)
* Darwin-arm64
* FreeBSD-i386 (GCC, LLVM/Clang)
* FreeBSD-amd64 (GCC, LLVM/Clang, also DragonflyBSD)
* HPUX-ia64 (GCC, HP ANSI C)
* HPUX-parisc (GCC, HP ANSI C)
* Linux-arm, any of Linux-armel Linux-armhf
* Linux-aarch64 (for 64-bit ARM)
* Linux-i386, any of Linux-i486 Linux-i586 Linux-i686
* Linux-x86_64 (for AMD64 or Intel equivalent)
* Linux-mips, aka Linux-mipsel
* Linux-mips64, or Linux-mips64el
* Linux-ppc
* Linux-ppc64, or Linux-ppc64le
* Linux-s390
* Linux-s390x
* Linux-sparc
* Linux-sparc64
* Linux-alpha
* Minix-i386 (GCC)
* NetBSD-i386
* NetBSD-amd64
* OpenBSD-i386 (GCC, and MirBSD)
* OpenBSD-amd64 (GCC)
* SunOS-i386 (GCC), aka Solaris-i386
* SunOS-sparc (GCC), aka Solaris-sparc
* SunOS-sparc64, aka Solaris-sparc64, bimodal

The following platforms might work if they have sufficient POSIX features.

* PCBSD
* GNU/Hurd (GCC)
* OpenVMS (HP C compiler)
* Ultrix
* UnixWare
* Tru64 (GCC, Compaq C compiler)
* IRIX (MIPSpro)
* QNX
* OPENSTEP
        
Chicory on Microsoft Windows works by way of CYGWIN or MKS
(Unix Services for Windows). Chicory works perfectly under
Windows Subsystem for Linux where full POSIX capabilities exist,
but that does not always translate back to the traditional side.

* Windows-x86, aka Windows-i386
* Windows-amd64
* MinGW-i386


IBM z/OS has a POSIX subsystem called USS which works fine with Chicory,
though the environment is EBCDIC rather than ASCII. Scripts are not
portable between z/OS USS and other POSIX systems without translation.
IBM z/VM (CMS) provides the same POSIX subsystem but with limits on
`fork()` in the nucleus.

* OS390-s390
* OS390-s390x


