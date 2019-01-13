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

* AIX-powerpc
* CYGWIN-i386
* CYGWIN-x86_64
* Darwin-i386
* Darwin-x86_64
* FreeBSD-amd64
* FreeBSD-i386
* HPUX-ia64
* HPUX-parisc
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
* Minix-i386
* OpenBSD-amd64
* OpenBSD-i386
* Solaris-i386
* Solaris-sparc


