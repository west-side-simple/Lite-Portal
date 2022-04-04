require("westSidePortal")
----------------------------------------------------------------------
local function escapeJSString(str)
 if str == nil then return nil end
 str = string.gsub(str,'\\','\\\\')
 str = string.gsub(str,'"','\\"')
 str = string.gsub(str,'\n','\\n')
 str = string.gsub(str,'\r','\\r')
 return str
end
----------------------------------------------------------------------
local function translateHtml(Object)
  m_simpleTV.Dialog.ExecScript(Object,'m_Version = ' .. westSidePortal.getVersion())
  m_simpleTV.Dialog.ExecScript(Object,'doTranslate();')
end
----------------------------------------------------------------------
function baseInit(Object)

 local scr = 'setStartVals('
                       .. tostring(westSidePortal.isEnabled())
                       .. ',' .. tostring(westSidePortal.isEmbedded())
                       .. ',' .. tostring(westSidePortal.isSavePosition())
					   .. ',' .. tostring(westSidePortal.isChromium())
                       .. ');'

 m_simpleTV.Dialog.ExecScript(Object,scr)
end
----------------------------------------------------------------------
function OnNavigateComplete(Object)
  translateHtml(Object)
  baseInit(Object)
end
----------------------------------------------------------------------
function OnOk(Object)
 local t = m_simpleTV.Dialog.ExecScriptParam(Object,'getVals();')
 if type(t) == 'table' then

   local needRestart = false

   if t.Enabled~=westSidePortal.isEnabled() then
      needRestart = true
      westSidePortal.setEnabled(t.Enabled);
   end
   if t.Embedded~=westSidePortal.isEmbedded() then
      westSidePortal.setEmbedded(t.Embedded);
   end
   if t.SavePosition~=westSidePortal.isSavePosition() then
      westSidePortal.setSavePosition(t.SavePosition);
   end
   if t.Chromium~=westSidePortal.isChromium() then
      westSidePortal.setChromium(t.Chromium);
   end

   if needRestart then
     m_simpleTV.Config.Apply('NEED_RESTART_APP')
   end
 end
end