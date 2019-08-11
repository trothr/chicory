# Chicory Platforms

Chicory identifies platforms by operating system name
and hardware architecture. The two are usually sufficient
to describe a unique execution environment.

Chicory uses `uname` to identify the host platform
because it is included with all current major POSIX implementations.
The OS name is usually taken as-is from `uname -s`. (One exception
is true SCO for which `uname -s` is the hostname.) The hardware is
often taken from `uname -m` but sometimes from `uname -p` and
frequently requires some normalization. (For example, Chicory will
roll together 32-bit ix86 variants as "i386" unless the finer-grained
name is required.)

The following platforms are viable as of time of writing.

* AIX-powerpc (GCC, IBM XL C)
* CYGWIN-i386
* CYGWIN-x86_64
* Darwin-i386 (GCC)
* Darwin-x86_64 (GCC)
* FreeBSD-amd64 (GCC, LLVM/Clang, also DragonflyBSD)
* FreeBSD-i386 (GCC, LLVM/Clang)
* HPUX-ia64 (GCC, HP ANSI C)
* HPUX-parisc (GCC, HP ANSI C)
* Linux (GCC, LLVM/Clang, ICC, IBM XL C)
* Linux-arm, any of Linux-armel Linux-armhf Linux-arm64
* Linux-i386, any of Linux-i486 Linux-i586 Linux-i686
* Linux-mips, aka Linux-mipsel
* Linux-mips64, or Linux-mips64el
* Linux-ppc
* Linux-ppc64, or Linux-ppc64le
* Linux-s390
* Linux-s390x
* Linux-sparc
* Linux-x86_64, aka Linux-amd64
* Minix-i386 (GCC)
* OpenBSD-amd64 (GCC)
* OpenBSD-i386 (GCC, and MirBSD)
* Solaris-i386 (GCC)
* Solaris-sparc (GCC)

The following platforms might work if they have sufficient POSIX features.

* NetBSD (GCC)
* GNU/Hurd (GCC)
* OpenVMS (HP C compiler)
* Ultrix
* UnixWare
* Tru64 (GCC, Compaq C compiler)
* IRIX (MIPSpro)
* QNX
* OPENSTEP
        
Microsoft Windows works by way of CYGWIN or MKS / Unix Services for Windows
but should also work by way of the Windows Subsystem for Linux.

IBM z/OS has a POSIX subsystem called USS which works fine with Chicory
though the environment is EBCDIC rather than ASCII. Scripts are not
portable between z/OS USS and other POSIX systems without translation.


