--VideoCDN desc west_side 15.05.25

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,'LiteConf.ini')
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,'LiteConf.ini')
end
----------------------------------get color
local function ARGB(A,R,G,B)
   local a = A*256*256*256+R*256*256+G*256+B
   if A<128 then return a end
   return a - 4294967296
end

local function Get_rating(rating1,rating2,rating3)

	rating1 = rating1 or 0
	rating2 = rating2 or 0
	rating3 = rating3 or 0

	local rating = math.max(rating1,rating2,rating3)

--	debug_in_file(rating .. ' / ' .. rating1 .. ' ' .. rating2 .. ' ' .. rating3 .. '\n','c://1/reting.txt')
	return math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
end

function stena_videocdn()

	if m_simpleTV.User.Videocdn == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.Videocdn.stena_use = true
				m_simpleTV.OSD.RemoveElement('ID_DIV_1')
				m_simpleTV.OSD.RemoveElement('ID_DIV_2')
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
				 t.id = 'TEXT_STENA_TITLE_ID'
				 t.cx=-66
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0102
				 t.text = m_simpleTV.User.Videocdn.stena_title:gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub('голосый','-'):gsub(' закадровый','закадр.'):gsub(' дублирование',' дуб.')
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

				t = {}
				t.id = 'STENA_HOME_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/AudioTranslat v3.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 180
				t.transparency = 220
				t.zorder=2
--				t.background = 0
--			    t.backcolor0 = 0x66992299
--			    t.backcolor1 = 0
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if not m_simpleTV.User.Videocdn.type:match('search') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'run_lite_qt_cdntr_ozv'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_MOVIE_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/movie.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 260
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.Videocdn.type:gsub('search_','') == 'movie' then

				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				if m_simpleTV.User.Videocdn.type:match('search') then
					t.mousePressEventFunction = 'page_movie_search_cdntr'
				else
					t.mousePressEventFunction = 'page_movie_cdntr'
				end
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_TV_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tv.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 340
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.Videocdn.type:gsub('search_','') == 'tv' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				if m_simpleTV.User.Videocdn.type:match('search') then
					t.mousePressEventFunction = 'page_tv_search_cdntr'
				else
					t.mousePressEventFunction = 'page_tv_cdntr'
				end
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_ANIME_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/mult.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 420
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.Videocdn.type:gsub('search_','') == 'anime' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				if m_simpleTV.User.Videocdn.type:match('search') then
					t.mousePressEventFunction = 'page_anime_search_cdntr'
				else
					t.mousePressEventFunction = 'page_anime_cdntr'
				end
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_ANIME_TV_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/multserial.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 500
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.Videocdn.type:gsub('search_','') == 'anime_tv' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				if m_simpleTV.User.Videocdn.type:match('search') then
					t.mousePressEventFunction = 'page_anime_tv_search_cdntr'
				else
					t.mousePressEventFunction = 'page_anime_tv_cdntr'
				end
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_TV_SHOW_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 580
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.Videocdn.type:gsub('search_','') == 'tv_show' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				if m_simpleTV.User.Videocdn.type:match('search') then
					t.mousePressEventFunction = 'page_show_tv_search_cdntr'
				else
					t.mousePressEventFunction = 'page_show_tv_cdntr'
				end
				AddElement(t,'ID_DIV_STENA_1')
