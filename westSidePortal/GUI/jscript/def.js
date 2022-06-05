function setViewMode(mode)
{
  if (mode)
  {
    //embedded
    document.body.style.backgroundColor  = 'rgba(20, 20, 20, 0.25)';
  }
  else 
  {
    //stand alone
    document.body.style.backgroundColor  = 'rgba(20, 20, 20, 1)';
  }
}
//--------------------------------------------------------------
function doClose()
{
 window.CHtmlDialog.callLua('westSidePortalDialogRequestClose')
}
//--------------------------------------------------------------
function doSearch()
{
 var search = document.getElementById('SearchID').value;
 window.CHtmlDialog.callLua1('setSearch',search)
 window.CHtmlDialog.callLua('search_all')
 doClose();
}
//--------------------------------------------------------------
//translate
//--------------------------------------------------------------
function tr(str)
{ 
 return new Promise(function(resolve, reject) 
  {
   window.CHtmlDialog.htmlTranslate(str,'simpleTV::westSidePortal'
        ,function(data)
        {
          resolve(data);
        });
  });
}
//--------------------------------------------------------------
function doTranslate()  
{
search.then(data => document.getElementById('SearchID').textContent = data);	
}
//--------------------------------------------------------------
//not functions
//--------------------------------------------------------------
window.onkeydown = function(event) {
 if (event.keyCode == 27) 
    {
	 doClose();
	}
 return true;	
}
//--------------------------------------------------------------
var shift=0;
var caps=0;
var uml = 0;
var circ = 0;
var grave = 0;
var acute = 0;

