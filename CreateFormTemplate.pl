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

open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while (my $line = <$data>) {
	if ($line =~ /FriendlyName/) {
		next;
	}

	chomp $line;
	ProcessLine($line);
	print "\n\n";
}

	createDateJS();
	createDateJSEnum();



# print "$sum\n";

sub ProcessLine {

	my ($line) = @_;

	if ($csv->parse($line)) {

		my @fields = $csv->fields();


		if ($#fields != 7) {
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
		my $toolTip="";
		my $options="";

		for (my $i=0; $i <= $#fields; $i++) {

			my $val = $fields[$i];
			$val =~ s/^\s+|\s+$//g;


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
				$required = lc$val;
			}
			if ($i == 6) {
				$toolTip=$val;
			}
			if ($i == 7) {
				$options=$val;
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

		if ($type eq "") {
			$type = "string";
		}


		if ($required eq "") {
			$required = "false";	
		}

		if ($toolTip ne "") {
			$toolTip = 'uib-tooltip="'.$toolTip.'"';
		}



		print "<!-- *************** HTML TEMPLATE ($codeName) **************** -->\n";

		if ($type =~ /^string$/i) {

			# handle option fields


			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<input type="text" ng-maxlength="'.$ngmax.'" maxlength='.$max.' id="'.$codeName.'" name="'.$codeName.'" class="form-control"'."\n";
			print 'ng-model="fmodel.'.$codeName.'" '.$toolTip.' ng-required="'.$required.'" />'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";



		} elsif ($type =~ /^number$/i) {
			print "number hit --> $friendlyName\n";

			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<input type="number" ng-maxlength="'.$ngmax.'" maxlength='.$max.' id="'.$codeName.'" name="'.$codeName.'" class="form-control"'."\n";
			print 'ng-model="fmodel.'.$codeName.'" '.$toolTip.' ng-required="'.$required.'" />'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";


		} elsif ($type =~ /^date$/i) {

			print '<div class="form-group" show-errors>'."\n";
			print '<div>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-6">'."\n";
			print '<p class="input-group">'."\n";
			print '<input id="'.$codeName.'" name="'.$codeName.'" type="text" class="form-control" uib-datepicker-popup="{{format}}" ng-model="rf.'.$codeName.'" is-open="datePopupStatus.'.$codeName.'" datepicker-options="dateOptions" '.$toolTip.' ng-required="'.$required.'" close-text="Close" alt-input-formats="altInputFormats" readonly />'."\n";
			print '<span class="input-group-btn">'."\n";
			print '<button type="button" class="btn btn-default" ng-click="openDatePopup(enumPopupType.'.$codeName.')"><i class="glyphicon glyphicon-calendar"></i></button>'."\n";
			print '</span>'."\n";
			print '</p>'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";




		} elsif ($type =~ /^checkbox$/i) {
			print "chekbox hit --> $friendlyName\n";






		} elsif ($type =~ /^select$/i) {
		# Parse the options strings for the JS generation.






		} else {
			warn "**** Line does not have a valid type: ****\n\t$line\n";




		}



	} else {
		warn "Line could not be parsed: $line\n";
	}
}


## Create the Javascript collateral code for the Date fields
	
sub createDateJS {

	open(my $data, '<', $file) or die "Could not open '$file' $!\n";
	my $commonOnce = 0;
	while (my $line = <$data>) {
		if ($line =~ /FriendlyName/) {
			next;
		}

		chomp $line;


		if ($csv->parse($line)) {

			my @fields = $csv->fields();


			if ($#fields != 7) {
				warn "There needs to be **six** fields, you have $#fields"
			}


			my $friendlyName="";
			my $codeName="";
			my $type="";

			for (my $i=0; $i <= $#fields; $i++) {

				my $val = $fields[$i];
				$val =~ s/^\s+|\s+$//g;

				if ($i == 0) {
					$friendlyName = $val;
				}
				if ($i == 1) {
					$codeName = $val;
				}
				if ($i == 2) {
					$type = $val;
				}

			}

			if ($type =~ /^date$/i) {
				if ($commonOnce == 0) {
					print "<!-- *************** Generating Javascript template **************** -->\n";
					print '$scope.openDatePopup = popup => {'."\n";
					print 'switch (popup) {'."\n";
						$commonOnce = 1;
				}

				print 'case $scope.enumPopupType.'.$codeName.':'."\n";
				print '$scope.datePopupStatus.'.$codeName.' = true;'."\n";
				print 'break;'."\n";
			}
		}
	}
	print 'default:'."\n";
	print '}'."\n";
	print '};'."\n";
}


sub createDateJSEnum {
	open(my $data, '<', $file) or die "Could not open '$file' $!\n";
	my $commonOnce = 0;
	my $index = 0;
	while (my $line = <$data>) {
		if ($line =~ /FriendlyName/) {
			next;
		}

		chomp $line;


		if ($csv->parse($line)) {

			my @fields = $csv->fields();


			if ($#fields != 7) {
				warn "There needs to be **six** fields, you have $#fields"
			}


			my $friendlyName="";
			my $codeName="";
			my $type="";

			for (my $i=0; $i <= $#fields; $i++) {

				my $val = $fields[$i];
				$val =~ s/^\s+|\s+$//g;

				if ($i == 0) {
					$friendlyName = $val;
				}
				if ($i == 1) {
					$codeName = $val;
				}
				if ($i == 2) {
					$type = $val;
				}

			}

			if ($type =~ /^date$/i) {
				if ($commonOnce == 0) {
					print "<!-- *************** Generating Javascript template **************** -->\n";
					print '$scope.enumPopupType = {'."\n";
					$commonOnce = 1;
				}

				print ''.$codeName.': '.$index++.','."\n";

			}
		}
	}
	print '}'."\n";
}



