-- SergeyVS, west_side 18.05.25
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
 if not Object then return end
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
--------------------------------------
function add_to_history_of_search()

	local search_ini = m_simpleTV.Config.GetValue('search/media',"LiteConf.ini") or ''
	local title = m_simpleTV.Common.fromPercentEncoding(search_ini)


	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = m_simpleTV.Config.GetValue('search/history','LiteConf.ini') or ''

    local t={}
    local i=2
	t[1] = {}
    t[1].Id = 1
    t[1].Name = title
	if recentName~='' then
		for w in string.gmatch(recentName,"[^|]+") do
			t[i] = {}
			t[i].Id = i
			t[i].Name = w
			i=i+1
		end
		local function isExistName()
			for i=2,#t do
				if title==t[i].Name then
					return true, i
				end
			end
			return false
		end
		local isExist, i = isExistName()
		if isExist then
			table.remove(t,i)
--			table.remove(t,1)
		end
		recentName=''
		if #t <= tonumber(max_history) then
			cur_max = #t
		else
			cur_max = tonumber(max_history)
		end
		for i = 1, cur_max do
			local name = t[i].Name
			recentName = recentName .. '|' .. name
			t[i].Id = i
	--      debug_in_file(t[i].Id .. ' / ' .. t[i].Name .. '\n-----------------/n','c://1/history_search.txt')
		end
		m_simpleTV.Config.SetValue('search/history','|' .. recentName .. '|','LiteConf.ini')
	else
		m_simpleTV.Config.SetValue('search/history', '|' .. title .. '|','LiteConf.ini')
	end
