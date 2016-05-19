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
	chomp $line;
	ProcessLine($line);
}

# print "$sum\n";

sub ProcessLine {

	my ($line) = @_;
	print "$line \n";

	if ($csv->parse($line)) {

		my @fields = $csv->fields();


		for (my $i=0; $i <= $#fields; $i++) {

			my $val = $fields[$i];
			$val =~ s/^\s+|\s+$//g;
			

			# Let do the work and set the values... 
			# FriendlyName	CodeName	Type	Span(9 highest & default)	MaxLength(default 50)	Required

			my $friendlyName="";
			my $codeName="";
			my $type="";
			my $span="";
			my $maxlength="";
			my $required="";


			if ($i == 0) {
				$friendlyName = $val;
			}
			if ($i == 0) {
				$codeName = $val;
			}
			if ($i == 0) {
				$type = $val;
			}
			if ($i == 0) {
				$span = $val;
			}
			if ($i == 0) {
				$maxlength = $val;
			}
			if ($i == 0) {
				$required = $val;
			}




			print $friendlyName."\n";
            



		}

	} else {
		warn "Line could not be parsed: $line\n";
	}


}