#!/bin/usr/perl


###	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
###	Copyright (C) Adrien Barbaresi, 2012.
###	The Corpus-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


use strict;
use warnings;
#use locale;
use utf8;


### THERE REALLY SHOULD BE A PARSER HERE...


my ($zeile);


while (<>) {

$zeile = $_;

next if ( ($zeile =~ m/<[?!]/) || ($zeile =~ m/]>/) || ($zeile =~ m/collection>/) || ($zeile =~ m/rohtext>/) );

if ($zeile =~ m/<\/text>/) {
	$zeile = "XENDEDESTEXTES\n";
	print STDOUT $zeile;
	next;
}


##neu
#$zeile =~ s/(\w+)(\W)(–)/$1\n$3\n/g;
#$zeile =~ s/(–)(\W)(\w+)/$1\n$3\n/g;
#$zeile =~ s/([0-9]+)(\W+)(\w)/$1\n$3/g;
#$zeile =~ s/zusammenbringen –/zusammenbringen\n–\n/g;


if ($zeile =~ m/^<text/) {
	$zeile =~ s/<text person="(.+?)" /XPerson: $1\n/;
	$zeile =~ s/titel="(.+?)" /XTitel: $1\n/;
	$zeile =~ s/datum="(.+?)" /XDatum: $1\n/;
	$zeile =~ s/ort="(.*?)" /XOrt: $1\n/;
	$zeile =~ s/untertitel="(.*?)" /XExcerpt: $1\n/;
	$zeile =~ s/excerpt="(.*?)" /XExcerpt: $1\n/;
	$zeile =~ s/url="(.+?)" ?\n?/XUrl: $1\n/;
	$zeile =~ s/info="(.*?)"\n?/XExcerpt: $1\n/;
}

$zeile =~ s/anrede="(.*?)">/XAnrede: $1XENDE-META\n/s;


#### XML

$zeile =~ s/&quot;/"/g;
$zeile =~ s/&apos;/'/g;
$zeile =~ s/&gt;/\>/g;
$zeile =~ s/&lt;/\</g;
$zeile =~ s/&amp;/&/g;


#### TYPO

#$zeile =~ s/[´’]/\n'\n/g;
$zeile =~ s/–+/\n$&\n/;
$zeile =~ s/\- +$//;

#perl -pe 's/([A-Za-z0-9]+)\+[0-9]+/\1/g' | perl -pe 's/\(([A-ZÄÖÜa-zäöü\-]+)\)[A-ZÄÖÜa-zäöü]+/\1\2/g'
$zeile =~ s/([A-Za-z0-9]+)\+[0-9]+/$1/g;
$zeile =~ s/\(([A-ZÄÖÜa-zäöüß\-]+)\)([A-ZÄÖÜa-zäöü])+/$1$2/g;

$zeile =~ s/\.@/\./g;
#$zeile =~ s/¨b/üb/g;


##### ABBRV

$zeile =~ s/[V|v]er\.di/Verdi/;
$zeile =~ s/d\.h\./das heisst/; ### kein ß ?
$zeile =~ s/u\.a\./unter anderen/;
$zeile =~ s/z\.B\./zum Beispiel/;


##### ROMAN
$zeile =~ s/([MDLIVX]+)\.?\s?$/$1/;


##### FIGURES
$zeile =~ s/([0-9]+)\.\s?$/$1/;
$zeile =~ s/^\(?[0-9]+\)$//;
$zeile =~ s/\< 10\.000/\<10\.000/;

print STDOUT $zeile;
}
