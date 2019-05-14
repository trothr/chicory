# Chicory

Chicory is a supplemental software package management scheme
for Unix and Unix-like systems. It works alongside the primary
package manager of the system without interfering.

The first goal of Chicory is to require very little infrastructure.
Many Chicory packages can with no additional support.

## Chicory

Chicory is the key ingredient in a special blend, traditionally of coffee. 

Chicory works well for just a single package, not necessarily a whole
system. Nothing technically prevents someone from using it for a whole
system, but Chicory works best when blended with other methods.

Chicory allows that packages can reside locally, remotely, or on removable
media. It does not require that software packages be shrink-wrapped
for delivery (e.g., RPM, MSI). It supports point-and-shoot.

To date, more than 100 open source packages have been built with Chicory
and deployed on more than a dozen different systems (OS+HW combinations).
See the [current list of packages](doc/packages.md) for the latest
successful builds.

## Features

With Chicory, we can … 

* Deploy Instantly
* Leave the operating system pristine
* Install or upgrade (or downgrade) without disrupting users
* Have protected copies (R/O to each client, container, or virtual machine)
* Have less content to be backed up
* Install mixed releases if needed
* Recognize multi-platform storage savings (preemptive de-duplication)
* (conditionally) Install without admin privileges

## Scripts

Historically, the only script was the `setup` script which might accompany
any single package. The script runs stand-alone without particular
dependencies beyond the environment found on most Unix systems. Similarly,
individual makefile wrappers for Chicory packages have no special
requirements or infrastructure dependencies.

Chicory's main goal is to require as little infrastructure as possible.
For years, Chicory was used with only the master prefix and a `setup` script.

One goal of this project is to deliver a set of scripts which facilitate
simplified operation with Chicory: build, search, install, etc.