end
--------------------------------------
function search_all()
--m_simpleTV.Control.ExecuteAction(37)

	local search_ini = m_simpleTV.Config.GetValue('search/media',"LiteConf.ini") or ''

	local tt1={
	{'Трекеры',''},
	{'TMDb',''},
	{'IMDB',''},
	{'Filmix',''},
	{'Rezka',''},
	{'YouTube',''},
	{'EX-FS',''},
	{'KinoGo',''},
	{'KinoKong',''},
	{'RipsClub (HEVC)',''},
--	{'UA',''},
	{'Kinopub',''},
	{'PortalTV',''},
	{'VideoCDN',''},
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
  elseif t1[id].Name == 'IMDB' then content_imdb('https://www.imdb.com/find/?s=tt&ref_=nv_sr_sm&q=' .. search_ini:gsub('%%28.-%%29',''), m_simpleTV.Common.fromPercentEncoding(search_ini))
  elseif t1[id].Name == 'EX-FS' then search_media()
  elseif t1[id].Name == 'Rezka' then search_rezka()
  elseif t1[id].Name == 'Filmix' then search_filmix_media()
  elseif t1[id].Name == 'Трекеры' then content_adr_page('http://api.vokino.tv/v2/list?name=' .. search_ini:gsub('%%28.-%%29',''))
  elseif t1[id].Name == 'RipsClub (HEVC)' then search_hevc('https://rips.club/search.php?part=0&year=&cat=0&standard=0&bit=0&order=1&search=' .. search_ini:gsub('%%28.-%%29',''))
  elseif t1[id].Name == 'KinoGo' then search_kinogo()
  elseif t1[id].Name == 'KinoKong' then search_kinokong()
  elseif t1[id].Name == 'UA' then search_ua()
  elseif t1[id].Name == 'Kinopub' then show_select('https://kino.pub/item/search?query=' .. search_ini:gsub('%%28.-%%29',''))
  elseif t1[id].Name == 'YouTube' then search_youtube()
  elseif t1[id].Name == 'PortalTV' then
  if m_simpleTV.User.TVPortal.Use == 0 then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Аддон отключен.\n Включить можно в настройках.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return search_all()
	else
		SelectTVPortal_search()
	end
  elseif t1[id].Name == 'VideoCDN' then search_videocdn()
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
--------------------------------------
function start_page_mediaportal()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local function get_balanser_img(name)
		local balansers = {
						{'VF','Vibix'},
						{'ZF','Zetflix'},
						{'HDVB','HDVB'},
						{'Collaps','Collaps'},
						{'FX','FXLite'},
						{'Ashdi','ASHDI'},
						{'Magnets','Trackers'},
						}
		for i = 1,#balansers do
			if balansers[i][1] == name then
				return balansers[i][2]
			end
		end
		return
	end

	local function get_balanser_img_from_adr(adr)
		if adr:match('videoframe') then
			return 'Vibix'
		elseif adr:match('zetflix') then
			return 'Zetflix'
		elseif adr:match('https?://api%..-/embed/') then
			return 'Collaps'
		elseif adr:match('https?://vid%d+[^/]+/%a+/%x+/iframe') then
			return 'HDVB'
		elseif adr:match('/lite/ashdi') then
			return 'ASHDI'
		elseif adr:match('/lite/filmix') then
			return 'FXLite'
		elseif adr:match('magnet:') then
			return 'Trackers'
		end
		return ''
	end

			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
--			stena_clear()
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = true

			local tt = {
			{'Поиск Медиа','poisk_media.png','stena_search'},
			{'EX-FS','EX-FS.png','run_lite_qt_exfs'},
			{'TMDB','tmdb.png','run_lite_qt_tmdb'},
			{'HDRezka','hdrezka.png','get_start'},
			{'Filmix','filmix.png','movie_genres_filmix1'},
			{'IMDB','IMDB.png','run_lite_qt_imdb'},
			{'VideoCDN','VideoCDN.png','run_lite_qt_cdntr_ozv'},
			{'TV Potal','tv_portal.png','SelectTVPortal'},
			{'YouTube','youtube.png','get_answer_start'},
			}

			local tt1 = {
			{'Search ⟲','','get_history_of_search'},
--			{'VideoCDN','VideoCDN.png','run_lite_qt_cdntr_ozv'},
--			{'EX-FS','','run_lite_qt_exfs'},
			{'KinoGo','','run_lite_qt_kinogo'},
			{'KinoKong','','run_lite_qt_kinokong'},
--			{'UA','','run_lite_qt_ua'},
			{'RipsClub','hevc.png','start_hevc'},
			{'Kinopub','','run_lite_qt_kinopub'},
			{'Трекеры','','start_page'},
			}

			local  t, AddElement = {}, m_simpleTV.OSD.AddElement

			 t = {}
			 t.id = 'ID_DIV_STENA_1'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=-70 / m_simpleTV.Interface.GetScale()*1.5
			 t.once=1
			 t.zorder=1
			 t.background = -1
			 t.backcolor0 = 0xff0000000
			 AddElement(t)

			 t = {}
			 t.id = 'ID_DIV_STENA_2'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=0
			 t.once=1
			 t.zorder=0
			 t.background = 1
			 t.backcolor0 = 0x440000FF
--			 t.backcolor1 = 0x77FFFFFF
			 AddElement(t)

			 t = {}
			 t.id = 'FON_STENA_ID'
			 t.cx= -100
			 t.cy= -100
			 t.class="IMAGE"
			 t.animation = true
			 t.imagepath = 'type="dir" count="150" delay="60" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/cerberus/cerberus%1.png"'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=0
			 t.top=0
			 t.transparency = 255
			 t.zorder=1
			 AddElement(t,'ID_DIV_STENA_2')

				 t = {}
				 t.id = 'GLOBUS_STENA_ID'
				 t.cx= 60
				 t.cy= 60
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d/d%0.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0103
				 t.left=15
				 t.top=110
				 t.transparency = 255
				 t.zorder=2
				 t.isInteractive = true
				 t.cursorShape = 13
				 t.mousePressEventFunction = 'stena_clear'
--				 t.mousePressEventFunction = 'start_page_mediaportal_test'
				 AddElement(t,'ID_DIV_STENA_1')
				 
				 t = {}
				 t.id = 'BOOKMARK_STENA_ID'
				 t.cx= 60
				 t.cy= 60
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Bookmark/d%0.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=15
				 t.top=110
				 t.transparency = 255
				 t.zorder=2
				 t.isInteractive = true
				 t.cursorShape = 13
				 t.mousePressEventFunction = 'get_bookmark'
				 AddElement(t,'ID_DIV_STENA_1')

				 t={}
				 t.id = 'TEXT_STENA_TITLE_ID'
				 t.cx=-100
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = 'Mediaportal SimpleTV'
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = m_simpleTV.User.TVPortal.stena_exfs_title_font or 'Segoe UI Black'
				 t.textparam = 0x00000001
				 t.boundWidth = 15 -- bound to screen
				 t.row_limit=1 -- row limit
				 t.scrollTime = 40 --for ticker (auto scrolling text)
				 t.scrollFactor = 2
				 t.scrollWaitStart = 70
				 t.scrollWaitEnd = 100
				 t.left = 0
				 t.top  = 100
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'ID_DIV_STENA_1')

			for j = 1,9 do

			 t = {}
			 t.id = 'MEDIAPOISK_IMG_STENA_BACK_ID' .. j
			 t.cx= 170
			 t.cy= 170
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 75 + 200*(j-1)
			 t.top= 200
			 t.transparency = 200
			 t.zorder=0
