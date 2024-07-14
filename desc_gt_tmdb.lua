--TMDb desc west_side 04.07.24

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

local function Get_ZF(id)
	m_simpleTV.User.TVPortal.stena.balanser3 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = decode64('aHR0cHM6Ly9nby56ZWZsaXgub25saW5lL2lwbGF5ZXIvdmlkZW9kYi5waHA/a3A9') .. id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36\nReferer: ' .. 'https://go.zeflix.online/iplayer/player.php\nCookie: ' .. m_simpleTV.User.ZF.cookies})
	if rc==200 and answer:match('^<script>') then m_simpleTV.User.TVPortal.stena.balanser3 = '' return 'need_phpsesid' end
	if rc~=200 or answer:match('video_not_found') or (not answer:match('%.mp4') and not answer:match('%.m3u8')) then
		m_simpleTV.Http.Close(session)
		return false
	end
	m_simpleTV.User.TVPortal.stena.balanser3 = url
	return true
end

function get_phpsesid()
	local cookie = m_simpleTV.Interface.CopyFromClipboard()
	if cookie:match('PHPSESSID') then
		m_simpleTV.User.ZF.cookies = cookie
		Get_ZF(m_simpleTV.User.TVPortal.stena.imdb)
		return tmdb_info()
	end
end

local function Get_rating(rating)
	if rating == nil or rating == '' or rating and tonumber(rating) == nil then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

local function Get_name_favorite(j)
	local t = {'Русские сериалы','Русские фильмы','Французские комедии','Детективные сериалы Великобритании','Советские комедии','Советские сериалы','Мультфильмы','Сериалы AMC','Сериалы HBO','Детективные сериалы BBC ONE','Документальные сериалы','Музыка','Советские мультфильмы'}
	if j == 0 then return #t end
	for i = 1,#t do
		if i == tonumber(j) then
			return t[i]
		end
	end
	return 'Favorite'
end

local function Get_length(str)
	return m_simpleTV.Common.lenUTF8(str)
end

local function Get_current_balanser_name(name)
 if not m_simpleTV.User.TVPortal then m_simpleTV.User.TVPortal = {} end
 if not m_simpleTV.User.TMDB then m_simpleTV.User.TMDB = {} end
 if not m_simpleTV.User.TVPortal.get then m_simpleTV.User.TVPortal.get = {} end
 if not m_simpleTV.User.TVPortal.get.TMDB then m_simpleTV.User.TVPortal.get.TMDB = {} end
-- debug_in_file((m_simpleTV.User.TVPortal.balanser or 'not') .. ' and ' .. name .. ' / ' .. (m_simpleTV.User.TVPortal.get.TMDB.Id or 'not') .. ' and ' .. (m_simpleTV.User.TMDB.Id or 'not') .. '\n','c://1/name.txt')
 if m_simpleTV.User.TVPortal.balanser and m_simpleTV.User.TVPortal.balanser == name and m_simpleTV.User.TVPortal.get.TMDB.Id and m_simpleTV.User.TMDB.Id and tonumber(m_simpleTV.User.TVPortal.get.TMDB.Id) == tonumber(m_simpleTV.User.TMDB.Id) then
  return 1
 end
  return 0
end

local function torrents(name)
	local t,i = {},1
	if m_simpleTV.User.TVPortal.stena.balanser0 and m_simpleTV.User.TVPortal.stena.balanser0.rutor and m_simpleTV.User.TVPortal.stena.balanser0.rutor[1] and (name == 'rutor' or name == 'все')then
		for j = 1,#m_simpleTV.User.TVPortal.stena.balanser0.rutor do
			t[i] = {}
			t[i].Id = i
			t[i].Name = m_simpleTV.User.TVPortal.stena.balanser0.rutor[j].Name
			t[i].InfoPanelLogo = m_simpleTV.User.TVPortal.stena.logo
			t[i].Address = m_simpleTV.User.TVPortal.stena.balanser0.rutor[j].Address
			t[i].InfoPanelName = m_simpleTV.User.TVPortal.stena.balanser0.rutor[j].InfoPanelName
			t[i].InfoPanelTitle = m_simpleTV.User.TVPortal.stena.balanser0.rutor[j].InfoPanelTitle
			t[i].InfoPanelShowTime = 30000
			i = i + 1
			j = j + 1
		end
	end
	if m_simpleTV.User.TVPortal.stena.balanser0 and m_simpleTV.User.TVPortal.stena.balanser0.rutracker and m_simpleTV.User.TVPortal.stena.balanser0.rutracker[1] and (name == 'rutracker' or name == 'все')then
		for j = 1,#m_simpleTV.User.TVPortal.stena.balanser0.rutracker do
			t[i] = {}
			t[i].Id = i
			t[i].Name = m_simpleTV.User.TVPortal.stena.balanser0.rutracker[j].Name
			t[i].InfoPanelLogo = m_simpleTV.User.TVPortal.stena.logo
			t[i].Address = m_simpleTV.User.TVPortal.stena.balanser0.rutracker[j].Address
			t[i].InfoPanelName = m_simpleTV.User.TVPortal.stena.balanser0.rutracker[j].InfoPanelName
			t[i].InfoPanelTitle = m_simpleTV.User.TVPortal.stena.balanser0.rutracker[j].InfoPanelTitle
			t[i].InfoPanelShowTime = 30000
			i = i + 1
			j = j + 1
		end
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Трекеры '}
		local AutoNumberFormat, FilterType

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.TVPortal.balanser = 'Trackers'
			m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. t[id].Address, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
		end
		if ret == 2 then
			Get_ruru_balanser()
		end
end
----------------------------------
function genres_arr()
	if m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena and m_simpleTV.User.TVPortal.stena.movie_genres and m_simpleTV.User.TVPortal.stena.tv_genres then
		return
	end
	local url_g1, tmdb_media
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return
	end
	m_simpleTV.Http.SetTimeout(session, 60000)
	for tv=0,1 do
		if tv == 0 then
			url_g1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9nZW5yZS9tb3ZpZS9saXN0P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
			tmdb_media = 'tmdb_movie_page=1'
		elseif tv == 1 then
			url_g1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9nZW5yZS90di9saXN0P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
			tmdb_media = 'tmdb_tv_page=1'
		end
		local rc7,answer_g1 = m_simpleTV.Http.Request(session,{url=url_g1})
		if rc7~=200 then
		return ''
		end
		require('json')
		answer_g1 = answer_g1:gsub('(%[%])', '"nil"')
		local tab_g1 = json.decode(answer_g1)
		local t, i, name = {}, 1, ''
		while true do
			if not tab_g1.genres[i]	then break end
			t[i]={}
			t[i].id = tab_g1.genres[i].id
			t[i].name = tab_g1.genres[i].name
			i=i+1
		end
		if tv == 0 then
			m_simpleTV.User.TVPortal.stena.movie_genres = t
		elseif tv == 1 then
			m_simpleTV.User.TVPortal.stena.tv_genres = t
		end
	end
	return
