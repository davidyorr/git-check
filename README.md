git check
===============
Check your code for unwanted statements that are being introduced.

Installation
------------

### wget

    wget -qO- https://raw.githubusercontent.com/davidyorr/git-print-check/master/gitcheck-installer.sh | sudo bash

### curl

    curl -s https://raw.githubusercontent.com/davidyorr/git-print-check/master/gitcheck-installer.sh | sudo bash

Configuration
-------------
Override and set which statement/s to search for:

    git config --global --replace-all gitcheck.statements "<statements> <separated> <by> <space>"

Add statement/s without overriding:

    git config --global --add "<statement> <or> <statements>"