--			 t.borderwidth = 1
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 4
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
--			 t.borderwidth_UnderMouse = 4
--			 t.backroundcorner_UnderMouse = 6*6
--			 t.borderround_UnderMouse = 6
			 t.mousePressEventFunction = tt[j][3]
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'MEDIAPOISK_IMG_STENA_ID' .. j
			 t.cx= 120 / 1*1.25
			 t.cy= 120 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/' .. tt[j][2]
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'MEDIAPOISK_IMG_STENA_BACK_ID' .. j)

			t = {}
			t.id = 'MEDIAPOISK_TXT_STENA_ID' .. j
			t.cx= 100 / 1*1.25
			t.cy= 100 / 1*1.25
			t.class="TEXT"
			t.text = tt[j][1]
			t.align = 0x0101
			t.left= 145 + 170*(j-1) / 1*1.25
			t.top= 250
			t.color = ARGB(255, 192, 192, 192)
			t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			t.font_name = "Segoe UI Black"
			t.color_UnderMouse = ARGB(255, 65, 105, 225)
			t.glowcolor_UnderMouse = 0xFFFFFFFF
			t.glow_samples_UnderMouse = 4
			t.isInteractive = true
			t.cursorShape = 13
			t.textparam = 0x00000001
			t.text_elidemode = 1
			t.zorder=2
			t.glow = 2 -- коэффициент glow эффекта
			t.glowcolor = 0xFF000077 -- цвет glow эффекта
			t.mousePressEventFunction = tt[j][3]
--			AddElement(t,'ID_DIV_STENA_1')

		end

			for j = 1,6 do

			 t = {}
			 t.id = 'MEDIAPOISK2_IMG_STENA_BACK_ID' .. j
			 t.cx= 240
			 t.cy= 100
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 140 + 280*(j-1)
			 t.top= 410
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 4
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 4*4
			 t.borderround = 4
			 t.mousePressEventFunction = tt1[j][3]
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'MEDIAPOISK2_IMG_STENA_ID' .. j
			 t.cx= 120 / 1*1.25
			 t.cy= 120 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/' .. tt1[j][2]
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 125 + 250*(j-1)
			 t.top= 445
			 t.transparency = 200
			 t.zorder=2
