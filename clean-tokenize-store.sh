#!/bin/bash


###	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
###	Copyright (C) Adrien Barbaresi, 2012.
###	The Microblog-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


# TODO:
# tagger option




### Paths

INPUT=test.xml

PREP=lib/prep-xml.pl
#POSTTOK=post-tok.pl
#TOK=abbrv-tok-xml.pl

METASTORE=lib/store-metadata.pl
SPACING=lib/sent-and-spacing.pl

## Tagger
#TTSTORE=lib/ttstore.pl
#TAGGER=TreeTagger/bin/tree-tagger
#OPTIONS="-token -lemma"
#PARMFILE=TreeTagger/lib/german-utf8.par
#FILTER=TreeTagger/cmd/filter-german-tags

export ABBR_LIST=lib/abbrev.lex
export FRQ_LIST=lib/myleipzig
export DATABASE=corpus.db
export DBI_TYPE=SQLite
export COMMIT=500000

export DICT=dict touch $DICT

### Init

#chmod +x $TAGGER
#chmod +x $RFTAGGER

cat /dev/null > ${DATABASE}
sqlite3 ${DATABASE}  "CREATE TABLE meta ( tkey INTEGER PRIMARY KEY, person TEXT, titel TEXT, datum TEXT, datumdef DATE, jahr INTEGER, excerpt TEXT, ort TEXT, url TEXT, anrede TEXT, anfang INTEGER, ende INTEGER, absglob TEXT, abslok TEXT, numabs INTEGER, numsent INTEGER );"
sqlite3 ${DATABASE}  "CREATE TABLE alles ( tkey INTEGER PRIMARY KEY, wort TEXT, tag TEXT, lemma TEXT, rfttag TEXT, rftlemma TEXT, stantext TEXT, stanford TEXT, textnum INTEGER, absnum INTEGER, sentnum INTEGER );"


#### BAUSTELLE
echo $SECONDS

< $INPUT perl $PREP | #(Vor-)Lesen
sed -e 's/ //g' -e 's/\([«»]\)/\s\1\s/g' -e 's/[„“”‚’]/\"/g' -e 's/¬/-/g' -e 's/\(–\)/\s\1\s/g' -e 's/s–s//g' -e 's/\s+/\s/g' -e '/^\s*$/d' > temp0
#sed -e 's/\&amp;/\&/g' -e "s/\&apos;/'/g" -e 's/\&quot;/"/g' | #XML
#sed -e 's/\&gt;/>/g' -e 's/\&lt;/</g' |
< temp0 perl $METASTORE |
sed '/^$/d' | perl -pe 's/\r\n|\n|\r/\n\n/g' > temp1
#sed 's/\r\n|\n|\r/\n\n/g' temp0 > temp1
#echo $SECONDS

### TOKENIZATION SCRIPT HERE
< temp1 sed -e 's/ /\n/g' > temp2

echo $SECONDS

#sed 's/\([a-z]\)\(…\)/\1\n\2/' | 
#< temp2 perl $POSTTOK | perl $SPACING > temp3
< temp2 perl $SPACING > temp3

echo $SECONDS

#< temp3 $TAGGER $OPTIONS $PARMFILE | perl $TTSTORE
#echo $SECONDS


#rm temp1 temp2 temp3

sqlite3 ${DATABASE}  "CREATE TABLE refname (anzahl INTEGER, name TEXT);"
sqlite3 ${DATABASE}  "INSERT INTO refname SELECT COUNT(wort), (SELECT person FROM meta WHERE tkey = textnum) AS person FROM alles GROUP BY person;"

sqlite3 ${DATABASE}  "CREATE TABLE refjahr (anzahl INTEGER, jahr INTEGER);"
sqlite3 ${DATABASE}  "INSERT INTO refjahr SELECT COUNT(wort), (SELECT jahr FROM meta WHERE tkey = textnum) AS jahr FROM alles GROUP BY jahr;"


echo $SECONDS
