-- Видеоскрипт для стены лого медиапортала TV (14.02.2024)

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
	m_simpleTV.User.TVPortal.stena_tvportal_type = 'vod'
	m_simpleTV.User.TVPortal.stena_tvportal_logopack = 'ColorPic'
	m_simpleTV.User.TVPortal.stena_tvportal_filter = 'Gabbarit'

local function check_logo(logo,session)

	local rc, answer = m_simpleTV.Http.Request(session, {url = logo})
	if rc ~= 200 then return nil end
	return logo

end

local function GetLogo(name)
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	local logopack = m_simpleTV.Database.GetTable('SELECT * FROM logopackchannels WHERE (logopackchannels.AuthorLogopack = "' .. m_simpleTV.User.TVPortal.stena_tvportal_logopack .. '" AND (logopackchannels.NameChannels LIKE "' .. name .. ';%" OR logopackchannels.NameChannels LIKE "%;' .. name .. ';%" OR logopackchannels.NameChannels LIKE "%;' .. name .. '" OR logopackchannels.NameChannels LIKE "' .. name .. '" ))')
--	debug_in_file('SELECT * FROM logopackchannels WHERE (logopackchannels.AuthorLogopack = "' .. author .. '" AND (logopackchannels.NameChannels LIKE "' .. name .. ';%" OR logopackchannels.NameChannels LIKE "%;' .. name .. ';%" OR logopackchannels.NameChannels LIKE "%;' .. name .. '" OR logopackchannels.NameChannels LIKE "' .. name .. '" ))' .. '\n','c://1/zaprosy.txt')
	if logopack == nil or logopack[1] == nil then
		return false
	else
		return logopack[1].LogoChannels:gsub('https://picon%.pp%.ua/','https://epgx.site/p/')
	end
end

local function GetNames(name)
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	local logopack = m_simpleTV.Database.GetTable('SELECT * FROM logopackchannels WHERE (logopackchannels.AuthorLogopack = "' .. m_simpleTV.User.TVPortal.stena_tvportal_filter .. '" AND (logopackchannels.NameChannels LIKE "' .. name .. ';%" OR logopackchannels.NameChannels LIKE "%;' .. name .. ';%" OR logopackchannels.NameChannels LIKE "%;' .. name .. '" OR logopackchannels.NameChannels LIKE "' .. name .. '" ))')
	local channel_logo
	if logopack == nil or logopack[1] == nil then
		channel_logo = GetLogo(name)
	else
		local channel_names_in_FILTER = logopack[1].NameChannels .. ';'
		for w in channel_names_in_FILTER:gmatch('.-%;') do
			local channel_name_from_FILTER = w:match('(.-)%;')
			channel_logo = GetLogo(channel_name_from_FILTER:gsub(' $',''):gsub(' orig$',''):gsub(' 50$',''):gsub('^ ',''))
			if channel_logo then break end
		end
	end
	return channel_logo
end