end

function stena()
	if m_simpleTV.User.TVPortal.stena == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_use = true
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.cur_content_adr = nil
	m_simpleTV.OSD.RemoveElement('ID_DIV_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_2')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')

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
				 t.text = m_simpleTV.User.TVPortal.stena_title
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
				t.id = 'STENA_MOVIE_IMG_ID'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'movie' and m_simpleTV.User.TVPortal.stena_title:match('%) ') == nil then

				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_movie'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_TV_IMG_ID'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'tv' and m_simpleTV.User.TVPortal.stena_title:match('%) %S') == nil then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_tv'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_GENRES_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.png'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'genres' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_genres'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_COLLECTIONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections.png'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'collections' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_collections'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_PERSONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/persons.png'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'persons' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_persons'
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
			    t.top  = 660
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
				t.id = 'STENA_SEARCH_CONTENT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search_History.png'
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
				t.mousePressEventFunction = 'search_tmdb'
				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena.type == 'collection' then
				t = {}
				t.id = 'STENA_PLAY_COLLECTION_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Play.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 820
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
				t.mousePressEventFunction = 'collection_play'
				AddElement(t,'ID_DIV_STENA_1')
				elseif m_simpleTV.User.TVPortal.stena_page then
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
				t.mousePressEventFunction = 'select_page'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_prev then
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

			local dx,dy,nx,ny

			for j = 1,#m_simpleTV.User.TVPortal.stena do

				t = {}
				t.id = 'STENA_' .. j .. '_IMG_ID'
				t.cx=320
				t.cy=180
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena[j].InfoPanelLogo
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
				t.mousePressEventFunction = 'content' .. j

				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena[j].Reting then
				t = {}
				t.id = 'STENA_RETING_' .. j .. '_IMG_ID'
				t.cx= 80 / 1*1.25
				t.cy= 16 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars1/' .. Get_rating(m_simpleTV.User.TVPortal.stena[j].Reting) .. '.png'
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
				t.class="TEXT"
				t.cx=320
				t.cy=0
				if not m_simpleTV.User.TVPortal.stena.type:match('persons') and not m_simpleTV.User.TVPortal.stena.type:match('collections') then
				t.text = '\n\n\n\n\n\n' .. m_simpleTV.User.TVPortal.stena[j].Name .. '\n\n\n'
				t.font_height = -8 / m_simpleTV.Interface.GetScale()*1.5
				t.left = nx*dx - 220
			    t.top  = ny*dy - 5
				else
				t.text = '\n\n\n\n' .. m_simpleTV.User.TVPortal.stena[j].Name .. '\n\n\n'
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
				AddElement(t,'ID_DIV_STENA_1')
			end
	m_simpleTV.OSD.RemoveElement('STENA_INFO_ITEM_IMG_ID')
	m_simpleTV.OSD.RemoveElement('STENA_RETING_ITEM_IMG_ID')
	m_simpleTV.OSD.RemoveElement('USER_LOGO_ITEM_IMG_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_1_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_2_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_3_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_4_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_11_ID')
end

function stena_genres()
	m_simpleTV.User.TVPortal.stena.type = 'genres'
	if m_simpleTV.User.TVPortal.stena == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_genres = true
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
				m_simpleTV.OSD.RemoveElement('ID_DIV_1')
				m_simpleTV.OSD.RemoveElement('ID_DIV_2')
				m_simpleTV.OSD.RemoveElement('STENA_INFO_ITEM_IMG_ID')
				m_simpleTV.OSD.RemoveElement('STENA_RETING_ITEM_IMG_ID')
				m_simpleTV.OSD.RemoveElement('USER_LOGO_ITEM_IMG_ID')
				m_simpleTV.OSD.RemoveElement('TEXT_ITEM_1_ID')
				m_simpleTV.OSD.RemoveElement('TEXT_ITEM_2_ID')
				m_simpleTV.OSD.RemoveElement('TEXT_ITEM_3_ID')
				m_simpleTV.OSD.RemoveElement('TEXT_ITEM_4_ID')
				m_simpleTV.OSD.RemoveElement('TEXT_ITEM_11_ID')
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

				 t={}
				 t.id = 'TEXT_STENA_TITLE_ID'
				 t.cx=-100
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = 'Жанровый выбор контента'
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
				t.id = 'STENA_MOVIE_IMG_ID'
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
				t.mousePressEventFunction = 'stena_movie'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_TV_IMG_ID'
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
				t.mousePressEventFunction = 'stena_tv'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_GENRES_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 420
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -1250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_genres'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_COLLECTIONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections.png'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'collections' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_collections'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_PERSONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/persons.png'
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
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena.type == 'persons' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_persons'
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
			    t.top  = 660
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

					 t={}
					 t.id = 'TEXT_MOVIE_TITLE_ID'
					 t.cx=0
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = 'Фильмы'
					 t.color = -2123993
					 t.font_height = -20 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0--1+4
					 t.left = 400
					 t.top  = 180
					 t.glow = 2 -- коэффициент glow эффекта
					 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					 AddElement(t,'ID_DIV_STENA_1')

					 t={}
					 t.id = 'TEXT_TV_TITLE_ID'
					 t.cx=0
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = 'Сериалы'
					 t.color = -2123993
					 t.font_height = -20 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0--1+4
					 t.left = 800
					 t.top  = 180
					 t.glow = 2 -- коэффициент glow эффекта
					 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					 AddElement(t,'ID_DIV_STENA_1')

					 t={}
					 t.id = 'TEXT_FAVORITE_TITLE_ID'
					 t.cx=0
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = 'Избранный контент'
					 t.color = -2123993
					 t.font_height = -20 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0--1+4
					 t.left = 1200
					 t.top  = 180
					 t.glow = 2 -- коэффициент glow эффекта
					 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					 AddElement(t,'ID_DIV_STENA_1')

				if not m_simpleTV.User.TVPortal.stena.movie_genres or not #m_simpleTV.User.TVPortal.stena.movie_genres or
				not m_simpleTV.User.TVPortal.stena.tv_genres or not #m_simpleTV.User.TVPortal.stena.tv_genres then
					genres_arr()
				end
				if m_simpleTV.User.TVPortal.stena.movie_genres and #m_simpleTV.User.TVPortal.stena.movie_genres and m_simpleTV.User.TVPortal.stena.tv_genres and #m_simpleTV.User.TVPortal.stena.tv_genres then
					for j=1,#m_simpleTV.User.TVPortal.stena.movie_genres do

					 t={}
					 t.id = 'TEXT_MOVIE_GENRES_' .. j .. '_ID'
					 t.cx=0
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. m_simpleTV.User.TVPortal.stena.movie_genres[j].name .. ' '
					 t.color = -2113993
					 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0--1+4
					 t.left = 400
					 t.top  = 250 + (j-1)*45
					 t.glow = 2 -- коэффициент glow эффекта
					 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					 t.borderwidth = 1
					 t.backroundcorner = 3*3
					 t.isInteractive = true
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xEE4169E1
					 t.backcolor1_UnderMouse = 0xEE00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'movie_genres' .. m_simpleTV.User.TVPortal.stena.movie_genres[j].id
					 AddElement(t,'ID_DIV_STENA_1')

