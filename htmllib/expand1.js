//	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
//	Copyright (C) Adrien Barbaresi, 2012.
//	The Corpus-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


function modLink(txt){
  var list = document.getElementsByClassName("l");
  for (var i = 0; i < list.length; i++) {
    list[i].href += "?hl=" + txt;
    list[i].target= "_blank";
  }
}
