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