-------------------------------
				if m_simpleTV.User.Videocdn.search == nil then
				m_simpleTV.User.Videocdn.search = {}
				end
			if m_simpleTV.User.Videocdn.type:match('search') then

				t = {}
				t.id = 'VIDEOCDN_SEARCH_MOVIE_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.Videocdn.search[1]
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 65, 105, 225)
			 	t.glowcolor_UnderMouse = 0xFFFFFFFF
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 30
			    t.top  = 290
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'page_movie_search_cdntr'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'VIDEOCDN_SEARCH_TV_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.Videocdn.search[2]
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 65, 105, 225)
			 	t.glowcolor_UnderMouse = 0xFFFFFFFF
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 30
			    t.top  = 370
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'page_movie_search_cdntr'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'VIDEOCDN_SEARCH_ANIME_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.Videocdn.search[3]
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 65, 105, 225)
			 	t.glowcolor_UnderMouse = 0xFFFFFFFF
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 30
			    t.top  = 450
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'page_movie_search_cdntr'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'VIDEOCDN_SEARCH_ANIME_TV_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.Videocdn.search[4]
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 65, 105, 225)
			 	t.glowcolor_UnderMouse = 0xFFFFFFFF
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 30
			    t.top  = 530
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'page_movie_search_cdntr'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'VIDEOCDN_SEARCH_SHOW_TV_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.Videocdn.search[5]
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 65, 105, 225)
			 	t.glowcolor_UnderMouse = 0xFFFFFFFF
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 30
			    t.top  = 610
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'page_movie_search_cdntr'
				AddElement(t,'ID_DIV_STENA_1')

			end
-------------------------------
				t = {}
				t.id = 'STENA_SEARCH_VIDEOCDN_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 740
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
				t.id = 'STENA_SEARCH_VIDEOCDN_CONTENT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search_History.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 660
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.Videocdn.type:match('search') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'get_history_of_search'
				AddElement(t,'ID_DIV_STENA_1')


				if m_simpleTV.User.Videocdn.stena_page and tonumber(m_simpleTV.User.Videocdn.stena_page[1]) > 2 then
				t = {}
				t.id = 'STENA_SELECT_PAGE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Page.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 820
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
				t.mousePressEventFunction = 'select_page_videocdn'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.Videocdn.stena_prev then
				t = {}
				t.id = 'STENA_PREV_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 900
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_prev_videocdn'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.Videocdn.stena_next then
				t = {}
				t.id = 'STENA_NEXT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 980
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_next_videocdn'
				AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_CLEAR_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Clear.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 1060
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

			   for j = 1,#m_simpleTV.User.Videocdn.stena do

			    local dx = 1800/5
				local dy = 1000/4
				local nx = j - (math.ceil(j/5) - 1)*5
				local ny = math.ceil(j/5)*3 - 2
				t = {}
				t.id = 'STENA_' .. j .. '_IMG_ID'
				t.cx=320
				t.cy=180
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.Videocdn.stena[j].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 240
			    t.top  = ny*dy - 65
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 3*3
				t.borderround = 3

				t.enterEventFunction = 'get_info_for_item'
--				t.mouseMoveEventFunction = 'close_event'
				t.mousePressEventFunction = 'play_videocdn'

				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.Videocdn.stena[j].Reting then
--			    local dx = 1800/5
--				local dy = 1000/4
--				local nx = j - (math.ceil(j/5) - 1)*5
--				local ny = math.ceil(j/5)
				t = {}
				t.id = 'STENA_RETING_' .. j .. '_IMG_ID'
				t.cx= 80 / 1*1.25
				t.cy= 16 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars2/' .. Get_rating(m_simpleTV.User.Videocdn.stena[j].ret_tmdb,m_simpleTV.User.Videocdn.stena[j].ret_imdb,m_simpleTV.User.Videocdn.stena[j].ret_kp) .. '.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 240 + 10
			    t.top  = ny*dy - 65 + 10
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_' .. j .. '_TEXT_ID'
				t.cx=320
				t.cy=0
				t.class="TEXT"
				t.text = '\n\n\n\n' .. m_simpleTV.User.Videocdn.stena[j].Name .. '\n\n\n'
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255 ,255, 192, 63)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = nx*dx - 240
			    t.top  = ny*dy
				t.row_limit=2
				t.text_elidemode = 2
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'content' .. j
				AddElement(t,'ID_DIV_STENA_1')
				end
end

function stena_prev_videocdn()
	page_cdntr(m_simpleTV.User.Videocdn.stena_prev)
end

function stena_next_videocdn()
	page_cdntr(m_simpleTV.User.Videocdn.stena_next)
end