--						debug_in_file(t.text .. '\n','c://1/name_for_ln')
					end

					for j=1,#m_simpleTV.User.TVPortal.stena.tv_genres do

					 t={}
					 t.id = 'TEXT_TV_GENRES_' .. j .. '_ID'
					 t.cx=0
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. m_simpleTV.User.TVPortal.stena.tv_genres[j].name .. ' '
					 t.color = -2113993
					 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0--1+4
					 t.left = 800
					 t.top  = 250 + (j-1)*45
					 t.glow = 2 -- коэффициент glow эффекта
					 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					 t.borderwidth = 1
					 t.backroundcorner = 3*3
					 t.isInteractive = true
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xEE4169E1
					 t.backcolor1_UnderMouse = 0xEE00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'tv_genres' .. m_simpleTV.User.TVPortal.stena.tv_genres[j].id
					 AddElement(t,'ID_DIV_STENA_1')
--						debug_in_file(t.text .. '\n','c://1/name_for_ln')
					end
				end
					local all = Get_name_favorite(0)
					for j=1,tonumber(all) do
					 t={}
					 t.id = 'TEXT_FAVORITE_' .. j .. '_ID'
					 t.cx=0
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. Get_name_favorite(j) .. ' '
					 t.color = -2113993
					 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0--1+4
					 t.left = 1200
					 t.top  = 250 + (j-1)*45
					 t.glow = 2 -- коэффициент glow эффекта
					 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					 t.borderwidth = 1
					 t.backroundcorner = 3*3
					 t.isInteractive = true
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xEE4169E1
					 t.backcolor1_UnderMouse = 0xEE00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'favorite' .. j
					 AddElement(t,'ID_DIV_STENA_1')
					end
end

function stena_prev()
	if m_simpleTV.User.TVPortal.stena.type == 'movie' then
		tmdb_movie_page(m_simpleTV.User.TVPortal.stena_prev[1], m_simpleTV.User.TVPortal.stena_prev[2],m_simpleTV.User.TVPortal.stena_prev[3])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'tv' then
		tmdb_tv_page(m_simpleTV.User.TVPortal.stena_prev[1], m_simpleTV.User.TVPortal.stena_prev[2],m_simpleTV.User.TVPortal.stena_prev[3],m_simpleTV.User.TVPortal.stena_prev[4])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		tmdb_person_page(m_simpleTV.User.TVPortal.stena_prev[1])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'persona' then
		personWorkById(m_simpleTV.User.TVPortal.stena_prev[1],m_simpleTV.User.TVPortal.stena_prev[2])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection(m_simpleTV.User.TVPortal.stena_prev[1])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'collection' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_prev[1],m_simpleTV.User.TVPortal.stena_prev[2])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_movie' then
		search_movie(m_simpleTV.User.TVPortal.stena_prev)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		search_tv(m_simpleTV.User.TVPortal.stena_prev)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		search_persons(m_simpleTV.User.TVPortal.stena_prev)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_persona' then
		search_persona(m_simpleTV.User.TVPortal.stena_prev[1],m_simpleTV.User.TVPortal.stena_prev[2])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		search_collections(m_simpleTV.User.TVPortal.stena_prev)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_collection' then
		search_collection(m_simpleTV.User.TVPortal.stena_prev[1],m_simpleTV.User.TVPortal.stena_prev[2])
	end
end

function stena_next()
	if m_simpleTV.User.TVPortal.stena.type == 'movie' then
		tmdb_movie_page(m_simpleTV.User.TVPortal.stena_next[1], m_simpleTV.User.TVPortal.stena_next[2],m_simpleTV.User.TVPortal.stena_next[3])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'tv' then
		tmdb_tv_page(m_simpleTV.User.TVPortal.stena_next[1], m_simpleTV.User.TVPortal.stena_next[2],m_simpleTV.User.TVPortal.stena_next[3], m_simpleTV.User.TVPortal.stena_next[4])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		tmdb_person_page(m_simpleTV.User.TVPortal.stena_next[1])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'persona' then
		personWorkById(m_simpleTV.User.TVPortal.stena_next[1],m_simpleTV.User.TVPortal.stena_next[2])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection(m_simpleTV.User.TVPortal.stena_next[1])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'collection' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_next[1],m_simpleTV.User.TVPortal.stena_next[2])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_movie' then
		search_movie(m_simpleTV.User.TVPortal.stena_next)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		search_tv(m_simpleTV.User.TVPortal.stena_next)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		search_persons(m_simpleTV.User.TVPortal.stena_next)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_persona' then
		search_persona(m_simpleTV.User.TVPortal.stena_next[1],m_simpleTV.User.TVPortal.stena_next[2])
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		search_collections(m_simpleTV.User.TVPortal.stena_next)
	end
	if m_simpleTV.User.TVPortal.stena.type == 'search_collection' then
		search_collection(m_simpleTV.User.TVPortal.stena_next[1],m_simpleTV.User.TVPortal.stena_next[2])
	end
end

function select_page()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		local t = {}
		for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_page[1]) do
			t[i] = {}
			t[i].Id = i
			t[i].Name = i
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_page[2])-1, t, 10000, 'ALWAYS_OK | MODAL_MODE')
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			tmdb_person_page(id)
		end
	elseif m_simpleTV.User.TVPortal.stena.type == 'persona' then
		local t = {}
		for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_page[2]) do
			t[i] = {}
			t[i].Id = i
			t[i].Name = i
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_page[3])-1, t, 10000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			personWorkById(m_simpleTV.User.TVPortal.stena_page[1],id)
		end
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		local t = {}
		for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_page[1]) do
			t[i] = {}
			t[i].Id = i
			t[i].Name = i
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_page[2])-1, t, 10000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			collection(id)
		end
	elseif m_simpleTV.User.TVPortal.stena.type == 'movie' then
		local t = {}
		for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_page[1]) do
			t[i] = {}
			t[i].Id = i
			t[i].Name = i
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_page[2])-1, t, 10000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			tmdb_movie_page(id, m_simpleTV.User.TVPortal.stena_page[3],m_simpleTV.User.TVPortal.stena_page[4])
		end
	elseif m_simpleTV.User.TVPortal.stena.type == 'tv' then
		local t = {}
		for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_page[1]) do
			t[i] = {}
			t[i].Id = i
			t[i].Name = i
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_page[2])-1, t, 10000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			tmdb_tv_page(id, m_simpleTV.User.TVPortal.stena_page[3],m_simpleTV.User.TVPortal.stena_page[4],m_simpleTV.User.TVPortal.stena_page[5])
		end
	end
