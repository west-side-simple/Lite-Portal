--menu west_side 17.02.22
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

function run_youtube_portal()

m_simpleTV.Control.ExecuteAction(37)

local tt={
{"YouTube главная страница","https://www.youtube.com","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube список подписок >>","https://www.youtube.com/feed/channels","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube список подписок (ленты каналов - RSS feed) >>","https://www.youtube.com/feed/rss_channels","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube подписки >>","https://www.youtube.com/feed/subscriptions","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube в тренде","https://www.youtube.com/feed/trending","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube история просмотра","https://www.youtube.com/feed/history","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube понравившиеся","https://www.youtube.com/playlist?list=LL","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube понравившиеся (музыка)","https://www.youtube.com/playlist?list=LM","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube отложенный просмотр","https://www.youtube.com/playlist?list=WL","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
}

  local t={}
  for i=1,#tt do
    t[i] = {}
    t[i].Id = i
    t[i].Name = tt[i][1]
    t[i].Action = tt[i][2]
	t[i].InfoPanelLogo = tt[i][3]
	t[i].InfoPanelTitle = 'Guide (необходимо использовать cookies)'
	t[i].InfoPanelDesc = 'Guide (необходимо использовать cookies)' .. tt[i][4]
	t[i].InfoPanelShowTime = 9000
  end

  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Youtube menu',0,t,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
    m_simpleTV.Control.PlayAddressT({address = t[id].Action})
  end

  end

function highlight()
m_simpleTV.Control.ExecuteAction(37)
local tt2={
{'Youtube канал SimpleTV M24WS','https://youtube.com/playlist?list=PL0OszcisBIjOax3iduZNSGfvuMj8NAyMj'},


}

  local t2={}
  for i=1,#tt2 do
    t2[i] = {}
    t2[i].Id = i
    t2[i].Name = tt2[i][1]
	t2[i].Address = tt2[i][2]
  end
  local cur_id = 0
  if getConfigVal('highlight') then cur_id = tonumber(getConfigVal('highlight'))-1 end
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Highlight',cur_id or 0,t2,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
	setConfigVal('highlight',id)
	m_simpleTV.Control.PlayAddressT({address = t2[id].Address})
  end
end

function run_westSide_portal()

m_simpleTV.Control.ExecuteAction(37)

local tt1={
{'Поиск',''},
{'TMDb',''},
{'EX-FS',''},
{'Rezka',''},
{'Filmix',''},
{'Kinopub',''},
{'YouTube',''},
{'SimpleTV - видеоинструкции',''},
}

  local t1={}
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
  end

  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Menu Lite Portal',0,t1,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
  if t1[id].Name == 'TMDb' then run_lite_qt_tmdb()
  elseif t1[id].Name == 'EX-FS' then run_lite_qt_exfs()
  elseif t1[id].Name == 'Rezka' then run_lite_qt_rezka()
  elseif t1[id].Name == 'Filmix' then run_lite_qt_filmix()
  elseif t1[id].Name == 'Kinopub' then run_lite_qt_kinopub()
  elseif t1[id].Name == 'YouTube' then run_youtube_portal()
  elseif t1[id].Name == 'Поиск' then search()
  elseif t1[id].Name:match('SimpleTV') then highlight()
  end
  end
end
-------------------------------------------------------------------

 local t={}
 t.utf8 = true
 t.name = 'Youtube меню'
 t.luastring = 'run_youtube_portal()'
 t.lua_as_scr = true
 t.submenu = 'Youtube by Nexterr'
 t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuYT.png'
 t.key = string.byte('I')
 t.ctrlkey = 4
 t.location = 0
 t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuYT.png'
 m_simpleTV.Interface.AddExtMenuT(t)

-- Add ext Menu

	local tp = {}
	tp.utf8 = true -- string coding
	tp.name = 'Archive slider plus'
	tp.luastring = 'user/epgslider/EPG_plus.lua'
	tp.submenu = 'Archive slider'
	tp.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. '/user/show_mi/timeshift_WS.png'
	tp.key = string.byte('+')
	tp.ctrlkey = 1 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
	tp.location = 0 --(0) - 0 - in main menu, 1 - in playlist menu, -1 all
	tp.image = m_simpleTV.MainScriptDir_UTF8 .. '/user/show_mi/timeshiftactive.png'
	m_simpleTV.Interface.AddExtMenuT(tp)

-- Add ext Menu

	local tm = {}
	tm.utf8 = true -- string coding
	tm.name = 'Archive slider minus'
	tm.luastring = 'user/epgslider/EPG_minus.lua'
	tm.submenu = 'Archive slider'
	tm.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. '/user/show_mi/timeshift_WS.png'
	tm.key = string.byte('-')
	tm.ctrlkey = 1 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
	tm.location = 0 --(0) - 0 - in main menu, 1 - in playlist menu, -1 all
	tm.image = m_simpleTV.MainScriptDir_UTF8 .. '/user/show_mi/timeshiftactive.png'
	m_simpleTV.Interface.AddExtMenuT(tm)

-- Add Menu lite portal

 local t1={}
 t1.utf8 = true
 t1.name = 'Lite portal меню'
 t1.luastring = 'run_westSide_portal()'
 t1.lua_as_scr = true
 t1.key = string.byte('I')
 t1.ctrlkey = 3
 t1.location = 0
 t1.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/lite.png'
 m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
 m_simpleTV.Interface.AddExtMenuT(t1)
 m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})