function select_page_videocdn()
	local current = m_simpleTV.User.Videocdn.stena_page[2]:match('%&page=(%d+)')
	local url = m_simpleTV.User.Videocdn.stena_page[2]:gsub('%&page=%d+','')
	local t = {}
	for i = 1,tonumber(m_simpleTV.User.Videocdn.stena_page[1]) do
		t[i] = {}
		t[i].Id = i
		t[i].Name = i
	end
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(current)-1, t, 10000, 1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		page_cdntr(url .. '&page=' .. id)
	end
end

function page_movie_cdntr()
	m_simpleTV.User.Videocdn.type = 'movie'
	m_simpleTV.User.Videocdn.type_name = 'Фильмы'
	local url = ''
	if m_simpleTV.User.Videocdn.translate then url = '&translation=' .. m_simpleTV.User.Videocdn.translate end
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M='):gsub('&translation=%d+','') .. url)
end

function page_tv_cdntr()
	m_simpleTV.User.Videocdn.type = 'tv'
	m_simpleTV.User.Videocdn.type_name = 'Сериалы'
	local url = ''
	if m_simpleTV.User.Videocdn.translate then url = '&translation=' .. m_simpleTV.User.Videocdn.translate end
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M='):gsub('&translation=%d+','') .. url)
end

function page_anime_cdntr()
	m_simpleTV.User.Videocdn.type = 'anime'
	m_simpleTV.User.Videocdn.type_name = 'Аниме'
	local url = ''
	if m_simpleTV.User.Videocdn.translate then url = '&translation=' .. m_simpleTV.User.Videocdn.translate end
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M='):gsub('&translation=%d+','') .. url)
end

function page_anime_tv_cdntr()
	m_simpleTV.User.Videocdn.type = 'anime_tv'
	m_simpleTV.User.Videocdn.type_name = 'Аниме сериалы'
	local url = ''
	if m_simpleTV.User.Videocdn.translate then url = '&translation=' .. m_simpleTV.User.Videocdn.translate end
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWUtdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M='):gsub('&translation=%d+','') .. url)
end

function page_show_tv_cdntr()
	m_simpleTV.User.Videocdn.type = 'tv_show'
	m_simpleTV.User.Videocdn.type_name = 'ТВ Шоу'
	local url = ''
	if m_simpleTV.User.Videocdn.translate then url = '&translation=' .. m_simpleTV.User.Videocdn.translate end
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvdy10di1zZXJpZXM/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJnBhZ2U9MSZsaW1pdD0xMCZkaXJlY3Rpb249ZGVzYw=='):gsub('&translation=%d+','') .. url)
end
------------------------------
function page_movie_search_cdntr()
	m_simpleTV.User.Videocdn.type = 'search_movie'
	m_simpleTV.User.Videocdn.type_name = 'Фильмы'
	local search_ini = getConfigVal('search/media') or ''
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9') .. search_ini)
end

function page_tv_search_cdntr()
	m_simpleTV.User.Videocdn.type = 'search_tv'
	m_simpleTV.User.Videocdn.type_name = 'Сериалы'
	local search_ini = getConfigVal('search/media') or ''
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9') .. search_ini)
end

function page_anime_search_cdntr()
	m_simpleTV.User.Videocdn.type = 'search_anime'
	m_simpleTV.User.Videocdn.type_name = 'Аниме'
	local search_ini = getConfigVal('search/media') or ''
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9') .. search_ini)
end

function page_anime_tv_search_cdntr()
	m_simpleTV.User.Videocdn.type = 'search_anime_tv'
	m_simpleTV.User.Videocdn.type_name = 'Аниме сериалы'
	local search_ini = getConfigVal('search/media') or ''
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWUtdHYtc2VyaWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9') .. search_ini)
end

