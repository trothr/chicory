# Chicory

Chicory is the key ingredient in a special blend, traditionally of coffee. 

I have presented talks like “Build Your Own Linux” at conferences,
but it’s nothing all that complicated. Chicory works well for just
a single package, not necessarily a whole system. (Nothing stopping
someone from using it for a whole system.) Chicory works best when
blended with other methods. 

NORD is a system which combines Chicory with another package build scheme.
The core of NORD is built with an in-place package wrapper called
“CSCRATCH”, which is described elsewhere. Supplemental packages are
added to NORD using Chicory, which is described here. Chicory does not
require NORD. 

For more than 20 years, I have used this myself, and occasionally gotten
others interested. It was always done with a lot of manual effort.
Recently I have been tinkering with generalized scripts to automate
the whole thing. The focal point is a package prefix directory designed
to be used by admins or non-admins. I'm looking at cascading RC files
for the supporting scripts. 


## Chicory Features

With Chicory, we can … 

* Deploy Instantly
* Leave the operating system pristine
* Install or upgrade (or downgrade) without disrupting users
* Have protected copies (R/O to each client, container, or virtual
machine)
* Have less content to be backed up
* Install mixed releases if needed
* Recognize multi-platform storage savings (preemptive de-duplication)
* (conditionally) Install without admin privileges

Compare the above points with most systems …

* Packages must be [re]deployed on each system (no sharing)
* Deployment is usually disruptive
* Each package demands private (R/W) file storage
* Upgrade and/or removal is messy
* Installed files are vulnerable
* More things needing to be backed up
* Cannot mix releases
* Cannot install without explicit privileges
* Different tools from one distro to the next


## How it Works

Chicory is simple. 
There is a master prefix under which installed Chicory packages are found.
The prefix is a directory of symbolic links. Software packages are
configured to refer back to their own content via this prefix. 

`/usr/opt/package ->` *package-version*
`/usr/opt/package-version ->` */where/it/lives*

The prefix directory doesn’t interfere with package managers.
Chicory packages can be recorded with a package manager.
(Integration with RPM has been demonstrated.) 

## Point and Shoot

Software residence includes any of … 

* local disk (usually R/W)
* CD-ROM (or any R/O media)
* NFS
* SMB
* shared virtual disks
(“minidisks” on z/VM or disk images on VMware, Xen, KVM)
* SAN

You can copy a Chicory package from a repository. But any time a Chicory
package is in-place using one of the above residence options, you can
deploy instantly by simply referencing what's there. It's point-and-shoot.
Get the volume mounted, if it is not already (consider automounter),
run the 'setup' script for the package release of interest, the rest is
automatic. When there is no copying, there is no concern about having
enough space on the target system. It just works. When there is no copying,
there is less stuff needing to be backed up. 

## Chicory Delivery

Chicory can either be available on-demand or can be retrieved remotely.
Some examples of delivery include: 

* networked filesystem (NFS, SMB) 
* RSYNC
* CURL+TAR
* Shared Disk
* Shared Memory
* Shared SAN
* Pre-loaded ROM (CD-ROM)
* Removable Media


## Example: GnuPG 1.4.21

Consider installing GnuPG 1.4.21 via Chicory with the defaults. 

    # default settings
    CHICORY_REPOS=rsync://chic.casita.net/opt
    CHICORY_RESDIR=/local/opt
    CHICORY_PREFIX=/usr/opt
    CHICORY_LINKTO=/usr/local

Not meaning to compete with Brew, suppose we’re on a Mac. 
If you installed GnuPG 1.4.21 via Chicory, you'd wind up with ... 

pull from: 
    rsync://chic.casita.net/opt/gnupg-1.4.21/Darwin-x86_64

install to: 
    /local/opt/gnupg-1.4.21/Darwin-x86_64

link as: 
    /usr/opt/gnupg-1.4.21 -> /local/opt/gnupg-4.1.21/Darwin-x86_64
    /usr/opt/gnupg -> gnupg-1.4.21
    /usr/local/bin/gpg -> /usr/opt/gnupg/bin/gpg

Users would then find ‘gpg’ under /usr/local/bin (assuming PATH includes
it) and the 1.4.21 install would not collide with the stock install in
/usr/bin (if any). 


## Configuration

CHICORY_PREFIX is central and indicates the reference point directory
used by both consumers and producers. Consumers (users) look there for
Chicory packages. Producers (builders of the packages) specify this
directory so packages can refer back to their content. The default is
/usr/opt. The directory should be 'chmod 1777' so anyone can "install
stuff" but only superuser can change what others have done. (e.g.,
Glenn can install something but Rick cannot come along and break that.) 

The default CHICORY_PREFIX, which is compiled-into the body of samples,
is /usr/opt. 

CHICORY_LINKTO indicates where symbolic links should be made. By default
this is /usr/local, which is popular across the industry. If these
secondary sym-links fail, the Chicory package is still usable: simply
point directly. (Add its “bin” directory to your PATH.) It’s reasonable
to sometimes change CHICORY_LINKTO, perhaps to /usr. 

