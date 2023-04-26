# Chicory Doesn't Work when ...

Chicory is built on historically well understood POSIX concepts.
When advances in systems and security take an odd turn,
Chicory might not work as smoothly as it did before.

None of the hurdles listed here are show stoppers.
They range from annoyance to time sink, and may provide debate fodder.
In so far as Chicory is meant to extend ecosystems, they are challenges.

## `sysctl`

Linux broke the traditional use of symbolic links with
`fs.protected_hardlinks` and `fs.protected_symlinks` kernel settings.
These magical settings, particularly the latter, prevent most users from
following a symbolic link which is owned by another user (other than root).

If you want to use Chicory entirely as the administrator,
then these new kernel settings should not be a problem.
But if you want non-admin users to use Chicory without privileges,
then disable these settings with

    sudo sysctl -w fs.protected_hardlinks=0
    sudo sysctl -w fs.protected_symlinks=0

## Mac Darwin and `/usr/opt`

The recommended prefix for Chicory is `/usr/opt`.
Apple rendered `/usr` and other directories as unwritable, even by the
superuser, so this directory is not available on MacOS/Darwin systems.

It's good practice that `/usr/opt` be a symbolic link to `/var/opt`.
This turns out to be handy for Apple systems: you can put the disk
into service mode, create the sym-link `/usr/opt`, and then return
the disk to normal mode.

## RSYNC

As of release 3.2.4, RSYNC has a defense against man-in-the-middle
attacks when using `rsync://` protocol. Sometimes this defense gets
in the way of legitimate work. Addressing the conflict is a work in
progress. Some `rsync` clients will not retrieve packages from older
RSYNC servers.


