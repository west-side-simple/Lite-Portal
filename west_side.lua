--startup westSide portal
--saved as utf-8 without bom
--wafee code, west_side updated 24.02.23
-------------------------------------------------------------------
if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
if m_simpleTV.User.filmix==nil then m_simpleTV.User.filmix={} end
if m_simpleTV.User.torrent==nil then m_simpleTV.User.torrent={} end
if m_simpleTV.User.hevc==nil then m_simpleTV.User.hevc={} end
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
		if m_simpleTV.User.filmix and m_simpleTV.User.filmix.TabSimilar then
			similar_filmix()
			elseif m_simpleTV.User.TMDB and m_simpleTV.User.TMDB.Id and m_simpleTV.User.TMDB.tv then
			media_info_tmdb(m_simpleTV.User.TMDB.Id,m_simpleTV.User.TMDB.tv)
			elseif m_simpleTV.User.collaps and m_simpleTV.User.collaps.ua then
			ua_info(m_simpleTV.User.westSide.PortalTable)
			elseif m_simpleTV.User.hdua and m_simpleTV.User.hdua.serial then
			ua_serial()
			elseif m_simpleTV.User.collaps and m_simpleTV.User.collaps.kinogo then
			kinogo_info(m_simpleTV.User.westSide.PortalTable)
			elseif m_simpleTV.User.torrent and m_simpleTV.User.torrent.content then
			content(m_simpleTV.User.westSide.PortalTable)
			elseif m_simpleTV.User.hevc and m_simpleTV.User.hevc.content then
			content_hevc(m_simpleTV.User.westSide.PortalTable)
		end
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
--------------------------------------
function KP_Get_History()

-- wafee code for history

    local recentName = getConfigVal('kp_history/title') or ''
    local recentAddress = getConfigVal('kp_history/adr') or ''
	local recentLogo = getConfigVal('kp_history/logo') or ''

     local t,i={},1

   if recentName~='' and recentLogo~='' and recentAddress~='' and recentIndex~='' then
     for w in string.gmatch(recentName,"[^,]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
	   t[i].InfoPanelName = w
	   t[i].InfoPanelShowTime = 10000
       i=i+1
     end
     i=1
     for w in string.gmatch(recentAddress,"[^,]+") do
       t[i].Address = w
	   t[i].InfoPanelTitle = w:match('%&bal=(.-)$')
       i=i+1
     end
	 i=1
     for w in string.gmatch(recentLogo,"[^,]+") do
       t[i].InfoPanelLogo = w
       i=i+1
     end
   end
   t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
   t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Cleane '}
   local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Кинопоиск: История просмотра',0,t,9000,1+4+8)
   if id==nil then return end
   if ret==1 then
      m_simpleTV.Control.PlayAddressT({address = t[id].Address})
   end
   if ret==2 then
	  run_westSide_portal()
   end
   if ret==3 then
      setConfigVal('kp_history/title','')
	  setConfigVal('kp_history/logo','')
	  setConfigVal('kp_history/adr','')
	  run_westSide_portal()
   end
   end
--------------------------------------------------
function run_westSide_portal()
 m_simpleTV.Control.ExecuteAction(37)
 local tt1={
 {'Поиск',''},
 {'Кинопоиск: История',''},
 {'Закладки',''},
 {'TMDb',''},
 {'Трекеры',''},
 {'RipsClub (HEVC)',''},
 {'EX-FS',''},
 {'Rezka',''},
 {'Filmix',''},
 {'Kinopub',''},
 {'Переводы',''},
 {'KinoGo',''},
 {'KinoKong',''},
 {'UA',''},
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
  elseif t1[id].Name == 'Поиск' then
--  search()
  dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\westSidePortal\\GUI\\showDialog.lua')
  elseif t1[id].Name == 'Закладки' then
  m_simpleTV.Control.ExecuteAction(100)
  elseif t1[id].Name == 'Кинопоиск: История' then KP_Get_History()
  elseif t1[id].Name == 'Медиабазы' then mediabaze()
  elseif t1[id].Name:match('SimpleTV') then highlight()
  elseif t1[id].Name == 'Переводы' then run_lite_qt_cdntr()
  elseif t1[id].Name == 'Трекеры' then start_page()
  elseif t1[id].Name == 'KinoGo' then run_lite_qt_kinogo()
  elseif t1[id].Name == 'KinoKong' then run_lite_qt_kinokong()
  elseif t1[id].Name == 'UA' then run_lite_qt_ua()
  elseif t1[id].Name == 'RipsClub (HEVC)' then start_hevc()
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