# Software Supply Chain

Chicory facilitates the open source software supply chain by wrapping
various open source software packages in simpler logic *and keeping
original sources* even when other repositories go 404.

## Chicory

The effect of a Chicory supply chain is ready-to-run artifacts for
a variety of environments (operating systems) which can be installed
quickly and can be removed (or returned to previous level) immediately.
Chicory explicitly separates package residence from package reference,
meaning that new versions of any package can be installed without
colliding with existing installation, even used concurrently
with other versions.

Chicory has the following catetories:

* CD1 - scripting langauges (e.g., Perl and Python)
* CD2 - compiler and related tools
* CD3 - major utilities
* CD4 - common and popular libraries
* CD5 - all things security

## NORD

The NORD system uses Chicory for all packages outside of its
core OS components. The distinction is intentionally vague.
What is "the core"?

When you see references to "CD0", those are packages
which can be reliably built via Chicory and even deployed by Chicory
but which are considered "core" in some cases. In NORD, such packages
are pre-installed apart from Chicory and not inventoried via Chicory.

https://www.github.com/trothr/nord/

NORD is a complete system (self hosting) and used in limited context
as a production server. It is inspired by Linux From Scratch (LFS)
and similar projects. NORD relies heavily on Chicory, providing
very little on its own. But Chicory is essentially open-ended.

## Unix (POSIX)

Chicory supports a Unix model and requires some aspects of a POSIX
environment, specifically symbolic links. While most of the development
is done on Linux, Chicory explicitly does not favor Linux.

Darwin / Mac OS X locks down the `/usr` directory in such a way that
the administrator cannot create the standard `/usr/opt` prefix directory.
It is acceptable (and for Mac recommended) that `/usr/opt` be a sym-link
to `/var/opt`, but the link has to be created in maintenance mode.

What Darwin does is an option for the administrator in other environments.
To be clear, an administrator can use Chicory and lock-down the content
of the `/usr/opt` directory. Apple takes away that ability from the admin
by locking down `/usr` beyond admin control. Otherwise, the Darwin hack
would be a valuable feature.


