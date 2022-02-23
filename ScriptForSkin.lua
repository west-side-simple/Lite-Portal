--Плагин быстрого доступа к замене скина, обоев, расположения контролпанели для lite portal - west_side 23.02.22
function background_skin()
	local currentbackground = m_simpleTV.Config.GetValue('mainView/logo/file','simpleTVConfig') or ''
	local path = m_simpleTV.Common.GetMainPath(2) .. 'work/Channel/logo/Wallpapers/'
	local dir = io.popen('chcp 1251|dir /a-d /b "' .. path .. '"')
	local t,i,currentid = {},1,1
	for filename in dir:lines() do
	if not filename:match('%.jpg') and not filename:match('%.png') then break end
	t[i] ={}
	t[i].Id = i
	t[i].Name = filename
	t[i].Action = filename
	t[i].InfoPanelLogo = m_simpleTV.Common.GetMainPath(2) .. 'work/Channel/logo/Wallpapers/' .. filename
	t[i].InfoPanelTitle = 'Select background'
	t[i].InfoPanelDesc = '<html><body ><table><tr><td width="100%"><center><img src="simpleTVImage:./work/Channel/logo/Wallpapers/' .. filename .. '" width="900"></td></tr></table></body></html>'
	t[i].InfoPanelShowTime = 9000
	if currentbackground == '../Channel/logo/Wallpapers/' .. filename then currentid = i end
	i=i+1
end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Skins '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' View '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Select background',currentid-1,t,9000,1+4+8)
    if id==nil then return end
    if ret == 1 then
	  m_simpleTV.Config.SetValue('mainView/logo/file', '../Channel/logo/Wallpapers/' .. t[id].Action ,'simpleTVConfig')
	  m_simpleTV.Config.Apply('NEED_MAIN_VIEW_UPDATE')
	  m_simpleTV.Control.ExecuteAction(37)
	  background_skin()
    end
	if ret == 2 then
	  skin_schema_settings()
    end
	if ret == 3 then
	if id == #t
	then
	  m_simpleTV.Config.SetValue('mainView/logo/file', '../Channel/logo/Wallpapers/' .. t[1].Action ,'simpleTVConfig')
	else
	  m_simpleTV.Config.SetValue('mainView/logo/file', '../Channel/logo/Wallpapers/' .. t[id+1].Action ,'simpleTVConfig')
	end
	  m_simpleTV.Config.Apply('NEED_MAIN_VIEW_UPDATE')
	  m_simpleTV.Control.ExecuteAction(37)
	  background_skin()
    end
	dir:close()
end
-------------------------------------------------------------------
function skin_schema_settings()

local function set_skin(dir)
	local answer
	local baze = 'skin.xml'
	local path = m_simpleTV.Common.GetMainPath(2) .. 'skin/' .. dir .. '/'
	local file = io.open(path .. baze, 'r')
	if not file then
	skin_schema_settings()
	return
	else
	answer = file:read('*a')
	file:close()
	end
	local version,author,name,desc,preview = answer:match('<SimpleTVSkin.-version="(.-)".-author="(.-)".-name="(.-)".-desc="(.-)".-imagepre="(.-)">')
-- controlside
	local controlside = 1
	if dir:match('WS')
	or dir:match('base')
	or dir:match('BlackGlass')
-- add dir for controlside = 0
	then controlside = 0 end
-- backgroundimage
	local backgroundimage = '../Channel/logo/Wallpapers/simple.jpg'
	if dir:match('WS')
	or dir:match('FM')
	or dir:match('Dark')
-- add dir for backgroundimage
	then backgroundimage = '../Channel/logo/Wallpapers/' .. dir .. '.jpg' end
	return name, m_simpleTV.Common.GetMainPath(2) .. 'skin/' .. dir .. '/' .. preview:gsub('\\','/'), desc .. ', author: ' .. author .. ', version: ' .. version, backgroundimage, controlside
end

m_simpleTV.Control.ExecuteAction(37)
require'lfs'
	local currentskin = m_simpleTV.Config.GetValue('skin/path','simpleTVConfig') or ''
	local path = m_simpleTV.Common.GetMainPath(2) .. 'skin/'
	local dir = io.popen('dir /ad /b "' .. path .. '"')

	local t,i,currentid = {},1,1
	for direname in dir:lines() do
	t[i] ={}
	t[i].Id = i
	t[i].Name,t[i].InfoPanelLogo,t[i].InfoPanelTitle,t[i].backgroundimage,t[i].osdcontrolpanelside = set_skin(direname)
	t[i].Action = direname
	t[i].InfoPanelDesc = '<html><body ><table><tr><td width="100%"><center><img src="simpleTVImage:' .. t[i].InfoPanelLogo .. '" width="700"></td></tr></table></body></html>'
	t[i].InfoPanelShowTime = 10000
	if currentskin == './skin/' .. direname then currentid = i end
	i=i+1
	end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Control '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Background '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Skin settings',currentid-1,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
    m_simpleTV.Config.SetValue('skin/path', './skin/' .. t[id].Action ,'simpleTVConfig')
	m_simpleTV.Config.SetValue('osdcontrolpanel/side', t[id].osdcontrolpanelside ,'simpleTVConfig')
	m_simpleTV.Config.SetValue('mainView/logo/file', t[id].backgroundimage ,'simpleTVConfig')
	m_simpleTV.Common.Restart()
  end
  if ret == 2 then
    controlside()
  end
  if ret == 3 then
	background_skin()
  end