function ping(capa){
element=eval('this.'+form_name);
var text_ch ="";

switch (capa){
	case "UML" : {uml = (uml==1) ? 0 : 1; return;};
	case "CIRC" : {circ = (circ==1) ? 0 : 1; return;};
	case "GRAVE" : {grave = (grave==1) ? 0 : 1; return;};
	case "ACUTE" : {acute = (acute==1) ? 0 : 1; return;};
	case "CLEAR_ALL" : {element.value="";return;};
	case "BACK" : {var text_ch=element.value; element.value = text_ch.substr(0, (text_ch.length-1)); return;};
	case "ENTER" : {doSearch();return;};
	case "CAPS" : {caps= (caps==0) ? 1 : 0; change_mode();};
	case "SHIFT" : {shift= (shift==1) ? 0 : 1; return;};
	default : {
		if (uml == 1) {
			if(shift == 0) {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(228); break;
					case "e" : element.value += String.fromCharCode(235); break;
					case "i" : element.value += String.fromCharCode(239); break;
					case "o" : element.value += String.fromCharCode(246); break;
					case "u" : element.value += String.fromCharCode(252); break;
					case "y" : element.value += String.fromCharCode(255); break;
					default: element.value += capa;
				}	
			} 
			else {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(196); break;
					case "e" : element.value += String.fromCharCode(203); break;
					case "i" : element.value += String.fromCharCode(207); break;
					case "o" : element.value += String.fromCharCode(214); break;
					case "u" : element.value += String.fromCharCode(220); break;
					default: element.value += capa;
				}	
			}	
			uml = 0;
		}
		else if (circ == 1) {
			if(shift == 0) {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(226); break;
					case "e" : element.value += String.fromCharCode(234); break;
					case "i" : element.value += String.fromCharCode(238); break;
					case "o" : element.value += String.fromCharCode(244); break;
					case "u" : element.value += String.fromCharCode(251); break;
					default: element.value += capa;
				}	
			} 
			else {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(194); break;
					case "e" : element.value += String.fromCharCode(202); break;
					case "i" : element.value += String.fromCharCode(206); break;
					case "o" : element.value += String.fromCharCode(212); break;
					case "u" : element.value += String.fromCharCode(219); break;
					default: element.value += capa;
				}	
			}	
			circ = 0;
		}
		else if (grave == 1) {
			if(shift == 0) {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(224); break;
					case "e" : element.value += String.fromCharCode(232); break;
					case "i" : element.value += String.fromCharCode(236); break;
					case "o" : element.value += String.fromCharCode(242); break;
					case "u" : element.value += String.fromCharCode(249); break;
					default: element.value += capa;
				}	
			} 
			else {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(192); break;
					case "e" : element.value += String.fromCharCode(200); break;
					case "i" : element.value += String.fromCharCode(204); break;
					case "o" : element.value += String.fromCharCode(210); break;
					case "u" : element.value += String.fromCharCode(217); break;
					default: element.value += capa;
				}	
			}	
			grave = 0;
		}
		else if (acute == 1) {
			if(shift == 0) {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(225); break;
					case "e" : element.value += String.fromCharCode(233); break;
					case "i" : element.value += String.fromCharCode(237); break;
					case "o" : element.value += String.fromCharCode(243); break;
					case "u" : element.value += String.fromCharCode(250); break;
					default: element.value += capa;
				}	
			} 
			else {
				switch (capa) {
					case "a" : element.value += String.fromCharCode(193); break;
					case "e" : element.value += String.fromCharCode(201); break;
					case "i" : element.value += String.fromCharCode(205); break;
					case "o" : element.value += String.fromCharCode(211); break;
					case "u" : element.value += String.fromCharCode(218); break;
					default: element.value += capa;
				}	
			}	
			acute = 0;
		}
		else if (shift == 0) element.value=element.value + capa
		else if (shift == 1) {
			switch (capa) {
				case "`" : text_ch="`"; break;
				case "1" : text_ch="!"; break;
				case "2" : text_ch="@"; break;
				case "3" : text_ch="#"; break;
				case "4" : text_ch="$"; break;
				case "5" : text_ch="%"; break;
				case "6" : text_ch="^"; break;
				case "7" : text_ch="&"; break;
				case "8" : text_ch="*"; break;
				case "9" : text_ch="("; break;
				case "0" : text_ch=")"; break;
				case "-" : text_ch="_"; break;
				case "=" : text_ch="+"; break;
				case ";" : text_ch=":"; break;
				case "й" : text_ch="Й"; break;
				case "ц" : text_ch="Ц"; break;
				case "у" : text_ch="У"; break;
				case "к" : text_ch="К"; break;
				case "е" : text_ch="Е"; break;
				case "н" : text_ch="Н"; break;
				case "г" : text_ch="Г"; break;
				case "ш" : text_ch="Ш"; break;
				case "щ" : text_ch="Щ"; break;
				case "з" : text_ch="З"; break;
				case "х" : text_ch="Х"; break;
				case "ъ" : text_ch="Ъ"; break;
				case "{" : text_ch="}"; break;
				case "ф" : text_ch="Ф"; break;
				case "ы" : text_ch="Ы"; break;
				case "в" : text_ch="В"; break;
				case "а" : text_ch="А"; break;
				case "п" : text_ch="П"; break;
				case "р" : text_ch="Р"; break;
				case "о" : text_ch="О"; break;
				case "л" : text_ch="Л"; break;
				case "д" : text_ch="Д"; break;
				case "ж" : text_ch="Ж"; break;
				case "э" : text_ch="Э"; break;
				case "я" : text_ch="Я"; break;
				case "ч" : text_ch="Ч"; break;
				case "с" : text_ch="С"; break;
				case "м" : text_ch="М"; break;
				case "и" : text_ch="И"; break;
				case "т" : text_ch="Т"; break;
				case "ь" : text_ch="Ь"; break;
				case "б" : text_ch="Б"; break;
				case "ю" : text_ch="Ю"; break;
				case "ё" : text_ch="Ё"; break;
				case "," : text_ch=","; break;
				case "<" : text_ch=">"; break;
				case "'" : text_ch='"'; break;
				case "]" : text_ch="["; break;
				case "/" : text_ch="?"; break;
				case "\\" : text_ch="|"; break;	
				case "q" : text_ch="Q"; break;	
				case "w" : text_ch="W"; break;
				case "e" : text_ch="E"; break;
				case "r" : text_ch="R"; break;
				case "t" : text_ch="T"; break;
				case "y" : text_ch="Y"; break;
				case "u" : text_ch="U"; break;
				case "i" : text_ch="I"; break;
				case "o" : text_ch="O"; break;
				case "p" : text_ch="P"; break;
				case "a" : text_ch="A"; break;
				case "s" : text_ch="S"; break;
				case "d" : text_ch="D"; break;
				case "f" : text_ch="F"; break;
				case "g" : text_ch="G"; break;
				case "h" : text_ch="H"; break;
				case "j" : text_ch="J"; break;
				case "k" : text_ch="K"; break;
				case "l" : text_ch="L"; break;
				case "z" : text_ch="Z"; break;
				case "x" : text_ch="X"; break;
				case "c" : text_ch="C"; break;
				case "v" : text_ch="V"; break;
				case "b" : text_ch="B"; break;
				case "n" : text_ch="N"; break;
				case "m" : text_ch="M"; break;
				case String.fromCharCode(228): text_ch=String.fromCharCode(196); break;
				case String.fromCharCode(246): text_ch=String.fromCharCode(214); break;
				case String.fromCharCode(252): text_ch=String.fromCharCode(220); break;
				case String.fromCharCode(339): text_ch=String.fromCharCode(338); break;
				case String.fromCharCode(231): text_ch=String.fromCharCode(199); break;
				case String.fromCharCode(241): text_ch=String.fromCharCode(209); break;

				default : text_ch=capa
			}
			element.value=element.value + text_ch
		} 
		shift = (caps==1) ? 1 : 0;
	}
	
};
element.focus();
}

	//case "ENTER" : {element.value=element.value + "\n";return;};
