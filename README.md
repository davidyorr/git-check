git check
===============
Check your code for unwanted statements that are being introduced.

Installation
------------

    $ git clone git clone git://github.com/davidyorr/git-check.git
    $ make install

Configuration
-------------
Override and set which statement/s to search for:

    git config --global --replace-all gitcheck.statements "<statements> <separated> <by> <space>"

Add statement/s without overriding:

    git config --global --add "<statement> <or> <statements>"