end
-------------------------------------------------------------------
function controlside()
local mws={{"UP",0},{"DOWN",1}}
local t = {}
	for i=1,#mws do
    t[i] = {}
    t[i].Id = i
    t[i].Name = mws[i][1]
    t[i].Action = mws[i][2]
    end
	local side = m_simpleTV.Config.GetValue('osdcontrolpanel/side','simpleTVConfig') or 0
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Skins '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('OSD controlpanel side',side,t,9000,1+4+8)
    if id==nil then return end
    if ret == 1 then
	  m_simpleTV.Config.SetValue('osdcontrolpanel/side', t[id].Action ,'simpleTVConfig')
	  controlside()
	  m_simpleTV.Config.Apply('NEED_CONTROLPANELBASE_UPDATE')
    end
	if ret == 2 then
	  skin_schema_settings()
    end
end
-------------------------------------------------------------------

	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
local function getConfigVal(key)
 return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

-------------------------------------------------------------------
local dataEN = os.date ("%a %d %b %Y %H:%M")
	dataRU = dataEN:gsub('Sun', 'Вс'):gsub('Mon', 'Пн'):gsub('Tue', 'Вт'):gsub('Wed', 'Ср'):gsub('Thu', 'Чт'):gsub('Fri', 'Пт'):gsub('Sat', 'Сб')
	dataRU = dataRU:gsub('Jan', 'Янв'):gsub('Feb', 'Фев'):gsub('Mar', 'Мар'):gsub('Apr', 'Апр'):gsub('May', 'Май'):gsub('Jun', 'Июн'):gsub('Jul', 'Июл'):gsub('Aug', 'Авг'):gsub('Sep', 'Сен'):gsub('Oct', 'Окт'):gsub('Nov', 'Ноя'):gsub('Dec', 'Дек')
	if m_simpleTV.Interface.GetLanguage() == 'ru' then data = dataRU else data = dataEN end
-------------------------------------------------------------------

	userAgent = "Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0"
	session =  m_simpleTV.Http.New(userAgent)
	if not session then
	return ''
	end
	m_simpleTV.Http.SetTimeout(session, 8000)

rc,answer = m_simpleTV.Http.Request(session,{url='http://m24.do.am/_fr/0/upd.txt'})
if rc~=200 then
  m_simpleTV.Http.Close(session)
  return
end
	local str3 = answer:match('^.-\n.-\n(.-)\n')
	local str4 = answer:match('^.-\n.-\n.-\n(.-)\n')
	local str5 = answer:match('^.-\n.-\n.-\n.-\n(.-)\n')
	local str6 = answer:match('^.-\n.-\n.-\n.-\n.-\n(.-)\n')
	local str7 = answer:match('^.-\n.-\n.-\n.-\n.-\n.-\n(.-)\n')
	local h,m,d,mo,y = answer:match('(%d+):(%d+) (%d+)%.(%d+)%.(%d+)')
	local h1,m1,d1,mo1,y1 = answer:match('\n(%d+):(%d+) (%d+)%.(%d+)%.(%d+)')
	dateuptime = { year = '20' .. y,
                   month = mo,
                   day = d,
                   hour = h,
                   min = m,
                   sec = 0
                  }
	dateuptime1 = { year = '20' .. y1,
                   month = mo1,
                   day = d1,
                   hour = h1,
                   min = m1,
                   sec = 0
                  }
	t1 = os.time(dateuptime)
	t2 = getConfigVal("Upd") or 0
	t3 = os.time(dateuptime1)
	t4 = getConfigVal("Upd1") or 0


if t1 and t2 then
	need = tonumber(t1) - tonumber(t2)
end
if t3 and t4 then
	need1 = tonumber(t3) - tonumber(t4)
end
if need then
if need > 0 then
	setConfigVal("Upd",t1)
	setConfigVal("need",1)
	m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/_fr/0/7911633.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.5" src="http://m24.do.am/images/liteportal.png"', text = str3 .. '\nТекущее время: ' .. data, color = ARGB(255, 255, 255, 255), showTime = 2000 * 10})
   local params = {}
   params.message = 'Для обновления сборки нажмите кнопку ДА.'
   params.caption = 'westSide'
   params.buttons = 'Yes|No'
   params.icon = 'Question'
   params.defButton = 'Yes'
   if m_simpleTV.Interface.MessageBoxT(params) == 'Yes' then
    setConfigVal("Upd",t1)
	setConfigVal("need",0)
	os.execute('tv-update.exe')
   end
	elseif need <= 0 then
	setConfigVal("need",0)
	if str5~='' then
	m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = str5 , TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.5" src="http://m24.do.am/images/liteportal.png"' , text = str6 ,  color = ARGB(255, 255, 255, 255), showTime = 1700 * 10})
end
end

 local t={}
 t.utf8 = true
 t.name = 'Skin settings'
 t.luastring = 'skin_schema_settings()'
 t.lua_as_scr = true
 t.key = string.byte('E')
 t.ctrlkey = 4
 t.location = 0
 t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/emptyLogo.png'
 m_simpleTV.Interface.AddExtMenuT(t)