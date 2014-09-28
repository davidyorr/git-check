#!/bin/sh

print_statements=$(git config "gitcheck.statements")

# check for print statements that are being introduced
run_check () {
	total_amount=0
	set added_filename
	set curr_line_num
	diff_output=$(git diff)
	(
		# allows diff_output to be read line by line, separated by "\n"
		IFS="
		"
		for line in $diff_output; do
			# iterate the curr_line_num
			if [ "$(echo "$line" | head -c1)" != "-" ] && [ $line != "\\ No newline at end of file" ]; then
				curr_line_num=$((curr_line_num+1))
			fi
			# get the starting line number
			if [ "$(echo "$line" | head -c2)" = "@@" ]; then
				curr_line_num=$(echo "$line" | grep -o -P '(?<=\+)[0-9]*(?=,)')
				curr_line_num=$((curr_line_num-1))
			fi
			if [ "$(echo $line | head -c3)" = "+++" ]; then
				filename=$(echo "${line#*/}")
				added_filename=false
			else
				# read print_statements separated by " "
				IFS=" "
				for s in $print_statements; do
					if [ "$(echo "$line" | grep $s)" ] && [ "$(echo "$line" | head -c1)" = "+" ]; then
						if [ "$added_filename" = false ]; then
							printf '\n%s\n' "$filename"
							added_filename=true
						fi
						#output+=($(printf '%6s: %s' "$curr_line_num" "$line"))
						printf '%6s: %s\n' "$curr_line_num" "$line"
						total_amount=$((total_amount+1))
					fi
				done
				# go back to reading diff_output by "\n"
				IFS="
				"
			fi
		done

		printf '\nFound %d print statement%s\n' $total_amount $([ "$total_amount" != 1 ] && echo 's')
	)

	unset total_amount
	unset added_filename
	unset curr_line_num
	unset diff_output
}

run_check