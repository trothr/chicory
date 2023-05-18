# Chicory Platforms

Chicory identifies platforms by operating system name
and hardware architecture. Those two indicators are usually sufficient
to describe a unique execution environment.

Chicory uses `uname` to identify the host platform because `uname`
is included with all current major POSIX implementations.
The OS name is usually taken as-is from `uname -s`. (One exception
is true SCO for which `uname -s` is the hostname.) The hardware is
often taken from `uname -m` but sometimes from `uname -p` and
frequently requires some normalization. (For example, Chicory will
roll together 32-bit ix86 variants as "i386" unless the finer-grained
name is required.)

The following platforms are viable as of time of writing.

* AIX-powerpc (using either GCC or IBM XL C)
* AIX-powerpc64, bimodal
* CYGWIN-i386
* CYGWIN-x86_64
* Darwin-i386 (GCC)
* Darwin-x86_64 (GCC)
* Darwin-arm64
* FreeBSD-i386 (using either GCC or LLVM/Clang)
* FreeBSD-amd64 (also DragonflyBSD, using either GCC or LLVM/Clang)
* HPUX-ia64 (using either GCC or HP ANSI C)
* HPUX-parisc (using either GCC or HP ANSI C)
* Linux-arm, any of: Linux-armel, Linux-armhf
* Linux-aarch64 (for 64-bit ARM, a.k.a. Linux-arm64)
* Linux-i386, any of: Linux-i486, Linux-i586, Linux-i686
* Linux-x86_64 (for AMD64 or Intel equivalent, a.k.a. Linux-amd64)
* Linux-mips, a.k.a. Linux-mipsel
* Linux-mips64, or Linux-mips64el
* Linux-ppc
* Linux-ppc64, or Linux-ppc64le
* Linux-s390
* Linux-s390x
* Linux-sparc
* Linux-sparc64
* Linux-alpha
* Minix-i386 (uses GCC, never tried ACK)
* NetBSD-i386
* NetBSD-amd64
* OpenBSD-i386 (using GCC or and MirBSD)
* OpenBSD-amd64 (using GCC)
* SunOS-i386 (using GCC), a.k.a. Solaris-i386
* SunOS-sparc (using GCC), a.k.a. Solaris-sparc
* SunOS-sparc64, a.k.a. Solaris-sparc64, bimodal
* SunOS-x86_64, a.k.a. Solaris-x86_64

The following platforms might work if they have sufficient POSIX features.

* PCBSD
* GNU/Hurd (GCC)
* OpenVMS (using HP C compiler)
* Ultrix
* UnixWare
* Tru64 (a.k.a. "Digital Unix" or OSF1, using GCC or Compaq C compiler)
* IRIX (MIPSpro)
* QNX
* OPENSTEP or NeXT

Chicory on Microsoft Windows works by way of CYGWIN or "MKS Toolkit"
(Unix Services for Windows). Chicory works perfectly under WSL
(Windows Subsystem for Linux) where full POSIX capabilities exist,
but that does not always translate back to the traditional side.

* Windows-x86, a.k.a. Windows-i386
* Windows-amd64
* MINGW-i386

IBM z/OS (MVS) has a POSIX subsystem called USS (Unix System Services)
which works fine with Chicory, though the environment is EBCDIC rather
than ASCII. Scripts and sources and textual content are not portable
between z/OS USS and other POSIX systems without translation.

* OS390-s390 (31-bit addressing, 32-bit integers)
* OS390-s390x (64-bit addressing)

IBM z/VM (CMS) provides the same POSIX subsystem but with limits on
`fork()` in the nucleus.


