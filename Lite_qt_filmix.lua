--Filmix portal - lite version west_side 01.07.24

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

	local host = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
	if not sessionFilmix then return end
	m_simpleTV.Http.SetTimeout(sessionFilmix, 16000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.filmix then
		m_simpleTV.User.filmix = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
	if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
	end
	local rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
	if not answer then
		m_simpleTV.User.filmix.cookies = ''
	else
		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
		local avatar = answer:match('<div class="pro%-comment">.-<img src="(.-)"') or (m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Filmix.png')
		local pro = answer:match('<div class="login%-item my%-pro%-settings%-page">.-</div>') or ''
		pro = pro:gsub('<.->','')
		m_simpleTV.User.filmix.avatar = avatar:gsub('dog/','fm/')
		m_simpleTV.User.filmix.pro = pro
--		debug_in_file(avatar .. ' ' .. pro .. '\n','c://1/filmix1.txt')
		m_simpleTV.User.filmix.cookies = m_simpleTV.Http.GetCookies(sessionFilmix,host)
--		debug_in_file(m_simpleTV.User.filmix.cookies .. '\n','c://1/filmix_cookies.txt')
	end
	m_simpleTV.Http.Close(sessionFilmix)

local function get_count_for_search()
	if m_simpleTV.User == nil then
		m_simpleTV.User = {}
	end
	if m_simpleTV.User.TVPortal == nil then
		m_simpleTV.User.TVPortal = {}
	end
	if m_simpleTV.User.TVPortal.stena_filmix == nil then
		m_simpleTV.User.TVPortal.stena_filmix = {}
	end
	if m_simpleTV.User.TVPortal.stena_filmix_search_count == nil then
		m_simpleTV.User.TVPortal.stena_filmix_search_count = {}
	end

	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local search_ini = getConfigVal('search/media') or ''
	local year = m_simpleTV.Common.fromPercentEncoding(search_ini):match(' %((%d%d%d%d)%)$')
	local title = m_simpleTV.Common.fromPercentEncoding(search_ini):gsub(' %(%d%d%d%d%)$',''):gsub(' %(%)$','')
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
			local count1,count2,count3=0,0,0
			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies
			local body
			if year then
			body = 'scf=fx&story=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&search_start=0&do=search&subaction=search&years_ot=' .. tonumber(year)-1 .. '&years_do=' .. tonumber(year)+1 .. '&kpi_ot=1&kpi_do=10&imdb_ot=1&imdb_do=10&sort_name=&undefined=asc&sort_date=&sort_favorite=desc'
			else
			body = 'scf=fx&story=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&search_start=0&do=search&subaction=search&years_ot=&years_do=&kpi_ot=&kpi_do=&imdb_ot=&imdb_do=&sort_name=&undefined=asc&sort_date=&sort_favorite=desc'
			end
			local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})
--			m_simpleTV.Http.Close(session)
--			debug_in_file(rc .. ':\n' .. answer .. '\n','c://1/filmixs.txt')
			local res_count = answer:match('res_count=(%d+)') or 0
			count1 = res_count
					local otvet = answer:match('<article.-<script>') or ''
					local i, t = 1, {}
					for w in otvet:gmatch('<article.-</article>') do
					local logo, name, adr = w:match('<a class="fancybox" href="(.-)".-alt="(.-)".-<a class="watch icon%-play" itemprop="url" href="(.-)"')
					if not logo or not adr or not name then break end
							t[i] = {}
							t[i].Id = i
							t[i].Address = adr
							if adr:match('filmi/') then name = name .. ' - Кино'
							elseif adr:match('seria/') then name = name .. ' - Сериал'
							elseif adr:match('multserialy/') then name = name .. ' - Мультсериал'
							elseif adr:match('mults/') then name = name .. ' - Мультфильм'
							end
							t[i].Name = name:gsub('%&nbsp%;',' ')
							t[i].InfoPanelLogo = logo:gsub('/orig/','/thumbs/w220/')
							t[i].InfoPanelName = name:gsub('%&nbsp%;',' ')
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
------------------------

			rc, answer = m_simpleTV.Http.Request(session, {url = filmixsite .. '/loader.php?do=persons&search=' .. search_ini, method = 'post', headers = headers})