//--------------------------------------------------------------	
_dom=document.all?3:(document.getElementById?1:(document.layers?2:0));
//alert(_dom);
_mode=1;

if(_dom==3){
}

if(_dom==1){
window.onkeyup =  test;
textEl=0;
}

<!-- общие функции -->

ImgBase = "img/";

function change_mode(){
pic=document.getElementById('klava');
if(_mode) {
_mode=0;
pic.src=ImgBase + "new_keyb_ON.svg"
}
else {
_mode=1;
pic.src=ImgBase + "new_keyb_OFF.svg"
}
}


<!-- функции для mozilla -->

function test (e)
{
//alert(e.keyCode); 
textEl=eval(form_name);
if(_mode) {click_mz(e); 
}
//textEl.focus();
}

function switch_lang(to_lang, style) {
	switch(to_lang) {
	case 'russian': 
		keyboard_img.src = ImgBase + 'new_keyb.gif'; 
		keyboard_img.useMap = "#newkeyboard";
		lang= "russian";
		break;
	case 'russian_abc': 
		keyboard_img.src = ImgBase + 'new_keyb_abc.gif'; 
		keyboard_img.useMap = "#newkeyboard_abc";
		lang= "russian";
		break;	
	case 'german': 
		keyboard_img.src = ImgBase + 'german_keyb.gif'; 
		keyboard_img.useMap = "#german_keyboard";
		lang = "german";
		break;	
	case 'france': 
		keyboard_img.src = ImgBase + 'french_keyb.gif'; 
		keyboard_img.useMap = "#france_keyboard";
		lang = "france";
		break;
	case 'spanish': 
		keyboard_img.src = ImgBase + 'spanish_keyb.gif'; 
		keyboard_img.useMap = "#spanish_keyboard";
		lang = "spanish";
		break;
	case 'italian': 
		keyboard_img.src = ImgBase + 'italian_keyb.gif'; 
		keyboard_img.useMap = "#italian_keyboard";
		lang = "italian";
		break;
	}
	if(style) {
		parent_td = document.getElementById('menu').childNodes;
		for (i=0; i<parent_td.length; i++) {
			//alert(parent_td[i].tagName);
			if(parent_td[i].tagName == "A") parent_td[i].style.cssText = "text-decoration : underline;"
		}
		style.cssText = "text-decoration : none; color: black";
	}
}

function press_mz(key, rus_small, rus_big, event)
{
if (key)
	{
	//	document.getElementById(key).className = "down";
	//	setTimeout("release('"+key+"')", 100);
	}
	ch = event.shiftKey ? rus_big : rus_small;
	insertText(textEl,ch);
	//textEl.focus();
	
} 

function insertText(element,text) 
{ 
if (element && element.caretPos) 
element.caretPos.text=text; 
else if (element && element.selectionStart+1 && element.selectionEnd+1) {
var caretpos=element.selectionStart;
//alert(caretpos);
//alert(element.value.substring(0,element.selectionStart-1));
//alert(text);
//alert(element.value.substring(element.selectionEnd,element.value.length));
element.value=element.value.substring(0,element.selectionStart-1)+text+element.value.substring(element.selectionEnd,element.value.length)

element.selectionStart=caretpos;
element.selectionEnd=caretpos;


//alert('ok');
}
else if (element) 
element.value+=text; 
} 