function stena_desc_tvportal_content()
--	if m_simpleTV.User.TVPortal.stena_search == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.User.TVPortal.stena_tvportal_use = true
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
				m_simpleTV.OSD.RemoveElement('ID_DIV_1')
				m_simpleTV.OSD.RemoveElement('ID_DIV_2')
				if m_simpleTV.User.TVPortal.stena == nil then m_simpleTV.User.TVPortal.stena = {} end
				if m_simpleTV.User.TVPortal.stena_tvportal == nil then m_simpleTV.User.TVPortal.stena_tvportal = {} end
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
--				 t.backcolor1 = 0x77FFFFFF
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
				 t.mousePressEventFunction = 'start_page_mediaportal'
				 AddElement(t,'ID_DIV_STENA_1')

				 t={}
				 t.id = 'TEXT_STENA_PORTALTV_TITLE_ID'
				 t.cx=-100
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = m_simpleTV.User.TVPortal.Group_name .. ' - ' .. #m_simpleTV.User.TVPortal.Channel_Of_Group .. ' кан. (стр. ' .. m_simpleTV.User.TVPortal.stena_tvportal_page .. ' из ' .. m_simpleTV.User.TVPortal.stena_tvportal_allpage .. ')'
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = "Segoe UI Black"
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


				t = {}
				t.id = 'STENA_PORTALTV_CHANGE_BACK_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 650
			    t.top  = 170
				t.transparency = 0
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'change_stena_tvportal_type'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_PORTALTV_CHANGE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/options.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 651
			    t.top  = 170
				t.transparency = 220
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_PORTALTV_LOGOPACK_BACK_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 730
			    t.top  = 170
				t.transparency = 0
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'change_stena_tvportal_logopack'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_PORTALTV_LOGOPACK_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/plst.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 731
			    t.top  = 170
				t.transparency = 220
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'TVPORTAL_STENA_OPTIONS_TXT_ID'
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_tvportal_logopack .. ' (' ..m_simpleTV.User.TVPortal.stena_tvportal_type .. ')'
				t.color = ARGB(255 ,0, 250, 154)
				t.font_height = 12 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 400
				t.left = 520
			    t.top  = 260
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')
----------------------
				t = {}
				t.id = 'STENA_TVPORTAL_SEARCH_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 490
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_CONTENT_TVPORTAL_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search_History.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 410
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
--				t.background = 0
--			    t.backcolor0 = 0x66999999
--			    t.backcolor1 = 0
--				t.backcenterpoint_x = 30
--                t.backcenterpoint_y = 30
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'start_tv_search'
				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena_tvportal_page and m_simpleTV.User.TVPortal.stena_tvportal_allpage and tonumber(m_simpleTV.User.TVPortal.stena_tvportal_allpage) > 2 then
				t = {}
				t.id = 'STENA_TVPORTAL_SELECT_PAGE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Page.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 330
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
--				t.background = 0
--			    t.backcolor0 = 0x66999999
--			    t.backcolor1 = 0
--				t.backcenterpoint_x = 30
--                t.backcenterpoint_y = 30
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'select_tvportal_page'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_tvportal_prev then
				t = {}
				t.id = 'STENA_TVPORTAL_PREV_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 250
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_tvportal_prev'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_tvportal_next then
				t = {}
				t.id = 'STENA_TVPORTAL_NEXT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 170
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_tvportal_next'
				AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_TVPORTAL_CLEAR_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Clear.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 90
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_clear'
				AddElement(t,'ID_DIV_STENA_1')
---------------------
					t = {}
					t.id = 'TVPORTAL_STENA_BANNER1_BACK_IMG_ID'
					t.cx= 220
					t.cy= 60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 90
					t.top  = 250
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'SelectTVPortal'
					AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'TVPORTAL_STENA_BANNER1_TXT_ID'
				t.cy=60
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.Current_Playlist_PortalTV
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 200
				t.left = 100
			    t.top  = 255
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'TVPORTAL_STENA_BANNER1_TXT1_ID'
				t.cy=0
				t.class="TEXT"
				t.text = 'Плейлист'
				t.color = ARGB(255 ,0, 250, 154)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 210
				t.left = 95
			    t.top  = 310
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'TVPORTAL_STENA_BANNER2_BACK_IMG_ID'
					t.cx= 220
					t.cy= 60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 330
					t.top  = 250
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'start_tv'
					AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'TVPORTAL_STENA_BANNER2_TXT_ID'
				t.cy=60
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.Group_name
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 200
				t.left = 340
			    t.top  = 250
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'TVPORTAL_STENA_BANNER2_TXT1_ID'
				t.cy=0
				t.class="TEXT"
				t.text = 'Группа'
				t.color = ARGB(255 ,0, 250, 154)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 210
				t.left = 335
			    t.top  = 310
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

