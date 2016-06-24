#!/usr/bin/perl
require 5.006_001;
use strict;
use warnings;


# You may need to update the csv file to make it more unix friendly for parsing purpose
# tr -d '\15\32' < test.csv > unix.csv ; ./CreateFormTemplate.pl unix.csv

# Global variable
my $formName = "uf";


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
	createSql();



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
				$codeName = lcfirst($val);
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
			$max = '"'.$maxLength.'"';
		}

		if ($type eq "") {
			$type = "string";
		}


		if ($required eq "") {
			$required = "false";	
		}

		if ($toolTip ne "") {
			$toolTip = ' uib-tooltip="'.$toolTip.'" tooltip-trigger="focus"  tooltip-placement="bottom-left" ';
		}



		print "<!-- *************** HTML TEMPLATE ($codeName) **************** -->\n";

		if ($type =~ /^string$/i) {


			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<input type="text" ng-maxlength="'.$ngmax.'" maxlength='.$max.' id="'.$codeName.'" name="'.$codeName.'" class="form-control"'."\n";
			print 'ng-model="'.$formName.'.'.$codeName.'"'.$toolTip.'ng-required="'.$required.'" autocomplete="off" />'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";



		} elsif ($type =~ /^textarea$/i) {


			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<textarea ng-maxlength="'.$ngmax.'" maxlength='.$max.' id="'.$codeName.'" name="'.$codeName.'" class="form-control"'."\n";
			print 'ng-model="'.$formName.'.'.$codeName.'"'.$toolTip.'ng-required="'.$required.'" autocomplete="off" ></textarea>'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";

		} elsif ($type =~ /^number$/i) {

			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<input type="number" ng-maxlength="'.$ngmax.'" maxlength='.$max.' id="'.$codeName.'" name="'.$codeName.'" class="form-control"'."\n";
			print 'ng-model="'.$formName.'.'.$codeName.'"'.$toolTip.'ng-required="'.$required.'" autocomplete="off" />'."\n";
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
			print '<input id="'.$codeName.'" name="'.$codeName.'" type="text" class="form-control" uib-datepicker-popup="{{format}}" ng-model="'.$formName.'.'.$codeName.'" is-open="datePopupStatus.'.$codeName.'" datepicker-options="dateOptions"'.$toolTip.'ng-required="'.$required.'" close-text="Close" alt-input-formats="altInputFormats" readonly />'."\n";
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
			print '<div class="form-group">'."\n";
			print '<div class="col-sm-offset-3 col-sm-9">'."\n";
			print '<div class="checkbox">'."\n";
			print '<label>'."\n";
			print '<input type="checkbox"'."\n";
			print 'ng-model="'.$formName.'.'.$codeName.'"'.$toolTip.'/>'.$friendlyName.''."\n";
			print '</label>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";



		} elsif ($type =~ /^select$/i) {
		# Parse the options strings for the JS generation.
			
			print '<div class="form-group" show-errors>'."\n";
			print '<label for="'.$codeName.'" class="col-sm-3 control-label">'.$friendlyName.'</label>'."\n";
			print '<div class="col-sm-'.$span.'">'."\n";
			print '<select id="'.$codeName.'" name="'.$codeName.'" class="form-control" data-ng-options="item for item in '.$codeName.'Options track by item"'."\n";
			print 'data-ng-model="rf.'.$codeName.'" ng-required="'.$required.'"'.$toolTip.'>'."\n";
			print '<option value="">---Please select---</option>'."\n";
			print '</select>'."\n";
			print '<div class="help-block" ng-messages="myForm.'.$codeName.'.$error" ng-show="myForm.'.$codeName.'.$touched || submitted">'."\n";
			print '<div ng-messages-include="app/html/error-messages.html"></div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";
			print '</div>'."\n";


			print "<!-- XXXXXXX Javascript dropdown for: ($codeName) XXXXXXX -->\n";
			# @personal = split(/:/, $info);
			my @optionSplit = split(/;/,$options);
			if ($#optionSplit <= 1) {
				print "<!-- YOu will need to add the options manually in Javascript -->\n";
				print '$scope.'.$codeName.'Options = [\'Opt1\', \'Opt2\'];'."\n";
			} else {


				print '$scope.'.$codeName.'Options = [';
				my $isFirst = 1;
				foreach my $option (@optionSplit) { 
      		$option =~ s/^\s+|\s+$//g;
				  if ($isFirst == 1) {
				  	print '\''.$option.'\'';
				  	$isFirst = 0;
				  } else {
				  	print ',';
	  				print '\''.$option.'\'';
				  }
				} 

				print '];'."\n";

			}
			# print '$scope.favColorOptions = ['Red', 'Blue', 'Orange', 'Black', 'White'];'."\n";






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



sub createSql {


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
			my $maxLength="";


			for (my $i=0; $i <= $#fields; $i++) {

				my $val = $fields[$i];
				$val =~ s/^\s+|\s+$//g;

				if ($i == 1) {
					$codeName = $val;
				}
				if ($i == 2) {
					$type = $val;
				}
				if ($i == 4) {
					$maxLength = $val;
				}


			}

			if ($commonOnce == 0) {
				print "\n\n\n\n<!-- *************** Generating Optional SQL Script **************** -->\n";
				print 'CREATE TABLE [dbo].<TABLE_NAME>('."\n";
				$commonOnce = 1;
			}


			if ($type =~ /^string$/i) {
				if ($maxLength <= 100) {
					$maxLength = 100
				}
				print '['.ucfirst$codeName.'] [NCHAR] ('.$maxLength.') NULL,'."\n";
			} elsif ($type =~ /^number$/i) {
				print '['.ucfirst$codeName.'] [INT] NULL,'."\n";
			} elsif ($type =~ /^date$/i) {
				print '['.ucfirst$codeName.'] [DATETIME] NULL,'."\n";
			} elsif ($type =~ /^checkbox$/i) {
				print '['.ucfirst$codeName.'] [BIT] NULL,'."\n";
			} elsif ($type =~ /^select$/i) {
				print '['.ucfirst$codeName.'] [NCHAR] (100) NULL,'."\n";
			}






		}
	}
	print ')'."\n";

}

