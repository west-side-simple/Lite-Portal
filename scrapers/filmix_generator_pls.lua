-- скрапер TVS для генерации плейлистов с сайта https://filmix.my
-- author west_side (18/01/25)
-- необходимы:
-- filmix.lua west_side mod for lite (18/01/25)
-- playerjs.lua
-- info_fox.lua, show_mi.lua - author west_side
-- логопак show_mi

	module('filmix_generator_pls', package.seeall)
	local my_src_name = 'filmix Playlists'

	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://filmix.my/templates/Filmix/media/img/favicon.ico', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 1, TypeSkip = 0, TypeFind = 1, TypeMedia = 3}}
	end

	function GetVersion()
	 return 2, 'UTF-8'
	end
	
	local function LoadFromPage(playlist,pls_name,sessionfilmix)
	local t1,t2
	local str, page = '', 1
	if page == 1 then t1=os.time() end
	local txt = '🎥 filmix: ' .. pls_name
	local page_type
	if playlist:match('playlist/') then page_type = '/page/' else page_type = '/pages/' end
	while true do
		local filmixurl = (m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.my') .. '/' .. playlist .. page_type .. page .. '/'
		local rc, filmixanswer = m_simpleTV.Http.Request(sessionfilmix, {url = filmixurl:gsub('/page/1/',''):gsub('/pages/1/',''), method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. filmixurl:gsub('/page/1/',''):gsub('/pages/1/','') .. '\nCookie:' .. m_simpleTV.User.filmix.cookies})
		if rc ~= 200
			then
				m_simpleTV.Common.Sleep(30000)
			else			
				filmixanswer = m_simpleTV.Common.multiByteToUTF8(filmixanswer)
				str = str .. filmixanswer:gsub('\n', ' ')
--				debug_in_file(str .. '\n-----\n','c://1/fx.txt')
				if filmixanswer:match(page_type .. (page + 1) .. '/"')
					then

						m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = ' ' .. txt .. ' (' .. page .. ')', color = ARGB(255, 127, 63, 255), showTime = 1000 * 60})
						page = page + 1
					else
						t2=os.time()
						m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = ' Время загрузки ' .. t2-t1 .. ' сек. Приятного просмотра', color = ARGB(255, 127, 63, 255), showTime = 1000 * 60})
						return str, txt
				end
		end
		rc, answer = m_simpleTV.Http.Request(sessionfilmix, {body = filmixurl:gsub('/page/1/',''), url = (m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.my') .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl:gsub('/page/1/','') .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	end
	end

	local function LoadFromSite(playlist,pls_name,sessionfilmix)
		local t, i = {}, 1
		local name, adr, logo
		local answer, gr = LoadFromPage(playlist,pls_name,sessionfilmix)
			for w in answer:gmatch('<article class="shortstory line" itemscope itemtype="http://schema%.org/Movie"(.-)</article>') do
			if w and not w:match('Добавлена%:') then			
				name_rus = w:match('itemprop="name" content="(.-)"><a itemprop'):gsub('&amp;', '&')
				year = w:match('<a itemprop="copyrightYear".->(.-)</a>') or 0
				adr = w:match('<a itemprop="url" href="(.-)"')
				logo = w:match('<img src="(.-)"') or ''
				t[i] = {}
				t[i].logo = logo
				t[i].name = name_rus .. ' (' .. year .. ')'
				t[i].address = adr
				t[i].group = gr
			    i = i + 1
			end
			end
	 return t
	end

	function GetList(UpdateID, m3u_file)
		local host = 'https://filmix.my'
		local sessionfilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
		if not sessionfilmix then return end
			m_simpleTV.Http.SetTimeout(sessionfilmix, 600000)
		if not m_simpleTV.User then
			m_simpleTV.User = {}
		end
		if not m_simpleTV.User.filmix then
			m_simpleTV.User.filmix = {}
		end
--		if not m_simpleTV.User.filmix.cookies then
			local host = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.my'
			local sessionfilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
			if not sessionfilmix then return end
			m_simpleTV.Http.SetTimeout(sessionfilmix, 16000)
			local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
			if not login or not password or login == '' or password == '' then
				login = decode64('TWluaW9uc1RW')
				password = decode64('cXdlcnZjeHo=')
			end
			local rc, answer = m_simpleTV.Http.Request(sessionfilmix, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
			if not answer then
				m_simpleTV.User.filmix.cookies = ''
			else
				answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
				local avatar = answer:match('<div class="pro%-comment">.-<img src="(.-)"') or (m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/filmix.png')
				local pro = answer:match('<div class="login%-item my%-pro%-settings%-page">.-</div>') or ''
				pro = pro:gsub('<.->','')
				m_simpleTV.User.filmix.avatar = avatar:gsub('dog/','my/')
				m_simpleTV.User.filmix.pro = pro
	--			debug_in_file(avatar .. ' ' .. pro .. '\n','c://1/filmix1.txt')
				m_simpleTV.User.filmix.cookies = m_simpleTV.Http.GetCookies(sessionfilmix,host)
	--			debug_in_file(m_simpleTV.User.filmix.cookies .. '\n','c://1/filmix_cookies.txt')
			end
--		end	
		if not UpdateID then return end
		if not m3u_file then return end
		if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local pll={
		{"film/animes","Аниме"},
		{"film/biografia","Биография"},
		{"film/boevik","Боевики"},
		{"film/vesterny","Вестерн"},
		{"film/voennyj","Военный"},
		{"film/detektivy","Детектив"},
		{"film/detskij","Детский"},
		{"film/for_adults","Для взрослых"},
		{"film/dokumentalenyj","Документальные"},
		{"film/drama","Драмы"},
		{"film/istoricheskie","Исторический"},
		{"film/komedia","Комедии"},
		{"film/korotkometragka","Короткометражка"},
		{"film/kriminaly","Криминал"},
		{"film/melodrama","Мелодрамы"},
		{"film/mistika","Мистика"},
		{"film/music","Музыка"},
		{"film/muzkl","Мюзикл"},
		{"film/novosti","Новости"},
		{"film/original","Оригинал"},
		{"film/otechestvennye","Отечественные"},
		{"film/tvs","Передачи с ТВ"},
		{"film/prikluchenija","Приключения"},
		{"film/realnoe_tv","Реальное ТВ"},
		{"film/semejnye","Семейный"},
		{"film/sports","Спорт"},
		{"film/tok_show","Ток-шоу"},
		{"film/triller","Триллеры"},
		{"film/uzhasu","Ужасы"},
		{"film/fantastiks","Фантастика"},
		{"film/film_noir","Фильм-нуар"},
		{"film/fjuntezia","Фэнтези"},
		{"film/engl","На английском"},
		{"film/ukraine","На украинском"},
		{"film/c64","СОВЕТСКИЕ ФИЛЬМЫ"},
		{"mults/c64","СОВЕТСКИЕ МУЛЬТФИЛЬМЫ"},
		{"mults/c6","РУССКИЕ МУЛЬТФИЛЬМЫ"},
		{"mults/c996","ЗАРУБЕЖНЫЕ МУЛЬТФИЛЬМЫ"},
		{"film/r19851990","Фильмы 90-ых"},
		{"playlist/13559-novogodnie-melodramy","НОВОГОДНИЕ МЕЛОДРАМЫ"},
		{"playlist/13674-dushevnye-istorii-o-pervoy-lyubvi","ДУШЕВНЫЕ ИСТОРИИ О ПЕРВОЙ ЛЮБВИ"},
		{"playlist/9984-filmy-proverennye-vremenem","США. ПРОВЕРЕНО ВРЕМЕНЕМ. НАЦИОНАЛЬНОЕ ДОСТОЯНИЕ."},
		{"playlist/546-klassika-kino","OLD SCHOOL"},
		{"playlist/5269-kidorg","ФИЛЬМЫ И СЕРИАЛЫ ЖАНРА КИБЕРПАНК"},
		{"playlist/9964-ves-startrek","ВЕСЬ СТАРТРЕК (ЗВЕЗДНЫЙ ПУТЬ)"},
		{"playlist/40-luchshie-serialy-21-veka","ЛУЧШИЕ СЕРИАЛЫ 21 ВЕКА"},
		{"playlist/13521-luchshie-novogodnie-i-rozhdestvenskie-multfilmy","ЛУЧШИЕ НОВОГОДНИЕ И РОЖДЕСТВЕНСКИЕ МУЛЬТФИЛЬМЫ"},
		{"playlist/27-national-geographic-dokumentalnye-filmy","NATIONAL GEOGRAPHIC - ДОКУМЕНТАЛЬНЫЕ ФИЛЬМЫ"},
		{"playlist/2829-v-dalekom-buduschem-v-nashey-galaktike","В ДАЛЕКОМ БУДУЩЕМ В НАШЕЙ ГАЛАКТИКЕ…"},
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Select playlist',0,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = t[id].Action
   pls_name = t[id].Name
  end
		local t_pls = LoadFromSite(playlist, pls_name, sessionfilmix)
			if not t_pls then m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'}) return end
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')