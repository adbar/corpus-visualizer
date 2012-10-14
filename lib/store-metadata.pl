#!/usr/bin/perl


###	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
###	Copyright (C) Adrien Barbaresi, 2012.
###	The Microblog-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


use strict;
use warnings;
use DBI;
use locale;
use utf8;

my (@ligne, $value, $etat, $r);
my $button = 0; 

my ($groupe, $verbe);
my (@tags, $tags, @candidates, %freq, @tri, $num, $w, $jahr, @jahr);
my ($person, $titel, $datum, $ort, $excerpt, $url, $anrede);
my (@person, @titel, @datum, @ort, @excerpt, @url, @anrede);
my ($dbtest, $insmeta, $rows, $j, $temp, @repfin, @tempabs, @absaetze, $prec, @absabs, @abs, $xx);
my $x = 0; my $i = 0; my $t = 1; my $n = 0;
my ($tag, $monat, $datumdef, @datumdef);


# TO BE CHANGED ?

while (<>) {

	#next if ($_ =~ m/^$/);

	$i++;

	if ($_ =~ m/XENDEDESTEXTES/ ) {
		$t++; $n = 0; $x -= 1; $xx = 0;
		#next;
	}


	if ($_ =~ m/XPerson:/ ) {
		$_ =~ s/XPerson: //;
		$person = $_ ;
	}
	elsif ($_ =~ m/XTitel:/ ) {
		$_ =~ s/XTitel: //;
		$titel = $_ ;
	}
	elsif ($_ =~ m/XDatum:/ ) {
		$_ =~ s/XDatum: //;
		$datum = $_ ;
	}
	elsif ($_ =~ m/XOrt:/ ) {
		$_ =~ s/XOrt: //;
		$ort = $_ ;
	}
	elsif ($_ =~ m/XExcerpt:/ ) {
		$_ =~ s/XExcerpt: //;
		$excerpt = $_ ;
	}
	elsif ($_ =~ m/XUrl:/ ) {
		$_ =~ s/XUrl: //;
		$url = $_ ;
	}
	elsif ($_ =~ m/XAnrede:/ ) {
		$_ =~ s/XAnrede: //;
		$_ =~ s/XENDE-META//;
		$anrede = $_ ;

		if ($datum =~ m/[0-9]{4}/) {
			$jahr = $&;
			if ($datum =~ m/^[0-9]{2}/) {$tag = $&;}
			else {$datum =~ m/^[0-9]/; $tag = "0" . $&;}
			if ($datum =~ m/[A-Za-z]+/) {
				if ($datum =~ m/Januar/) {$monat = "01";}
				elsif ($datum =~ m/Februar/) {$monat = "02";}
				elsif ($datum =~ m/März/) {$monat = "03";}
				elsif ($datum =~ m/April/) {$monat = "04";}
				elsif ($datum =~ m/Mai/) {$monat = "05";}
				elsif ($datum =~ m/Juni/) {$monat = "06";}
				elsif ($datum =~ m/Juli/) {$monat = "07";}
				elsif ($datum =~ m/August/) {$monat = "08";}
				elsif ($datum =~ m/September/) {$monat = "09";}
				elsif ($datum =~ m/Oktober/) {$monat = "10";}
				elsif ($datum =~ m/November/) {$monat = "11";}
				elsif ($datum =~ m/Dezember/) {$monat = "12";}
			}
			else {
				if ($datum =~ m/^[0-9].+?\.([0-9]{2})/) {$monat = $1;}
			}

			$datumdef = $jahr . "-" . $monat . "-" . $tag;
			$datumdef =~ s/ //g;
		}
		else {
			$jahr = "NA";
			$datumdef = ();
		}
		$person =~ s/\s+$//;

		# do something here
		if ($person eq "Unbekannt") {
			$person = "k.A.";
		}

		push (@person, $person);
		push (@titel, $titel);
		push (@datum, $datum);
		push (@datumdef, $datumdef);
		push (@jahr, $jahr);
		push (@ort, $ort);
		push (@excerpt, $excerpt);
		push (@url, $url);
		push (@anrede, $anrede);
		$button = 0;
	}
	else {
		print $_;
	}


} # end of while

$dbtest = DBI->connect("dbi:$ENV{'DBI_TYPE'}:$ENV{'DATABASE'}","","");
$dbtest->{AutoCommit} = 0;

	# METADATA HERE
	$insmeta = $dbtest->prepare( "INSERT INTO meta (person, titel, datum, datumdef, jahr, ort, excerpt, url, anrede) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)" );
	$j=0;
	foreach $temp (@person) {
		$insmeta->execute( $temp, $titel[$j], $datum[$j], $datumdef[$j], $jahr[$j], $ort[$j], $excerpt[$j], $url[$j], $anrede[$j] );
		$j++;
	}

$dbtest->commit();
$dbtest->disconnect;
