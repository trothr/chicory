# Dot-Slash-Configure

Chicory benefits from the so-called "standard recipe".

## Dot-Slash-Configure

The standard recipe is ...

    ./configure
    make
    make install

Many packages in the open source world use this sequence to configure
(for the local system), compile, and then install the products of the build.
Not all packages built for Chicory follow this recipe, but it makes
integration easier. (see `--prefix` in the next section)

## ./configure

It also helps if the `configure` script supports a *prefix* option.

    ./configure --prefix=/usr/opt/package-version
    make
    # redirect /usr/opt/package-version with a sym-link
    make install

Real example, GnuPG:

    ./configure --prefix=/usr/opt/gnupg-1.4.23
    make
    # redirect /usr/opt/gnupg-1.4.23 with a sym-link
    make install

The redirect is so that you can capture the artifacts of `make install`.
Point the specified path at a directory where you want the package to land,
do the 'make install', then remove the sym-link. In this example,
create the desired "residence" directory, then create sym-link
`/usr/opt/gnupg-1.4.23` pointing to that directory, then `make install`
and things will happen automagically.

## Without ./configure

Not all `configure` scripts support setting an installation prefix.
For that matter, not all packages have a `configure` script.
In those cases, building for Chicory requires other methods
to set the installation prefix and vary from one package to the next.

The variations range far and wide and are beyond the scope of this document,
but examples can be found in the "wrapper" makefiles in the `arc` collection.

## Rationale

The following was seen on Twitter for @LinuxPatriarch and seemed fitting:

    After this manner build ye: configure; make; make install.

https://twitter.com/LinuxPatriarch/status/818184227825025026

this page "Dot-Slash-Configure" last updated 2023-05-18 (Thursday) by RMT


