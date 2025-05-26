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
function doPortal()
{
 window.CHtmlDialog.callLua('start_page_mediaportal')
 doClose();
}
//--------------------------------------------------------------
function doSearch()
{
 var search = document.getElementById('value').value;
 window.CHtmlDialog.callLua1('setSearch', search);
 window.CHtmlDialog.callLua('add_to_history_of_search');
 window.CHtmlDialog.callLua('search_all');
 doClose();
}
//--------------------------------------------------------------
function keyboard()
{ 
 window.CHtmlDialog.callLua('select_keyboard')
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