CHICORY_RESDIR tells where downloaded packages are stored. This can be
changed with no negative impact. 

CHICORY_REPOS tells where packages can be downloaded. This can be changed
with no negative impact. 

For RC files, I'm thinking ... 

* /etc/chicoryrc, 
* /etc/sysconfig/chicory, or 
* $HOME/.chicoryrc, 

 ... in that order, all optional, with the last having final say.
Root would set CHICORY_LINKTO to /usr maybe. 

## `chicory-install`

Scripting it means that some of the advantages are not as prominent,
like the ability to fall-back to GPG 1.4.19 with
PATH=/usr/opt/gnupg-1.4.19/bin:$PATH (without having to un-do the update
for everyone). The scripts don’t account for one-off variances like the
your ability (as admin) to reference a commercial package via /usr/opt. 

There is (now) a crude ‘chicory-install’ script which automates fetching,
local copy, and then execution of the ‘setup’ script. There is no need
to install Chicory itself. It’s really just a method. The script is just
Bourne compatible shell with no requirements other than common tools
(‘rsync’ or maybe also ‘curl’, ‘wget’, ‘tar’). 

Packages residing on shared media or removable media can use `setup`
which has been around for years and is fairly honed. 

## Multiple Concurrent Versions

Chicory allows for any number of versions of a package. As an example,
perhaps your current GCC is 4.8.5 but you have a particular need for 4.1.2.
/usr/opt might have … 

gcc -> gcc-4.8.5
gcc-4.8.5 -> /opt/CD2/gcc-4.8.5/Linux-i386
gcc-4.1.2 -> /opt/CD2/gcc-4.1.2/Linux-i386
gcc-3.4.6 -> /local/opt/gcc-3.4.6/Linux-i386

To use the 4.1.2 version, simply put it ahead of others in command PATH
search. 

PATH=/usr/opt/gcc-4.1.2/bin:$PATH ; export PATH

## Multiple Coresident Platforms

Chicory allows that several architectures, several builds of a given
package, can reside on the same media. This is particularly useful for
portable media (flash drives or CD-ROM) and networked media or any
shared media (SAN, virtual disk, etc). 

For Ohio LinuxFest 2016 PGP key signing, a CD-ROM was provided with
several releases of GnuPG, OpenSSL, LibreSSL, and other utilities.
The gnupg-1.4.21 directory contains … 

    drwxr-xr-x  5 rmt rmt  4096 Nov  6 13:20 CYGWIN-x86_64
    drwxr-xr-x  5 rmt rmt  4096 Oct  2 23:18 Linux-i386
    drwxr-xr-x  5 rmt rmt  4096 Oct  2 23:18 Linux-ppc
    drwxr-xr-x  5 rmt rmt  4096 Oct  2 23:18 Linux-s390
    -rwxr-xr-x  1 rmt rmt  4862 Jul 16  2014 setup

Each platform directory contains … 

    drwxr-xr-x  2 rmt rmt  4096 Oct  2 23:18 bin
    drwxr-xr-x  3 rmt rmt  4096 Oct  2 23:17 libexec
    drwxr-xr-x  6 rmt rmt  4096 Oct  2 23:17 share

## Building with Chicory

Building most packages for Chicory involves configuring the prefix.
For packages with a Gnu Autoconf configuration script, this is … 

./configure --prefix=/usr/opt/package-version 

Then do normal ‘make’, but intercept the target directory before doing
`make install`.

## Challenges

No solution can be all things to all users. One thing Chicory lacks is
specific ability to handle bi-modal packages. For example, two flavors
of a package are released: 32-bit and 64-bit. Which do you want to
install? In Chicory, both would normally have the same name. It’s not a
show stopper (/usr/opt is just a collection of sym-links), but it can be
frustrating. 

Chicory is all about pre-compiled software independent from the package
management of the target system. That will expose runtime dependencies.
Be prepared. One mitigation is to build on the oldest release available
and then deploy on systems at that level or at some newer level.
The majority of runtime environments are forward-compatible.
Another mitigation is to minimize runtime dependencies, especially
shared libraries. Packages available in the Chicory sample repositories
typically do use a shared core (e.g., GLIBC) but eschew other shared
libraries (e.g., OpenSSH links OpenSSL support statically). 

## Documentation

Chicory is easy. Explaining it is hard. (There are features not everyone
will use, but some might want, so we’d like to retain them all.) Here’s
an early draft of … 

    Chicory Trickery doc: 
    A bug! Your app did stop. 
    New app pulled down; 
    New features found! 
    Chicory, smarter than Spock! 

Okay, okay, we’re desperate for a last line in the rhyme. Help me out. 

Remain calm. Add Chicory and brew on! 


-- R; <><


Link

    https://docs.google.com/document/d/1AXLqM6g-cGnW-YwUYzO1MLygSrWCypUVpYFpSym4EpI

this page “Chicory.md” last updated 2018-Oct-21 (Sunday) by RMT