--					answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
--					debug_in_file(rc .. ':\n' .. answer .. '\n','c://1/filmixs.txt')
					answer = answer:gsub('\n', ' ')

					for w in answer:gmatch('<div class="short">.-</a></h2>') do
					local sim_adr, sim_img, sim_name = w:match('href="(.-)".-img src="(.-)".-<h2 class="name" itemprop="name"><a href=".-">(.-)</a></h2>')
					if not sim_adr or not sim_name then break end
					count2 = count2 + 1
							t[i] = {}
							t[i].Id = i
							t[i].Address = sim_adr
							t[i].Name = sim_name .. ' - Персона'
							t[i].InfoPanelLogo = sim_img
							t[i].InfoPanelName = sim_name
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end

	rc, answer = m_simpleTV.Http.Request(session, {body = filmixurl, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
------------------------

			rc, answer = m_simpleTV.Http.Request(session, {url = filmixsite .. '/loader.php?do=playlists&sort_filter=rateup&items_only=true&search=' .. search_ini, method = 'post', headers = headers})
--					answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
--					debug_in_file(rc .. ':\n' .. answer .. '\n','c://1/filmixs.txt')
					answer = answer:gsub('\n', ' ')

					for w in answer:gmatch('<div class="short">.-</a></h3>') do
					local sim_adr, sim_img, sim_name = w:match('href="(.-)".-img src="(.-)".-<h3 class="name"><a href=".-">(.-)</a></h3>')
					local count = w:match('<div class="count">(%d+)')
					if not sim_adr or not sim_name then break end
						if count and tonumber(count) and tonumber(count) > 0 then
						count3 = count3 + 1
							t[i] = {}
							t[i].Id = i
							t[i].Address = sim_adr
							t[i].Name = sim_name .. ' - Подборка'
							t[i].InfoPanelLogo = sim_img
							t[i].InfoPanelName = sim_name
							t[i].InfoPanelShowTime = 30000
							i = i + 1
						end
					end

	rc, answer = m_simpleTV.Http.Request(session, {body = filmixurl, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

		m_simpleTV.User.TVPortal.stena_filmix_search_count = {count1,count2,count3}
--		debug_in_file(m_simpleTV.User.TVPortal.stena_filmix_search_count[1] .. ':' .. m_simpleTV.User.TVPortal.stena_filmix_search_count[2] .. ':' .. m_simpleTV.User.TVPortal.stena_filmix_search_count[3] .. '\n','c://1/filmixs.txt')
end

local function get_stena_for_url(url)

-- films
		local tt1 = {
		{"https://filmix.fm/films/","Все"},
		{"https://filmix.fm/films/animes/","Аниме"},
		{"https://filmix.fm/films/biografia/","Биография"},
		{"https://filmix.fm/films/boevik/","Боевики"},
		{"https://filmix.fm/films/vesterny/","Вестерн"},
		{"https://filmix.fm/films/voennyj/","Военный"},
		{"https://filmix.fm/films/detektivy/","Детектив"},
		{"https://filmix.fm/films/detskij/","Детский"},
		{"https://filmix.fm/films/for_adults/","Для взрослых"},
		{"https://filmix.fm/films/dokumentalenyj/","Документальные"},
		{"https://filmix.fm/films/drama/","Драмы"},
		{"https://filmix.fm/films/istoricheskie/","Исторический"},
		{"https://filmix.fm/films/komedia/","Комедии"},
		{"https://filmix.fm/films/korotkometragka/","Короткометражка"},
		{"https://filmix.fm/films/kriminaly/","Криминал"},
		{"https://filmix.fm/films/melodrama/","Мелодрамы"},
		{"https://filmix.fm/films/mistika/","Мистика"},
		{"https://filmix.fm/films/music/","Музыка"},
		{"https://filmix.fm/films/muzkl/","Мюзикл"},
		{"https://filmix.fm/films/novosti/","Новости"},
		{"https://filmix.fm/films/original/","Оригинал"},
		{"https://filmix.fm/films/otechestvennye/","Отечественные"},
		{"https://filmix.fm/films/tvs/","Передачи с ТВ"},
		{"https://filmix.fm/films/prikluchenija/","Приключения"},
		{"https://filmix.fm/films/realnoe_tv/","Реальное ТВ"},
		{"https://filmix.fm/films/semejnye/","Семейный"},
		{"https://filmix.fm/films/sports/","Спорт"},
		{"https://filmix.fm/films/tok_show/","Ток-шоу"},
		{"https://filmix.fm/films/triller/","Триллеры"},
		{"https://filmix.fm/films/uzhasu/","Ужасы"},
		{"https://filmix.fm/films/fantastiks/","Фантастика"},
		{"https://filmix.fm/films/film_noir/","Фильм-нуар"},
		{"https://filmix.fm/films/fjuntezia/","Фэнтези"},
		{"https://filmix.fm/films/engl/","На английском"},
		{"https://filmix.fm/films/ukraine/","На украинском"},
		{"https://filmix.fm/films/c6/","Русские"},
		{"https://filmix.fm/films/c64/","Советские"},
		{"https://filmix.fm/films/y2024/","2024"},
		{"https://filmix.fm/top250/","TOP фильмы"},
		{"https://filmix.fm/films/q4/","4K (PRO, PRO+)"},
		}
-- serials
		local tt2 = {
		{"https://filmix.fm/seria/","Все"},
		{"https://filmix.fm/seria/animes/s7/","Аниме"},
		{"https://filmix.fm/seria/biografia/s7/","Биография"},
		{"https://filmix.fm/seria/boevik/s7/","Боевики"},
		{"https://filmix.fm/seria/vesterny/s7/","Вестерн"},
		{"https://filmix.fm/seria/voennyj/s7/","Военный"},
		{"https://filmix.fm/seria/detektivy/s7/","Детектив"},
		{"https://filmix.fm/seria/detskij/s7/","Детский"},
		{"https://filmix.fm/seria/for_adults/s7/","Для взрослых"},
		{"https://filmix.fm/seria/dokumentalenyj/s7/","Документальные"},
		{"https://filmix.fm/seria/dorama/s7/","Дорамы"},
		{"https://filmix.fm/seria/drama/s7/","Драмы"},
		{"https://filmix.fm/seria/game/s7/","Игра"},
		{"https://filmix.fm/seria/istoricheskie/s7/","Исторический"},
		{"https://filmix.fm/seria/komedia/s7/","Комедии"},
		{"https://filmix.fm/seria/kriminaly/s7/","Криминал"},
		{"https://filmix.fm/seria/melodrama/s7/","Мелодрамы"},
		{"https://filmix.fm/seria/mistika/s7/","Мистика"},
		{"https://filmix.fm/seria/music/s7/","Музыка"},
		{"https://filmix.fm/seria/muzkl/s7/","Мюзикл"},
		{"https://filmix.fm/seria/novosti/s7/","Новости"},
		{"https://filmix.fm/seria/original/s7/","Оригинал"},
		{"https://filmix.fm/seria/otechestvennye/s7/","Отечественные"},
		{"https://filmix.fm/seria/tvs/s7/","Передачи с ТВ"},
		{"https://filmix.fm/seria/prikluchenija/s7/","Приключения"},
		{"https://filmix.fm/seria/realnoe_tv/s7/","Реальное ТВ"},
		{"https://filmix.fm/seria/semejnye/s7/","Семейный"},
		{"https://filmix.fm/seria/sitcom/s7/","Ситком"},
		{"https://filmix.fm/seria/sports/s7/","Спорт"},
		{"https://filmix.fm/seria/tok_show/s7/","Ток-шоу"},
		{"https://filmix.fm/seria/triller/s7/","Триллеры"},
		{"https://filmix.fm/seria/uzhasu/s7/","Ужасы"},
		{"https://filmix.fm/seria/fantastiks/s7/","Фантастика"},
		{"https://filmix.fm/seria/fjuntezia/s7/","Фэнтези"},
		{"https://filmix.fm/seria/ukraine/s7/","На украинском"},
		{"https://filmix.fm/series/c6/","Русские"},
		{"https://filmix.fm/series/c64/","Советские"},
		{"https://filmix.fm/series/y2024/","2024"},
		{"https://filmix.fm/top250s/","TOP сериалы"},
		{"https://filmix.fm/series/q4/","4K (PRO, PRO+)"},
		}

		local tt3 = {
		{"https://filmix.fm/mults/","Все"},
		{"https://filmix.fm/mults/animes/s14/","Аниме"},
		{"https://filmix.fm/mults/biografia/s14/","Биография"},
		{"https://filmix.fm/mults/boevik/s14/","Боевики"},
		{"https://filmix.fm/mults/vesterny/s14/","Вестерн"},
		{"https://filmix.fm/mults/voennyj/s14/","Военный"},
		{"https://filmix.fm/mults/detektivy/s14/","Детектив"},
		{"https://filmix.fm/mults/detskij/s14/","Детский"},
		{"https://filmix.fm/mults/for_adults/s14/","Для взрослых"},
		{"https://filmix.fm/mults/dokumentalenyj/s14/","Документальные"},
		{"https://filmix.fm/mults/drama/s14/","Драмы"},
		{"https://filmix.fm/mults/istoricheskie/s14/","Исторический"},
		{"https://filmix.fm/mults/komedia/s14/","Комедии"},
		{"https://filmix.fm/mults/kriminaly/s14/","Криминал"},
		{"https://filmix.fm/mults/melodrama/s14/","Мелодрамы"},
		{"https://filmix.fm/mults/mistika/s14/","Мистика"},
		{"https://filmix.fm/mults/music/s14/","Музыка"},
		{"https://filmix.fm/mults/muzkl/s14/","Мюзикл"},
		{"https://filmix.fm/mults/original/s14/","Оригинал"},
		{"https://filmix.fm/mults/otechestvennye/s14/","Отечественные"},
		{"https://filmix.fm/mults/prikluchenija/s14/","Приключения"},
		{"https://filmix.fm/mults/semejnye/s14/","Семейный"},
		{"https://filmix.fm/mults/sports/s14/","Спорт"},
		{"https://filmix.fm/mults/triller/s14/","Триллеры"},
		{"https://filmix.fm/mults/uzhasu/s14/","Ужасы"},
		{"https://filmix.fm/mults/fantastiks/s14/","Фантастика"},
		{"https://filmix.fm/mults/fjuntezia/s14/","Фэнтези"},
		{"https://filmix.fm/mults/engl/s14/","На английском"},
		{"https://filmix.fm/mults/ukraine/s14/","На украинском"},
		{"https://filmix.fm/mults/c6/","Русские"},
		{"https://filmix.fm/mults/c64/","Советские"},
		{"https://filmix.fm/mults/y2024/","2024"},
		{"https://filmix.fm/mults/y2023/","2023"},
		{"https://filmix.fm/mults/y2022/","2022"},
		{"https://filmix.fm/mults/y2021/","2021"},
		{"https://filmix.fm/mults/y2021/","2020"},
		{"https://filmix.fm/mults/y2021/","2019"},
		{"https://filmix.fm/mults/y2021/","2018"},
		{"https://filmix.fm/top250m/","TOP мульты"},
		{"https://filmix.fm/mults/q4/","4K (PRO, PRO+)"},
		}

		local tt4 = {
		{"https://filmix.fm/multseries/","Все"},
		{"https://filmix.fm/multseries/animes/s93/","Аниме"},
		{"https://filmix.fm/multseries/biografia/s93/","Биография"},
		{"https://filmix.fm/multseries/boevik/s93/","Боевики"},
		{"https://filmix.fm/multseries/vesterny/s93/","Вестерн"},
		{"https://filmix.fm/multseries/voennyj/s93/","Военный"},
		{"https://filmix.fm/multseries/detektivy/s93/","Детектив"},
		{"https://filmix.fm/multseries/detskij/s93/","Детский"},
		{"https://filmix.fm/multseries/for_adults/s93/","Для взрослых"},
		{"https://filmix.fm/multseries/dokumentalenyj/s93/","Документальные"},
		{"https://filmix.fm/multseries/dorama/s93/","Дорамы"},
		{"https://filmix.fm/multseries/drama/s93/","Драмы"},
		{"https://filmix.fm/multseries/istoricheskie/s93/","Исторический"},
		{"https://filmix.fm/multseries/komedia/s93/","Комедии"},
		{"https://filmix.fm/multseries/kriminaly/s93/","Криминал"},
		{"https://filmix.fm/multseries/melodrama/s93/","Мелодрамы"},
		{"https://filmix.fm/multseries/mistika/s93/","Мистика"},
		{"https://filmix.fm/multseries/music/s93/","Музыка"},
		{"https://filmix.fm/multseries/muzkl/s93/","Мюзикл"},
		{"https://filmix.fm/multseries/otechestvennye/s93/","Отечественные"},
		{"https://filmix.fm/multseries/tvs/s93/","Передачи с ТВ"},
		{"https://filmix.fm/multseries/prikluchenija/s93/","Приключения"},
		{"https://filmix.fm/multseries/semejnye/s93/","Семейный"},
		{"https://filmix.fm/multseries/sitcom/s93/","Ситком"},
		{"https://filmix.fm/multseries/sports/s93/","Спорт"},
		{"https://filmix.fm/multseries/triller/s93/","Триллеры"},
		{"https://filmix.fm/multseries/uzhasu/s93/","Ужасы"},
		{"https://filmix.fm/multseries/fantastiks/s93/","Фантастика"},
		{"https://filmix.fm/multseries/fjuntezia/s93/","Фэнтези"},
		{"https://filmix.fm/multseries/ukraine/s93/","На украинском"},
		{"https://filmix.fm/multseries/c6/","Русские"},
		{"https://filmix.fm/multseries/c64/","Советские"},
		{"https://filmix.fm/multseries/y2024/","2024"},
		{"https://filmix.fm/multseries/y2023/","2023"},
		{"https://filmix.fm/multseries/y2022/","2022"},
		{"https://filmix.fm/multseries/y2021/","2021"},
		{"https://filmix.fm/multseries/y2020/","2020"},
		{"https://filmix.fm/multseries/y2019/","2019"},
		{"https://filmix.fm/multseries/y2018/","2018"},
		{"https://filmix.fm/multseries/q4/","4K (PRO, PRO+)"},
		}

		for i = 1,#tt1 do
			if tt1[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/','') then
				return Get_filmix_stena_info('film',i,1)
			end
		end
		for i = 1,#tt2 do
			if tt2[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/',''):gsub('series/','seria/') then
				return Get_filmix_stena_info('serial',i,1)
			end
		end
		for i = 1,#tt3 do
			if tt3[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/',''):gsub('multes/','mults/') then
				return Get_filmix_stena_info('mult',i,1)
			end
		end
		for i = 1,#tt4 do
			if tt4[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/','') then
				return Get_filmix_stena_info('multserial',i,1)
			end
		end
end

local function show_filmix(answer)
	if m_simpleTV.User.TVPortal.stena_filmix == nil then m_simpleTV.User.TVPortal.stena_filmix = {} end
	local masshtab = 0.66
	local rus, orig, poster, kpR, vote_kpR, imdbR, vote_imdbR, reting = '', '', '', '', '', '', '', ''
	rus = answer:match('<h1 class="name" itemprop="name">(.-)</h1>') or ''
	m_simpleTV.User.TVPortal.stena_filmix.title = rus
	orig = answer:match('<div class="origin%-name" itemprop="alternativeHeadline">(.-)</div>') or ''
	m_simpleTV.User.TVPortal.stena_filmix.title_en = orig:gsub('%&rsquo%;',"'")
	poster = answer:match('<meta property="og%:image" content="(.-)" />')
	m_simpleTV.User.TVPortal.stena_filmix.logo = poster:gsub('thumbs/w220','orig')
	local background = answer:match('<ul class="frames%-list">(.-)</ul>')
	local host = answer:match('https?://.-/')
	if background then background = background:match('"(.-)"') end
	if background then background = host .. background:gsub('^/','') end
	m_simpleTV.User.TVPortal.stena_filmix.background = background or poster:gsub('thumbs/w220','orig')
	kpR, vote_kpR = answer:match('\"Кинопоиск\"\'>.-<p>(.-)</p>.-<p>(.-)</p>')
	imdbR, vote_imdbR = answer:match('\“IMDB\”\'>.-<p>(.-)</p>.-<p>(.-)</p>')
	if kpR and kpR ~= '-' then kpR = math.floor(tonumber(kpR)*10)/10 else kpR = '' end
	if imdbR and imdbR ~= '-' then imdbR = math.floor(tonumber(imdbR)*10)/10 else imdbR = '' end

	local max = answer:match('<span class="rateinf ratePos">(%d+)') or 1
	local min = answer:match('<span class="rateinf rateNeg">(%d+)') or 1
	local ret = max/(max+min)*10

	if kpR ~= '' then
		reting = reting .. '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuKP.png" height="' .. 24*masshtab .. '" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. kpR .. '.png" height="' .. 24*masshtab .. '" align="top"> ' .. kpR .. ' (' .. vote_kpR .. ')</h5>'
	end
	if imdbR ~= '' then
		reting = reting .. '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuIMDb.png" height="' .. 24*masshtab .. '" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. imdbR .. '.png" height="' .. 24*masshtab .. '" align="top"> ' .. imdbR .. ' (' .. vote_imdbR .. ')</h5>'
	end

	m_simpleTV.User.TVPortal.stena_filmix.ret_imdb = imdbR
	m_simpleTV.User.TVPortal.stena_filmix.ret_KP = kpR
	m_simpleTV.User.TVPortal.stena_filmix.ret_filmix = ret

	local country = answer:match('<div class="item contry"><span class="label">Страна:</span><span class="item%-content">(.-)</span></div>') or ''
	country = country:gsub('<span><a href=".-">',''):gsub('</a>','')
	country = country:gsub(', ', ','):gsub(',', ', ')
	m_simpleTV.User.TVPortal.stena_filmix.country = country:gsub('^%, ',''):gsub('%&nbsp%;',''):gsub('<.->','')

	local year = answer:match('<div class="item year"><span class="label">Год:</span><span class="item%-content"><a itemprop="copyrightYear" href=".-">(.-)</a>') or ''
	m_simpleTV.User.TVPortal.stena_filmix.year = year

--------director
	local director = answer:match('<div class="item directors"><span class="label">Режиссер:</span><span class="item%-content">(.-)</span></div>') or ''
	local directors = ''
	m_simpleTV.User.TVPortal.stena_filmix.actors = nil
	m_simpleTV.User.TVPortal.stena_filmix.actors = {}
	local i, ta = 1, {}
	if director ~= '' then
		for w in director:gmatch('<a.-</a>') do
			ta[i] = {}
			ta[i].actors_adr, ta[i].actors_name = w:match('href ="(.-)".-"name">(.-)<')
			directors = directors .. ', ' .. ta[i].actors_name
			i = i + 1
		end
	else
		directors = ''
	end
--------actors
	local actor = answer:match('<div class="item actors"><span class="label">В ролях:</span><span class="item%-content">(.-)</span></div>') or ''
	local actors = ''
	if actor ~= '' then
		for w in actor:gmatch('<a.-</a>') do
			ta[i] = {}
			ta[i].actors_adr, ta[i].actors_name = w:match('href ="(.-)".-"name">(.-)<')
			actors = actors .. ', ' .. ta[i].actors_name
			i = i + 1
		end
	else
		actors = ''
	end
	m_simpleTV.User.TVPortal.stena_filmix.actors = ta
--------genres
	local genre = answer:match('<span class="label">Жанр:</span>.-</div>') or ''
	local genres = ''
	m_simpleTV.User.TVPortal.stena_filmix.genres = nil
	m_simpleTV.User.TVPortal.stena_filmix.genres = {}
	local i, ta = 1, {}
	if genre ~= '' then
		for w in genre:gmatch('<a.-</a>') do
			ta[i] = {}
			ta[i].genre_adr, ta[i].genre_name = w:match('href="(.-)">(.-)</a>')
			genres = genres .. ', ' .. ta[i].genre_name
			i = i + 1
		end
	else
		genres = ''
	end
	m_simpleTV.User.TVPortal.stena_filmix.genres = ta
-------------- collection
	local collection = answer:match('<span class="label">В подборках:.-</div>') or ''
	m_simpleTV.User.TVPortal.stena_filmix.collections = nil
	m_simpleTV.User.TVPortal.stena_filmix.collections = {}
	local i, ta = 1, {}
	for w in collection:gmatch('<a.-</a>') do
		local adr,name = w:match('href="(.-)".-class="pl%-link">(.-)<')
		if not adr or not name then break end
		ta[i] = {}
		ta[i].Id = i
		ta[i].Name = name
		ta[i].Address = adr
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_filmix.collections = ta
--------other
	local description = answer:match('<div class="full%-story">(.-)</div>') or ''
	m_simpleTV.User.TVPortal.stena_filmix.overview = description:gsub('<.->', '')
	local slogan = answer:match('<span class="label">Слоган:</span><span class="item%-content">(.-)</span>') or ''
	if slogan ~= '' and slogan ~= '-' then slogan = ' «' .. slogan:gsub('«', ''):gsub('»', '') .. '» ' else slogan = '' end
	m_simpleTV.User.TVPortal.stena_filmix.slogan = slogan

	local age = answer:match('<span class="label">MPAA:</span><span class="item%-content">(.-)</span>') or '0+'
	m_simpleTV.User.TVPortal.stena_filmix.age = ' ● ' .. age

	local time_all = answer:match('<span class="label">Время:</span><span class="item%-content">(.-)</span>') or ''
	m_simpleTV.User.TVPortal.stena_filmix.time_all = ' ● ' .. time_all

	local quality = answer:match('<div class="quality">(.-)</div>')
	m_simpleTV.User.TVPortal.stena_filmix.qual = quality

	local perevod = answer:match('<span class="label">Перевод:</span><span class="item%-content">(.-)</span>') or ''
--------country
	local function get_country_flags(country_ID)
		country_flag = '<img src="simpleTVImage:./luaScr/user/show_mi/country/' .. country_ID .. '.png" height="' .. 36*masshtab .. '" align="top">'
		return country_flag:gsub('"', "'")
	end

	local tmp_country_ID = ''
	local country_ID = ''
	if country and country:match('СССР') then tmp_country_ID = 'ussr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Аргентина') then tmp_country_ID = 'ar' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Австрия') then tmp_country_ID = 'at' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Австралия') then tmp_country_ID = 'au' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Бельгия') then tmp_country_ID = 'be' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Бразилия') then tmp_country_ID = 'br' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Канада') then tmp_country_ID = 'ca' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Швейцария') then tmp_country_ID = 'ch' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Китай') then tmp_country_ID = 'cn' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Гонконг') then tmp_country_ID = 'hk' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Германия') then tmp_country_ID = 'de' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Дания') then tmp_country_ID = 'dk' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Испания') then tmp_country_ID = 'es' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Финляндия') then tmp_country_ID = 'fi' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Франция') then tmp_country_ID = 'fr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Великобритания') then tmp_country_ID = 'gb' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Греция') then tmp_country_ID = 'gr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Ирландия') then tmp_country_ID = 'ie' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Израиль') then tmp_country_ID = 'il' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Индия') then tmp_country_ID = 'in' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Исландия') then tmp_country_ID = 'is' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Италия') then tmp_country_ID = 'it' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Япония') then tmp_country_ID = 'jp' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Южная Корея') or country and country:match('Корея Южная') then tmp_country_ID = 'kr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Мексика') then tmp_country_ID = 'mx' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Нидерланды') then tmp_country_ID = 'nl' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Норвегия') then tmp_country_ID = 'no' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Польша') then tmp_country_ID = 'pl' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Венгрия') then tmp_country_ID = 'hu' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Новая Зеландия') then tmp_country_ID = 'nz' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Португалия') then tmp_country_ID = 'pt' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Румыния') then tmp_country_ID = 'ro' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('ЮАР') then tmp_country_ID = 'rs' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Россия') then tmp_country_ID = 'ru' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Швеция') then tmp_country_ID = 'se' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Турция') then tmp_country_ID = 'tr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('Украина') then tmp_country_ID = 'ua' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
	if country and country:match('США') then tmp_country_ID = 'us' country_ID = get_country_flags(tmp_country_ID) .. country_ID end

	local videodesc = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="' .. 470*masshtab .. '"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. rus .. '</font></h4><h5><i><font color=#CCCCCC>' .. slogan .. '</font></i></h5><h5><font color=#BBBBBB>' .. orig .. '<h5><font color=#EBEBEB>' .. country_ID .. ' ' .. country:gsub('^%, ','') .. ' </font> • ' .. year .. '</h5><h5><font color=#00CAA4>' .. perevod .. '</font></h5><h5><font color=#EBEBEB>' .. genres:gsub('^%, ','') .. '</font> • ' .. age .. '</h5>' .. reting .. '<h5><font color=#EBEBEB>' .. time_all .. '</font></h5><h5>Режиссер: <font color=#EBEBEB>' .. directors:gsub('^%, ','') .. '</font><br>В ролях: <font color=#EBEBEB>' .. actors:gsub('^%, ','') .. '</font></h5></td></tr></table><table width="100%"><tr><td style="padding: 5px 5px 5px;"><h5><font color=#EBEBEB>' .. description .. '</font></h5></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')

	return videodesc