end

function tmdb_info()
			m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.User.TVPortal.stena_info = true
			m_simpleTV.User.TVPortal.stena_search_use = false
			m_simpleTV.User.TVPortal.stena_genres = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = false
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			local add = 0

			 t.BackColor = 0
			 t.BackColorEnd = 255
			 t.PictFileName = m_simpleTV.User.TVPortal.stena.background
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
			 t.id = 'USER_LOGO_IMG_STENA_1_ID'
			 t.cx= 300 / 1*1.25
			 t.cy= 450 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.TVPortal.stena.logo
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

			local add = 20

--			m_simpleTV.User.TVPortal.stena.balanser0 = true

			if m_simpleTV.User.TVPortal.stena.balanser0 and (m_simpleTV.User.TVPortal.stena.balanser0.rutor and m_simpleTV.User.TVPortal.stena.balanser0.rutor[1] or m_simpleTV.User.TVPortal.stena.balanser0.rutracker and m_simpleTV.User.TVPortal.stena.balanser0.rutracker[1]) then

			 t = {}
			 t.id = 'BALANSER0_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Trackers')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser0'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER0_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Trackers.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser1 = true

			if m_simpleTV.User.TVPortal.stena.balanser1 then

			 t = {}
			 t.id = 'BALANSER1_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Trackers')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser1'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER1_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Trackers.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser2 = true

			if m_simpleTV.User.TVPortal.stena.balanser2 then

			 t = {}
			 t.id = 'BALANSER2_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('VideoCDN')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser2'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER2_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/VideoCDN.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser3 = true

			if m_simpleTV.User.TVPortal.stena.balanser3 then

			 t = {}
			 t.id = 'BALANSER3_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Zetflix')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 if m_simpleTV.User.TVPortal.stena.balanser3 == '' then
			 t.mousePressEventFunction = 'get_phpsesid'
			 else
			 t.mousePressEventFunction = 'play_balanser3'
			 end
			 AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.TVPortal.stena.balanser3 == '' then
			 t = {}
			 t.id = 'BALANSER3_TXT_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="TEXT"
			 t.text = '🔄'
			 t.color = -2113993
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.align = 0x0103
			 t.textparam = 0x00000008
			 t.left= (add-2) / 1*1.25
			 t.top= (170-3) / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')
			end

			 t = {}
			 t.id = 'BALANSER3_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Zetflix.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser4 = true

			if m_simpleTV.User.TVPortal.stena.balanser4 then

			 t = {}
			 t.id = 'BALANSER4_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Voidboost')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser4'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER4_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Voidboost.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser5 = true

			if m_simpleTV.User.TVPortal.stena.balanser5 then

			 t = {}
			 t.id = 'BALANSER5_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('HDVB')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser5'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER5_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/HDVB.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			t = {}
			t.id = 'BALANSER5_TXT_STENA_ID'
			t.cx= 80 / 1*1.25
			t.cy= 80 / 1*1.25
			t.class="TEXT"
			t.text = 'HDVB'
			t.align = 0x0103
			t.left= (add + 5) / 1*1.25
			t.top= 187.5 / 1*1.25
			t.color = ARGB(255, 192, 192, 192)
			t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
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
			t.mousePressEventFunction = 'play_balanser5'
--			AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser6 = true

			if m_simpleTV.User.TVPortal.stena.balanser6 then

			 t = {}
			 t.id = 'BALANSER6_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Collaps')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser6'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER6_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Collaps.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			t = {}
			t.id = 'BALANSER6_TXT_STENA_ID'
			t.cx= 80 / 1*1.25
			t.cy= 80 / 1*1.25
			t.class="TEXT"
			t.text = 'Collaps'
			t.align = 0x0103
			t.left= (add + 5) / 1*1.25
			t.top= 187.5 / 1*1.25
			t.color = ARGB(255, 192, 192, 192)
			t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
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
			t.mousePressEventFunction = 'play_balanser6'
--			AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser7 = true

			if m_simpleTV.User.TVPortal.stena.balanser7 then

			 t = {}
			 t.id = 'BALANSER7_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Kodik')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser7'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER7_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Kodik.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			t = {}
			t.id = 'BALANSER7_TXT_STENA_ID'
			t.cx= 80 / 1*1.25
			t.cy= 80 / 1*1.25
			t.class="TEXT"
			t.text = 'Kodik'
			t.align = 0x0103
			t.left= (add + 5) / 1*1.25
			t.top= 187.5 / 1*1.25
			t.color = ARGB(255, 192, 192, 192)
			t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
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
			t.mousePressEventFunction = 'play_balanser7'
	--		AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end

--			m_simpleTV.User.TVPortal.stena.balanser8 = true

			if m_simpleTV.User.TVPortal.stena.balanser8 then

			 t = {}
			 t.id = 'BALANSER8_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('ASHDI')
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_balanser8'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSER8_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 80 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/ASHDI.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 5) / 1*1.25
			 t.top= 160 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			t = {}
			t.id = 'BALANSER8_TXT_STENA_ID'
			t.cx= 80 / 1*1.25
			t.cy= 80 / 1*1.25
			t.class="TEXT"
			t.text = 'ASHDI'
			t.align = 0x0103
			t.left= (add + 5) / 1*1.25
			t.top= 187.5 / 1*1.25
			t.color = ARGB(255, 192, 192, 192)
			t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
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
			t.mousePressEventFunction = 'play_balanser8'
	--		AddElement(t,'ID_DIV_STENA_1')

			 add = add + 105

			end



			 t = {}
			 t.id = 'BALANSERS_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.bordercolor = -6250336
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'change_balansers'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BALANSERS_IMG_STENA_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 if m_simpleTV.User.TVPortal.stena.balansers then
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next.png'
			 else
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
			 end
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add + 20) / 1*1.25
			 t.top= 175 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'HOME_IMG_STENA_BACK_ID'
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
			 t.id = 'HOME_IMG_STENA_ID'
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
			 t.id = 'BACK_IMG_STENA_BACK_ID'
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
			 t.id = 'BACK_IMG_STENA_ID'
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
			 t.id = 'STENA_CLEAR_IMG_BACK_ID'
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
			 t.id = 'STENA_CLEAR_IMG_ID'
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

			if m_simpleTV.User.TVPortal.stena.coll.adr then
				t = {}
				t.id = 'COLLECTION_STENA_IMG_ID'
				t.cx=300 / 1*1.25
				t.cy=67 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena.coll.back
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
			    t.left=20 / 1*1.25
			    t.top=800 / 1*1.25
				t.transparency = 200
				t.zorder=0
				t.borderwidth = 3
			    t.bordercolor = ARGB(192, 192, 192, 192)
			    t.backroundcorner = 3*3
			    t.borderround = 3
			    t.isInteractive = true
			    t.background_UnderMouse = 0
			    t.backcolor0_UnderMouse = 0xEE4169E1
			    t.backcolor1_UnderMouse = 0
			    t.cursorShape = 13
			    t.bordercolor_UnderMouse = 0xEE4169E1
			    t.backroundcorner = 3*3
			    t.borderround = 3
				t.mousePressEventFunction = 'collection_plus'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'COLLECTION_STENA_TEXT_ID'
				t.cx=300 / 1*1.25
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena.coll.name .. '\n\n'
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = -2113993
			 	t.glowcolor_UnderMouse = 0xFF0000FF
				t.glow_samples_UnderMouse = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
