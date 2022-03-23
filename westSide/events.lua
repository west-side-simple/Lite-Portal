--westSide events 22.03.22

if m_simpleTV.Control.Reason=='addressready'  then
 
  if m_simpleTV.User.westSide.PortalTable~=nil then

    local t={}
    t.utf8 = true
    t.name = '-'
    t.luastring = ''
    t.lua_as_scr = false 
    t.submenu = 'westSide Portal'
    t.imageSubmenu = ''
    --t.key = string.byte('I')
    t.ctrlkey = 0
    t.location = 0
    t.image=''
    m_simpleTV.User.westSide.PortalSeparatorId = m_simpleTV.Interface.AddExtMenuT(t)
  
    local t={}
    t.utf8 = true
    t.name = 'Portal Info Window'
    t.luastring = 'show_portal_window()'
    t.lua_as_scr = true 
    t.submenu = 'westSide Portal'
    t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide/icons/portal.png'
    t.key = string.byte('I')
    t.ctrlkey = 0
    t.location = 0
    t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/fw_box_t3.png'
    m_simpleTV.User.westSide.PortalShowWindowId = m_simpleTV.Interface.AddExtMenuT(t)
   
  end

end

if m_simpleTV.Control.Reason=='Stopped' or m_simpleTV.Control.Reason=='Error' then

  m_simpleTV.User.westSide.PortalTable=nil
 
  if m_simpleTV.User.westSide.PortalShowWindowId then
    m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.westSide.PortalShowWindowId)
  end

end