#!/usr/bin/perl

use strict;
use warnings;

my $unwanted_statements_str = `git config --get-all gitcheck.statements`;
my $highlight_color = "\033[33m\033[1m";
my $highlight_color_length = length($highlight_color);
my $highlight_reset = "\033[0m";
my $highlight_reset_length = length($highlight_reset);

sub main {
	my @output;
	my $total_amount = 0;
	my $added_filename;
	my $added_statement;
	my $curr_line_num;
	my $filename;
	my $diff_output = `git diff HEAD`;
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
			my @unwanted_statements = split(" ", $unwanted_statements_str);
			$added_statement = 0;
			foreach my $unwanted_statement (@unwanted_statements) {
				if (!$added_statement && $line =~ /^\+/ && $line =~ /$unwanted_statement/) {
					if (!$added_filename) {
						push (@output, "");
						push (@output, $filename);
						$added_filename = 1;
					}
					my $match = $line;
					my $offset = 0;
					while ($line =~ /$unwanted_statement/g) {
						substr($match,$+[0]+$offset,0,$highlight_reset);
						substr($match,$-[0]+$offset,0,$highlight_color);
						$offset += $highlight_reset_length + $highlight_color_length;
					}
					push (@output, sprintf("%6s: %s", $curr_line_num, $match));
					$total_amount++;
					$added_statement = 1;
				}
			}
		}
	}

	printf "Found %d unwanted statement%s\n", $total_amount, $total_amount != 1 ? "s" : "";
	foreach my $line (@output) {
		print "$line\n";
	}
	return $total_amount;
}

my $ret_code = main();

exit($ret_code);