--				t.padding = 20 / 1*1.25
--				t.boundWidth = 15
			    t.left=20 / 1*1.25
			    t.top=810 / 1*1.25
				t.row_limit=4
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'collection_plus'
				AddElement(t,'ID_DIV_STENA_1')

			end

			if m_simpleTV.User.TVPortal.stena.networks and m_simpleTV.User.TVPortal.stena.networks[1] then
			 for j = 1,#m_simpleTV.User.TVPortal.stena.networks do
				t = {}
				t.id = 'NETWORK_STENA_' .. j .. '_IMG_ID'
				t.cx=300 / 1*1.25
				t.cy=67 / 1*1.25
				t.class="IMAGE"
				if m_simpleTV.User.TVPortal.stena.networks[j].logo_path then
				t.imagepath = 'https://image.tmdb.org/t/p/original' .. m_simpleTV.User.TVPortal.stena.networks[j].logo_path
				end
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
			    t.left=20 / 1*1.25
			    t.top=(790 + (j-1)*75) / 1*1.25
				t.transparency = 200
				t.background = 2
				t.backcolor0 = 0x7FBBBBBB
				t.backcolor0 = 0x70BBBBBB
				t.zorder=0
				t.borderwidth = 3
			    t.bordercolor = ARGB(192, 192, 192, 192)
			    t.backroundcorner = 3*3
			    t.borderround = 3
			    t.isInteractive = true
			    t.background_UnderMouse = 2
			    t.backcolor0_UnderMouse = 0xEE4169E1
			    t.backcolor1_UnderMouse = 0xEE00008B
			    t.cursorShape = 13
			    t.bordercolor_UnderMouse = 0xEE4169E1
			    t.backroundcorner = 3*3
			    t.borderround = 3
				t.mousePressEventFunction = 'network' .. j
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'NETWORK_STENA_' .. j .. '_TEXT_ID'
				t.cx=295 / 1*1.25
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena.networks[j].Name .. '\n\n'
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = -2113993
			 	t.glowcolor_UnderMouse = 0xFF0000FF
				t.glow_samples_UnderMouse = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000002
--				t.padding = 20 / 1*1.25
--				t.boundWidth = 15
			    t.left=20 / 1*1.25
			    t.top=(795 + (j-1)*75) / 1*1.25
				t.row_limit=4
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'network' .. j
				AddElement(t,'ID_DIV_STENA_1')
			 j=j+1
			 end
			end

			 t = {}
			 t.id = 'RIMDB_IMG_STENA_ID'
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
			 t.id = 'R_IMDB_STENA_IMG_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena.ret_imdb) .. '.png'
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
			 t.id = 'RKP_IMG_STENA_ID'
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
			 t.id = 'R_KP_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena.ret_KP) .. '.png'
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
			 t.id = 'RTMDB_IMG_STENA_ID'
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
			 t.id = 'R_TMDB_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena.ret_tmdb or 0) .. '.png'
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

			 t = {}
			 t.id = 'FILMIX_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+100) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Filmix')
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
--			 t.borderwidth = 2
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'search_filmix_from_tmdb'
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'FILMIX_IMG_STENA_ID'
			 t.cx= 60 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Filmix.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= (170+200) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'REZKA_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+200) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('HDRezka')
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
--			 t.borderwidth = 2
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'search_rezka_from_tmdb'
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'REZKA_IMG_STENA_ID'
			 t.cx= 60 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/HDRezka.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= (170+300) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.TVPortal.stena.youtube then

			 t = {}
			 t.id = 'YOUTUBE_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+300) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = Get_current_balanser_name('Youtube')
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
--			 t.borderwidth = 2
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_youtube'
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'YOUTUBE_IMG_STENA_ID'
			 t.cx= 60 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/menuYT.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= (170+400) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')
			end

			 t={}
			 t.id = 'TEXT_STENA_0_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena.slogan
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
			 t.id = 'TEXT_STENA_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena.title
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
			 t.id = 'TEXT_STENA_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena.title_en
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
			 t.id = 'TEXT_STENA_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena.year .. ' ● ' .. m_simpleTV.User.TVPortal.stena.country .. (m_simpleTV.User.TVPortal.stena.age or '') ..  (m_simpleTV.User.TVPortal.stena.time_all or '')
			 t.color = ARGB(255, 192, 192, 192)
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
			 t.id = 'TEXT_STENA_5_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 192, 192, 192)
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.TVPortal.stena.overview .. '\n\n\n'
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

			local delta = 0
			if m_simpleTV.User.TVPortal.stena.genres and #m_simpleTV.User.TVPortal.stena.genres then
			 for j=1,#m_simpleTV.User.TVPortal.stena.genres do

			 t={}
			 t.id = 'TEXT_GENRES_STENA_' .. j .. '_ID'
			 t.cx=0
			 t.cy=0
			 t.once = 0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = ' ● ' .. m_simpleTV.User.TVPortal.stena.genres[j].Name .. ' '
			 t.color = ARGB(255, 192, 192, 192)
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 425 + delta
			 delta = delta + Get_length(t.text)*18
			 t.top  = 340 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 t.borderwidth = 1
			 t.backroundcorner = 3*3
			 t.isInteractive = true
			 t.color_UnderMouse = ARGB(255 ,255, 192, 63)
			 t.background_UnderMouse = 2
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0xEE00008B
			 t.bordercolor_UnderMouse = 0xEE4169E1
			 t.cursorShape = 13
			 if tonumber(m_simpleTV.User.TVPortal.stena.genres[j].Type) == 0 then
			  t.mousePressEventFunction = 'movie_genres' .. m_simpleTV.User.TVPortal.stena.genres[j].Id
			 elseif tonumber(m_simpleTV.User.TVPortal.stena.genres[j].Type) == 1 then
			  t.mousePressEventFunction = 'tv_genres' .. m_simpleTV.User.TVPortal.stena.genres[j].Id
			 end

			 AddElement(t,'ID_DIV_STENA_1')

			end
			end

			if 	m_simpleTV.User.TVPortal.stena.persons and
				m_simpleTV.User.TVPortal.stena.persons[1]	then
				for j = 1,#m_simpleTV.User.TVPortal.stena.persons do
				t = {}
				t.id = 'PERSON_STENA_' .. j .. '_IMG_ID'
				t.cx=125
				t.cy=125
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena.persons[j].logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 425 + (j-1)*150
			    t.top  = 750
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'personWork_stena' .. j
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'PERSON_STENA_' .. j .. '_TEXT_ID'
				t.cx=125
				t.cy=0
				t.class="TEXT"
				t.text = '\n\n\n\n' .. m_simpleTV.User.TVPortal.stena.persons[j].name .. '\n\n\n'
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
				t.left = 425 + (j-1)*150
			    t.top  = 760
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'personWork_stena' .. j
				AddElement(t,'ID_DIV_STENA_1')
				end
			end
			m_simpleTV.OSD.RemoveElement('STENA_INFO_ITEM_IMG_ID')
			m_simpleTV.OSD.RemoveElement('STENA_RETING_ITEM_IMG_ID')
