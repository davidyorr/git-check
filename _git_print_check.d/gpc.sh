# gpc.sh

# read config variables
source ~/.git_print_check.d/gpc.conf

# override the git command
function git {
  command=$1

  if [ $command == "check" ]; then
    :
  else
    "`which git`" "$@"
  fi
}