function click_mz(event) 
{

	
switch (lang) {
		case 'russian': {
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_mz("", "\\", "/", event); break;
			case 223: press_mz("", "ё", "Ё", event); break;
			case 52: press_mz("", "4", ";", event); break;
			case 54: press_mz("", "6", ":", event); break;
			case 55: press_mz("", "7", "?", event); break;
			case 81: press_mz("q", "й", "Й", event); break;
			case 87: press_mz("w", "ц", "Ц", event); break;
			case 69: press_mz("e", "у", "У", event); break;
			case 82: press_mz("r", "к", "К", event); break;
			case 84: press_mz("t", "е", "Е", event); break;
			case 89: press_mz("y", "н", "Н", event); break;
			case 85: press_mz("u", "г", "Г", event); break;
			case 73: press_mz("i", "ш", "Ш", event); break;
			case 79: press_mz("o", "щ", "Щ", event); break;
			case 80: press_mz("p", "з", "З", event); break;
			case 219: press_mz("ob", "х", "Х", event); break;
			case 221: press_mz("cb", "ъ", "Ъ", event); break;
			case 65: press_mz("a", "ф", "Ф", event); break;
			case 83: press_mz("s", "ы", "Ы", event); break;
			case 68: press_mz("d", "в", "В", event); break;
			case 70: press_mz("f", "а", "А", event); break;
			case 71: press_mz("g", "п", "П", event); break;
			case 72: press_mz("h", "р", "Р", event); break;
			case 74: press_mz("j", "о", "О", event); break;
			case 75: press_mz("k", "л", "Л", event); break;
			case 76: press_mz("l", "д", "Д", event); break;
			case 186: press_mz("sc", "ж", "Ж", event); break;
			case 192: press_mz("ap", "э", "Э", event); break;
			case 90: press_mz("z", "я", "Я", event); break;
			case 88: press_mz("x", "ч", "Ч", event); break;
			case 67: press_mz("c", "с", "С", event); break;
			case 86: press_mz("v", "м", "М", event); break;
			case 66: press_mz("b", "и", "И", event); break;
			case 78: press_mz("n", "т", "Т", event); break;
			case 77: press_mz("m", "ь", "Ь", event); break;
			case 188: press_mz("co", "б", "Б", event); break;
			case 190: press_mz("fs", "ю", "Ю", event); break;
			case 191: press_mz("sl", ".", ",", event); break;
			}
			break;
			}
		case 'german':	{
		//alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_mz("", "\\", "/", event); break;
			case 221: press_mz("", "]", "[", event); break;
			case 89: press_mz("y", "z", "Z", event); break;
			case 219: press_mz("ob", String.fromCharCode(252), String.fromCharCode(220), event); break;
			case 221: press_mz("cb", "ъ", "Ъ", event); break;
			case 59: press_mz("sc", String.fromCharCode(246), String.fromCharCode(214), event); break;
			case 222: press_mz("ap", String.fromCharCode(228), String.fromCharCode(196), event); break;
			case 90: press_mz("z", "y", "Y", event); break;
			case 188: press_mz("co", String.fromCharCode(223), String.fromCharCode(223), event); break;
			case 190: press_mz("fs", String.fromCharCode(956), String.fromCharCode(956), event); break;
			case 223: press_mz("sl", ".", ",", event); break;
			
	// общие места
			case 52: press_mz("", "4", ";", event); break;
			case 54: press_mz("", "6", ":", event); break;
			case 55: press_mz("", "7", "?", event); break;
			case 81: press_mz("q", "q", "Q", event); break;
			case 87: press_mz("w", "w", "W", event); break;
			case 69: press_mz("e", "e", "E", event); break;
			case 82: press_mz("r", "r", "R", event); break;
			case 84: press_mz("t", "t", "T", event); break;
			case 85: press_mz("u", "u", "U", event); break;
			case 73: press_mz("i", "i", "I", event); break;
			case 79: press_mz("o", "o", "O", event); break;
			case 80: press_mz("p", "p", "P", event); break;
			case 65: press_mz("a", "a", "A", event); break;
			case 83: press_mz("s", "s", "S", event); break;
			case 68: press_mz("d", "d", "D", event); break;
			case 70: press_mz("f", "f", "F", event); break;
			case 71: press_mz("g", "g", "G", event); break;
			case 72: press_mz("h", "h", "H", event); break;
			case 74: press_mz("j", "j", "J", event); break;
			case 75: press_mz("k", "k", "K", event); break;
			case 76: press_mz("l", "l", "L", event); break;
			case 88: press_mz("x", "x", "X", event); break;
			case 67: press_mz("c", "c", "C", event); break;
			case 86: press_mz("v", "v", "V", event); break;
			case 66: press_mz("b", "b", "B", event); break;
			case 78: press_mz("n", "n", "N", event); break;
			case 77: press_mz("m", "m", "M", event); break;
			}
			break;
			}

			case 'france':	{
		//alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_mz("", "\\", "/", event); break;
			case 89: press_mz("y", "y", "Y", event); break;
			case 219: press_mz("ob", "", "", event); break;
			case 221: press_mz("cb", "", "", event); break;
			case 186: press_mz("sc", "", "", event); break;
			case 222: press_mz("ap", "", "", event); break;
			case 90: press_mz("z", "z", "Z", event); break;
			case 190: press_mz("co", String.fromCharCode(231), String.fromCharCode(199), event); break;
			case 188: press_mz("fs", String.fromCharCode(339), String.fromCharCode(338), event); break;
			case 191: press_mz("sl", ".", ",", event); break;
			
	// общие места
			case 223: press_mz("", "ё", "Ё", event); break;
			case 52: press_mz("", "4", ";", event); break;
			case 54: press_mz("", "6", ":", event); break;
			case 55: press_mz("", "7", "?", event); break;
			case 81: press_mz("q", "q", "Q", event); break;
			case 87: press_mz("w", "w", "W", event); break;
			case 69: press_mz("e", "e", "E", event); break;
			case 82: press_mz("r", "r", "R", event); break;
			case 84: press_mz("t", "t", "T", event); break;
			case 85: press_mz("u", "u", "U", event); break;
			case 73: press_mz("i", "i", "I", event); break;
			case 79: press_mz("o", "o", "O", event); break;
			case 80: press_mz("p", "p", "P", event); break;
			case 65: press_mz("a", "a", "A", event); break;
			case 83: press_mz("s", "s", "S", event); break;
			case 68: press_mz("d", "d", "D", event); break;
			case 70: press_mz("f", "f", "F", event); break;
			case 71: press_mz("g", "g", "G", event); break;
			case 72: press_mz("h", "h", "H", event); break;
			case 74: press_mz("j", "j", "J", event); break;
			case 75: press_mz("k", "k", "K", event); break;
			case 76: press_mz("l", "l", "L", event); break;
			case 88: press_mz("x", "x", "X", event); break;
			case 67: press_mz("c", "c", "C", event); break;
			case 86: press_mz("v", "v", "V", event); break;
			case 66: press_mz("b", "b", "B", event); break;
			case 78: press_mz("n", "n", "N", event); break;
			case 77: press_mz("m", "m", "M", event); break;
			}
			break;
			}
			
			case 'spanish':	{
		alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_mz("", "\\", "/", event); break;
			case 89: press_mz("y", "y", "Y", event); break;
			case 219: press_mz("ob", "", "", event); break;
			case 221: press_mz("cb", "", "", event); break;
			case 186: press_mz("sc", "", "", event); break;
			case 222: press_mz("ap", "", "", event); break;
			case 90: press_mz("z", "z", "Z", event); break;
			case 190: press_mz("co", String.fromCharCode(231), String.fromCharCode(199), event); break;
			case 188: press_mz("fs", String.fromCharCode(339), String.fromCharCode(338), event); break;
			case 191: press_mz("sl", ".", ",", event); break;
			
	// общие места
			case 223: press_mz("", "ё", "Ё", event); break;
			case 52: press_mz("", "4", ";", event); break;
			case 54: press_mz("", "6", ":", event); break;
			case 55: press_mz("", "7", "?", event); break;
			case 81: press_mz("q", "q", "Q", event); break;
			case 87: press_mz("w", "w", "W", event); break;
			case 69: press_mz("e", "e", "E", event); break;
			case 82: press_mz("r", "r", "R", event); break;
			case 84: press_mz("t", "t", "T", event); break;
			case 85: press_mz("u", "u", "U", event); break;
			case 73: press_mz("i", "i", "I", event); break;
			case 79: press_mz("o", "o", "O", event); break;
			case 80: press_mz("p", "p", "P", event); break;
			case 65: press_mz("a", "a", "A", event); break;
			case 83: press_mz("s", "s", "S", event); break;
			case 68: press_mz("d", "d", "D", event); break;
			case 70: press_mz("f", "f", "F", event); break;
			case 71: press_mz("g", "g", "G", event); break;
			case 72: press_mz("h", "h", "H", event); break;
			case 74: press_mz("j", "j", "J", event); break;
			case 75: press_mz("k", "k", "K", event); break;
			case 76: press_mz("l", "l", "L", event); break;
			case 88: press_mz("x", "x", "X", event); break;
			case 67: press_mz("c", "c", "C", event); break;
			case 86: press_mz("v", "v", "V", event); break;
			case 66: press_mz("b", "b", "B", event); break;
			case 78: press_mz("n", "n", "N", event); break;
			case 77: press_mz("m", "m", "M", event); break;
			}
			break;
			}

		}	
}

