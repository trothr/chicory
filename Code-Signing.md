# Code Signing

This page discusses both Code Signing and key vetting.

The problem is this: when you acquire a package, can you trust that
it is from the author? Can you be sure it has not been replaced by,
or injected with, malware?

## PGP Signatures

The majority of packages used in supporting the core system
(largely C sourced, and distributed as compressed TAR files) is signed
with PGP. More often than not, it's signed using GnuPG, but that's a PGP
workalike, so we're talking about the same web of trust is involved.

The standard Chicory "wrapper" makefile has a `verify` target
which drives a check of the signature, if there is a signature.
For the check to pass, your system will need the PGP key of the signer.
Most of these wrapper makefiles have a comment indicating the hex ID
of the key needed.

More than half the packages under the Chicory umbrella are signed.
All of that signing is via PGP. NOT all of the keys used in signing
are found in the Chicory project on GitHub because vetting is a manual
process. (And is ultimately *your* responsibility, not automated.)

## Key Servers

You can find PGP keys used in signing from any of several PGP key servers.
If the key used for signing is in your public "keyring", then the `make
verify` step will succeed. Be careful to only put keys into your public
keyring (i.e., `pubring.gpg`) that have been confirmed as authentic.

It seems to be getting harder to find a usable key server. (see below)
Or perhaps most of the traditional key servers have gotten restrictive.
(See the signature poisoning attack against SKS key servers and OpenPGP.)

The Chicory project maintains a collection of PGP keys which have been
vetted locally. You'll want to vet those keys yourself, but they are at
less risk of poisoning because these copies are static.


https://pgp.surf.nl

https://keys.openpgp.org

https://keyring.debian.org

https://pgp.mit.edu

https://keys.gnupg.net

https://subkeys.pgp.net

https://keyserver.ubuntu.com

https://attester.flowcrypt.com

https://zimmermann.mayfirst.org


## Trust Paths

Be sure that the keys you collect and use are authentic.
Follow the "trust paths" from your own PGP key, through the web of trust,
to the public key of interest.

https://the.earth.li/~noodles/pathfind.html

If a given key is "too far" then you might want to check
several paths. Don't discount other channels besides the web of trust.


## Signature Poisoning

Yet another tragedy of the commons:
the open and publicly facing key servers were not resilient against junk
signatures.

In the summer of 2019, one or more malicious actors "stuffed" the public
keys of a few high profile victims. The result was that the compromised
instances of the public keys of the victims were unusable. Many PGP
implementations could not handle the excess number of signatures.
In any case, processing was slowed and files were bloated.

https://threatpost.com/pgp-ecosystem-targeted-in-poisoning-attacks/146240/

https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f

Since the attack, measures have been taken to dramatically lessen the risk.
The OpenPGP project runs a verifying server.

https://pgp-servers.net/


## Henk Penning

It was Thursday 2022-10-06 when I learned of the 2019 passing of Henk Penning.
It was a loss to the whole Open Source community.

For many years, I turned to the excellent trust web analysis tool hosted
by the University of Utrecht. As of this writing, the site says ... 

    This site is no longer maintained

Henk wrote the path finder used by that site.
I have not found the code, but the aforementioned site is now running it.

<!-- 

The program used to calculate it is public: https://pgp.cs.uu.nl/wotsap/

As is the archive data it uses, updated as of... today https://pgp.cs.uu.nl/archive/wot-0.3/

  -->


## Links

Two memorials to Henk Penning:

https://www.apache.org/memorials/henk_penning.html

https://log.perl.org/2019/09/henk-penning.html

Be aware that OpenPGP requires user IDs (email addresses).

https://dev.gnupg.org/T4393#133689

The Debian project maintains a strong list of keys and signatures.











https://bcn.boulder.co.us/~neal/pgpstat/

https://www.zdnet.com/article/openpgp-flooded-with-spam-by-unknown-hackers/

https://www.securityweek.com/threat-actor-poisons-openpgp-certificates

https://securityaffairs.co/wordpress/88071/hacking/poisoning-pgp-sks-key-network.html

https://keys.openpgp.org/about/faq
https://keys.openpgp.org/search?q=0x81e4ea2778e3fa1b

https://the.earth.li/~noodles/pathfind.html

http://pgp.key-server.io/


https://pgp-servers.net/







