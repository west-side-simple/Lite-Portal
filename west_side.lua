--startup westSide portal
--saved as utf-8 without bom
--wafee code, west_side updated 17.07.25
-------------------------------------------------------------------

if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
if m_simpleTV.User.filmix==nil then m_simpleTV.User.filmix={} end
if m_simpleTV.User.rezka==nil then m_simpleTV.User.rezka={} end
if m_simpleTV.User.torrent==nil then m_simpleTV.User.torrent={} end
if m_simpleTV.User.hevc==nil then m_simpleTV.User.hevc={} end
if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
if m_simpleTV.User.VF==nil then m_simpleTV.User.VF={} end
if m_simpleTV.User.EXFS==nil then m_simpleTV.User.EXFS={} end
-- VF headers
m_simpleTV.User.VF.headers = decode64('QXV0aG9yaXphdGlvbjogIEJlYXJlciAxNjkzM3xMQklrS0drTEFIdEFMUmVGYUlkR0o2V3JUamNWdExscUw4NG1zVmpyNWJlNDhlYWY=')

m_simpleTV.User.TVPortal.isTEXTonTHUMB = false --true - text on thumb
m_simpleTV.User.TVPortal.is_stena = false

AddFileToExecute('events', m_simpleTV.MainScriptDir .. "user/westSide/events.lua")
require 'ex'
local pathname = m_simpleTV.MainScriptDir .. 'user/westSidePortal/startup/'
if os.dir(pathname) then
for entry in os.dir(pathname) do
	if entry.name:match('%.lua$')
	then
		dofile(pathname .. entry.name)
	end
end
pathname = m_simpleTV.MainScriptDir .. 'user/westSidePortal/video/'
for entry in os.dir(pathname) do
	if entry.name:match('%.lua$')
	then
		AddFileToExecute('getaddress', pathname .. entry.name)
	end
end
end
-------------------------------------------------------------------

function get_scheme_color()
	local currentskin = m_simpleTV.Config.GetValue('skin/path','simpleTVConfig')
	local pass = m_simpleTV.Common.GetMainPath(2) .. currentskin:gsub('^%./','')
	local file = io.open(pass .. '/img/back.svg', 'r')
	if not file then
		return 0xd0252850, 0xd01E213D
	end
	local answer = file:read('*a')
	file:close()
	local color = {
	{'Blue', 0xd0B0C4DE, 0xd01E213D, 0xd04169E1, 0xd06699CC, 0xd0252850},
	{'Green', 0xd0A0D6B4, 0xd0123524, 0xd000A693, 0xd071BC78, 0xd0177245},
	{'Red', 0xd0FFCBBB, 0xd0560319, 0xd0FF2400, 0xd0FFA089, 0xd092000A},
	{'Orange', 0xd0E7C697, 0xd035170C, 0xd0E8793E, 0xd0DEAA88, 0xd04D220E},
	{'Magenta', 0xd0FCB4D5, 0xd0270A1F, 0xd0ED3CCA, 0xd0FF97BB, 0xd04A192C},
	{'Cyan', 0xd0AFEEEE, 0xd0193737, 0xd048D1CC, 0xd078DBE2, 0xd0256D7B},
	{'Orchid', 0xd0C9A0DC, 0xd0320B35, 0xd09932CC, 0xd0BA55D3, 0xd07442C8},
	{'User', 0xd0C1CACA, 0xd0293133, 0xd0708090, 0xd09DA1AA, 0xd0414A4C},
	}
	for i = 1,#color do
		if answer:match(color[i][1]) then
			return color[i][6], color[i][3]
		end
	end
	return  0xd0252850, 0xd01E213D
end

function get_bookmark()
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.ExecuteAction(100)
end

function start_page_mediaportal_test()
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\startup\\west_side.lua')
	start_page_mediaportal()
end

