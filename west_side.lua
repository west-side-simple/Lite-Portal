--startup westSide portal
--saved as utf-8 without bom
--wafee code, west_side updated 22.03.22
-------------------------------------------------------------------
if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end

AddFileToExecute('events', m_simpleTV.MainScriptDir .. "user/westSide/events.lua")
-------------------------------------------------------------------
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
-------------------------------------------------------------------
function show_portal_window()
 local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
 end
 local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
 end
 if m_simpleTV.User.westSide.PortalTable~=nil then
   kinogo_info(m_simpleTV.User.westSide.PortalTable)
 end
end
-------------------------------------------------------------------
function mediabaze()
 m_simpleTV.Control.ExecuteAction(37)
 local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
 end

 local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
 end
 local tt2={
  {'Избранные медиабалансеры (быстро)',1},
  {'Все медиабалансеры (медленно)',2},
           }
  local t2={}
  for i=1,#tt2 do
    t2[i] = {}
    t2[i].Id = i
    t2[i].Name = tt2[i][1]
	t2[i].Address = tt2[i][2]
  end
  local cur_id = getConfigVal('mediabaze') or 0
  if getConfigVal('mediabaze') then cur_id = tonumber(getConfigVal('mediabaze'))-1 end
  t2.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выбор медиабалансеров',cur_id,t2,9000,1+4+8)
  if id==nil then return end
  if ret==1 then
	setConfigVal('mediabaze',id)
	mediabaze()
  end
  if ret==2 then
	run_westSide_portal()
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
 {'Переводы',''},
 {'KinoGo',''},
 {'YouTube',''},
 {'Медиабазы',''},
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
  elseif t1[id].Name == 'Медиабазы' then mediabaze()
  elseif t1[id].Name:match('SimpleTV') then highlight()
  elseif t1[id].Name == 'Переводы' then run_lite_qt_cdntr()
  elseif t1[id].Name == 'KinoGo' then run_lite_qt_kinogo()
  end
  end
end
-------------------------------------------------------------------
function west_side_substr(str)
 if m_simpleTV.Common.lenUTF8(str) > 30 then
   str = m_simpleTV.Common.midUTF8(str,0,30) .. '...'
 end
 return str
end
-------------------------------------------------------------------
function west_side_substr20(str)
 if m_simpleTV.Common.lenUTF8(str) > 20 then
   str = m_simpleTV.Common.midUTF8(str,0,20) .. '...'
 end
 return str
end
-------------------------------------------------------------------
function west_side_substr50(str)
 if m_simpleTV.Common.lenUTF8(str) > 50 then
   str = m_simpleTV.Common.midUTF8(str,0,50) .. '...'
 end
 return str
end
-------------------------------------------------------------------
-- Add ext Menu Archive slider plus
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
-- Add ext Menu Archive slider minus
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
-- Add Menu Portal
	local t1={}
	t1.utf8 = true
	t1.name = 'Portal меню'
	t1.luastring = 'run_westSide_portal()'
	t1.lua_as_scr = true
	t1.submenu = 'westSide Portal'
    t1.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide/icons/portal.png'
	t1.key = string.byte('I')
	t1.ctrlkey = 3
	t1.location = 0
	t1.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/MediaPortal_Logo.png'
	m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
	m_simpleTV.Interface.AddExtMenuT(t1)
	m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
-------------------------------------------------------------------