end

function Get_ruru_balanser()
	local t, i = {}, 1
	if m_simpleTV.User.TVPortal.stena.balanser0 and (m_simpleTV.User.TVPortal.stena.balanser0.rutor and m_simpleTV.User.TVPortal.stena.balanser0.rutor[1] or m_simpleTV.User.TVPortal.stena.balanser0.rutracker and m_simpleTV.User.TVPortal.stena.balanser0.rutracker[1]) then
		if m_simpleTV.User.TVPortal.stena.balanser0.rutor and m_simpleTV.User.TVPortal.stena.balanser0.rutor[1] and m_simpleTV.User.TVPortal.stena.balanser0.rutracker and m_simpleTV.User.TVPortal.stena.balanser0.rutracker[1] then
		t[1]={}
		t[1].Id = i
		t[1].Name = 'все'
		i=i+1
		end
		if m_simpleTV.User.TVPortal.stena.balanser0 and m_simpleTV.User.TVPortal.stena.balanser0.rutor and m_simpleTV.User.TVPortal.stena.balanser0.rutor[1] then
		t[i]={}
		t[i].Id = i
		t[i].Name = 'rutor'
		i=i+1
		end
		if m_simpleTV.User.TVPortal.stena.balanser0 and m_simpleTV.User.TVPortal.stena.balanser0.rutracker and m_simpleTV.User.TVPortal.stena.balanser0.rutracker[1] then
		t[i]={}
		t[i].Id = i
		t[i].Name = 'rutracker'
		end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Контент '}
		local AutoNumberFormat, FilterType

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			torrents(t[id].Name)
		end
		if ret == 2 then
			tmdb_info()
		end
	end
end

function Get_pirs_balanser()
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local url = 'http://api.vokino.tv/v2/torrents/' .. m_simpleTV.User.TVPortal.stena.balanser1 .. '?token=' .. token
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.menu or not tab.menu[1] or not tab.menu[1].title or not tab.menu[1].submenu or not tab.menu[1].submenu[1] or not tab.menu[1].submenu[1].playlist_url or not tab.menu[1].submenu[1].title or tab.menu[1].submenu[1].title ~= 'Все' then
		return false
	end
	m_simpleTV.Http.Close(session)
	local title = tab.menu[1].title
	local current_id=1
	local t, i = {}, 1
	while true do
	if not tab.menu[1].submenu[i]
				then
				break
				end
	t[i]={}
	local name = tab.menu[1].submenu[i].title
	local address = tab.menu[1].submenu[i].playlist_url
	t[i].Id = i
	t[i].Name = tab.menu[1].submenu[i].title
	t[i].Address = address
	if tab.menu[1].submenu[i].selected == true then current_id = i end
    i=i+1
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Контент '}
		local AutoNumberFormat, FilterType

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, tonumber(current_id-1), t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			torrents_tracker(t[id].Address)
		end
		if ret == 2 then
			tmdb_info()
		end
end

--movie: боевик
function movie_genres28()
	tmdb_movie_page(1,28,'')
end

--movie: приключения
function movie_genres12()
	tmdb_movie_page(1,12,'')
end

--movie: мультфильм
function movie_genres16()
	tmdb_movie_page(1,16,'')
end

--movie: комедия
function movie_genres35()
	tmdb_movie_page(1,35,'')
end

--movie: криминал
function movie_genres80()
	tmdb_movie_page(1,80,'')
end

--movie: документальный
function movie_genres99()
	tmdb_movie_page(1,99,'')
end

--movie: драма
function movie_genres18()
	tmdb_movie_page(1,18,'')
end

--movie: семейный
function movie_genres10751()
	tmdb_movie_page(1,10751,'')
end

--movie: фэнтези
function movie_genres14()
	tmdb_movie_page(1,14,'')
end

--movie: история
function movie_genres36()
	tmdb_movie_page(1,36,'')
end

--movie: ужасы
function movie_genres27()
	tmdb_movie_page(1,27,'')
end

--movie: музыка
function movie_genres10402()
	tmdb_movie_page(1,10402,'')
end

--movie: детектив
function movie_genres9648()
	tmdb_movie_page(1,9648,'')
end

--movie: мелодрама
function movie_genres10749()
	tmdb_movie_page(1,10749,'')
end

--movie: фантастика
function movie_genres878()
	tmdb_movie_page(1,878,'')
end

--movie: телевизионный фильм
function movie_genres10770()
	tmdb_movie_page(1,10770,'')
end

--movie: триллер
function movie_genres53()
	tmdb_movie_page(1,53,'')
end

--movie: военный
function movie_genres10752()
	tmdb_movie_page(1,10752,'')
end

--movie: вестерн
function movie_genres37()
	tmdb_movie_page(1,37,'')
end

--tv: Боевик и Приключения
function tv_genres10759()
	tmdb_tv_page(1,10759,'','')
end

--tv: мультфильм
function tv_genres16()
	tmdb_tv_page(1,16,'','')
end

--tv: комедия
function tv_genres35()
	tmdb_tv_page(1,35,'','')
end

--tv: криминал
function tv_genres80()
	tmdb_tv_page(1,80,'','')
end

--tv: документальный
function tv_genres99()
	tmdb_tv_page(1,99,'','')
end

--tv: драма
function tv_genres18()
	tmdb_tv_page(1,18,'','')
end

--tv: семейный
function tv_genres10751()
	tmdb_tv_page(1,10751,'','')
end

--tv: Детский
function tv_genres10762()
	tmdb_tv_page(1,10762,'','')
end

--tv: детектив
function tv_genres9648()
	tmdb_tv_page(1,9648,'','')
end

--tv: Новости
function tv_genres10763()
	tmdb_tv_page(1,10763,'','')
end

--tv: Реалити-шоу
function tv_genres10764()
	tmdb_tv_page(1,10764,'','')
end

--tv: НФ и Фэнтези
function tv_genres10765()
	tmdb_tv_page(1,10765,'','')
