# About MuslLibc

This is where "wrapper makefiles" for the MuslLibc runtime library are found.

## Runtime Libraries

There are two runtime libraries in Chicory space as of this writing:
GLIBC and MuslLibc. The latter works well as an alternate for linkage
of static executables and similar artifacts. (You can use MuslLibc
to produce deliverables which do not depend on either shared MuslLibc
nor on GLIBC.) Static linkage against GLIBC could perhaps also fill
this role, but GLIBC is a much bigger package to manage.


