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
  local currLineNum
  local diffOutput=$("$gitCommand" diff)
  (
    # allows diffOutput to be read line by line, separated by '\n'
    IFS=$'\n'
    for line in $diffOutput; do
      # iterate the currLineNum
      if [ ${line:0:1} != "-" ] && [ $line != "\\ No newline at end of file" ]; then
        ((currLineNum++))
      fi
      # get the starting line number
      if [[ $line =~ ^\@\@ ]]; then
        currLineNum=$(echo "$line" | grep -o -P '(?<=\+)[0-9]*(?=,)')
        ((currLineNum--))
      fi
      if [[ $line =~ ^\+\+\+ ]]; then
        fileName=$(echo "${line#*/}")
        addedFileName=false
      else
        for s in "${PRINT_STATEMENTS[@]}"; do
          if [ $(echo "$line" | grep $s) ]; then
            if [ $addedFileName == false ]; then
              output="$output\n$fileName\n"
              addedFileName=true
            fi
            output=$(printf '%s%6s: %s' "$output" "$currLineNum" "$line\n")
            ((totalAmount++))
          fi
        done
      fi
    done

    printf 'Found %d print statement%s\n' $totalAmount $([ "$totalAmount" != 1 ] && echo 's')
    printf "$output"
  )
}
