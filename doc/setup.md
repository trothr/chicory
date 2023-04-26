# Chicory `setup` Script

Chicory packages commonly include a `setup` script to facilitate
local installation from shared or networked media. This script runs
stand-alone and creates the requisite symbolic links in the
prefix directory `/usr/opt`. 

The upside to this script is that a Chicory package can be installed
without any other infrastructure. (It will tell you to create the
`/usr/opt` directory if that is missing.) The downside is that it becomes
redundant, clutter, in a large Chicory packages collection. (Would be
better to have a common script apart from the packages in that case.) 

## How it Works

Chicory `setup` detects the directory where it resides and confirms
that it looks like a package directory. The name of the directory
must have the form “package-version”. 

The script confirms that the master prefix (`/usr/opt`) is writable
by the user running the script. This is where installed Chicory packages
are found. The prefix is a directory of symbolic links. Software packages
are configured to refer back to their own content via this prefix.
Most often, the prefix is compiled-in.

The prefix directory doesn’t interfere with package managers.
Chicory packages can be recorded with a package manager, but that
is not mandatory. (Integration with RPM has been demonstrated.) 

## Point and Shoot

To use the Chicory `setup` script, invoke it from the package of interest.
For example, if you have a Chicory build of GCC 4.8.5 (and it’s mounted),
you might simply ...

    /local/opt/gcc-4.8.5/setup

`setup` does the rest. It finds the appropriate platform directory,
e.g. `Linux-x86_64`, and points to that from `/usr/opt/gcc-4.8.5`.
It then renders 4.8.5 as “current” by pointing `/usr/opt/gcc`
at the `gcc-4.8.5` link.

This method does not work until after the package directory has been
made available (e.g. via automounter or on removable media)
or copied in (e.g. via RSYNC). 

## Pay No Attention …

`setup` will attempt to create sym-links for convenience in
`/usr/local/bin` and its siblings. In the case of GCC, this would mean
that `/usr/local/bin/gcc` would be found in a standard command search
via PATH. But these links will fail if you run `setup` without
privileges to write to `/usr/local/bin`. This is normal. If you want
such links to be done automatically then run `setup` with privileges.
Otherwise, run it as a normal user, or just run it under your own ID,
and ignore any errors for the convenience sym-links.


