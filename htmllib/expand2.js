//	This script is part of the Corpus-Visualizer project (https://github.com/adbar/corpus-visualizer).
//	Copyright (C) Adrien Barbaresi, 2012.
//	The Corpus-Explorer is freely available under the GNU GPL v3 license (http://www.gnu.org/licenses/gpl.html).


function modLink(txt){
  var list = document.getElementsByTagName("a");
  for (var i = 0; i < list.length; i++) {
    if (!list[i].getAttribute('href')) {
      var num = list[i].firstChild.data;
      list[i].href += "t/" + num + ".html" + "?hl=" + txt;
      list[i].target= "_blank";
    }
  }
}

function modSpan() {
  var spanlist = document.getElementsByTagName("span");
  for (var n = 0; n < spanlist.length; n++) {
  if (!spanlist[n].getAttribute('class')) {
    var inspan = spanlist[n].firstChild.data;
    if (/\(/.test(inspan)) {
      var num2 = /[0-9]+/.exec(inspan);
      var add2 = "i" + num2;
      spanlist[n].setAttribute('class', add2);
      spanlist[n].setAttribute('className', add2);
    }
    else {
      spanlist[n].setAttribute('class', 'c');
      spanlist[n].setAttribute('className', 'c');
    }
  }}
}

//function start() {modLink(); modSpan;}
//window.onload = start;
