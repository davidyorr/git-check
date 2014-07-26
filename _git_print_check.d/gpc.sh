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
  local output
  local addedFileName
  local tempDiff=$("$gitCommand" diff)
  (
    IFS=$'\n'
    for line in $tempDiff; do
      if [[ $line =~ ^\+\+\+ ]]; then
        file=$(echo "${line#*/}")
        addedFileName=false
      else
        for s in "${PRINT_STATEMENTS[@]}"; do
          if [ $(echo "$line" | grep $s) ]; then
            if [ $addedFileName == false ]; then
              output="$output\n$file\n"
              addedFileName=true
            fi
            output="$output$line\n"
            totalAmount=$((totalAmount + 1))
          fi
        done
      fi
    done

    printf 'Found %d print statement%s\n' $totalAmount $([ "$totalAmount" != 1 ] && echo 's')
    printf "$output"
  )
}