end

--tv: Мыльная опера
function tv_genres10766()
	tmdb_tv_page(1,10766,'','')
end

--tv: Ток-шоу
function tv_genres10767()
	tmdb_tv_page(1,10767,'','')
end

--tv: Война и Политика
function tv_genres10768()
	tmdb_tv_page(1,10768,'','')
end

--tv: вестерн
function tv_genres37()
	tmdb_tv_page(1,37,'','')
end

function personWork_stena1()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[1] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[1].action,1)
end

function personWork_stena2()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[2] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[2].action,1)
end

function personWork_stena3()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[3] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[3].action,1)
end

function personWork_stena4()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[4] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[4].action,1)
end

function personWork_stena5()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[5] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[5].action,1)
end

function personWork_stena6()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[6] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[6].action,1)
end

function personWork_stena7()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[7] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[7].action,1)
end

function personWork_stena8()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[8] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[8].action,1)
end

function personWork_stena9()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[9] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[9].action,1)
end

function personWork_stena10()
	if m_simpleTV.User.TVPortal.stena.persons == nil or m_simpleTV.User.TVPortal.stena.persons[10] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.stena.persons[10].action,1)
end

-- for pause menu
function personWork1()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[1] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[1].action,1)
end

function personWork2()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[2] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[2].action,1)
end

function personWork3()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[3] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[3].action,1)
end

function personWork4()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[4] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[4].action,1)
end

function personWork5()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[5] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[5].action,1)
end

function personWork6()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[6] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[6].action,1)
end

function personWork7()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[7] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[7].action,1)
end

function personWork8()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[8] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[8].action,1)
end

function personWork9()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[9] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[9].action,1)
end

function personWork10()
	if m_simpleTV.User.TVPortal.persons == nil or m_simpleTV.User.TVPortal.persons[10] == nil or not personWorkById then return end
	return personWorkById(m_simpleTV.User.TVPortal.persons[10].action,1)
end
--- end for pause menu

function content1()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[1].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[1].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[1].Address,m_simpleTV.User.TVPortal.stena[1].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[1].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[1].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[1].Address,m_simpleTV.User.TVPortal.stena_search[1].Type)
	end
end

function content2()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[2].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[2].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[2].Address,m_simpleTV.User.TVPortal.stena[2].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[2].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[2].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[2].Address,m_simpleTV.User.TVPortal.stena_search[2].Type)
	end
end

function content3()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[3].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[3].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[3].Address,m_simpleTV.User.TVPortal.stena[3].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[3].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[3].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[3].Address,m_simpleTV.User.TVPortal.stena_search[3].Type)
	end
end

function content4()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[4].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[4].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[4].Address,m_simpleTV.User.TVPortal.stena[4].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[4].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[4].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[4].Address,m_simpleTV.User.TVPortal.stena_search[4].Type)
	end
end

function content5()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[5].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[5].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[5].Address,m_simpleTV.User.TVPortal.stena[5].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[5].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[5].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[5].Address,m_simpleTV.User.TVPortal.stena_search[5].Type)
	end
end

function content6()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[6].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[6].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[6].Address,m_simpleTV.User.TVPortal.stena[6].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[6].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[6].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[6].Address,m_simpleTV.User.TVPortal.stena_search[6].Type)
	end
end

function content7()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[7].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[7].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[7].Address,m_simpleTV.User.TVPortal.stena[7].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[7].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[7].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[7].Address,m_simpleTV.User.TVPortal.stena_search[7].Type)
	end
end

function content8()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[8].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[8].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[8].Address,m_simpleTV.User.TVPortal.stena[8].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[8].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[8].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[8].Address,m_simpleTV.User.TVPortal.stena_search[8].Type)
	end
end

function content9()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[9].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[9].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[9].Address,m_simpleTV.User.TVPortal.stena[9].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[9].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[9].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[9].Address,m_simpleTV.User.TVPortal.stena_search[9].Type)
	end
end

function content10()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[10].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[10].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[10].Address,m_simpleTV.User.TVPortal.stena[10].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[10].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[10].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[10].Address,m_simpleTV.User.TVPortal.stena_search[10].Type)
	end
end

function content11()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[11].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[11].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[11].Address,m_simpleTV.User.TVPortal.stena[11].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[11].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[11].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[11].Address,m_simpleTV.User.TVPortal.stena_search[11].Type)
	end
end

function content12()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[12].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[12].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[12].Address,m_simpleTV.User.TVPortal.stena[12].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[12].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[12].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[12].Address,m_simpleTV.User.TVPortal.stena_search[12].Type)
	end
end

function content13()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[13].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[13].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[13].Address,m_simpleTV.User.TVPortal.stena[13].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[13].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[13].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[13].Address,m_simpleTV.User.TVPortal.stena_search[13].Type)
	end
end

function content14()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[14].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[14].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[14].Address,m_simpleTV.User.TVPortal.stena[14].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[14].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[14].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[14].Address,m_simpleTV.User.TVPortal.stena_search[14].Type)
	end
end

function content15()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[15].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[15].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[15].Address,m_simpleTV.User.TVPortal.stena[15].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[15].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[15].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[15].Address,m_simpleTV.User.TVPortal.stena_search[15].Type)
	end
end

function content16()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[16].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[16].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[16].Address,m_simpleTV.User.TVPortal.stena[16].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[16].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[16].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[16].Address,m_simpleTV.User.TVPortal.stena_search[16].Type)
	end
end

function content17()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[17].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[17].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[17].Address,m_simpleTV.User.TVPortal.stena[17].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[17].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[17].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[17].Address,m_simpleTV.User.TVPortal.stena_search[17].Type)
	end
end

function content18()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[18].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[18].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[18].Address,m_simpleTV.User.TVPortal.stena[18].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[18].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[18].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[18].Address,m_simpleTV.User.TVPortal.stena_search[18].Type)
	end
end

function content19()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[19].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[19].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[19].Address,m_simpleTV.User.TVPortal.stena[19].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[19].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[19].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[19].Address,m_simpleTV.User.TVPortal.stena_search[19].Type)
	end
end