----------------------
			if not m_simpleTV.User.TVPortal.Channel_Of_Group_stena then m_simpleTV.User.TVPortal.Channel_Of_Group_stena = {} end
			local t1 = {}
			for j = 1,#m_simpleTV.User.TVPortal.Channel_Of_Group_stena do

			    local dx
				local dy
				local nx
				local ny
				t = {}
				t.id = 'STENA_TVPORTAL_' .. j .. '_BACK_IMG_ID'
				if m_simpleTV.User.TVPortal.stena_tvportal_type == 'square' then
			    dx = 1920/10
				dy = 800/4
				nx = j - (math.ceil(j/10) - 1)*10
				ny = math.ceil(j/10)
				 t.left = nx*dx - 192 + 16
				 t.cx=160
				 t.cy=160
				 t.top  = ny*dy + 155
				else
			    dx = 1920/8
				dy = 800/5
				nx = j - (math.ceil(j/8) - 1)*8
				ny = math.ceil(j/8)
				t.left = nx*dx - 240 + 8
				t.cx=224
				t.cy=126
				t.top  = ny*dy + 155 + 40
				end
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
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
				if (tonumber(m_simpleTV.User.TVPortal.stena_tvportal_page) - 1) * 40 + j == tonumber(m_simpleTV.User.TVPortal.Channel_id) then
				 get_EPG_for_id_channel('active' .. j)
				 t.id = 'STENA_TVPORTAL_active' .. j .. '_BACK_IMG_ID'
				 t.background = 0
				 t.backcolor0 = 0xBBFFD700
				 t.backcolor1 = 0
				end
				t.enterEventFunction = 'get_EPG_for_id_channel'
				t.mousePressEventFunction = 'playaddress_from_stena'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_TVPORTAL_' .. j .. '_IMG_ID'
				if m_simpleTV.User.TVPortal.stena_tvportal_type == 'square' then
					dx = 1920/10
					dy = 800/4
					nx = j - (math.ceil(j/10) - 1)*10
					ny = math.ceil(j/10)
					t.left = nx*dx - 192 + 16 + 10
					t.cx=140
					t.cy=140
					t.top  = ny*dy + 155 + 10
					t.imagepath = GetNames(m_simpleTV.User.TVPortal.Channel_Of_Group_stena[j].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$',''))
				else
					dx = 1920/8
					dy = 800/5
					nx = j - (math.ceil(j/8) - 1)*8
					ny = math.ceil(j/8)
					t.left = nx*dx - 240 + 8 + 12
					t.cx=200
					t.cy=110
					t.top  = ny*dy + 155 + 40 + 8
					t.imagepath = GetNames(m_simpleTV.User.TVPortal.Channel_Of_Group_stena[j].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$',''))
				end
				t.class="IMAGE"
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.transparency = 200
				t.zorder=2
				if t.imagepath and t.imagepath ~= '' then
					t1[j] = true
					AddElement(t,'ID_DIV_STENA_1')
				else
					t1[j] = false
				end

				t = {}
				t.id = 'STENA_TVPORTAL_' .. j .. '_TEXT_ID'
				if m_simpleTV.User.TVPortal.stena_tvportal_type == 'square' then
					dx = 1920/10
					dy = 800/4
					nx = j - (math.ceil(j/10) - 1)*10
					ny = math.ceil(j/10)
					t.left = nx*dx - 192 + 26
					t.cx=140
					t.top  = ny*dy + 155 + 160 - 3
					t.cy=0
				else
					dx = 1920/8
					dy = 800/5
					nx = j - (math.ceil(j/8) - 1)*8
					ny = math.ceil(j/8)
					t.left = nx*dx - 240 + 20
					t.cx=220
					t.top  = ny*dy + 195 + 126
					t.cy=0
				end
				t.textparam = 0x00400001
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.Channel_Of_Group_stena[j].Name .. '\n\n'
				t.align = 0x0101
				if (tonumber(m_simpleTV.User.TVPortal.stena_tvportal_page) - 1) * 40 + j == tonumber(m_simpleTV.User.TVPortal.Channel_id) then
					t.color = ARGB(255, 255, 215, 0)
				else
					t.color = ARGB(255 ,192, 192, 192)
				end
				t.font_height = 8 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13

				t.boundWidth = 15
				t.row_limit=2
				t.text_elidemode = 2
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'playaddress_from_stena'
				AddElement(t,'ID_DIV_STENA_1')
			end

			local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0')
			if not session then return false end
			m_simpleTV.Http.SetTimeout(session, 2000)

			for j = 1,#m_simpleTV.User.TVPortal.Channel_Of_Group_stena do

			    local dx
				local dy
				local nx
				local ny
				if t1[j] ~= true then
					t = {}
					t.id = 'STENA_TVPORTAL_' .. j .. '_IMG_ID'
					if m_simpleTV.User.TVPortal.stena_tvportal_type == 'square' then
						dx = 1920/10
						dy = 800/4
						nx = j - (math.ceil(j/10) - 1)*10
						ny = math.ceil(j/10)
						t.left = nx*dx - 192 + 16 + 10
						t.cx=140
						t.cy=140
						t.top  = ny*dy + 155 + 10
						t.imagepath = check_logo(m_simpleTV.User.TVPortal.Channel_Of_Group_stena[j].Logo,session)
					else
						dx = 1920/8
						dy = 800/5
						nx = j - (math.ceil(j/8) - 1)*8
						ny = math.ceil(j/8)
						t.left = nx*dx - 240 + 8 + 12
						t.cx=200
						t.cy=110
						t.top  = ny*dy + 155 + 40 + 8
						t.imagepath = check_logo(m_simpleTV.User.TVPortal.Channel_Of_Group_stena[j].Logo,session)
					end

					t.class="IMAGE"
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.transparency = 200
					t.zorder=2
					if t.imagepath and t.imagepath ~= '' then
						AddElement(t,'ID_DIV_STENA_1')
					else
						t = {}
						t.id = 'STENA_TVPORTAL_' .. j .. '_TEXT1_ID'
						if m_simpleTV.User.TVPortal.stena_tvportal_type == 'square' then
							dx = 1920/10
							dy = 800/4
							nx = j - (math.ceil(j/10) - 1)*10
							ny = math.ceil(j/10)
							t.left = nx*dx - 192 + 36
							t.cx=120
							t.top  = ny*dy + 170
							t.row_limit=3
						else
							dx = 1920/8
							dy = 800/5
							nx = j - (math.ceil(j/8) - 1)*8
							ny = math.ceil(j/8)
							t.left = nx*dx - 240 + 20
							t.cx=200
							t.top  = ny*dy + 215
							t.row_limit=2
						end
						t.class="TEXT"
						t.text = m_simpleTV.User.TVPortal.Channel_Of_Group_stena[j].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub('^ ','') .. '\n\n\n\n'
						t.align = 0x0101
						t.color = ARGB(255, 255, 239, 213)
						t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
						t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
						t.font_name = "Segoe Print"
						t.textparam = 0x00000001
						t.zorder=2
						t.text_elidemode = 2
		--				t.glow = 2 -- коэффициент glow эффекта
		--				t.glowcolor = 0xFF000077 -- цвет glow эффекта
						AddElement(t,'ID_DIV_STENA_1')
					end
				end
			end
end

function change_stena_tvportal_type()
	if m_simpleTV.User.TVPortal.stena_tvportal_type == 'square' then
		m_simpleTV.User.TVPortal.stena_tvportal_type = 'vod'
	else
		m_simpleTV.User.TVPortal.stena_tvportal_type = 'square'
	end
	return stena_desc_tvportal_content()
end

function change_stena_tvportal_logopack()
	local t1 = {

	'original',
	'1OTT',
	'EDEM dark',
	'EDEM transparent',
	'Gabbarit',
	'IPTV ONE',
	'TROYA',
	'Mirror Glass',
	'mini by AnZo',
	'ColorPic',
				}

	if m_simpleTV.User.TVPortal.stena_tvportal_logopack == t1[10] then
		m_simpleTV.User.TVPortal.stena_tvportal_logopack = t1[1]
		m_simpleTV.User.TVPortal.stena_tvportal_type = 'square'
		return stena_desc_tvportal_content()
	end
	for i = 1,#t1 do
		if m_simpleTV.User.TVPortal.stena_tvportal_logopack == t1[i] then
			if i == 1 or i == 3 or i == 7 or i == 9 then
				m_simpleTV.User.TVPortal.stena_tvportal_type = 'vod'
			else
				m_simpleTV.User.TVPortal.stena_tvportal_type = 'square'
			end
			m_simpleTV.User.TVPortal.stena_tvportal_logopack = t1[i + 1]
			return stena_desc_tvportal_content()
		end
	end
end