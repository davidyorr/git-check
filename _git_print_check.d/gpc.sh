# gpc.sh

# read config variables
source ~/.git_print_check.d/gpc.conf

# override the git command
function git {
  local command=$1
  local gitCommand=`which git`

  if [ $command == "check" ]; then
    __gpc_git_check
  else
    "$gitCommand" "$@"
  fi
}

# check for print statements that are being introduced
function __gpc_git_check {
  local totalAmount=0
  local s
  for s in "${PRINT_STATEMENTS[@]}"; do
    local printStatement=$("$gitCommand" diff | grep "$s")
    if [ ${#printStatement} == 0 ]; then
      continue
    fi
    local amount=$(echo "$printStatement" | wc -l)
    totalAmount=$((totalAmount + amount))
  done
  printf 'Found %d print statement%s\n' $totalAmount $([ "$totalAmount" != 1 ] && echo 's')
}
