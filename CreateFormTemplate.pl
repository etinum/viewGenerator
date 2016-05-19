#!/usr/bin/perl
require 5.006_001;
use strict;
use warnings;




# print '<div class="form-group" show-errors>'."\n";
# print '<label for="investigator" class="col-sm-3 control-label">Investigator</label>'."\n";
# print '<div class="col-sm-9">'."\n";
# print '<input type="text" ng-maxlength="ng_maxLength" maxlength={{maxLength}} id="investigator" name="investigator" class="form-control"'."\n";
# print 'ng-model="rf.investigator" ng-required="true" />'."\n";
# print '<div class="help-block" ng-messages="repoForm.investigator.$error" ng-show="repoForm.investigator.$touched || submitted">'."\n";
# print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
# print '</div>'."\n";
# print '</div>'."\n";
# print '</div>'."\n";



use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $sum = 0;
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while (my $line = <$data>) {
	if ($line =~ /FriendlyName/) {
		next;
	}

	chomp $line;
	ProcessLine($line);
	print "\n\n\n\n";
}

# print "$sum\n";

sub ProcessLine {

	my ($line) = @_;
	# print "my line: $line \n";

	if ($csv->parse($line)) {

		my @fields = $csv->fields();


		if ($#fields != 5) {
			warn "There needs to be **six** fields, you have $#fields"
		}


		my $friendlyName="";
		my $codeName="";
		my $type="";
		my $span="";
		my $maxLength="";
		my $ngmax="";
		my $max="";
		my $required="";

		for (my $i=0; $i <= $#fields; $i++) {

			my $val = $fields[$i];
			$val =~ s/^\s+|\s+$//g;

			# Let do the work and set the values... 
			# FriendlyName	CodeName	Type	Span(9 highest & default)	MaxLength(default 50)	Required

			if ($i == 0) {
				$friendlyName = $val;
			}
			if ($i == 1) {
				$codeName = $val;
			}
			if ($i == 2) {
				$type = $val;
			}
			if ($i == 3) {
				$span = $val;
			}
			if ($i == 4) {
				$maxLength = $val;
			}
			if ($i == 5) {
				$required = $val;
			}
		}

		# Now you can take these values and print what you need to print
		# Here we will print different template based on the types

		if ($span eq "") {
			$span = "9";
		}
		if ($maxLength eq "") {
			$ngmax = "ng_maxLength";
			$max = "{{maxLength}}";
		} else {
			$ngmax = $maxLength;
			$max = $maxLength
		}


		if ($required eq "") {
			$required = "false";	
		}


		if ($type =~ /^string$/i) {

			# handle option fields


			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<input type="text" ng-maxlength="'.$ngmax.'" maxlength='.$max.' id="'.$codeName.'" name="'.$codeName.'" class="form-control"'."\n";
			print 'ng-model="fmodel.'.$codeName.'" ng-required="'.$required.'" />'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";

		}

		if ($type =~ /^number$/i) {
			print "string hit --> $friendlyName\n";
		}

		if ($type =~ /^date$/i) {
			print "string hit --> $friendlyName\n";
		}

		if ($type =~ /^checkbox$/i) {
			print "string hit --> $friendlyName\n";
		}



	} else {
		warn "Line could not be parsed: $line\n";
	}


}