--			 AddElement(t,'ID_DIV_STENA_1')

			t = {}
			t.id = 'MEDIAPOISK2_TXT_STENA_ID' .. j
			t.cx= 120 / 1*1.25
			t.cy= 60 / 1*1.25
			t.class="TEXT"
			t.text = tt1[j][1]
			t.align = 0x0202
			t.left= 0
			t.top= 15
			t.color = ARGB(255, 192, 192, 192)
			t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			t.font_name = "Segoe UI Black"
			t.color_UnderMouse = ARGB(255, 65, 105, 225)
			t.glowcolor_UnderMouse = 0xFFFFFFFF
			t.glow_samples_UnderMouse = 6
			t.isInteractive = true
			t.cursorShape = 13
			t.textparam = 0x00000001
			t.text_elidemode = 1
			t.zorder=2
			t.glow = 2 -- коэффициент glow эффекта
			t.glowcolor = 0xFF000077 -- цвет glow эффекта
			t.mousePressEventFunction = tt1[j][3]
			AddElement(t,'MEDIAPOISK2_IMG_STENA_BACK_ID' .. j)

		end
		
			t={}
			t.id = 'TEXT_STENA_6_ID'
			t.cx=0
			t.cy=50
			t.class="TEXT"
			t.align = 0x0101
			t.color = -2113993
			t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			t.text = '    История просмотра    '
			t.boundWidth = 50
			t.row_limit=2
			t.text_elidemode = 1
			t.zorder=2
			t.glow = 2 -- коэффициент glow эффекта
			t.font_name = m_simpleTV.User.TVPortal.stena_exfs_title_font or 'Segoe UI Black'
			t.textparam = 0--1+4
			t.left = 755
			t.top  = 540
			t.glowcolor = 0xFF000077 -- цвет glow эффекта
			t.backroundcorner = 3*3
			t.background = 2
			t.backcolor0 = 0xEE4169E1
			t.backcolor1 = 0xEE00008B
			AddElement(t,'ID_DIV_STENA_1')

	local schemes = {
	'EX-FS ⟲',
	'HDRezka ⟲',
	'Filmix ⟲',
	'TMDB ⟲',
	'IMDb ⟲',
	'Trackers ⟲'
	}
	local current_scheme = getConfigVal('current_scheme') or 'EX-FS'
	for j = 1, #schemes do
		t = {}
			 t.id = 'HISTORY_STENA_' .. schemes[j]:gsub('%s.-$','') .. '_IMG_ID'
			 t.cx= 255
			 t.cy= 40
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left = 105 + (j-1)*290
			 t.top  = 610
			 t.transparency = 60
			 t.zorder=0
			 t.borderwidth = 2
			 if current_scheme == schemes[j]:gsub('%s.-$','') then
				t.bordercolor = ARGB(255, 255, 255, 255)
				t.background = 2
				t.backcolor0 = 0xEE4169E1
				t.backcolor1 = 0x774169E1
			 else
				t.bordercolor = -6250336
			 end
			 t.isInteractive = true
			 t.background_UnderMouse = 2
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0x774169E1
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 2*2
			 t.borderround = 2
			 t.mousePressEventFunction = ''
			 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'HISTORY_STENA_' .. schemes[j]:gsub('%s.-$','') .. '_TEXT_ID'
				t.cx=180
				t.cy=35
				t.class="TEXT"
				t.text = schemes[j]
				t.align = 0x0202
				if current_scheme == schemes[j]:gsub('%s.-$','') then
					t.color = ARGB(255, 255, 255, 255)
				else
					t.color = ARGB(255, 192, 192, 192)
				end
				t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = m_simpleTV.User.TVPortal.stena_exfs_title_font or 'Segoe UI Black'
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 0
			    t.top  = 0
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'history_stena_start'
				AddElement(t,'HISTORY_STENA_' .. schemes[j]:gsub('%s.-$','') .. '_IMG_ID')

				t = {}
				t.id = 'HISTORY_STENA_' .. schemes[j]:gsub('%s.-$','') .. '_CLEANE_ID'
				t.cx=40
				t.cy=40
				t.class="TEXT"
				t.text = '  '
				t.align = 0x0101
				if current_scheme == schemes[j]:gsub('%s.-$','') then
					t.color = ARGB(255, 255, 255, 255)
				else
					t.color = ARGB(255, 192, 192, 192)
				end
				t.font_height = -11 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 0, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 40
				t.left = 210
			    t.top  = 0
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'history_stena_cleane'
				AddElement(t,'HISTORY_STENA_' .. schemes[j]:gsub('%s.-$','') .. '_IMG_ID')
	end


    local recentName
    local recentAddress
	local recentLogo

	if current_scheme == 'EX-FS' then
		recentName = getConfigVal('exfs_history/title') or ''
		recentAddress = getConfigVal('exfs_history/adr') or ''
		recentLogo = getConfigVal('exfs_history/logo') or ''
	elseif current_scheme == 'HDRezka' then
		recentName = getConfigVal('rezka_history/title') or ''
		recentAddress = getConfigVal('rezka_history/adr') or ''
		recentLogo = getConfigVal('rezka_history/logo') or ''
	elseif current_scheme == 'IMDb' then
		recentName = getConfigVal('imdb_history/title') or ''
		recentAddress = getConfigVal('imdb_history/adr') or ''
		recentLogo = getConfigVal('imdb_history/logo') or ''
	elseif current_scheme == 'Filmix' then
		recentName = getConfigVal('filmix_history/title') or ''
		recentAddress = getConfigVal('filmix_history/adr') or ''
		recentLogo = getConfigVal('filmix_history/logo') or ''
	elseif current_scheme == 'TMDB' then
		recentName = getConfigVal('tmdb_history/title') or ''
		recentAddress = getConfigVal('tmdb_history/adr') or ''
		recentLogo = getConfigVal('tmdb_history/logo') or ''
	elseif current_scheme == 'Trackers' then
		recentName = getConfigVal('trackers_history/title') or ''
		recentAddress = getConfigVal('trackers_history/adr') or ''
		recentLogo = getConfigVal('trackers_history/logo') or ''
	end

     local t0,i={},1

   if recentName and recentLogo and recentAddress and recentName~='' and recentLogo~='' and recentAddress~='' then
     for w in string.gmatch(recentName,"[^%|]+") do
       t0[i] = {}
       t0[i].Id = i
       t0[i].Name = w
	   t0[i].InfoPanelName = w
	   t0[i].InfoPanelShowTime = 10000
       i=i+1
     end
     i=1

     for w in string.gmatch(recentAddress,"[^%|]+") do
       t0[i].Address = w
	   t0[i].InfoPanelTitle = w:match('%&bal=(.-)$')
       i=i+1
     end
	 i=1
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t0[i].InfoPanelLogo = w
       i=i+1
     end
   end
				local dn = 8
				local top = 680
				local dx = 1900/dn
				local dy = 1900/dn*1.5
				for j = 1,8 do

					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not t0[j] then break end
					t = {}
					t.id = 'STENA_START_BACK_IMG_ID&' .. t0[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 80
					t.class="IMAGE"
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = nx*dx - dx + 15
					t.top  = top
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'media_info_' .. current_scheme:gsub('%-','') .. '_from_stena'
					AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'STENA_START_LOGO_IMG_ID&' .. t0[j].Address
					t.cx=dx-10
					t.cy=dy-10
					t.class="IMAGE"
					t.imagepath = t0[j].InfoPanelLogo
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0102
					t.left = 1
					t.top  = 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

				if current_scheme == 'EX-FS' then
					t = {}
					t.id = 'STENA_START_BALANSER_BACK_ID&' .. t0[j].Address
					t.cx= 80
					t.cy= 50
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left= 0
					t.top= 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

					t = {}
					t.id = 'STENA_START_BALANSER_IMG_ID&' .. t0[j].Address
					t.cx=50
					t.cy=50
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/' .. get_balanser_img(t0[j].InfoPanelTitle) .. '.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 15
					t.top  = 0
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.bordercolor = -6250336
--					t.backroundcorner = 3*3
--					t.borderround = 3
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

				elseif current_scheme == 'TMDB' then
					t = {}
					t.id = 'STENA_START_BALANSER_BACK_ID&' .. t0[j].Address
					t.cx= 80
					t.cy= 50
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left= 0
					t.top= 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

					t = {}
					t.id = 'STENA_START_BALANSER_IMG_ID&' .. t0[j].Address
					t.cx=50
					t.cy=50
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/' .. get_balanser_img_from_adr(t0[j].Address) .. '.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 15
					t.top  = 0
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.bordercolor = -6250336
--					t.backroundcorner = 3*3
--					t.borderround = 3
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

				elseif current_scheme == 'HDRezka' then


					t = {}
					t.id = 'STENA_START_BALANSER_BACK_ID&' .. t0[j].Address
					t.cx= 80
					t.cy= 50
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left= 0
					t.top= 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

					t = {}
					t.id = 'STENA_START_BALANSER_IMG_ID&' .. t0[j].Address
					t.class="IMAGE"
					if t0[j].Address:match('/films/') then
					t.cx= 21 * 1.5
					t.cy= 16 * 1.5
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/films.svg'
					elseif t0[j].Address:match('/series/') then
					t.cx= 21 * 1.5
					t.cy= 16 * 1.5
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/series.svg'
					elseif t0[j].Address:match('/cartoons/') then
					t.cx= 19 * 1.5
					t.cy= 17 * 1.5
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.svg'
					elseif t0[j].Address:match('/animation/') then
					t.cx= 17 * 1.5
					t.cy= 17 * 1.5
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/anime.svg'
					end

					t.minresx=-1
					t.minresy=-1
					t.align = 0x0202
					t.left = 0
					t.top  = 0
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.bordercolor = -6250336
--					t.backroundcorner = 3*3
--					t.borderround = 3
					AddElement(t,'STENA_START_BALANSER_BACK_ID&' .. t0[j].Address)
				end

					t = {}
					t.id = current_scheme .. '&STENA_START_CLEANE_ITEM&' .. j
					t.cx=50
					t.cy=50
					t.class="TEXT"
					t.text = '  '
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 15
					t.left = dx-60
					t.top  = 5
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=2
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 0, 0)
					t.mousePressEventFunction = 'history_stena_cleane_item'
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

					t = {}
					t.id = 'STENA_START_TEXT_ID&' .. t0[j].Address
					t.cx=dx-30
					t.cy=dy-10 + 60
					t.class="TEXT"
					t.text = t0[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'media_info_' .. current_scheme:gsub('%-','') .. '_from_stena'
					AddElement(t,'STENA_START_BACK_IMG_ID&' .. t0[j].Address)

				end
end

