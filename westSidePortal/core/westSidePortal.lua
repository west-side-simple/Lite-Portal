----------------------------------------------------------------
--globals
----------------------------------------------------------------
----------------------------------------------------------------
--module
----------------------------------------------------------------
local base = _G
module("westSidePortal")
----------------------------------------------------------------
--locals
----------------------------------------------------------------
----------------------------------------------------------------
--for debug
----------------------------------------------------------------
local debugMode   = false
local debugInFile = false
----------------------------------------------------------------
--interface
----------------------------------------------------------------
function getVersion()
  return "1.1",1.1
end
----------------------------------------------------------------
function getDialogId()
 return 'westSidePortalDialog'
end
----------------------------------------------------------------
function isEnabled()
 local val = getConfigVal('enabled') 
 if base.type(val) ~= 'boolean' then
    val = true
 end
 return val
end
----------------------------------------------------------------
function setEnabled(val)
 if base.type(val) == 'boolean' then
   setConfigVal('enabled',val)
 end   
end
------------------------------------------------------------------------------
function isEmbedded()
 local val = getConfigVal('embedded') 
 if base.type(val) ~= 'boolean' then
    val = true
 end
 return val
end
----------------------------------------------------------------
function setEmbedded(val)
 if base.type(val) == 'boolean' then
   setConfigVal('embedded',val)
 end   
end
------------------------------------------------------------------------------
function isSavePosition()
 local val = getConfigVal('savePosition') 
 if base.type(val) ~= 'boolean' then
    val = true
 end
 return val
end
----------------------------------------------------------------
function setSavePosition(val)
 if base.type(val) == 'boolean' then
   setConfigVal('savePosition',val)
 end   
end
------------------------------------------------------------------------------
function isChromium()
 local val = getConfigVal('chromium') 
 if base.type(val) ~= 'boolean' then
    val = true
 end
 return val
end
----------------------------------------------------------------
function setChromium(val)
 if base.type(val) == 'boolean' then
   setConfigVal('chromium',val)
 end   
end
------------------------------------------------------------------------------
function getPosition() 
 local x,y,cx,cy
 
 x = getConfigVal('x') 
 y = getConfigVal('y') 
 cx = getConfigVal('cx') 
 cy = getConfigVal('cy') 
 return x,y,cx,cy
end
------------------------------------------------------------------------------
function savePosition(x,y,cx,cy) 
  if base.type(x) == 'number' then
     setConfigVal('x',x) 
  end
  if base.type(y) == 'number' then
     setConfigVal('y',y) 
  end
  if base.type(cx) == 'number' then
     setConfigVal('cx',cx) 
  end
  if base.type(cy) == 'number' then
     setConfigVal('cy',cy) 
  end
end
------------------------------------------------------------------------------
function getConfigFile()
 return 'westSidePortal.ini'
end
------------------------------------------------------------------------------
function getConfigVal(key)
 return base.m_simpleTV.Config.GetValue(key,getConfigFile())
end
------------------------------------------------------------------------------
function setConfigVal(key,val)
  base.m_simpleTV.Config.SetValue(key,val,getConfigFile())
end
------------------------------------------------------------------------------
function tr(str)
  return base.m_simpleTV.Interface.Translate(str,'simpleTV::westSidePortal')
end
----------------------------------------------------------------------  	
function Log(message,verbose)
 
 if not debugMode then return end
 
 message = message or 'nil' 
 if debugInFile then 
   base.debug_in_file(message .. '\n')
 else base.m_simpleTV.Logger.WriteToLog(message, verbose or 3, 'westSidePortal')
 end
end
----------------------------------------------------------------------          
--Helpers
----------------------------------------------------------------------          
