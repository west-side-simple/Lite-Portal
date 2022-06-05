if m_simpleTV.Common.GetVersion() < 880 then  --b12.7.6
   local mess = "simpleTV version too old [".. select(2,m_simpleTV.Common.GetVersion())  .. "], need 0.5.0 b12.7.6"
   m_simpleTV.Interface.MessageBox(mess,"westSidePortal",0x10)  
  return
 end

if not string.match(package.path, "user/westSidePortal/core", 0) then
  package.path = package.path .. ";" .. m_simpleTV.MainScriptDir .. "user/westSidePortal/core/?.lua"
end

m_simpleTV.Interface.AddTranslator(   m_simpleTV.MainScriptDir_UTF8 
								     .. "user/westSidePortal/translations/lang_" 
								     .. m_simpleTV.Interface.GetLanguageCountry())

require("westSidePortal")

AddFileToExecute("onconfig", m_simpleTV.MainScriptDir .. "user/westSidePortal/initconfig.lua")

if westSidePortal.isEnabled() then
  
  -- Add ext Menu
	local t = {}
	t.utf8 = true -- string coding
	t.name = westSidePortal.tr('Portal')
	t.luastring = 'user/westSidePortal/GUI/showDialog.lua' 
	t.key = 80 --P
	t.ctrlkey = 3 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
	t.location = 0 --(0) - 0 - in main menu, 1 - in playlist menu, -1 all
	t.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSidePortal/GUI/img/westSidePortal.png'
	m_simpleTV.Interface.AddExtMenuT(t)
 end    
     


