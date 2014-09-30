#!/usr/bin/perl

use strict;
use warnings;

my $print_statements_str = `git config --get-all gitcheck.statements`;

sub main {
	my @output;
	my $total_amount = 0;
	my $added_filename;
	my $curr_line_num;
	my $filename;
	my $diff_output = `git diff`;
	my @lines = split /\n/, $diff_output;
	foreach my $line (@lines) {
		if ($line !~ /^\-/ && $line ne "\\ No newline at end of file") {
			$curr_line_num++;
		}
		if ($line =~ /^\@\@/) {
			$line =~ /\+([0-9]+)\,/;
			$curr_line_num = $1 - 1;
		}
		if ($line =~ /^\+\+\+/) {
			$line =~ /\/(.+)/;
			$filename = $1;
			$added_filename = 0;
		} else {
			my @print_statements = split(" ", $print_statements_str);
			foreach my $print_statement (@print_statements) {
				if ($line =~ /$print_statement/ && $line =~ /^\+/) {
					if (!$added_filename) {
						push (@output, "");
						push (@output, $filename);
						$added_filename = 1;
					}
					push (@output, sprintf("%6s: %s", $curr_line_num, $line));
					$total_amount++;
				}
			}
		}
	}

	printf "Found %d unwanted statement%s\n", $total_amount, $total_amount != 1 ? "s" : "";
	foreach my $line (@output) {
		print "$line\n";
	}
}

main();