end

local function find_in_favorites1(address)
	local id = address:match('/(%d+)')
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local url = filmixsite.. '/favorites'
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end
		if login and password then
			local url1
			if filmixsite:match('filmix%.tech') then
				url1 = filmixsite
			else
				url1 = filmixsite .. '/engine/ajax/user_auth.php'
			end
			local url1 = filmixsite
			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})
		end
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
--		debug_in_file(rc .. ' - ' .. answer .. '\n','c://1/testfavorite.txt')
		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
		local t,i = {},1
		local answer1 = answer:match('<div class="line%-block">.-<script') or ''
		for w in answer1:gmatch('<article.-</article>') do
		local adr,logo,name,desc
		adr = w:match('itemprop="url" href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
			if not adr or not name or adr == '' then break end
			if adr == address then
				rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
				m_simpleTV.Http.Close(session)
				return '👀 '
			end
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	return ''
end

local function find_in_favorites2(adr)
	local id = adr:match('/(%d+)')
	if id == nil then return false end
	if m_simpleTV.User.TVPortal.stena_filmix_favorite_str:match(' ' .. id .. ' ') then
		return true
	end
	return false
end

local function find_in_favorites(address)
	local id = address:match('/(%d+)')
	if m_simpleTV.User.TVPortal.stena_filmix_favorite and
		#m_simpleTV.User.TVPortal.stena_filmix_favorite and
		m_simpleTV.User.TVPortal.stena_filmix_favorite[1] then
		for i = 1, #m_simpleTV.User.TVPortal.stena_filmix_favorite do
--		debug_in_file(id .. ' ' .. m_simpleTV.User.TVPortal.stena_filmix_favorite[i] .. '\n','c://1/testfavorite.txt')
			if tonumber(id) == tonumber(m_simpleTV.User.TVPortal.stena_filmix_favorite[i]) then
				return true
			end
		end
	end
	return false
end

local function get_favorites_media(page)
	local host = 'https://filmix.dog'
	local url = host.. '/favorites'
	if tonumber(page) > 1 then
		url = host.. '/favorites/page/' .. page .. '/'
	end
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 12000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end

			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})

