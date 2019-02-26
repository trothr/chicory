# Dot-Slash-Configure

Chicory benefits from the so-called "standard recipe".

## Dot-Slash-Configure

The standard recipe is ...

    ./configure
    make
    make install

Not all Chicory packages follow the standard recipe,
but it makes integration easier.

## ./configure

It also helps if the `configure` script supports a prefix option.

    ./configure --prefix=/usr/opt/package-version
    make
    # redirect /usr/opt/package-version with a sym-link
    make install

Real example, GnuPG:

    ./configure --prefix=/usr/opt/gnupg-1.4.23
    make
    # redirect /usr/opt/gnupg-1.4.23 with a sym-link
    make install

The redirect is so that you can capture the artifacts of 'make install'.
Point that path at a directory where you want the package to land,
do the 'make install', then remove the sym-link.

## Without ./configure

Not all `configure` scripts support setting an installation prefix.
For that matter, not all packages have a `configure` script.
In those cases, building for Chicory requires other methods
to set the installation prefix and vary from one package to the next.




## Rationale

The following was seen on Twitter for @LinuxPatriarch and seemed fitting:

    After this manner build ye: configure; make; make install.

https://twitter.com/LinuxPatriarch/status/818184227825025026




this page "Dot-Slash-Configure" last updated 2019-Feb-26 (Tuesday) by RMT


