#!/bin/bash
# install.sh

# move .git_print_check.d
printf "\nCreating ~/.git_print_check.d directory\n"
cp -R _git_print_check.d ~/.git_print_check.d

printf "Adding gpc.sh to ~/.bashrc\n"
cat _bashrc >> ~/.bashrc

printf "Done\n\n"
