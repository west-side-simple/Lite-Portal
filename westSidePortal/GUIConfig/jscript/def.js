var m_Version = 0
//--------------------------------------------------------------
function getVals()
{ 
 var retA = {'Enabled': document.getElementById('EnabledID').checked,
             'Embedded':document.getElementById('EmbeddedID').checked,
             'SavePosition':document.getElementById('SavePositionID').checked,
			 'Chromium':document.getElementById('ChromiumID').checked,
             };
  return retA;
}
//--------------------------------------------------------------
function setStartVals(enabled,embedded,savePostion,chromium)
{ 
 document.getElementById('EnabledID').checked  = enabled;
 document.getElementById('EmbeddedID').checked  = embedded;
 document.getElementById('SavePositionID').checked  = savePostion;
 document.getElementById('ChromiumID').checked  = chromium;
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
 tr('Options for westSidePortal v.').then(data => document.getElementById('LegendID').textContent  =  data + ' ' + m_Version);
 tr('Enabled').then(data => document.getElementById('EnabledTextID').textContent = data);
 tr('Embedded in main frame').then(data => document.getElementById('EmbeddedTextID').textContent = data);
 tr('Save position').then(data => document.getElementById('SavePositionTextID').textContent = data);
 tr('Chromium mode').then(data => document.getElementById('ChromiumModeID').textContent = data);
 
 tr("Addon Media portal for SimpleTV. Implements the ability to select media content for portal-connected sites based on dialog boxes.<br>Keyboard shortcuts: 'Ctrl+Shift+P' - show OSD.")
  .then(data => document.getElementById('desc0').innerHTML = data); 
}
//--------------------------------------------------------------
