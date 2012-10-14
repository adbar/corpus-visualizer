#!/usr/bin/perl


###	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
###	Copyright (C) Adrien Barbaresi, 2012.
###	The Corpus-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


use strict;
use warnings;


my $output = "i-list.css";

open (OUTPUT, ">", $output) or die;

my @list = (0 .. 100);

print OUTPUT ".chartlist ";

foreach my $n (@list) {
	print OUTPUT ".i$n, ";
}

print OUTPUT "{
display: block;
position: absolute;
top: 0;
left: 0;
height: 100%;
background: #B8E4F5;
text-indent: -9999px;
overflow: hidden;
line-height: 2em;
}\n";

foreach my $n (@list) {
print OUTPUT ".i$n {width: $n%;}\n"
} #.chartlist 

#print OUTPUT ".s$n {font-size: $n%;}\n"


close (OUTPUT);
