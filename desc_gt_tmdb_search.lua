--TMDb search desc west_side 29.05.23
local function ARGB(A,R,G,B)
   local a = A*256*256*256+R*256*256+G*256+B
   if A<128 then return a end
   return a - 4294967296
end

local function Get_rating(rating)
	if rating == nil or rating == '' then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

function stena_search_content()
--	if m_simpleTV.User.TVPortal.stena_search == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_search_use = true
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
				m_simpleTV.OSD.RemoveElement('ID_DIV_1')
				m_simpleTV.OSD.RemoveElement('ID_DIV_2')
				if m_simpleTV.User.TVPortal.stena == nil then m_simpleTV.User.TVPortal.stena = {} end
				if m_simpleTV.User.TVPortal.stena_search == nil then m_simpleTV.User.TVPortal.stena_search = {} end
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
				 t.cx=-100
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = 'Поиск TMDB: ' .. m_simpleTV.User.TVPortal.stena_search_title
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
				t.id = 'STENA_HOME_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/home.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 180
				t.transparency = 220
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'home' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20

				t.mousePressEventFunction = 'stena_home'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search.png'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_MOVIE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/movie.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 380
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'search_movie' then

				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search_movie'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_MOVIE_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.search[1]
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
				t.mousePressEventFunction = 'stena_search_movie'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_TV_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tv.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 460
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search_tv'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_TV_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.search[2]
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
				t.mousePressEventFunction = 'stena_search_tv'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_COLLECTIONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 540
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search_collections'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_COLLECTIONS_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.search[4]
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
				t.mousePressEventFunction = 'stena_search_collections'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_PERSONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/persons.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 620
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search_persons'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_PERSONS_TXT_ID'
				t.cx=60
				t.cy=70
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.search[3]
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
				t.mousePressEventFunction = 'stena_search_persons'
				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena_prev then
				t = {}
				t.id = 'STENA_SEARCH_PREV_IMG_ID'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_prev'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_next then
				t = {}
				t.id = 'STENA_SEARCH_NEXT_IMG_ID'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_next'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_clear'
				AddElement(t,'ID_DIV_STENA_1')

			if not m_simpleTV.User.TVPortal.stena_search then m_simpleTV.User.TVPortal.stena_search = {} end

			local dx,dy,nx,ny
			for j = 1,#m_simpleTV.User.TVPortal.stena_search do

				t = {}
				t.id = 'STENA_' .. j .. '_IMG_ID'
				t.cx=320
				t.cy=180
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_search[j].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				if not m_simpleTV.User.TVPortal.stena.type:match('persons') and not m_simpleTV.User.TVPortal.stena.type:match('collections') then
			    dx = 1360/4
				dy = 1000/5
				nx = j - (math.ceil(j/4) - 1)*4
				ny = math.ceil(j/4)
				t.left = nx*dx - 220
			    t.top  = ny*dy - 25
				t.enterEventFunction = 'get_info_for_play'
				else
				dx = 1800/5
				dy = 1000/4
				nx = j - (math.ceil(j/5) - 1)*5
				ny = math.ceil(j/5)
				t.left = nx*dx - 240
			    t.top  = ny*dy - 65
				end

				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 3*3
				t.borderround = 3
				t.enterEventFunction = 'get_info_for_play'
				t.mousePressEventFunction = 'content' .. j

				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena_search[j].Reting then

				t = {}
				t.id = 'STENA_RETING_' .. j .. '_IMG_ID'
				t.cx= 80 / 1*1.25
				t.cy= 16 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars1/' .. Get_rating(m_simpleTV.User.TVPortal.stena_search[j].Reting) .. '.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 220 + 10
			    t.top  = ny*dy - 25 + 10
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_' .. j .. '_TEXT_ID'
				t.cx=320
				t.cy=0
				t.class="TEXT"
				if not m_simpleTV.User.TVPortal.stena.type:match('persons') and not m_simpleTV.User.TVPortal.stena.type:match('collections') then
				t.text = '\n\n\n\n\n\n' .. m_simpleTV.User.TVPortal.stena_search[j].Name .. '\n\n\n'
				t.font_height = -8 / m_simpleTV.Interface.GetScale()*1.5
				t.left = nx*dx - 220
			    t.top  = ny*dy
				else
				t.text = '\n\n\n\n' .. m_simpleTV.User.TVPortal.stena_search[j].Name .. '\n\n\n'
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.left = nx*dx - 240
			    t.top  = ny*dy
				end
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255 ,255, 192, 63)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.row_limit=2
				t.text_elidemode = 2
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				t.mousePressEventFunction = 'content' .. j
				AddElement(t,'ID_DIV_STENA_1')
			end
end

function stena_search_movie()
	search_movie(1)
end

function stena_search_tv()
	search_tv(1)
end

function stena_search_collections()
	search_collections(1)
end

function stena_search_persons()
	search_persons(1)
end