function content20()
	if m_simpleTV.User.TVPortal.stena.type == 'persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena[20].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena[20].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'collection' or
	m_simpleTV.User.TVPortal.stena.type == 'persona' or
	m_simpleTV.User.TVPortal.stena.type == 'movie' or
	m_simpleTV.User.TVPortal.stena.type == 'tv'	then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena[20].Address,m_simpleTV.User.TVPortal.stena[20].Type)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_persons' then
		personWorkById(m_simpleTV.User.TVPortal.stena_search[20].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collections' then
		collection_TMDb(m_simpleTV.User.TVPortal.stena_search[20].Address,1)
	elseif m_simpleTV.User.TVPortal.stena.type == 'search_collection' or
	m_simpleTV.User.TVPortal.stena.type == 'search_persona' or
	m_simpleTV.User.TVPortal.stena.type == 'search_movie' or
	m_simpleTV.User.TVPortal.stena.type == 'search_tv' then
		tmdb_info_for_stena(m_simpleTV.User.TVPortal.stena_search[20].Address,m_simpleTV.User.TVPortal.stena_search[20].Type)
	end
end

function collection_plus()
	collection_TMDb(m_simpleTV.User.TVPortal.stena.coll.adr,1)
end

function stena_search()
	stena_clear()
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\westSidePortal\\GUI\\showDialog.lua')
end

function stena_movie()
	tmdb_movie_page(1, '','')
end

function stena_tv()
	tmdb_tv_page(1, '','','')
end

function stena_persons()
	tmdb_person_page(1)
end

function stena_collections()
	collection(1)
end

function stena_home()
	tmdb_movie_page(1, 80, '')
end

function network1()
	tmdb_tv_page(1, '', '', m_simpleTV.User.TVPortal.stena.networks[1].Id)
end

function network2()
	tmdb_tv_page(1, '', '', m_simpleTV.User.TVPortal.stena.networks[2].Id)
end

function favorite1()
	tmdb_tv_page(1, '','RU','')
end

function favorite2()
	tmdb_movie_page(1, '','RU')
end

function favorite3()
	tmdb_movie_page(1, 35,'FR')
end

function favorite4()
	tmdb_tv_page(1, 9648,'GB','')
end

function favorite5()
	tmdb_movie_page(1, 35,'SU')
end

function favorite6()
	tmdb_tv_page(1, '','SU','')
end

function favorite7()
	tmdb_movie_page(1, 16,'')
end

function favorite8()
	tmdb_tv_page(1, '','',174)
end

function favorite9()
	tmdb_tv_page(1, '','',49)
end

function favorite10()
	tmdb_tv_page(1, 9648,'',4)
end

function favorite11()
	tmdb_tv_page(1, 99,'','')
end

function favorite12()
	tmdb_movie_page(1, 10402,'')
end

function favorite13()
	tmdb_movie_page(1, 16,'SU')
end

function stena_clear()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.User.TVPortal.stena_tvportal_use = false
	m_simpleTV.User.Videocdn.stena_use = false
	m_simpleTV.User.TVPortal.isPause = true
	m_simpleTV.Interface.RestoreBackground()
end

function collection_play()
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = 'collection_tmdb=' .. m_simpleTV.User.TVPortal.stena.playcol
	m_simpleTV.Control.PlayAddress('collection_tmdb=' .. m_simpleTV.User.TVPortal.stena.playcol)
end

function play()
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	local retAdr = 'https://www.imdb.com/title/' .. m_simpleTV.User.TVPortal.stena.imdb .. '/reference'
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.PlayAddress(retAdr)
	return
end

function play_balanser0()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	Get_ruru_balanser()

end

function play_balanser1()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	Get_pirs_balanser()

end

function play_balanser2()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser2, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function play_balanser3()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser3, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function play_balanser4()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser4, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function play_balanser5()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	m_simpleTV.User.TVPortal.balanser = 'HDVB'
	if not m_simpleTV.User.TVPortal.hdvb then
		m_simpleTV.User.TVPortal.hdvb = {}
	end
	if #m_simpleTV.User.TVPortal.stena.balanser5 > 1 then
		m_simpleTV.User.TVPortal.stena.balanser5.ExtButton0 = {ButtonEnable = true, ButtonName = 'Контент '}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка HDVB', (tonumber(m_simpleTV.User.TVPortal.hdvb.transl_selected) or 1) - 1, m_simpleTV.User.TVPortal.stena.balanser5, 10000, 1 + 4 + 8 + 2)
		id = id or 1
		if ret == 1 then
			m_simpleTV.User.TVPortal.hdvb.transl_selected = id
			m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser5[id].Address, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ') - ' .. m_simpleTV.User.TVPortal.stena.balanser5[id].Name})
		end
		if ret == 2 then
			tmdb_info()
		end
	else
		m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser5[1].Address, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ') - ' .. m_simpleTV.User.TVPortal.stena.balanser5[1].Name})
	end
end

function play_balanser6()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser6, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function play_balanser7()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser7, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function play_balanser8()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.balanser8, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function play_youtube()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

	m_simpleTV.Control.PlayAddressT({address='tmdb_id=' .. m_simpleTV.User.TMDB.Id .. '&tv=' .. m_simpleTV.User.TMDB.tv .. '&' .. m_simpleTV.User.TVPortal.stena.youtube, title=m_simpleTV.User.TVPortal.stena.title .. ' (' .. m_simpleTV.User.TVPortal.stena.year .. ')'})
end

function search_filmix_from_tmdb()
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena.title),'LiteConf.ini')
	search_filmix_media()
end

function search_rezka_from_tmdb()
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena.title),'LiteConf.ini')
	search_rezka()
end

function change_balansers()
	if m_simpleTV.User.TVPortal.stena.balansers == true then
		m_simpleTV.User.TVPortal.stena.balansers = false
	else
		m_simpleTV.User.TVPortal.stena.balansers = true
	end
	tmdb_info_for_stena(m_simpleTV.User.TMDB.Id,m_simpleTV.User.TMDB.tv)
end

function stena_callback(typeEvent)
	if typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_use then
		stena()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_info then
		tmdb_info()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_genres then
		stena_genres()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_search_use then
		stena_search_content()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_search_youtube_use then
		stena_search_youtube_content()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_filmix_use then
		stena_filmix()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_filmix_info then
		filmix_info()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_tvportal_use
	then
		stena_desc_tvportal_content()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.Videocdn and m_simpleTV.User.Videocdn.stena_use then
		stena_videocdn()
	elseif typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.TVPortal and m_simpleTV.User.TVPortal.stena_home then
		start_page_mediaportal()
	end
end

m_simpleTV.OSD.AddEventListener({type = 1, callback = 'stena_callback'})

function onActionEsc(action, param)
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
 if (esc_action_id) then

   	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	m_simpleTV.OSD.RemoveElement('ID_DIV_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_2')
	m_simpleTV.OSD.RemoveElement('ID_DIV_AUDIO_1')
	m_simpleTV.OSD.RemoveElement('USER_LOGO_AUDIO_IMG_ID')
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.TVPortal.stena_tvportal_use = false
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.Videocdn.stena_use = false
	m_simpleTV.User.TVPortal.isPause = false
	m_simpleTV.Interface.RestoreBackground()

 else
   m_simpleTV.Control.ExecuteAction(action, param,true)
 end

end

local t ={}
t.name = '-'
t.location = -2
t.action = 'KEY_ESC'
t.lua_as_scr = true
t.luastring = "local action,param = ...; onActionEsc(action, param)"
esc_action_id = m_simpleTV.Interface.AddExtMenuT(t)