<!-- функции для IE -->
function press_ie(key, rus_small, rus_big, event)
{
	if(!eval(form_name)) return;
	if (key)
	{
	//	eval("document.all['" +key+ "']").className = "down"
	//	setTimeout("release('"+key+"')", 100);
	}
	ch = event.shiftKey ? rus_big : rus_small;
    if (textEl.createTextRange && textEl.caretPos)
	{
		var caretPos = textEl.caretPos;
        caretPos.text = ch;
    }
    else
	{
    	textEl.value  = ch;
	}     
	textEl.focus();
	event.returnValue = false;
}



function click_ie(event) 
{

if(!eval(form_name)) return;
textEl=eval(form_name);
	textEl.focus();
	
	if(!_mode) return;
	if (event.ctrlKey || event.altKey) return;
	if (!textEl.createTextRange()) return;
	textEl.caretPos = document.selection.createRange().duplicate();
	switch (lang) {
		case 'russian': {
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_ie("", "\\", "/", event); break;
			case 223: press_ie("", "ё", "Ё", event); break;
			case 52: press_ie("", "4", ";", event); break;
			case 54: press_ie("", "6", ":", event); break;
			case 55: press_ie("", "7", "?", event); break;
			case 81: press_ie("q", "й", "Й", event); break;
			case 87: press_ie("w", "ц", "Ц", event); break;
			case 69: press_ie("e", "у", "У", event); break;
			case 82: press_ie("r", "к", "К", event); break;
			case 84: press_ie("t", "е", "Е", event); break;
			case 89: press_ie("y", "н", "Н", event); break;
			case 85: press_ie("u", "г", "Г", event); break;
			case 73: press_ie("i", "ш", "Ш", event); break;
			case 79: press_ie("o", "щ", "Щ", event); break;
			case 80: press_ie("p", "з", "З", event); break;
			case 219: press_ie("ob", "х", "Х", event); break;
			case 221: press_ie("cb", "ъ", "Ъ", event); break;
			case 65: press_ie("a", "ф", "Ф", event); break;
			case 83: press_ie("s", "ы", "Ы", event); break;
			case 68: press_ie("d", "в", "В", event); break;
			case 70: press_ie("f", "а", "А", event); break;
			case 71: press_ie("g", "п", "П", event); break;
			case 72: press_ie("h", "р", "Р", event); break;
			case 74: press_ie("j", "о", "О", event); break;
			case 75: press_ie("k", "л", "Л", event); break;
			case 76: press_ie("l", "д", "Д", event); break;
			case 186: press_ie("sc", "ж", "Ж", event); break;
			case 192: press_ie("ap", "э", "Э", event); break;
			case 90: press_ie("z", "я", "Я", event); break;
			case 88: press_ie("x", "ч", "Ч", event); break;
			case 67: press_ie("c", "с", "С", event); break;
			case 86: press_ie("v", "м", "М", event); break;
			case 66: press_ie("b", "и", "И", event); break;
			case 78: press_ie("n", "т", "Т", event); break;
			case 77: press_ie("m", "ь", "Ь", event); break;
			case 188: press_ie("co", "б", "Б", event); break;
			case 190: press_ie("fs", "ю", "Ю", event); break;
			case 191: press_ie("sl", ".", ",", event); break;
			}
			break;
			}
		case 'german':	{
		//alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_ie("", "\\", "/", event); break;
			case 221: press_ie("", "]", "[", event); break;
			case 89: press_ie("y", "z", "Z", event); break;
			case 219: press_ie("ob", String.fromCharCode(252), String.fromCharCode(220), event); break;
			case 221: press_ie("cb", "ъ", "Ъ", event); break;
			case 186: press_ie("sc", String.fromCharCode(246), String.fromCharCode(214), event); break;
			case 222: press_ie("ap", String.fromCharCode(228), String.fromCharCode(196), event); break;
			case 90: press_ie("z", "y", "Y", event); break;
			case 188: press_ie("co", String.fromCharCode(223), String.fromCharCode(223), event); break;
			case 190: press_ie("fs", String.fromCharCode(956), String.fromCharCode(956), event); break;
			case 191: press_ie("sl", ".", ",", event); break;
			
	// общие места
			case 223: press_ie("", "ё", "Ё", event); break;
			case 52: press_ie("", "4", ";", event); break;
			case 54: press_ie("", "6", ":", event); break;
			case 55: press_ie("", "7", "?", event); break;
			case 81: press_ie("q", "q", "Q", event); break;
			case 87: press_ie("w", "w", "W", event); break;
			case 69: press_ie("e", "e", "E", event); break;
			case 82: press_ie("r", "r", "R", event); break;
			case 84: press_ie("t", "t", "T", event); break;
			case 85: press_ie("u", "u", "U", event); break;
			case 73: press_ie("i", "i", "I", event); break;
			case 79: press_ie("o", "o", "O", event); break;
			case 80: press_ie("p", "p", "P", event); break;
			case 65: press_ie("a", "a", "A", event); break;
			case 83: press_ie("s", "s", "S", event); break;
			case 68: press_ie("d", "d", "D", event); break;
			case 70: press_ie("f", "f", "F", event); break;
			case 71: press_ie("g", "g", "G", event); break;
			case 72: press_ie("h", "h", "H", event); break;
			case 74: press_ie("j", "j", "J", event); break;
			case 75: press_ie("k", "k", "K", event); break;
			case 76: press_ie("l", "l", "L", event); break;
			case 88: press_ie("x", "x", "X", event); break;
			case 67: press_ie("c", "c", "C", event); break;
			case 86: press_ie("v", "v", "V", event); break;
			case 66: press_ie("b", "b", "B", event); break;
			case 78: press_ie("n", "n", "N", event); break;
			case 77: press_ie("m", "m", "M", event); break;
			}
			break;
			}
			case 'france':	{
		//alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_ie("", "\\", "/", event); break;
			case 89: press_ie("y", "y", "Y", event); break;
			case 219: press_ie("ob", "", "", event); break;
			case 221: press_ie("cb", "", "", event); break;
			case 186: press_ie("sc", "", "", event); break;
			case 222: press_ie("ap", "", "", event); break;
			case 90: press_ie("z", "z", "Z", event); break;
			case 190: press_ie("co", String.fromCharCode(231), String.fromCharCode(199), event); break;
			case 188: press_ie("fs", String.fromCharCode(339), String.fromCharCode(338), event); break;
			case 191: press_ie("sl", ".", ",", event); break;
			
	// общие места
			case 223: press_ie("", "ё", "Ё", event); break;
			case 52: press_ie("", "4", ";", event); break;
			case 54: press_ie("", "6", ":", event); break;
			case 55: press_ie("", "7", "?", event); break;
			case 81: press_ie("q", "q", "Q", event); break;
			case 87: press_ie("w", "w", "W", event); break;
			case 69: press_ie("e", "e", "E", event); break;
			case 82: press_ie("r", "r", "R", event); break;
			case 84: press_ie("t", "t", "T", event); break;
			case 85: press_ie("u", "u", "U", event); break;
			case 73: press_ie("i", "i", "I", event); break;
			case 79: press_ie("o", "o", "O", event); break;
			case 80: press_ie("p", "p", "P", event); break;
			case 65: press_ie("a", "a", "A", event); break;
			case 83: press_ie("s", "s", "S", event); break;
			case 68: press_ie("d", "d", "D", event); break;
			case 70: press_ie("f", "f", "F", event); break;
			case 71: press_ie("g", "g", "G", event); break;
			case 72: press_ie("h", "h", "H", event); break;
			case 74: press_ie("j", "j", "J", event); break;
			case 75: press_ie("k", "k", "K", event); break;
			case 76: press_ie("l", "l", "L", event); break;
			case 88: press_ie("x", "x", "X", event); break;
			case 67: press_ie("c", "c", "C", event); break;
			case 86: press_ie("v", "v", "V", event); break;
			case 66: press_ie("b", "b", "B", event); break;
			case 78: press_ie("n", "n", "N", event); break;
			case 77: press_ie("m", "m", "M", event); break;
			}
			break;
			}	