function page_show_tv_search_cdntr()
	m_simpleTV.User.Videocdn.type = 'search_tv_show'
	m_simpleTV.User.Videocdn.type_name = 'ТВ Шоу'
	local search_ini = getConfigVal('search/media') or ''
	page_cdntr(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvdy10di1zZXJpZXM/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJnBhZ2U9MSZsaW1pdD0xMCZmaWVsZD10aXRsZSZxdWVyeT0=') .. search_ini)
end
------------------------------
function stena_videocdn_info()
			m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_search_use = false
			m_simpleTV.User.TVPortal.stena_genres = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = false
			m_simpleTV.User.Videocdn.stena_use = false
			m_simpleTV.User.Videocdn.stena_info = true
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			local add = 0

			 t.BackColor = 0
			 t.BackColorEnd = 255
			 t.PictFileName = m_simpleTV.User.Videocdn.stena.background
			 t.TypeBackColor = 0
			 t.UseLogo = 3
			 t.Once = 1
			 t.Blur = 0
			 m_simpleTV.Interface.SetBackground(t)

			 t = {}
			 t.id = 'ID_DIV_STENA_1'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=-80 / m_simpleTV.Interface.GetScale()*1.5
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
			 t.id = 'USER_VIDEOCDN_LOGO_IMG_STENA_1_ID'
			 t.cx= 300 / 1*1.25
			 t.cy= 450 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.Videocdn.stena.logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=250 / 1*1.25
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'HOME_VIDEOCDN_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=720 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.borderwidth = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'stena_home'


			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'HOME_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/home.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 40 / 1*1.25
			 t.top= 725 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'BACK_VIDEOCDN_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=125 / 1*1.25
			 t.top=720 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.borderwidth = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 if m_simpleTV.User.TVPortal.stena.type and m_simpleTV.User.TVPortal.stena.type:match('search') then
			  t.mousePressEventFunction = 'stena_search_content'
			 else
			  t.mousePressEventFunction = 'stena'
			 end
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'BACK_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/Prev.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 143 / 1*1.25
			 t.top= 725 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'STENA_VIDEOCDN_CLEAR_IMG_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=230 / 1*1.25
			 t.top=720 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.borderwidth = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'stena_clear'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'STENA_VIDEOCDN_CLEAR_IMG_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/Clear.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 250 / 1*1.25
			 t.top= 725 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'RIMDB_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/imdb.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'R_IMDB_VIDEOCDN_STENA_IMG_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.Videocdn.stena.ret_imdb) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=25 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'RKP_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/kinopoisk.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=125 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'R_KP_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.Videocdn.stena.ret_KP) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=130 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'RTMDB_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tmdb.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=230 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'R_TMDB_VIDEOCDN_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.Videocdn.stena.ret_tmdb) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=235 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_VIDEOCDN_STENA_0_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.Videocdn.stena.slogan
			 t.color = -9113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_italic = 1
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 195 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_VIDEOCDN_STENA_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.Videocdn.stena.title
			 t.color = -2123993
			 t.font_height = -35 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_underline = 1
			 t.font_name = "Segoe UI Black"
			 t.textparam = 1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 210 / 1*1.5
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_VIDEOCDN_STENA_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.Videocdn.stena.title_en
			 t.color = -2113993
			 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 265 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_VIDEOCDN_STENA_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.Videocdn.stena.year .. ' ● ' .. m_simpleTV.User.Videocdn.stena.country .. (m_simpleTV.User.Videocdn.stena.age or '') ..  (m_simpleTV.User.Videocdn.stena.time_all or '')
			 t.color = -2113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15
			 t.left = 355 / 1*1.25
			 t.top  = 315 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_VIDEOCDN_STENA_5_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = -2113993
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.Videocdn.stena.overview .. '\n\n\n'
			 t.boundWidth = 50
			 t.row_limit=4
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 380 / 1*1.25
			 t.top  = 380 / 1*1.5
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_VIDEOCDN_GENRES_STENA_ID'
			 t.cx=0
			 t.cy=0
			 t.once = 0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = ' ● ' .. m_simpleTV.User.Videocdn.stena.genres
			 t.color = -2113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 425
			 t.top  = 340 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

end

function play_videocdn(id_cur)
	local id = id_cur:match('(%d+)')
	local t = m_simpleTV.User.Videocdn.stena
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.Videocdn.stena_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	local retAdr = t[tonumber(id)].Action .. '&embed=' .. t[tonumber(id)].kinopoisk_id .. ',' .. t[tonumber(id)].imdb_id
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.PlayAddressT({address = retAdr, title = t[tonumber(id)].Name})
	return
end
