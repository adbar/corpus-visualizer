#!/usr/bin/perl


###	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
###	Copyright (C) Adrien Barbaresi, 2012.
###	The Corpus-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


use strict;
use warnings;
use DBI;
use locale;
use utf8;


my (@ligne, @t, @s, @a, $insert, @anfang, @ende, @absglob, @abslok, @numabs, @numsent, @words);
my $t = 1;
my $s = 1;
my $i = 1;
my $x = 1;
my ($absglob, $abslok);
my $numabs = 1;

push (@anfang, $i);

while (<>) {

	if ( $_ =~ m/XENDEDESTEXTES/ ) {
		$t++;
		push (@anfang, $i-1);
		push (@ende, $i-2);
		push (@abslok, $abslok);
		push (@absglob, $absglob);
		push (@numabs, $numabs);
		push (@numsent, $s);
		$s = 1; $x = 1;
		$abslok = (), $absglob = (); $numabs = 1;
	}
	elsif ( $_ =~ m/<newline\/>/ ) {
		unless ($x == 1) {
			{
			no warnings 'uninitialized';
			if (length $abslok) {$abslok .= "," . $x ;} else {$abslok = $x ;}
			if (length $absglob) {$absglob .= "," . $i} else {$absglob = $i ;}
			}
			$numabs++;
		}
	}
	elsif ( $_ =~ m/<sent_bound\/>/ ) {
		$s++;
	}
	else {
		$_ =~ s/<.+?>//g;
		#{
		#no warnings 'uninitialized';
		#if (length $_) {
			push (@t, $t); push (@s, $s); push (@a, $numabs);
			$_ =~ s/^\s//;
			print $_;
			chomp ($_);
			push (@words, $_);
			$i++; $x++;
		#}
		#}
	}


}


my $dbtest = DBI->connect( "dbi:$ENV{'DBI_TYPE'}:$ENV{'DATABASE'}","","");
$dbtest->{AutoCommit} = 0;

#$insert = $dbtest->prepare( "INSERT INTO alles (textnum, absnum, sentnum) VALUES (?, ?, ?)" );
$insert = $dbtest->prepare( "INSERT INTO alles (wort, textnum, absnum, sentnum) VALUES (?, ?, ?, ?)" );

my $j = 0;
pop (@t); #pop (@a); pop (@s);
foreach my $temp (@t) {
	unless ($j == 0) {
		#$insert->execute($temp, $a[$j], $s[$j]);
		$insert->execute($words[$j], $temp, $a[$j], $s[$j]);
	}
	$j++;
}

my $insrep = $dbtest->prepare( "UPDATE meta SET anfang = ?, ende = ?, absglob = ?, abslok = ?, numabs = ?, numsent = ? WHERE tkey = ?" );
$j = 1;
foreach my $temp (@anfang) {
	$insrep->execute( $temp, $ende[$j-1], $absglob[$j-1], $abslok[$j-1], $numabs[$j-1], $numsent[$j-1], $j );
	$j++;
}

$dbtest->commit();
$dbtest->disconnect;
