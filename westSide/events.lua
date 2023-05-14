--westSide events 28.04.23

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

if m_simpleTV.Control.Reason=='addressready'  then
  if m_simpleTV.User.westSide.PortalShowWindowId then
    m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.westSide.PortalShowWindowId)
  end
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
	m_simpleTV.User.filmix.TabSimilar=nil
	m_simpleTV.User.torrent.content=nil
	m_simpleTV.User.hevc.content=nil
	if m_simpleTV.User.westSide.PortalShowWindowId then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.westSide.PortalShowWindowId)
	end
end
if m_simpleTV.Control.Reason=='addressready' and (m_simpleTV.Control.CurrentAddress:match('/main/video%d+%.mp4') or m_simpleTV.Control.CurrentAddress:match('/SimpleTVupd/news%d+%.mp4')) and m_simpleTV.User.westSide.UP and m_simpleTV.User.westSide.UP == true then
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/SimpleTVupd/beckgr.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.Control.Action = 'stop'
end
if m_simpleTV.Control.Reason=='EndReached' and (m_simpleTV.Control.CurrentAddress:match('/main/video%d+%.mp4') or m_simpleTV.Control.CurrentAddress:match('/SimpleTVupd/news%d+%.mp4')) then
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/SimpleTVupd/beckgr.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.Control.Action = 'stop'
end
if (m_simpleTV.Control.Reason=='Stopped' or m_simpleTV.Control.Reason=='Error' or m_simpleTV.Control.GetPosition() and m_simpleTV.Control.GetPosition()>=0.9)
	and (m_simpleTV.User.westSide.UP==nil or m_simpleTV.User.westSide.UP~=true)
	and (m_simpleTV.Control.CurrentAddress:match('/main/video%d+%.mp4') or m_simpleTV.Control.CurrentAddress:match('/SimpleTVupd/news%d+%.mp4')) then
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/SimpleTVupd/beckgr.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.Control.Action = 'stop'
	local params = {}
	params.message = 'Для обновления сборки нажмите кнопку ДА.'
	params.caption = 'Update'
	params.buttons = 'Yes|No'
	params.icon = 'Question'
	params.defButton = 'Yes'
	m_simpleTV.User.westSide.UP = true
	if m_simpleTV.Interface.MessageBoxT(params) == 'Yes' then
		m_simpleTV.Control.ExecuteAction(11)
		setConfigVal("need",0) -- флаг текущего обновления и готовности к новому
		os.execute('tv-update.exe')
	end
	m_simpleTV.Control.ExecuteAction(11)
end