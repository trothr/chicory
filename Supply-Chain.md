# Software Supply Chain

Chicory facilitates the open source software supply chain by wrapping
various open source software packages in simpler logic *and keeping
original sources* even when other repositories go 404.

The "wrapper" makefile for any Chicory package automatically retrieves
the source for the package but never discards it. Neither `make clean`
nor `make distclean` remove the source archive. (The latter will remove
exploded source *hierarchy*, resetting the project state.)

Chicory is intended to promote the use of open source software.

## Chicory

The effect of a Chicory supply chain is ready-to-run artifacts for
a variety of environments (operating systems) which can be installed
quickly and can be removed (or returned to previous level) immediately.
Chicory explicitly separates package residence from package reference,
meaning that new versions of any package can be installed without
colliding with existing installation, even used concurrently
with other versions.

Chicory relies on a common prefix for software packages
that is independent of vendor or distribution package management.
The prefix is compiled-in, set as an option at configuration time.
You can choose your own Chicory prefix, but existing Chicory packages
assume the prefix `/usr/opt`. This prefix follows Chicory's history
and is similar to other paths such as IBM's `/usr/lpp`.

As an example, GCC 4.8.5 would be found under `/usr/opt/gcc-4.8.5`.
The commands and libraries reside logically under that path. The compiler
"finds itself" via that path. The path itself is a symbolic link
to where the compiler physically resides, which can vary widely.

An essential shortcut is `/usr/opt/gcc` which points to `gcc-4.8.5`.
Users can find the current version of any package usuing the shortcut.
(Call it the unqualified reference, since it does not indicate the version
of the package.) Users would run the compiler as `/usr/opt/gcc/bin/gcc`.

## Chicory Categories

Chicory has the following catetories:

* CD1 - scripting langauges (e.g.: Perl, Python, Rexx, Tcl)
* CD2 - compiler and assembler and related tools
* CD3 - major utilities (e.g., web servers)
* CD4 - common and popular libraries
* CD5 - all things security (SSH, SSL, etc)

These categories are not mandatory but may facilitate managing packages.
For example, if a system is considered vulnerable because users can
compile programs, then removing the CD2 collection is a quick way of
mitigating that vulnerability.

Chicory has a concept of the core system which it does not manage.
Packages which might be part of the "core" can be catetorized under CD0.

## Code Signing

Recently, many (most?) open source packages are cryptographically signed
or similarly assured (a collection of hashes which itself is signed).
The usual means of verification involves the PGP key of the signer.
Vetting of that key is *your responsibility*. Chicory cannot automate
the trust chain. The PGP web of trust is human by design.

Chicory can verify the signature on a source archive (tarball) when
it is downloaded (or any time afterward). Chicory "wrapper" makefiles
include a `verify` target for this operation. Since not all packages are
signed, verifying the signature is not always possible. But where a
signature is available, it is downloaded alongside the source archive.

A number of keys are held in the GitHub project for Chicory.
Keys included with the Chicory project have been through some amount
of vetting, but again, *vetting is your responsibility*. The Chicory
development team cannot be held responsible for rogue keys or other
malware, as hard as we try to keep things secure.

Vetting of keys is *your* responsibility. If the maintainers of Chicory
collections vetted the keys, that would introduce a hierarchy. But also,
you would have to delegate trust, distancing yourself from trust anchors.
For more information see the Code Signing markdown page.

Package artifacts from Chicory are usually delivered as hierarchies,
not as ZIP or TAR archives. The resulting hierarchies are not signed.
Cryptographic trust is at the source level.

## NORD

The NORD system uses Chicory for all packages outside of its core OS
components. The distinction is intentionally vague: What is "the core"?

When you see references to "CD0" in NORD space, those are packages
which can be reliably built via Chicory, and even deployed by Chicory,
but which are considered "core" in some cases. In NORD, such packages
are pre-installed apart from Chicory and not inventoried via Chicory.

https://www.github.com/trothr/nord/

NORD is a complete system (self hosting) and used in limited context
as a production server. It is inspired by Linux From Scratch (LFS)
and similar projects. NORD relies heavily on Chicory, providing
very little on its own. But Chicory is essentially open-ended.

Chicory does not require NORD.

## Unix (POSIX)

Chicory supports a Unix model and requires some aspects of a POSIX
environment, specifically symbolic links. While most of the development
is done on Linux, Chicory does not favor Linux over other systems.

All contemporary computer operating systems have a POSIX interface.
For some systems (such as MS Windows), the POSIX-compliant environment
is layered on top of a non-POSIX base system. For example, Chicory works
on CYGWIN and under WSL but does not work on plain Windows or MINGW.
(Chicory *must* have symbolic links.)

## A word about Darwin

Darwin / Mac OS X locks down the `/usr` directory in such a way that the
administrator cannot create the standard `/usr/opt` prefix directory.
It is acceptable (and for Mac recommended) that `/usr/opt` be a sym-link
to `/var/opt`, but the link has to be created in maintenance mode.

What Darwin does is an option for the administrator in other environments.
To be clear, an administrator can use Chicory and lock-down the content
of the `/usr/opt` directory. Apple takes away that ability from the admin
by locking down `/usr` beyond admin control. Otherwise, the Darwin hack
would be a valuable feature. Sym-linking `/usr/opt` to `/var/opt`
is recommended for most systems.

This Apple restriction is one of the issues mentioned in
[the 'hurdles' doc](Hurdles.md).


