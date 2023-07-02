--Плагин быстрого доступа к замене скина, обоев, виртуальной клавиатуры, расположения контролпанели для lite portal - west_side 02.07.23
function background_skin()
	local currentbackground = m_simpleTV.Config.GetValue('mainView/logo/file','simpleTVConfig') or ''
	local path = m_simpleTV.Common.GetMainPath(2) .. 'work/Channel/logo/Wallpapers/'
	local t1,t,i,currentid = m_simpleTV.Common.DirectoryEntryList(path,'*.png;*.jpg','Files|NoDot|NoDotDot','Name|IgnoreCase|DirsFirst'),{},1,1
    if t1~=nil then
    for i=1,#t1 do
	t[i] ={}
	t[i].Id = i
	t[i].Name = t1[i].fileName
	t[i].Action = t1[i].fileName
	t[i].InfoPanelLogo = m_simpleTV.Common.GetMainPath(2) .. 'work/Channel/logo/Wallpapers/' .. t1[i].fileName
	t[i].InfoPanelTitle = 'Select background'
	t[i].InfoPanelDesc = '<html><body ><table><tr><td width="100%"><center><img src="simpleTVImage:./work/Channel/logo/Wallpapers/' .. t1[i].fileName .. '" width="900"></td></tr></table></body></html>'
	t[i].InfoPanelShowTime = 9000
	if currentbackground == '../Channel/logo/Wallpapers/' .. t1[i].fileName then currentid = i end
	i=i+1
	end
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
	or dir:match('TiVi')
    or dir:match('MediaPortal')
    or dir:match('BloodNight')
	or dir:match('Dark')
	or dir:match('BlackGlass')
-- add dir for backgroundimage
	then backgroundimage = '../Channel/logo/Wallpapers/' .. dir .. '.jpg' end
	return name, m_simpleTV.Common.GetMainPath(2) .. 'skin/' .. dir .. '/' .. preview:gsub('\\','/'), desc .. ', author: ' .. author .. ', version: ' .. version, backgroundimage, controlside
end

m_simpleTV.Control.ExecuteAction(37)
require'lfs'

	local currentskin = m_simpleTV.Config.GetValue('skin/path','simpleTVConfig') or ''
	local path = m_simpleTV.Common.GetMainPath(2) .. 'skin/'
	local t1,t,i,currentid = m_simpleTV.Common.DirectoryEntryList(path,nil,'Dirs|NoDot|NoDotDot','Name|IgnoreCase|DirsFirst'),{},1,1
    if t1~=nil then
    for i=1,#t1 do
	t[i] ={}
	t[i].Id = i
	t[i].Name,t[i].InfoPanelLogo,t[i].InfoPanelTitle,t[i].backgroundimage,t[i].osdcontrolpanelside = set_skin(t1[i].fileName)
	t[i].Action = t1[i].fileName
	t[i].InfoPanelDesc = '<html><body ><table><tr><td width="100%"><center><img src="simpleTVImage:' .. t[i].InfoPanelLogo .. '" width="700"></td></tr></table></body></html>'
	t[i].InfoPanelShowTime = 10000
	if currentskin == './skin/' .. t1[i].fileName then currentid = i end
	i=i+1
	end
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
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Keyboard '}
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
	if ret == 3 then
	  select_keyboard()
    end
end
-------------------------------------------------------------------
function select_keyboard()
	m_simpleTV.Control.ExecuteAction(37)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"westSidePortal.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"westSidePortal.ini")
	end
	local kb_pack=
	{
	{"Без клавиатуры",0},
	{"Dark",1},
	{"Green",2},
	{"Light",3},
	{"Neon",4},
	{"Classic",5},
--[[	{"Grey",6},
	{"Modern Green",7},
	{"Rainbow",9},
	{"Vintage",10},
	{"Circle",11},
	{"Modern",12},
	{"Gold",13},
	{"Circle Neon",14},
	{"Neon",15},--]]
	{"Circle Grey",6},
	{"Umbrella",7},
	{"Circle Yellow",8},
    {"Glass",9},
	}
	local cur_keyboard = getConfigVal('keyboard/number') or m_simpleTV.Config.GetValue("keyboard/number","westSidePortal.ini") or 1
	local t = {}
	for i=1,#kb_pack do
    t[i] = {}
    t[i].Id = i
    t[i].Name = kb_pack[i][1]
    t[i].Action = kb_pack[i][2]
	t[i].InfoPanelLogo = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSidePortal/GUI/img/' .. kb_pack[i][2] .. '.svg'
	t[i].InfoPanelShowTime = 10000
    end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Skins '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Keyboard Pack',cur_keyboard,t,9000,1+4+8)
    if id==nil then return end
    if ret == 1 then
	  setConfigVal('keyboard/number',t[id].Action)
	  dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\westSidePortal\\GUI\\showDialog.lua')
    end
	if ret == 2 then
	  skin_schema_settings()
    end
end
		if not m_simpleTV.Config.GetValue('mainPlayController/playLastChannelOnStartup','simpleTVConfig') == true and not io.open(m_simpleTV.MainScriptDir .. 'user/startup/ScriptForAssemblage.lua', 'r') then
			m_simpleTV.Control.PlayAddressT({title='SimpleTV',address='SimpleTV'})-- fix title
		end
-------------------------------------------------------------------
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
-------------------------------------------------------------------