case 'spanish':	{
		//alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_ie("", "\\", "/", event); break;
			case 89: press_ie("y", "y", "Y", event); break;
			case 219: press_ie("ob", "", "", event); break;
			case 221: press_ie("cb", "", "", event); break;
			case 186: press_ie("sc", "", "", event); break;
			case 222: press_ie("ap", "", "", event); break;
			case 90: press_ie("z", "z", "Z", event); break;
			case 190: press_ie("co", String.fromCharCode(231), String.fromCharCode(199), event); break;
			case 188: press_ie("fs", String.fromCharCode(241), String.fromCharCode(209), event); break;
			case 191: press_ie("sl", ".", ",", event); break;
			
	// общие места
			case 223: press_ie("", "ё", "Ё", event); break;
			case 52: press_ie("", "4", ";", event); break;
			case 54: press_ie("", "6", ":", event); break;
			case 55: press_ie("", "7", "?", event); break;
			case 81: press_ie("q", "q", "Q", event); break;
			case 87: press_ie("w", "w", "W", event); break;
			case 69: press_ie("e", "e", "E", event); break;
			case 82: press_ie("r", "r", "R", event); break;
			case 84: press_ie("t", "t", "T", event); break;
			case 85: press_ie("u", "u", "U", event); break;
			case 73: press_ie("i", "i", "I", event); break;
			case 79: press_ie("o", "o", "O", event); break;
			case 80: press_ie("p", "p", "P", event); break;
			case 65: press_ie("a", "a", "A", event); break;
			case 83: press_ie("s", "s", "S", event); break;
			case 68: press_ie("d", "d", "D", event); break;
			case 70: press_ie("f", "f", "F", event); break;
			case 71: press_ie("g", "g", "G", event); break;
			case 72: press_ie("h", "h", "H", event); break;
			case 74: press_ie("j", "j", "J", event); break;
			case 75: press_ie("k", "k", "K", event); break;
			case 76: press_ie("l", "l", "L", event); break;
			case 88: press_ie("x", "x", "X", event); break;
			case 67: press_ie("c", "c", "C", event); break;
			case 86: press_ie("v", "v", "V", event); break;
			case 66: press_ie("b", "b", "B", event); break;
			case 78: press_ie("n", "n", "N", event); break;
			case 77: press_ie("m", "m", "M", event); break;
			}
			break;
			}	

			case 'italian':	{
		//alert(event.keyCode)
			switch (event.keyCode) {
			case 13: collect(); break;
			case 220: press_ie("", "\\", "/", event); break;
			case 89: press_ie("y", "y", "Y", event); break;
			case 219: press_ie("ob", "", "", event); break;
			case 221: press_ie("cb", "", "", event); break;
			case 186: press_ie("sc", "", "", event); break;
			case 222: press_ie("ap", "", "", event); break;
			case 90: press_ie("z", "z", "Z", event); break;
			case 190: press_ie("co", String.fromCharCode(231), String.fromCharCode(199), event); break;
			case 188: press_ie("fs", String.fromCharCode(176), String.fromCharCode(176), event); break;
			case 191: press_ie("sl", ".", ",", event); break;
			
	// общие места
			case 223: press_ie("", "ё", "Ё", event); break;
			case 52: press_ie("", "4", ";", event); break;
			case 54: press_ie("", "6", ":", event); break;
			case 55: press_ie("", "7", "?", event); break;
			case 81: press_ie("q", "q", "Q", event); break;
			case 87: press_ie("w", "w", "W", event); break;
			case 69: press_ie("e", "e", "E", event); break;
			case 82: press_ie("r", "r", "R", event); break;
			case 84: press_ie("t", "t", "T", event); break;
			case 85: press_ie("u", "u", "U", event); break;
			case 73: press_ie("i", "i", "I", event); break;
			case 79: press_ie("o", "o", "O", event); break;
			case 80: press_ie("p", "p", "P", event); break;
			case 65: press_ie("a", "a", "A", event); break;
			case 83: press_ie("s", "s", "S", event); break;
			case 68: press_ie("d", "d", "D", event); break;
			case 70: press_ie("f", "f", "F", event); break;
			case 71: press_ie("g", "g", "G", event); break;
			case 72: press_ie("h", "h", "H", event); break;
			case 74: press_ie("j", "j", "J", event); break;
			case 75: press_ie("k", "k", "K", event); break;
			case 76: press_ie("l", "l", "L", event); break;
			case 88: press_ie("x", "x", "X", event); break;
			case 67: press_ie("c", "c", "C", event); break;
			case 86: press_ie("v", "v", "V", event); break;
			case 66: press_ie("b", "b", "B", event); break;
			case 78: press_ie("n", "n", "N", event); break;
			case 77: press_ie("m", "m", "M", event); break;
			}
			break;
			}


		}	
}



	