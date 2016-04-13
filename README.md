git check
===============
Check your code for unwanted statements that are being introduced.

Installation
------------

````console
$ git clone git://github.com/davidyorr/git-check.git
$ cd git-check
$ make install
````

Configuration
-------------

Globally add a statement (`System.out.print` in this example) to search for:

````console
$ git config --global --add gitcheck.statements System.out.print
````

Add a statement (`System.out.err`) to the current repository:

````console
$ git config --add gitcheck.statements System.out.err
````

Or add them to your global `~/.gitconfig` or repository specific `.git/config` file:

````ini
[gitcheck]
    statements = System.out.print
    statements = System.out.err
````
