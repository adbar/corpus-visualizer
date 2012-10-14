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
    }
  }
}


function appendKW() {

var request = new XMLHttpRequest();
request.open("GET", "uebersicht.html", true);
request.onreadystatechange = function() {
  if (request.readyState === 4) {  // Makes sure the document is ready to parse.
    if (request.status === 200) {  // Makes sure it's found the file.
      //allText = txtFile.responseText;
      //lines = txtFile.responseText.split("\n"); // Will separate each line into an array
      var kwlines = getElementsByClassName("kw").responseText;
      var kwlist = [];
      for (var i = 0; i < kwlines.length; i++) {
        kwlist[i] = kwlines[i].firstChild.data;
      }
    }
  }
}
request.send(null);


var list = document.getElementsByClassName("kw");
var a = 0;

for (var j = 0; j < list.length; j++) {
  //var inSpan = list[j].firstChild.data;
  list[j].innerHTML = kwlist[j];
}

}



//for (var a = 0; a < lines.length; a++) {
//}