---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
--		debug_in_file(rc .. ' - ' .. answer .. '\n','c://1/testfavorite.txt')
--		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
		local t,i = {},1

		if not answer then return t,0 end

		local answer1 = answer:match('<div class="line%-block">.-<script') or ''
--		debug_in_file(answer1 .. '\n','c://1/testfavorite.txt')
		for w in answer1:gmatch('<article.-</article>') do
		local adr
		adr = w:match('itemprop="url" href="(.-)"') or ''
			if not adr or adr == '' then break end
			adr = adr:match('/(%d+)')
			t[i] = adr
--			debug_in_file(adr .. '\n','c://1/testfavorite.txt')
			i = i + 1
		end
		local max = tonumber(page) - 1
		if answer1:match('<a data%-number="%d+') then
		for w1 in answer1:gmatch('<a data%-number="%d+') do
			local get_page = w1:match('<a data%-number="(%d+)')
			if tonumber(get_page) > tonumber(max) then max = get_page end
		end
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = host ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
--	debug_in_file(#t .. '|||' .. max .. '\n','c://1/testfavorite.txt')
	return t, max
end

function set_favorites()
--	m_simpleTV.User.TVPortal.stena_filmix_favorite = nil
--	m_simpleTV.User.TVPortal.stena_filmix_favorite = {}
	m_simpleTV.User.TVPortal.stena_filmix_favorite_str = ''
	local tt1 = os.clock()
	local t, t1, i, max, cur, str = {}, {}, 1, 1, 1, ' '
	local j
	while tonumber(max) >= i do
		t1, max = get_favorites_media(i)
		if t1 and #t1 and #t1 > 0 then
			local k = 1
			for j = cur, cur - 1 + #t1 do
			t[j] = t1[k]
			str = str .. t1[k] .. ' '
			k = k + 1
			end
			cur = cur + #t1
			i = i + 1
		end
	end
--	m_simpleTV.User.TVPortal.stena_filmix_favorite = t
	m_simpleTV.User.TVPortal.stena_filmix_favorite_str = str
--	debug_in_file(str .. '\n' .. os.clock() - tt1 .. '\n','c://1/testfavorite.txt') -- ~ 1.7 sec
end

function run_lite_qt_filmix()
--	m_simpleTV.Control.ExecuteAction(37)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/filmix') or ''
	local tt = {
		{"","Персоны"},
		{"films","Фильмы"},
		{"seria","Сериалы"},
		{"mults","Мульты"},
		{"multserialy","Мультсериалы"},
		{"https://filmix.fm/playlists/popular","Популярные подборки"},
		{"https://filmix.fm/playlists/films","Подборки фильмов"},
		{"https://filmix.fm/playlists/serials","Подборки сериалов"},
		{"https://filmix.fm/playlists/multfilms","Подборки мультов"},
		{"","Избранное"},
		{"","ПОИСК"},
		{"","Filmix зеркало"},
		}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
	if last_adr and last_adr ~= '' then
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
	end
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию Filmix',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search_all()
			elseif t0[id].Name == 'Filmix зеркало' then
				zerkalo_filmix()
			elseif t0[id].Name:match('одборки') then
				collection_filmix(t0[id].Action)
			elseif t0[id].Name:match('Избранное') then
				favorite_filmix()
--				run_lite_qt_filmix()
			elseif t0[id].Name:match('Персоны') then
				person_filmix('https://filmix.fm/persons')
			elseif t0[id].Action == 'films' or t0[id].Action == 'seria' or t0[id].Action == 'mults' or t0[id].Action == 'multserialy' then
				type_filmix(t0[id].Action)
			end
		end
		if ret == 2 then
		media_info_filmix(last_adr)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function zerkalo_filmix()
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/filmix') or ''
	local current_zerkalo_id = 0
	local tt = {
		{'https://filmix.fm','Без зеркала'},
--		{'https://filmix.gay','https://filmix.gay'},
--		{'https://filmix.fm','https://filmix.fm'},
		{'https://filmix.dog','https://filmix.dog'},
		{'https://filmix.tech','https://filmix.tech'},
		}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
			if t0[i].Action == current_zerkalo then current_zerkalo_id = i-1 end
			i=i+1
		end

	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Filmix '}
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите зеркало Filmix',current_zerkalo_id,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			setConfigVal('zerkalo/filmix',t0[id].Action)
			zerkalo_filmix()
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
		if ret == 3 then
			run_westSide_portal()
		end
end

function type_filmix(con)
--	m_simpleTV.Control.ExecuteAction(37)
		local tt = {
		{"https://filmix.fm/films/","Все"},
		{"https://filmix.fm/films/animes/","Аниме"},
		{"https://filmix.fm/films/biografia/","Биография"},
		{"https://filmix.fm/films/boevik/","Боевики"},
		{"https://filmix.fm/films/vesterny/","Вестерн"},
		{"https://filmix.fm/films/voennyj/","Военный"},
		{"https://filmix.fm/films/detektivy/","Детектив"},
		{"https://filmix.fm/films/detskij/","Детский"},
		{"https://filmix.fm/films/for_adults/","Для взрослых"},
		{"https://filmix.fm/films/dokumentalenyj/","Документальные"},
		{"https://filmix.fm/films/drama/","Драмы"},
		{"https://filmix.fm/films/istoricheskie/","Исторический"},
		{"https://filmix.fm/films/komedia/","Комедии"},
		{"https://filmix.fm/films/korotkometragka/","Короткометражка"},
		{"https://filmix.fm/films/kriminaly/","Криминал"},
		{"https://filmix.fm/films/melodrama/","Мелодрамы"},
		{"https://filmix.fm/films/mistika/","Мистика"},
		{"https://filmix.fm/films/music/","Музыка"},
		{"https://filmix.fm/films/muzkl/","Мюзикл"},
		{"https://filmix.fm/films/novosti/","Новости"},
		{"https://filmix.fm/films/original/","Оригинал"},
		{"https://filmix.fm/films/otechestvennye/","Отечественные"},
		{"https://filmix.fm/films/tvs/","Передачи с ТВ"},
		{"https://filmix.fm/films/prikluchenija/","Приключения"},
		{"https://filmix.fm/films/realnoe_tv/","Реальное ТВ"},
		{"https://filmix.fm/films/semejnye/","Семейный"},
		{"https://filmix.fm/films/sports/","Спорт"},
		{"https://filmix.fm/films/tok_show/","Ток-шоу"},
		{"https://filmix.fm/films/triller/","Триллеры"},
		{"https://filmix.fm/films/uzhasu/","Ужасы"},
		{"https://filmix.fm/films/fantastiks/","Фантастика"},
		{"https://filmix.fm/films/film_noir/","Фильм-нуар"},
		{"https://filmix.fm/films/fjuntezia/","Фэнтези"},
		{"https://filmix.fm/films/engl/","На английском"},
		{"https://filmix.fm/films/ukraine/","На украинском"},
		{"https://filmix.fm/films/c6/","Русские"},
		{"https://filmix.fm/films/c64/","Советские"},
		{"https://filmix.fm/films/y2024/","2024"},
		{"https://filmix.fm/top250/","TOP фильмы"},
		{"https://filmix.fm/films/q4/","4K (PRO, PRO+)"},

		{"https://filmix.fm/seria/","Все"},
		{"https://filmix.fm/seria/animes/s7/","Аниме"},
		{"https://filmix.fm/seria/biografia/s7/","Биография"},
		{"https://filmix.fm/seria/boevik/s7/","Боевики"},
		{"https://filmix.fm/seria/vesterny/s7/","Вестерн"},
		{"https://filmix.fm/seria/voennyj/s7/","Военный"},
		{"https://filmix.fm/seria/detektivy/s7/","Детектив"},
		{"https://filmix.fm/seria/detskij/s7/","Детский"},
		{"https://filmix.fm/seria/for_adults/s7/","Для взрослых"},
		{"https://filmix.fm/seria/dokumentalenyj/s7/","Документальные"},
		{"https://filmix.fm/seria/dorama/s7/","Дорамы"},
		{"https://filmix.fm/seria/drama/s7/","Драмы"},
		{"https://filmix.fm/seria/game/s7/","Игра"},
		{"https://filmix.fm/seria/istoricheskie/s7/","Исторический"},
		{"https://filmix.fm/seria/komedia/s7/","Комедии"},
		{"https://filmix.fm/seria/kriminaly/s7/","Криминал"},
		{"https://filmix.fm/seria/melodrama/s7/","Мелодрамы"},
		{"https://filmix.fm/seria/mistika/s7/","Мистика"},
		{"https://filmix.fm/seria/music/s7/","Музыка"},
		{"https://filmix.fm/seria/muzkl/s7/","Мюзикл"},
		{"https://filmix.fm/seria/novosti/s7/","Новости"},
		{"https://filmix.fm/seria/original/s7/","Оригинал"},
		{"https://filmix.fm/seria/otechestvennye/s7/","Отечественные"},
		{"https://filmix.fm/seria/tvs/s7/","Передачи с ТВ"},
		{"https://filmix.fm/seria/prikluchenija/s7/","Приключения"},
		{"https://filmix.fm/seria/realnoe_tv/s7/","Реальное ТВ"},
		{"https://filmix.fm/seria/semejnye/s7/","Семейный"},
		{"https://filmix.fm/seria/sitcom/s7/","Ситком"},
		{"https://filmix.fm/seria/sports/s7/","Спорт"},
		{"https://filmix.fm/seria/tok_show/s7/","Ток-шоу"},
		{"https://filmix.fm/seria/triller/s7/","Триллеры"},
		{"https://filmix.fm/seria/uzhasu/s7/","Ужасы"},
		{"https://filmix.fm/seria/fantastiks/s7/","Фантастика"},
		{"https://filmix.fm/seria/fjuntezia/s7/","Фэнтези"},
		{"https://filmix.fm/seria/ukraine/s7/","На украинском"},
		{"https://filmix.fm/series/c6/","Русские"},
		{"https://filmix.fm/series/c64/","Советские"},
		{"https://filmix.fm/series/y2024/","2024"},
		{"https://filmix.fm/top250s/","TOP сериалы"},
		{"https://filmix.fm/series/q4/","4K (PRO, PRO+)"},

		{"https://filmix.fm/mults/","Все"},
		{"https://filmix.fm/mults/animes/s14/","Аниме"},
		{"https://filmix.fm/mults/biografia/s14/","Биография"},
		{"https://filmix.fm/mults/boevik/s14/","Боевики"},
		{"https://filmix.fm/mults/vesterny/s14/","Вестерн"},
		{"https://filmix.fm/mults/voennyj/s14/","Военный"},
		{"https://filmix.fm/mults/detektivy/s14/","Детектив"},
		{"https://filmix.fm/mults/detskij/s14/","Детский"},
		{"https://filmix.fm/mults/for_adults/s14/","Для взрослых"},
		{"https://filmix.fm/mults/dokumentalenyj/s14/","Документальные"},
		{"https://filmix.fm/mults/drama/s14/","Драмы"},
		{"https://filmix.fm/mults/istoricheskie/s14/","Исторический"},
		{"https://filmix.fm/mults/komedia/s14/","Комедии"},
		{"https://filmix.fm/mults/kriminaly/s14/","Криминал"},
		{"https://filmix.fm/mults/melodrama/s14/","Мелодрамы"},
		{"https://filmix.fm/mults/mistika/s14/","Мистика"},
		{"https://filmix.fm/mults/music/s14/","Музыка"},
		{"https://filmix.fm/mults/muzkl/s14/","Мюзикл"},
		{"https://filmix.fm/mults/original/s14/","Оригинал"},
		{"https://filmix.fm/mults/otechestvennye/s14/","Отечественные"},
		{"https://filmix.fm/mults/prikluchenija/s14/","Приключения"},
		{"https://filmix.fm/mults/semejnye/s14/","Семейный"},
		{"https://filmix.fm/mults/sports/s14/","Спорт"},
		{"https://filmix.fm/mults/triller/s14/","Триллеры"},
		{"https://filmix.fm/mults/uzhasu/s14/","Ужасы"},
		{"https://filmix.fm/mults/fantastiks/s14/","Фантастика"},
		{"https://filmix.fm/mults/fjuntezia/s14/","Фэнтези"},
		{"https://filmix.fm/mults/engl/s14/","На английском"},
		{"https://filmix.fm/mults/ukraine/s14/","На украинском"},
		{"https://filmix.fm/mults/c6/","Русские"},
		{"https://filmix.fm/mults/c64/","Советские"},
		{"https://filmix.fm/mults/y2024/","2024"},
		{"https://filmix.fm/mults/y2023/","2023"},
		{"https://filmix.fm/mults/y2022/","2022"},
		{"https://filmix.fm/mults/y2021/","2021"},
		{"https://filmix.fm/mults/y2021/","2020"},
		{"https://filmix.fm/mults/y2021/","2019"},
		{"https://filmix.fm/mults/y2021/","2018"},
		{"https://filmix.fm/top250m/","TOP мульты"},
		{"https://filmix.fm/mults/q4/","4K (PRO, PRO+)"},

		{"https://filmix.fm/multseries/","Все"},
		{"https://filmix.fm/multseries/animes/s93/","Аниме"},
		{"https://filmix.fm/multseries/biografia/s93/","Биография"},
		{"https://filmix.fm/multseries/boevik/s93/","Боевики"},
		{"https://filmix.fm/multseries/vesterny/s93/","Вестерн"},
		{"https://filmix.fm/multseries/voennyj/s93/","Военный"},
		{"https://filmix.fm/multseries/detektivy/s93/","Детектив"},
		{"https://filmix.fm/multseries/detskij/s93/","Детский"},
		{"https://filmix.fm/multseries/for_adults/s93/","Для взрослых"},
		{"https://filmix.fm/multseries/dokumentalenyj/s93/","Документальные"},
		{"https://filmix.fm/multseries/dorama/s93/","Дорамы"},
		{"https://filmix.fm/multseries/drama/s93/","Драмы"},
		{"https://filmix.fm/multseries/istoricheskie/s93/","Исторический"},
		{"https://filmix.fm/multseries/komedia/s93/","Комедии"},
		{"https://filmix.fm/multseries/kriminaly/s93/","Криминал"},
		{"https://filmix.fm/multseries/melodrama/s93/","Мелодрамы"},
		{"https://filmix.fm/multseries/mistika/s93/","Мистика"},
		{"https://filmix.fm/multseries/music/s93/","Музыка"},
		{"https://filmix.fm/multseries/muzkl/s93/","Мюзикл"},
		{"https://filmix.fm/multseries/otechestvennye/s93/","Отечественные"},
		{"https://filmix.fm/multseries/tvs/s93/","Передачи с ТВ"},
		{"https://filmix.fm/multseries/prikluchenija/s93/","Приключения"},
		{"https://filmix.fm/multseries/semejnye/s93/","Семейный"},
		{"https://filmix.fm/multseries/sitcom/s93/","Ситком"},
		{"https://filmix.fm/multseries/sports/s93/","Спорт"},
		{"https://filmix.fm/multseries/triller/s93/","Триллеры"},
		{"https://filmix.fm/multseries/uzhasu/s93/","Ужасы"},
		{"https://filmix.fm/multseries/fantastiks/s93/","Фантастика"},
		{"https://filmix.fm/multseries/fjuntezia/s93/","Фэнтези"},
		{"https://filmix.fm/multseries/ukraine/s93/","На украинском"},
		{"https://filmix.fm/multseries/c6/","Русские"},
		{"https://filmix.fm/multseries/c64/","Советские"},
		{"https://filmix.fm/multseries/y2024/","2024"},
		{"https://filmix.fm/multseries/y2023/","2023"},
		{"https://filmix.fm/multseries/y2022/","2022"},
		{"https://filmix.fm/multseries/y2021/","2021"},
		{"https://filmix.fm/multseries/y2021/","2020"},
		{"https://filmix.fm/multseries/y2021/","2019"},
		{"https://filmix.fm/multseries/y2021/","2018"},
		{"https://filmix.fm/multseries/q4/","4K (PRO, PRO+)"},
		}

	local ganre1,ganre2,ganre3,ganre4,k1,k2,k3,k4 = {},{},{},{},1,1,1,1
	for k = 1,#tt do
		if tt[k][1]:match('/films/') then
			ganre1[k1] = {}
			ganre1[k1].Id = k1
			ganre1[k1].Address = tt[k][1]
			ganre1[k1].Name = tt[k][2]
			k1 = k1 + 1
		end
		if tt[k][1]:match('/seri') then
			ganre2[k2] = {}
			ganre2[k2].Id = k2
			ganre2[k2].Address = tt[k][1]
			ganre2[k2].Name = tt[k][2]
			k2 = k2 + 1
		end
		if tt[k][1]:match('/mults/') then
			ganre3[k3] = {}
			ganre3[k3].Id = k3
			ganre3[k3].Address = tt[k][1]
			ganre3[k3].Name = tt[k][2]
			k3 = k3 + 1
		end
		if tt[k][1]:match('/multseri') then
			ganre4[k4] = {}
			ganre4[k4].Id = k4
			ganre4[k4].Address = tt[k][1]
			ganre4[k4].Name = tt[k][2]
			k4 = k4 + 1
		end
		k = k + 1
	end

	local title,ganre = '',{}

	if con == 'films' then title = 'Кино' ganre = ganre1
	elseif con == 'seria' then title = 'Сериалы' ganre = ganre2
	elseif con == 'mults' then title = 'Мульты' ganre = ganre3
	elseif con == 'multserialy' then title = 'Мультсериалы' ganre = ganre4
	end

	ganre.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' Filmix',0,ganre,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			ganres_content_filmix(ganre[id].Address)
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
end

function ganres_content_filmix(url)
	if get_stena_for_url then return get_stena_for_url(url) end
--	m_simpleTV.Control.ExecuteAction(37)
	local title
	if url:match('filmi/') then title = 'Кино'
	elseif url:match('seria/') then title = 'Сериалы'
	elseif url:match('multserialy/') then title = 'Мультсериалы'
	elseif url:match('mults/') then title = 'Мульты'
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end
		if login and password then
			local url1
			if filmixsite:match('filmix%.tech') then
				url1 = filmixsite
			else
				url1 = filmixsite .. '/engine/ajax/user_auth.php'
			end
			local url1 = filmixsite
			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite .. '\nCookie:' .. m_simpleTV.User.filmix.cookies})
		end
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then
			return
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		local title1 = answer:match('<div class="subtitle">(.-)</div>') or ''
		title1 = title1:gsub('Сейчас смотрят ','') or ''
		m_simpleTV.User.TVPortal.stena_filmix_title = title1
		local j, sim = 1, {}
		for w in answer:gmatch('"slider%-item">(.-)</li>') do
		sim[j] = {}
		local sim_adr, sim_img, sim_title = w:match('href="(.-)".-src="(.-)".-alt="(.-)"')
		if not sim_adr or not sim_title then break end
			sim[j] = {}
			sim[j].Id = j
			sim[j].Name = sim_title:gsub('%&nbsp%;',' ')
			sim[j].Address = sim_adr
			sim[j].InfoPanelLogo = sim_img
			sim[j].InfoPanelName = 'Filmix: ' .. sim_title
			sim[j].InfoPanelShowTime = 10000
			j = j + 1
		end
		local t,i = {},1
		for w in answer:gmatch('<article class="shortstory line".-</article>') do
		local adr,logo,name,desc,max,min,ret,qual
		adr = w:match('itemprop="url" href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
		max = w:match('<span class="rateinf ratePos">(%d+)') or 1
		min = w:match('<span class="rateinf rateNeg">(%d+)') or 1
		ret = max/(max+min)
		qual = w:match('<div class="quality">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('%&nbsp%;',' ')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].Reting = ret*10
				t[i].Qual = qual:gsub(' $','')
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end

	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	local function change_page(name,sim,t,title,title1)
		if name == 'Watch' then
		sim.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		sim.ExtButton1 = {ButtonEnable = true, ButtonName = ' New '}
		sim.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title1 .. ' - Watch (' .. #sim .. ')',0,sim,10000,1+4+8+2)

		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			similar_filmix(sim[id].Address)
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
		if ret == 3 then
			change_page('NEW',sim,t,title,title1)
		end
		elseif name == 'NEW' then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Watch '}
		t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title1 .. ' - NEW (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			similar_filmix(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
		if ret == 3 then
			change_page('Watch',sim,t,title,title1)
		end
		end
	end
	change_page('NEW',sim,t,title,title1)
end

function stena_filmix_collections(page)
	page = tonumber(page) or 1
	local url = 'https://filmix.fm/playlists'
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/') .. 'playlists/rateup/page/' .. page .. '/'

	local t,i,j = {},1,1
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)

		rc,answer = m_simpleTV.Http.Request(session,{url = filmixsite .. '/loader.php?do=playlists&sort_filter=rateup&items_only=true&cstart=' .. page, method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies})

		if rc ~= 200 then
			return
		end

		local max = page
		if answer:match('<a data%-number="%d+') then
		for w1 in answer:gmatch('<a data%-number="%d+') do
			local get_page = w1:match('<a data%-number="(%d+)')
			if tonumber(get_page) > tonumber(max) then max = get_page end
		end
		end

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		if tonumber(next_pg) <= tonumber(max) then
		m_simpleTV.User.TVPortal.stena_filmix_next = {tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if tonumber(prev_pg) > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {max, page}

		answer = answer:gsub('<br />', ''):gsub('\n', '')

		for w in answer:gmatch('<article.-<div class="panel') do
		local adr,num,logo,name,desc
		adr = w:match('href="(.-)"')
		num = w:match('"count">(.-)<') or 'nonum'
		logo = w:match('<img src="(.-)"') or ''
		if logo:match('/img/none%.png') then logo = 'https://filmix.dog/templates/Filmix/media/img/filmix.png' end
		name = w:match('alt="(.-)"')
		desc = w:match('"description">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' (' .. num .. ')'
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelTitle = desc:gsub('_','')
			i = i + 1
		end
	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'collections'
	m_simpleTV.User.TVPortal.stena_filmix_title = 'Подборки - стр. ' .. page .. ' из ' .. max
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	stena_filmix()
end

function collection_filmix(url)
--	m_simpleTV.Control.ExecuteAction(37)
	local title
	if url:match('/playlists/popular') then
	title = 'Популярное'
	elseif url:match('/playlists/films') then
	title = 'Фильмы'
	elseif url:match('/playlists/serials') then
	title = 'Сериалы'
	elseif url:match('/playlists/multfilms') then
	title = 'Мульты'
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t,i,j = {},1,1
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

        local content = url:match('/playlists/(.-)$')
		local page = content:match('/page/(%d+)/') or 1
		content = content:gsub('/page.-$','')

		if not url:match('/playlists/popular') then
		rc,answer = m_simpleTV.Http.Request(session,{url = filmixsite .. '/loader.php?do=playlists&items_only=true&cstart=' .. page .. '&scope=' .. content, method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. url})
		else
		rc,answer = m_simpleTV.Http.Request(session,{url = filmixsite .. '/loader.php?do=playlists&items_only=true&cstart=' .. page .. '&sort_filter=popular', method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. url})
		end
		if rc ~= 200 then
		return
		end
		answer = answer:gsub('<br />', ''):gsub('\n', '')
		local title1 = ' - страница ' .. page
		local navi = answer:match('<div class="navigation">.-</div>') or ''
		local left,right
		for w1 in navi:gmatch('<a.-</a>') do
		local adr = w1:match('href="(.-)"')
		if not adr then break end
		if w1:match('class="prev icon%-arowLeft">') then
		left = adr
		end
		if w1:match('class="next icon%-arowRight">') then
		right = adr
		end
		j = j + 1
		end
		for w in answer:gmatch('<article.-<div class="panel') do
		local adr,num,logo,name,desc
		adr = w:match('href="(.-)"') or ''
		num = w:match('"count">(.-)<') or 'nonum'
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' (' .. num .. ')'
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix collection: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	if left then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Filmix (' .. #t .. ') ' .. title .. ' ' .. title1,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			collection_filmix_url(t[id].Address)
		end
		if ret == 2 then
		if left then
			collection_filmix(left)
		else
			run_lite_qt_filmix()
		end
		end
		if ret == 3 then
		if right then
			collection_filmix(right)
		end
		end
end

function collection_filmix_url(url, page)

	local title = 'Сборник '
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local page = page or url:match('/page/(%d+)/') or 1
	url = url:gsub('/page/.-$', '')
	if tonumber(page) > 1 then url = url .. '/page/' .. page .. '/' end
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')

	local t,i,j = {},1,1
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end
	local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = filmixsite, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})

	m_simpleTV.Http.SetTimeout(session, 8000)

		local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nAccept: application/json, text/javascript, */*; q=0.01\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url
		local body = filmixsite .. '/api/notifications/get'
		local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
		if rc ~= 200 then
			return
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)

		local max = page
		if answer:match('<a data%-number="%d+') then
		for w1 in answer:gmatch('<a data%-number="%d+') do
			local get_page = w1:match('<a data%-number="(%d+)')
			if tonumber(get_page) > tonumber(max) then max = get_page end
		end
		end

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		if tonumber(next_pg) <= tonumber(max) then
		m_simpleTV.User.TVPortal.stena_filmix_next = {url, tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if tonumber(prev_pg) > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {url, tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {max, page, url}

		answer = answer:gsub('<br />', ''):gsub('\n', '')
		local title1 = answer:match('<title>(.-)</title>') or ''
		title1 = title1:gsub(' смотреть онлайн',''):gsub(' %- Страница.-$','')

		m_simpleTV.User.TVPortal.stena_filmix_title = title1 .. ' (стр. ' .. page .. ' из '  .. max .. ')'

		local navi = answer:match('<div class="navigation">.-</div>') or ''
		local left,right
		for w1 in navi:gmatch('<a.-</a>') do
		if w1:match('class="nav%-back prev icon%-arowLeft') then
		left = w1:match('href="(.-)"')
		end
		if w1:match('class="next icon%-arowRight') then
		right = w1:match('href="(.-)"')
		end
		j = j + 1
		end
		local answer1 = answer:match('<div class="clr playlist%-articles.-<script') or ''
		for w in answer1:gmatch('<article.-</article>') do
		local adr,logo,name,desc,max,min,ret,qual
		adr = w:match('itemprop="url" href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
		max = w:match('<span class="rateinf ratePos">(%d+)') or 1
		min = w:match('<span class="rateinf rateNeg">(%d+)') or 1
		ret = max/(max+min)
		qual = w:match('<div class="quality">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('%&nbsp%;',' ')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix медиаконтент: ' .. name:gsub('%&nbsp%;',' ')
				t[i].Reting = ret*10
				t[i].Qual = qual:gsub(' $','')
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end

	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'collection'

	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

	if stena_filmix then return stena_filmix() end

	if left then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Filmix (' .. #t .. ') ' .. title1 .. ' - стр. ' .. page .. ' из ' .. max,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
--			m_simpleTV.Control.ExecuteAction(37)
			similar_filmix(t[id].Address)
		end
		if ret == 2 then
		if left then
			collection_filmix_url(left)
		else
			run_lite_qt_filmix()
		end
		end
		if ret == 3 then
		if right then
			collection_filmix_url(right)
		end
		end
end

function person_filmix(page)
	page = tonumber(page) or 1
--	if page == nil then page = 1 end
--	m_simpleTV.Control.ExecuteAction(37)
	local title = 'Персоны'
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local url = filmixsite .. '/persons/page/' .. page
	if tonumber(page) == 1 then
		url = filmixsite .. '/persons'
	end
--	if not m_simpleTV.Control.CurrentAdress then
--		m_simpleTV.Control.SetTitle(title)
--	end
	local t,i = {},1
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

		local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nAccept: application/json, text/javascript, */*; q=0.01\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url
		local body = filmixsite .. '/api/notifications/get'
--		local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
--		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
		local rc,answer = m_simpleTV.Http.Request(session,{url = filmixsite .. '/loader.php?do=persons&cstart=' .. page, method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. url})

		if rc ~= 200 then
			return
		end
--		m_simpleTV.Http.Close(session)
		answer = answer:gsub('<br />', ''):gsub('\n', '')
		local title1 = answer:match('<title>(.-)</title>') or ''
		title1 = title1:gsub(' смотреть онлайн','')
		local left,right
		if tonumber(page) > 1 then
			left = tonumber(page) - 1
		end
		if tonumber(page) < 9292 then
			right = tonumber(page) + 1
		end

		for w in answer:gmatch('<article class="persone line shortstory".-</article>') do
		local adr,logo,name,desc
		adr = w:match('<a href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('itemprop="name"><.->(.-)<') or 'noname'
		desc = w:match('<div class="item">(.-)</article>') or ''
		desc = desc:gsub('<.->',''):gsub('%s%s%s%s',' '):gsub('%s%s%s',' '):gsub('%s%s',' ')
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name
				t[i].Address = adr
				if logo:match('/img/none%.png') then logo = 'https://filmix.dog/templates/Filmix/media/img/filmix.png' end
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'persons'
		if right and tonumber(right) <= 9292 then
		m_simpleTV.User.TVPortal.stena_filmix_next = {tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if left and tonumber(left) > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {9292, page}
		title = title .. ' (стр. ' .. page .. ' из ' .. 9292 .. ')'
		m_simpleTV.User.TVPortal.stena_filmix_title = title

	if stena_filmix then return stena_filmix() end

	if left then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (' .. #t .. ') ' .. title1 .. ' - стр. ' .. page,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			person_content_filmix(t[id].Address,1)
		end
		if ret == 2 then
			if left then
				person_filmix(left)
			else
				run_lite_qt_filmix()
			end
		end
		if ret == 3 then
			if right then
				person_filmix(right)
			end
		end
end

function person_content_filmix(url,page)
--	m_simpleTV.Control.ExecuteAction(37)
	local title = 'Персона'
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
--	if not m_simpleTV.Control.CurrentAdress then
--		m_simpleTV.Control.SetTitle(title)
--	end
	local t,i,j = {},1,1
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end

			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = filmixsite, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})

---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then
			return
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		answer = answer:gsub('<br />', ''):gsub('\n', '')
		title = title .. (': ' .. answer:match('<div class="name" itemprop="name">(.-)</div>') or '')
		local logo_person = answer:match('<meta property="og:image" content="(.-)"')

		local desc = answer:match('<div class="full min">.-</div>	</div>') or ''
		desc = desc:gsub('</div>','\n'):gsub('<.->','')
--		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="6.0" src="' .. logo_person .. '"', text = desc, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		local j,t = 1,{}
		for ws in answer:gmatch('<li class="slider%-item">.-</li>') do
		local adr,logo,name = ws:match('href="(.-)".-src="(.-)".-title="(.-)"')
		if not adr or not name then break end
		local year = adr:match('(%d%d%d%d)%.html$')
		if year then year = ', ' .. year else year = '' end
		t[j] = {}
		t[j].Id = j
		t[j].Name = name:gsub('%&nbsp%;',' ') .. year
		t[j].Address = adr
		t[j].InfoPanelLogo = logo:gsub('w140/','w220/')
		t[j].InfoPanelName = 'Filmix: ' .. name:gsub('%&nbsp%;',' ')
		j=j+1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

	if page then
		local all_page = math.ceil(#t/16)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = title .. ' (стр. ' .. page .. ' из ' .. all_page .. ')'
		local t1 = {}
		for i = 1,16 do
			if not t[i + (page-1)*16] then break end
			t1[i] = t[i + (page-1)*16]
		end
		m_simpleTV.User.TVPortal.stena_filmix = t1
		m_simpleTV.User.TVPortal.stena_filmix.type = 'persona'
		if next_pg <= tonumber(all_page) then
		m_simpleTV.User.TVPortal.stena_filmix_next = {url, tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {url, tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {all_page, page, url}
		m_simpleTV.User.TVPortal.stena_filmix_title = title
		m_simpleTV.User.TVPortal.stena_filmix_logo_person = logo_person
		m_simpleTV.User.TVPortal.stena_filmix_desc_person = desc
		if stena_filmix then return stena_filmix() end
	end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Filmix (' .. #t .. ') ' .. title,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
--			m_simpleTV.Control.ExecuteAction(37)
			similar_filmix(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
end

function favorite_filmix(page)
	page = tonumber(page) or 1
--	m_simpleTV.Control.ExecuteAction(37)
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local url = filmixsite.. '/favorites'
	if tonumber(page) > 1 then
		url = filmixsite.. '/favorites/page/' .. page .. '/'
	end
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 12000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end
		if login and password then
			local url1
			if filmixsite:match('filmix%.tech') then
				url1 = filmixsite
			else
				url1 = filmixsite .. '/engine/ajax/user_auth.php'
			end
			local url1 = filmixsite
			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})
		end
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		m_simpleTV.User.TVPortal.stena_filmix.type = 'favorite'
--		debug_in_file(rc .. ' - ' .. answer .. '\n','c://1/testfavorite.txt')
		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
		local t,i = {},1
		local answer1 = answer:match('<div class="line%-block">.-<script') or ''

		for w in answer1:gmatch('<article class="shortstory line".-</article>') do
		local adr,logo,name,desc,max,min,ret,qual
		adr = w:match('itemprop="url" href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
		max = w:match('<span class="rateinf ratePos">(%d+)') or 1
		min = w:match('<span class="rateinf rateNeg">(%d+)') or 1
		ret = max/(max+min)
		qual = w:match('<div class="quality">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('%&nbsp%;',' ')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].Reting = ret*10
				t[i].Qual = qual:gsub(' $','')
--				t[i].Fav = true
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end


		local max = tonumber(page) or 1
		if answer1:match('<a data%-number="%d+') then
		for w1 in answer1:gmatch('<a data%-number="%d+') do
			local get_page = w1:match('<a data%-number="(%d+)')
			if tonumber(get_page) > tonumber(max) then max = get_page end
		end
		end

	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'favorite'

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		if tonumber(next_pg) <= tonumber(max) then
		m_simpleTV.User.TVPortal.stena_filmix_next = {tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if tonumber(prev_pg) > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {max, page}

		local title = 'Избранное (стр. ' .. page .. ' из ' .. max .. ')'

		m_simpleTV.User.TVPortal.stena_filmix_title = title

	if stena_filmix then return stena_filmix() end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Избранное (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
--			m_simpleTV.Control.ExecuteAction(37)
			similar_filmix(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
end

function add_to_favorites(address,action)

	local id = address:match('/(%d+)')
	local action = address:match('%&.-%&(.-)$')
	local address = address:match('(http.-)%&')
--	debug_in_file(id .. ' ' .. action .. ' ' .. address .. '\n','c://1/testfavorite.txt')
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end
	if login and password then
		local url1
		if filmixsite:match('filmix%.tech') then
			url1 = filmixsite
		else
			url1 = filmixsite .. '/engine/ajax/user_auth.php'
		end
		local url1 = filmixsite
		local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})
	end
	rc,answer = m_simpleTV.Http.Request(session,{url = filmixsite .. '/engine/ajax/favorites.php?fav_id=' .. id .. '&action=' .. action .. '&skin=Filmix&alert=0', method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. address .. '\nCookie:' .. m_simpleTV.User.filmix.cookies})
	set_favorites()
	m_simpleTV.User.TVPortal.stena_filmix_need_recall = true
	stena_callback(1)
	m_simpleTV.User.filmix.Favorites = find_in_favorites1(address)
end

function similar_filmix(inAdr)
	if m_simpleTV.User.TVPortal.stena_filmix == nil then m_simpleTV.User.TVPortal.stena_filmix = {} end
	m_simpleTV.User.TVPortal.stena_filmix.current_address = inAdr
--	m_simpleTV.Control.ExecuteAction(37)
	local host = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
		local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then
		tooltip_body = ''
	else
		tooltip_body = 'bgcolor="#182633"'
	end
	---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)
	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end

			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
			if not m_simpleTV.User.filmix.cookies then
				m_simpleTV.User.filmix.cookies = m_simpleTV.Http.GetCookies(session,host)
			end
--			debug_in_file(m_simpleTV.User.filmix.cookies .. '\n','c://1/filmix.txt')
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=inAdr})
		if rc ~= 200 then
			return
		end

	answer = m_simpleTV.Common.multiByteToUTF8(answer)
	answer = answer:gsub('\n', ' ')
	m_simpleTV.User.filmix.Favorites = find_in_favorites1(inAdr)
--------------
	local logo = host .. '/templates/Filmix/media/img/filmix.png'
	local title = answer:match('<h1 class="name" itemprop="name">(.-)</h1>')

	local overview = answer:match('<div class="full%-story">(.-)</div>') or ''
	overview = overview:gsub('<.->','')
	local year = inAdr:match('(%d%d%d%d)%.html$') or answer:match('<a itemprop="copyrightYear".->(.-)</a>')
	if year then year = ', ' .. year else year = '' end
	local poster = answer:match('"og:image" content="([^"]+)') or logo
	local videodesc = show_filmix(answer)

	if filmix_info then return filmix_info() end
	local j,t = 2,{}
	t[1] = {}
	t[1].Id = 1
	t[1].Name = m_simpleTV.User.filmix.Favorites .. '.: info :.'
	t[1].Address = inAdr
	t[1].InfoPanelLogo = poster
	t[1].InfoPanelName =  title .. year
	t[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
	t[1].InfoPanelTitle = overview
	t[1].InfoPanelShowTime = 10000
--------------TabGanres
--	m_simpleTV.Control.ExecuteAction(37)
	local answer_g = answer:match('<span class="label">Жанр:.-</div>') or ''
	local i = 1
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href="(.-)">(.-)</a>')
	if not adr or not name then break end
	t[j] = {}
	t[j].Id = j
	t[j].Name = 'Жанр: ' .. name
	t[j].Address = adr
	j=j+1
	end
--------------TabPerson
	answer_g = answer:match('<span class="label">Режиссер:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href ="(.-)".-"name">(.-)<')
	if not adr or not name then break end
	t[j] = {}
	t[j].Id = j
	t[j].Name = 'Режиссер: ' .. name:gsub('^.+%s%s','')
	t[j].Address = adr
	j=j+1
	end
	answer_g = answer:match('<span class="label">В ролях:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href ="(.-)".-"name">(.-)<')
	if not adr or not name then break end
	t[j] = {}
	t[j].Id = j
	t[j].Name = 'В ролях: ' .. name
	t[j].Address = adr
	j=j+1
	end
--------------TabCollection
	answer_g = answer:match('<span class="label">В подборках:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href="(.-)".-class="pl%-link">(.-)<')
	if not adr or not name then break end
	t[j] = {}
	t[j].Id = j
	t[j].Name = 'Подборка: ' .. name
	t[j].Address = adr
	j=j+1
	end
-------------TabSimilar
	for ws in answer:gmatch('<li class="slider%-item">.-</li>') do
	local adr,logo,name = ws:match('href="(.-)".-src="(.-)".-title="(.-)"')
	if not adr or not name then break end
	local year = adr:match('(%d%d%d%d)%.html$')
	if year then year = ', ' .. year else year = '' end
	t[j] = {}
	t[j].Id = j
	t[j].Name = 'Похожий контент: ' .. name:gsub('%&nbsp%;',' ') .. year
	t[j].Address = adr
	t[j].InfoPanelLogo = logo
	t[j].InfoPanelName = 'Filmix медиаконтент: ' .. name:gsub('%&nbsp%;',' ') .. year
	j=j+1
	end
-------------TabTorrent
	local tor = answer:match('href="(' .. host .. 'download/%d+)">')
	if tor then
	t[j] = {}
	t[j].Id = j
	t[j].Name = 'Filmix torrent'
	t[j].Address = tor .. '&' .. inAdr
	end

--------------

		if not t then return end
		if #t > 0 then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. year, 0, t, 5000, 1 + 4 + 8 + 2)
			if ret == -1 or not id then
				return
			end
			if ret == 1 then
				if id == 1 then
					local action = 'minus'
					if not t[1].Name:match('👀') then action = 'plus' end
					add_to_favorites(t[1].Address,action)
					similar_filmix(t[1].Address)
				else
				if t[id].Name:match('Жанр: ') then
					ganres_content_filmix(t[id].Address)
				elseif t[id].Name:match('В ролях: ') or t[id].Name:match('Режиссер: ') then
					person_content_filmix(t[id].Address)
				elseif t[id].Name:match('Подборка: ') then
					collection_filmix_url(t[id].Address)
				else
					similar_filmix(t[id].Address)
				end
				end
			end
			if ret == 2 then
				run_lite_qt_filmix()
			end
			if ret == 3 then
				stena_clear()
				m_simpleTV.Control.PlayAddressT({address = inAdr})
			end
		end
	end

function search_filmix_medias(page)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local search_ini = getConfigVal('search/media') or ''
	local year = m_simpleTV.Common.fromPercentEncoding(search_ini):match(' %((%d%d%d%d)%)$')
	local title = m_simpleTV.Common.fromPercentEncoding(search_ini):gsub(' %(%d%d%d%d%)$',''):gsub(' %(%)$','')

			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies
			local body
			if year then
			body = 'scf=fx&story=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&search_start=0&do=search&subaction=search&years_ot=' .. tonumber(year)-1 .. '&years_do=' .. tonumber(year)+1 .. '&kpi_ot=1&kpi_do=10&imdb_ot=1&imdb_do=10&sort_name=&undefined=asc&sort_date=&sort_favorite=desc&search_start=' .. page
			else
			body = 'scf=fx&story=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&search_start=0&do=search&subaction=search&years_ot=&years_do=&kpi_ot=&kpi_do=&imdb_ot=&imdb_do=&sort_name=&undefined=asc&sort_date=&sort_favorite=desc&search_start=' .. page
			end
			local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})

--			debug_in_file(rc .. ':\n' .. answer .. '\n','c://1/filmixs.txt')
			local res_count = answer:match('res_count=(%d+)') or 0
					local otvet = answer:match('<article.-<script>') or ''
					local i, t = 1, {}
					for w in otvet:gmatch('<article.-</article>') do
					local desc,max,min,ret,qual
					local logo, name, adr = w:match('<a class="fancybox" href="(.-)".-alt="(.-)".-<a class="watch icon%-play" itemprop="url" href="(.-)"')
					desc = w:match('"description">(.-)<') or ''
					max = w:match('<span class="rateinf ratePos">(%d+)') or 1
					min = w:match('<span class="rateinf rateNeg">(%d+)') or 1
					ret = max/(max+min)
					qual = w:match('<div class="quality">(.-)<') or ''
					if not adr or not name or adr == '' then break end
							t[i] = {}
							t[i].Id = i
							t[i].Address = adr
							t[i].Name = name:gsub('%&nbsp%;',' ')
							t[i].InfoPanelLogo = logo:gsub('/orig/','/thumbs/w220/')
							t[i].InfoPanelName = name:gsub('%&nbsp%;',' ')
							t[i].InfoPanelTitle = desc
							t[i].Reting = ret*10
							t[i].Qual = qual:gsub(' $','')
					i = i + 1
					end

------------------------
	rc, answer = m_simpleTV.Http.Request(session, {body = filmixsite, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'search media'

		local max = math.ceil(tonumber(res_count)/16)

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		if tonumber(next_pg) <= tonumber(max) then
		m_simpleTV.User.TVPortal.stena_filmix_next = {tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if tonumber(prev_pg) > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {max, page}

		m_simpleTV.User.TVPortal.stena_filmix_title = 'Найдено медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (стр. ' .. page .. ' из ' .. max .. ') - ' .. res_count

	stena_filmix()
end

function search_filmix_persons(page)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local search_ini = getConfigVal('search/media') or ''
			local t, i = {}, 1
			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies
			rc, answer = m_simpleTV.Http.Request(session, {url = filmixsite .. '/loader.php?do=persons&search=' .. search_ini, method = 'post', headers = headers})
--					answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
--					debug_in_file(rc .. ':\n' .. answer .. '\n','c://1/filmixs.txt')
					answer = answer:gsub('\n', ' ')

					for w in answer:gmatch('<div class="short">.-</article>') do
					local sim_adr, sim_img, sim_name = w:match('href="(.-)".-img src="(.-)".-<h2 class="name" itemprop="name"><a href=".-">(.-)</a></h2>')
					local desc = w:match('<div class="item">(.-)</article>') or ''
					desc = desc:gsub('<.->',''):gsub('%s%s%s%s',' '):gsub('%s%s%s',' '):gsub('%s%s',' ')
					if not sim_adr or not sim_name then break end
							t[i] = {}
							t[i].Id = i
							t[i].Address = sim_adr
							t[i].Name = sim_name .. ' - Персона'
							t[i].InfoPanelLogo = sim_img
							t[i].InfoPanelName = sim_name
							t[i].InfoPanelTitle = desc
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end

	rc, answer = m_simpleTV.Http.Request(session, {body = filmixurl, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'search persons'

	m_simpleTV.User.TVPortal.stena_filmix_title = 'Найдено персон: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (стр. ' .. page .. ' из ' .. 1 .. ')'

	stena_filmix()
end

function search_filmix_collections(page)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local search_ini = getConfigVal('search/media') or ''
			local t, i = {}, 1
			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies
			rc, answer = m_simpleTV.Http.Request(session, {url = filmixsite .. '/loader.php?do=playlists&sort_filter=rateup&items_only=true&search=' .. search_ini, method = 'post', headers = headers})
--					answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
--					debug_in_file(rc .. ':\n' .. answer .. '\n','c://1/filmixs.txt')
					answer = answer:gsub('\n', ' ')

					for w in answer:gmatch('<div class="short">.-</article>') do
					local sim_adr, sim_img, sim_name = w:match('href="(.-)".-img src="(.-)".-<h3 class="name"><a href=".-">(.-)</a></h3>')
					if sim_img:match('/img/none%.png') then
					sim_img = 'https://filmix.dog/templates/Filmix/media/img/filmix.png'
					end
					local desc = w:match('"description">(.-)<') or ''
					local count = w:match('<div class="count">(%d+)')
					if not sim_adr or not sim_name then break end
						if count and tonumber(count) and tonumber(count) > 0 then
							t[i] = {}
							t[i].Id = i
							t[i].Address = sim_adr
							t[i].Name = sim_name .. ' - Подборка'
							t[i].InfoPanelTitle = desc:gsub('_','')
							t[i].InfoPanelLogo = sim_img
							t[i].InfoPanelName = sim_name
							i = i + 1
						end
					end

	rc, answer = m_simpleTV.Http.Request(session, {body = filmixurl, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)

	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = 'search collections'

	m_simpleTV.User.TVPortal.stena_filmix_title = 'Найдено подборок: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (стр. ' .. page .. ' из ' .. 1 .. ')'

	stena_filmix()
end

function search_filmix_media()
	get_count_for_search()
	if search_filmix_medias then return search_filmix_medias(1) end
------------------------
	local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено Filmix: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ') - ' .. res_count, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t[id].Name:match(' %- Персона') then
				person_content_filmix(t[id].Address, 1)
			elseif t[id].Name:match(' %- Подборка') then
				collection_filmix_url(t[id].Address, 1)
			else
				similar_filmix(t[id].Address)
--				m_simpleTV.Control.ExecuteAction(37)
--				m_simpleTV.Control.PlayAddress(t[id].Address)
			end
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Filmix: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end
if m_simpleTV.User.filmix.cookies and m_simpleTV.User.filmix.cookies:match('dle_user_id') then
	set_favorites()
end