-- SergeyVS, west_side 20.03.23
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
  m_simpleTV.Dialog.ExecScript(Object,'doTranslate();')
end
----------------------------------------------------------------------
function mess(Object, mes)
m_simpleTV.OSD.ShowMessageT({text = 'Portal info: ' .. tostring(mes), color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
end
----------------------------------------------------------------------
function setSearch(Object, search)
m_simpleTV.Config.SetValue('search/media',tostring(m_simpleTV.Common.toPercentEncoding(search)),'LiteConf.ini')
end

function update_skin(Object)
 local numbs = getConfigVal('keyboard/number') or '1'
 m_simpleTV.Dialog.ExecScript(Object,'updateSkin(\'' .. numbs .. '\');')
end
----------------------------------------------------------------------
function baseInit(Object)

 local scr = 'setViewMode(' ..  tostring(westSidePortal.isEmbedded()) .. ')'

 m_simpleTV.Dialog.ExecScript(Object,scr)
 if westSidePortal.isSavePosition() and not westSidePortal.isEmbedded() then
  m_simpleTV.Dialog.SetOnCloseEvent(Object,'westSidePortalDialogCloseEvent')
 end
end
----------------------------------------------------------------------
function OnNavigateComplete(Object)
  translateHtml(Object)
  baseInit(Object)
end
----------------------------------------------------------------------
function westSidePortalDialogRequestClose(Object)
 m_simpleTV.Dialog.Close(Object)
end
----------------------------------------------------------------------
function westSidePortalDialogCloseEvent(Object)
 if westSidePortal.isSavePosition() and not westSidePortal.isEmbedded() then
  westSidePortal.savePosition(m_simpleTV.Dialog.GetWindowPos(Object))
 end
end
----------------------------------------------------------------------
function getConfigFile()
 return 'westSidePortal.ini'
end
------------------------------------------------------------------------------
function getConfigVal(key)
 return m_simpleTV.Config.GetValue(key,getConfigFile())
end
------------------------------------------------------------------------------
function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,getConfigFile())
end
------------------------------------------------------------------------------
function search_all()
m_simpleTV.Control.ExecuteAction(37)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local search_ini = getConfigVal('search/media') or ''
	local tt1={
	{'Трекеры',''},
	{'RipsClub (HEVC)',''},
	{'TMDb',''},
	{'EX-FS',''},
	{'Rezka',''},
	{'Filmix',''},
--	{'KinoGo',''},
	{'KinoKong',''},
--	{'UA',''},
	{'Kinopub',''},
	{'YouTube',''},
--	{'VideoCDN',''},
	}

  local t1={}
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
	t1[i].Action = tt1[i][2]
  end
  t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
  t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Search Lite Portal: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini),0,t1,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
  if t1[id].Name == 'TMDb' then search_tmdb()
  elseif t1[id].Name == 'EX-FS' then search_media()
  elseif t1[id].Name == 'Rezka' then search_rezka()
  elseif t1[id].Name == 'Filmix' then search_filmix_media()
  elseif t1[id].Name == 'Трекеры' then content_adr_page('http://api.vokino.tv/v2/list?name=' .. search_ini)
  elseif t1[id].Name == 'RipsClub (HEVC)' then search_hevc('https://rips.club/search/?part=0&year=&cat=0&standard=0&bit=0&order=1&search=' .. search_ini)
  elseif t1[id].Name == 'KinoGo' then search_kinogo()
  elseif t1[id].Name == 'KinoKong' then search_kinokong()
  elseif t1[id].Name == 'UA' then search_ua()
  elseif t1[id].Name == 'Kinopub' then show_select('https://kino.pub/item/search?query=' .. search_ini)
  elseif t1[id].Name == 'YouTube' then search_youtube()
  elseif t1[id].Name == 'VideoCDN' then m_simpleTV.Control.PlayAddress('*' .. m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Common.fromPercentEncoding(search_ini)))
  end
  end
  if ret == 3 then
   search()
  end
  if ret == 2 then
   run_westSide_portal()
  end
end
------------------------------------------------------------------------------
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