function start_page_mediaportal()
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
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
						{'Kodik','Kodik'},
						{'FX','FXLite'},
						{'VideoDB','VideoDB'},
						{'Ashdi','ASHDI'},
						{'Magnets','Trackers'},
						{'Trailer','Trailer'},
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
		elseif adr:match('kodik%.info') then
			return 'Kodik'
		elseif adr:match('/lite/filmix') then
			return 'FXLite'
		elseif adr:match('/lite/veoveo') or adr:match('/movies/files/episodes/') then
			return 'VideoDB'	
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
			stena_clear()
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = true

			local tt = {
			{'Поиск Медиа','poisk_media.png','stena_search'},
			{'EX-FS','EX-FS.png','select_genres'},
			{'TMDB','tmdb.png','run_lite_qt_tmdb'},
			{'HDRezka','hdrezka.png','get_start'},
			{'Filmix','filmix.png','movie_genres_filmix1'},
			{'IMDB','IMDB.png','run_lite_qt_imdb'},
			{'RipsClub','hevc.png','start_hevc'},
--			{'VideoCDN','VideoCDN.png','run_lite_qt_cdntr_ozv'},
			{'TV Potal','tv_portal.png','SelectTVPortal'},
			{'YouTube','youtube.png','get_answer_start'},
			}

			local tt1 = {
			{'Search ⟲','','get_history_of_search'},
--			{'VideoCDN','VideoCDN.png','run_lite_qt_cdntr_ozv'},
--			{'EX-FS','','run_lite_qt_exfs'},
--			{'KinoGo','','run_lite_qt_kinogo'},
			{'KinoKong','','run_lite_qt_kinokong'},
--			{'UA','','run_lite_qt_ua'},
--			{'RipsClub','hevc.png','start_hevc'},
--			{'Kinopub','','run_lite_qt_kinopub'},
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
			 t.backcolor0, t.backcolor1 = get_scheme_color()
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

			local shift = (1920 - 200*tonumber(#tt))/2 + 15

			for j = 1,#tt do

			 t = {}
			 t.id = 'MEDIAPOISK_IMG_STENA_BACK_ID' .. j
			 t.cx= 170
			 t.cy= 170
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= shift + 200*(j-1)
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
			t.left= shift + 170*(j-1) / 1*1.25
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

			shift = (1920 - 280*tonumber(#tt1))/2 + 20

			for j = 1,#tt1 do

			 t = {}
			 t.id = 'MEDIAPOISK2_IMG_STENA_BACK_ID' .. j
			 t.cx= 240
			 t.cy= 100
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= shift + 280*(j-1)
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
			 t.left= shift - 15 + 250*(j-1)
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
-------------------------------------------------------------------
function show_portal_window()

	local function globus()

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
		t.id = 'GLOBUS_STENA_ID'
		t.cx= 60
		t.cy= 60
		t.class="IMAGE"
		t.animation = true
		t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d1/d%0.png"'
		t.minresx=-1
		t.minresy=-1
		t.align = 0x0103
		t.left=15
		t.top=110
		t.transparency = 255
		t.zorder=2
		t.isInteractive = true
		t.cursorShape = 13
		t.mousePressEventFunction = 'start_page_mediaportal'
		AddElement(t,'ID_DIV_STENA_1')
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	if m_simpleTV.User.westSide.PortalTable~=nil then
		if m_simpleTV.User.filmix and m_simpleTV.User.filmix.CurAddress then
			if m_simpleTV.User.TVPortal.is_stena == false then
				globus()
				m_simpleTV.User.TVPortal.is_stena = true
				similar_filmix(m_simpleTV.User.filmix.CurAddress)
			else
				stena_clear()
			end
		elseif m_simpleTV.User.rezka and m_simpleTV.User.rezka.CurAddress then
			if m_simpleTV.User.TVPortal.is_stena == false then
				globus()
				m_simpleTV.User.TVPortal.is_stena = true
				media_info_rezka(m_simpleTV.User.rezka.CurAddress)
			else
				stena_clear()
			end
		elseif m_simpleTV.User.EXFS and m_simpleTV.User.EXFS.CurAddress then
			m_simpleTV.User.TVPortal.get = {}
			if m_simpleTV.User.TVPortal.is_stena == false then
				globus()
				m_simpleTV.User.TVPortal.is_stena = true
				media_info(m_simpleTV.User.EXFS.CurAddress)
			else
				stena_clear()
			end
		elseif m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.get and m_simpleTV.User.TVPortal.get.TMDB and m_simpleTV.User.TVPortal.get.TMDB.Id and m_simpleTV.User.TVPortal.get.TMDB.tv then
			if m_simpleTV.User.TVPortal.is_stena == false then
				globus()
				m_simpleTV.User.TVPortal.is_stena = true
				media_info_tmdb(m_simpleTV.User.TVPortal.get.TMDB.Id,m_simpleTV.User.TVPortal.get.TMDB.tv)
			else
				stena_clear()
			end
		elseif m_simpleTV.User.collaps and m_simpleTV.User.collaps.ua then
			ua_info(m_simpleTV.User.westSide.PortalTable)
		elseif m_simpleTV.User.collaps and m_simpleTV.User.collaps.kinogo then
			kinogo_info(m_simpleTV.User.westSide.PortalTable)
		elseif m_simpleTV.User.torrent and m_simpleTV.User.torrent.content then
			content(m_simpleTV.User.westSide.PortalTable)
		elseif m_simpleTV.User.hevc and m_simpleTV.User.hevc.content then
			content_hevc(m_simpleTV.User.westSide.PortalTable)
		elseif m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.Channel_Of_Group then
			if m_simpleTV.User.TVPortal.is_stena == false then
				m_simpleTV.User.TVPortal.is_stena = true
				GetPortalTableForTVPortal()
			elseif m_simpleTV.User.AudioWS and m_simpleTV.User.AudioWS.TrackCash then
				stena_clear()
				GetPortalTableForAudio(m_simpleTV.User.westSide.PortalTable)
			else
				stena_clear()
			end
		elseif m_simpleTV.User.AudioWS and m_simpleTV.User.AudioWS.TrackCash then
			GetPortalTableForAudio(m_simpleTV.User.westSide.PortalTable)
		elseif m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_youtube_get_playlistID and m_simpleTV.User.TVPortal.stena_youtube_get_playlistID:match('^RD') then
			if m_simpleTV.User.TVPortal.is_stena == false then
				m_simpleTV.User.TVPortal.is_stena = true
				get_video_jam(m_simpleTV.User.TVPortal.stena_youtube_get_playlistID)
			else
				stena_clear()
			end
		elseif m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_youtube_get_playlistID then
			if m_simpleTV.User.TVPortal.is_stena == false then
				m_simpleTV.User.TVPortal.is_stena = true
				get_video_for_playlist(m_simpleTV.User.TVPortal.stena_youtube_get_playlistID, '')
			else
				stena_clear()
			end
		elseif m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_youtube_get_channelID then
			if m_simpleTV.User.TVPortal.is_stena == false then
				m_simpleTV.User.TVPortal.is_stena = true
				get_video_for_channel(m_simpleTV.User.TVPortal.stena_youtube_get_channelID, '')
			else
				stena_clear()
			end
		end
	end
end
-------------------------------------------------------------------
function mediabaze()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
 m_simpleTV.Control.ExecuteAction(37)
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
-------------------------------------------------------------------
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
   if id==nil then
   run_westSide_portal()
   end
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
-------------------------------------------------------------------
function run_westSide_portal()
-- m_simpleTV.Control.ExecuteAction(37)
 local tt1={
 {'Поиск',''},
 {'История поиска',''},
 {'Кинопоиск: История',''},
 {'Закладки',''},
 {'TMDb',''},
 {'IMDb',''},
 {'Трекеры',''},
 {'RipsClub (HEVC)',''},
 {'EX-FS',''},
 {'Rezka',''},
 {'Filmix',''},
 {'Kinopub',''},
 {'VideoCDN',''},
-- {'KinoGo',''},
 {'KinoKong',''},
-- {'UA',''},
 {'TV Portal',''},
 {'YouTube',''},
 {'Медиабазы',''},
 {'SimpleTV - видеоинструкции',''},
           }
  local t1,item={},(m_simpleTV.User.westSide.item or 1)
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
	t1[i].Item = i
  end
  m_simpleTV.Common.Sleep(200)
  t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Desc '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Menu Lite Portal',tonumber(item)-1,t1,9000,1+4+8)
  if id==nil then return end
  if ret==1 then
  if t1[id].Name == 'TMDb' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_tmdb()
  elseif t1[id].Name == 'IMDb' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_imdb()
  elseif t1[id].Name == 'EX-FS' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_exfs()
  elseif t1[id].Name == 'Rezka' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_rezka()
  elseif t1[id].Name == 'Filmix' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_filmix()
  elseif t1[id].Name == 'Kinopub' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_kinopub()
  elseif t1[id].Name == 'YouTube' then m_simpleTV.User.westSide.item = t1[id].Item run_youtube_portal()
  elseif t1[id].Name == 'Поиск' then m_simpleTV.User.westSide.item = t1[id].Item
--  search()
  dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\westSidePortal\\GUI\\showDialog.lua')
  elseif t1[id].Name == 'История поиска' then m_simpleTV.User.westSide.item = t1[id].Item get_history_of_search()
  elseif t1[id].Name == 'Закладки' then m_simpleTV.User.westSide.item = t1[id].Item m_simpleTV.Control.ExecuteAction(100)
  elseif t1[id].Name == 'Кинопоиск: История' then m_simpleTV.User.westSide.item = t1[id].Item IMDB_Get_History()
  elseif t1[id].Name == 'Медиабазы' then m_simpleTV.User.westSide.item = t1[id].Item mediabaze()
  elseif t1[id].Name:match('SimpleTV') then m_simpleTV.User.westSide.item = t1[id].Item highlight()
  elseif t1[id].Name == 'VideoCDN' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_cdntr()
  elseif t1[id].Name == 'Трекеры' then m_simpleTV.User.westSide.item = t1[id].Item start_page()
  elseif t1[id].Name == 'KinoGo' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_kinogo()
  elseif t1[id].Name == 'KinoKong' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_kinokong()
  elseif t1[id].Name == 'UA' then m_simpleTV.User.westSide.item = t1[id].Item run_lite_qt_ua()
  elseif t1[id].Name == 'RipsClub (HEVC)' then m_simpleTV.User.westSide.item = t1[id].Item start_hevc()
  elseif t1[id].Name == 'TV Portal' then
	if m_simpleTV.User.TVPortal.Use == 0 then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Аддон отключен.\n Включить можно в настройках.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return run_westSide_portal()
	else
		m_simpleTV.User.westSide.item = t1[id].Item SelectTVPortal()
	end
  end
  end
  if ret == 3 then
  start_page_mediaportal()
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
function history_stena_start(id)
	if not id then return end
	local adr = id:match('HISTORY_STENA_(.-)_')
	if adr and adr ~= '' then
		m_simpleTV.Config.SetValue('current_scheme', adr:gsub('EXFS','EX-FS'), 'LiteConf.ini')
		return start_page_mediaportal()
	end
end
-------------------------------------------------------------------
function history_stena_cleane(id)
	if not id then return end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local adr = id:match('HISTORY_STENA_(.-)_')
	if adr and adr ~= '' then
		if adr == 'EX-FS' then
			setConfigVal('exfs_history/title','')
			setConfigVal('exfs_history/adr','')
			setConfigVal('exfs_history/logo','')
		elseif adr == 'HDRezka' then
			setConfigVal('rezka_history/title','')
			setConfigVal('rezka_history/adr','')
			setConfigVal('rezka_history/logo','')
		elseif adr == 'IMDb' then
			setConfigVal('imdb_history/title','')
			setConfigVal('imdb_history/adr','')
			setConfigVal('imdb_history/logo','')
		elseif adr == 'Filmix' then
			setConfigVal('filmix_history/title','')
			setConfigVal('filmix_history/adr','')
			setConfigVal('filmix_history/logo','')
		elseif adr == 'TMDB' then
			setConfigVal('tmdb_history/title','')
			setConfigVal('tmdb_history/adr','')
			setConfigVal('tmdb_history/logo','')
		elseif adr == 'Trackers' then
			setConfigVal('trackers_history/title','')
			setConfigVal('trackers_history/adr','')
			setConfigVal('trackers_history/logo','')
		end
		return start_page_mediaportal()
	end
end
-------------------------------------------------------------------
function history_stena_cleane_item(id)
	if not id then return end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local current_scheme, item = id:match('^(.-)&STENA_START_CLEANE_ITEM&(%d+)')
--	debug_in_file(current_scheme..' '..item..'\n\n')
	local recentName
	local recentAddress
	local recentLogo
	if current_scheme and current_scheme ~= '' and item and tonumber(item) then
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
				i = i + 1
			end
			i=1
			for w in string.gmatch(recentAddress,"[^%|]+") do
				t0[i].Address = w
				i = i + 1
			end
			i=1
			for w in string.gmatch(recentLogo,"[^%|]+") do
				t0[i].Logo = w
				i = i + 1
			end
		end

		recentName=''
		recentAddress = ''
		recentLogo = ''

		for i = 1, #t0 do
			if i ~= tonumber(item) then
				recentName = recentName .. t0[i].Name .. '|'
				recentAddress = recentAddress .. t0[i].Address .. '|'
				recentLogo = recentLogo .. t0[i].Logo .. '|'
			end
		end

		if current_scheme == 'EX-FS' then
			setConfigVal('exfs_history/title',recentName)
			setConfigVal('exfs_history/adr',recentAddress)
			setConfigVal('exfs_history/logo',recentLogo)
		elseif current_scheme == 'HDRezka' then
			setConfigVal('rezka_history/title',recentName)
			setConfigVal('rezka_history/adr',recentAddress)
			setConfigVal('rezka_history/logo',recentLogo)
		elseif current_scheme == 'IMDb' then
			setConfigVal('imdb_history/title',recentName)
			setConfigVal('imdb_history/adr',recentAddress)
			setConfigVal('imdb_history/logo',recentLogo)
		elseif current_scheme == 'Filmix' then
			setConfigVal('filmix_history/title',recentName)
			setConfigVal('filmix_history/adr',recentAddress)
			setConfigVal('filmix_history/logo',recentLogo)
		elseif current_scheme == 'TMDB' then
			setConfigVal('tmdb_history/title',recentName)
			setConfigVal('tmdb_history/adr',recentAddress)
			setConfigVal('tmdb_history/logo',recentLogo)
		elseif current_scheme == 'Trackers' then
			setConfigVal('trackers_history/title',recentName)
			setConfigVal('trackers_history/adr',recentAddress)
			setConfigVal('trackers_history/logo',recentLogo)
		end
		return start_page_mediaportal()
	end
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

function ShowInfoCheckInfo_switch()
	if not m_simpleTV.User.westSide.CheckInfo then
		m_simpleTV.User.westSide.CheckInfo = true
	else
		m_simpleTV.User.westSide.CheckInfo = false
	end
end

local t={}
t.utf8 = true
t.name = 'CheckInfo'
t.luastring = 'ShowInfoCheckInfo_switch()'
t.lua_as_scr = true
t.key = string.byte('3')
t.ctrlkey = 2
t.location = 0
t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/fw_box_t2.png'
m_simpleTV.Interface.AddExtMenuT(t)