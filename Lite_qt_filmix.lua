--Filmix portal - lite version west_side 14.08.23

	local host = 'https://filmix.ac'
	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
	if not sessionFilmix then return end
	m_simpleTV.Http.SetTimeout(sessionFilmix, 10000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.filmix then
		m_simpleTV.User.filmix = {}
	end

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
	if not login or not password or login == '' or password == '' then
		login = decode64('bWV2YWxpbA')
		password = decode64('bTEyMzQ1Ng')
	end
	local rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
--	debug_in_file(m_simpleTV.User.filmix.cookies .. '\n','c://1/filmix.txt')
	m_simpleTV.User.filmix.cookies = m_simpleTV.Http.GetCookies(sessionFilmix,host)
	m_simpleTV.Http.Close(sessionFilmix)

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

local function show_filmix(answer)
	local masshtab = 0.66
	local rus, orig, poster, kpR, vote_kpR, imdbR, vote_imdbR, reting = '', '', '', '', '', '', '', ''
	rus = answer:match('<h1 class="name" itemprop="name">(.-)</h1>') or ''
	orig = answer:match('<div class="origin%-name" itemprop="alternativeHeadline">(.-)</div>') or ''
	poster = answer:match('<meta property="og%:image" content="(.-)" />')

	kpR, vote_kpR = answer:match('\"Кинопоиск\"\'>.-<p>(.-)</p>.-<p>(.-)</p>')
	imdbR, vote_imdbR = answer:match('\“IMDB\”\'>.-<p>(.-)</p>.-<p>(.-)</p>')
	if kpR and kpR ~= '-' then kpR = math.floor(tonumber(kpR)*10)/10 else kpR = '' end
	if imdbR and imdbR ~= '-' then imdbR = math.floor(tonumber(imdbR)*10)/10 else imdbR = '' end
	if kpR ~= '' then
		reting = reting .. '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuKP.png" height="' .. 24*masshtab .. '" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. kpR .. '.png" height="' .. 24*masshtab .. '" align="top"> ' .. kpR .. ' (' .. vote_kpR .. ')</h5>'
	end
	if imdbR ~= '' then
		reting = reting .. '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuIMDb.png" height="' .. 24*masshtab .. '" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. imdbR .. '.png" height="' .. 24*masshtab .. '" align="top"> ' .. imdbR .. ' (' .. vote_imdbR .. ')</h5>'
	end

	local country = answer:match('<div class="item contry"><span class="label">Страна:</span><span class="item%-content">(.-)</span></div>') or ''
	country = country:gsub('<span><a href=".-">',''):gsub('</a>','')
	country = country:gsub(', ', ','):gsub(',', ', ')
	local year = answer:match('<div class="item year"><span class="label">Год:</span><span class="item%-content"><a itemprop="copyrightYear" href=".-">(.-)</a>') or ''
--------director
	local director = answer:match('<div class="item directors"><span class="label">Режиссер:</span><span class="item%-content">(.-)</span></div>') or ''
	local directors = ''
	if director ~= '' then
		local i, ta = 1, {}
		for w in director:gmatch('<a.-</a>') do
			ta[i] = {}
			ta[i].director_adr, ta[i].director_name = w:match('href ="(.-)".-"name">(.-)<')
			directors = directors .. ', ' .. ta[i].director_name
		end
	else
		directors = ''
	end
--------actors
	local actor = answer:match('<div class="item actors"><span class="label">В ролях:</span><span class="item%-content">(.-)</span></div>') or ''
	local actors = ''
	if actor ~= '' then
		local i, ta = 1, {}
		for w in actor:gmatch('<a.-</a>') do
			ta[i] = {}
			ta[i].actors_adr, ta[i].actors_name = w:match('href ="(.-)".-"name">(.-)<')
			actors = actors .. ', ' .. ta[i].actors_name
		end
	else
		actors = ''
	end
--------genres
	local genre = answer:match('<span class="label">Жанр:</span>.-</div>') or ''
	local genres = ''
	if genre ~= '' then
		local i, ta = 1, {}
		for w in genre:gmatch('<a.-</a>') do
			ta[i] = {}
			ta[i].genre_adr, ta[i].genre_name = w:match('href="(.-)">(.-)</a>')
			genres = genres .. ', ' .. ta[i].genre_name
		end
	else
		genres = ''
	end
--------other
	local description = answer:match('<div class="full%-story">(.-)</div>') or ''

	local slogan = answer:match('<span class="label">Слоган:</span><span class="item%-content">(.-)</span>') or ''
	if slogan ~= '' and slogan ~= '-' then slogan = ' «' .. slogan:gsub('«', ''):gsub('»', '') .. '» ' else slogan = '' end

	local age = answer:match('<span class="label">MPAA:</span><span class="item%-content">(.-)</span>') or '0+'

	local time_all = answer:match('<span class="label">Время:</span><span class="item%-content">(.-)</span>') or ''

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

local function find_in_favorites(address)
	local id = address:match('/(%d+)')
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	local url = filmixsite.. '/favorites'
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
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
				rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
				m_simpleTV.Http.Close(session)
				return '👀 '
			end
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	return ''
end

function run_lite_qt_filmix()
	m_simpleTV.Control.ExecuteAction(37)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/filmix') or ''
	local tt = {
		{"","Персоны"},
		{"filmi","Фильмы"},
		{"seria","Сериалы"},
		{"mults","Мульты"},
		{"multserialy","Мультсериалы"},
		{"https://filmix.ac/playlists/popular","Популярные подборки"},
		{"https://filmix.ac/playlists/films","Подборки фильмов"},
		{"https://filmix.ac/playlists/serials","Подборки сериалов"},
		{"https://filmix.ac/playlists/multfilms","Подборки мультов"},
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
				person_filmix('https://filmix.ac/persons')
			elseif t0[id].Action == 'filmi' or t0[id].Action == 'seria' or t0[id].Action == 'mults' or t0[id].Action == 'multserialy' then
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
		{'https://filmix.ac','Без зеркала'},
		{'https://filmix.gay','https://filmix.gay'},
		{'https://filmix.love','https://filmix.love'},
		{'https://filmix.beer','https://filmix.beer'},
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
	m_simpleTV.Control.ExecuteAction(37)
		local tt = {
		{"https://filmix.gay/filmi/","TOP"},
		{"https://filmix.gay/filmi/animes/","Аниме"},
		{"https://filmix.gay/filmi/biografia/","Биография"},
		{"https://filmix.gay/filmi/boevik/","Боевики"},
		{"https://filmix.gay/filmi/vesterny/","Вестерн"},
		{"https://filmix.gay/filmi/voennyj/","Военный"},
		{"https://filmix.gay/filmi/detektivy/","Детектив"},
		{"https://filmix.gay/filmi/detskij/","Детский"},
		{"https://filmix.gay/filmi/for_adults/","Для взрослых"},
		{"https://filmix.gay/filmi/dokumentalenyj/","Документальные"},
		{"https://filmix.gay/filmi/drama/","Драмы"},
		{"https://filmix.gay/filmi/istoricheskie/","Исторический"},
		{"https://filmix.gay/filmi/komedia/","Комедии"},
		{"https://filmix.gay/filmi/korotkometragka/","Короткометражка"},
		{"https://filmix.gay/filmi/kriminaly/","Криминал"},
		{"https://filmix.gay/filmi/melodrama/","Мелодрамы"},
		{"https://filmix.gay/filmi/mistika/","Мистика"},
		{"https://filmix.gay/filmi/music/","Музыка"},
		{"https://filmix.gay/filmi/muzkl/","Мюзикл"},
		{"https://filmix.gay/filmi/novosti/","Новости"},
		{"https://filmix.gay/filmi/original/","Оригинал"},
		{"https://filmix.gay/filmi/otechestvennye/","Отечественные"},
		{"https://filmix.gay/filmi/tvs/","Передачи с ТВ"},
		{"https://filmix.gay/filmi/prikluchenija/","Приключения"},
		{"https://filmix.gay/filmi/realnoe_tv/","Реальное ТВ"},
		{"https://filmix.gay/filmi/semejnye/","Семейный"},
		{"https://filmix.gay/filmi/sports/","Спорт"},
		{"https://filmix.gay/filmi/tok_show/","Ток-шоу"},
		{"https://filmix.gay/filmi/triller/","Триллеры"},
		{"https://filmix.gay/filmi/uzhasu/","Ужасы"},
		{"https://filmix.gay/filmi/fantastiks/","Фантастика"},
		{"https://filmix.gay/filmi/film_noir/","Фильм-нуар"},
		{"https://filmix.gay/filmi/fjuntezia/","Фэнтези"},
		{"https://filmix.gay/filmi/engl/","На английском"},
		{"https://filmix.gay/filmi/ukraine/","На украинском"},

		{"https://filmix.gay/seria/","TOP"},
		{"https://filmix.gay/seria/animes/s7/","Аниме"},
		{"https://filmix.gay/seria/biografia/s7/","Биография"},
		{"https://filmix.gay/seria/boevik/s7/","Боевики"},
		{"https://filmix.gay/seria/vesterny/s7/","Вестерн"},
		{"https://filmix.gay/seria/voennyj/s7/","Военный"},
		{"https://filmix.gay/seria/detektivy/s7/","Детектив"},
		{"https://filmix.gay/seria/detskij/s7/","Детский"},
		{"https://filmix.gay/seria/for_adults/s7/","Для взрослых"},
		{"https://filmix.gay/seria/dokumentalenyj/s7/","Документальные"},
		{"https://filmix.gay/seria/dorama/s7/","Дорамы"},
		{"https://filmix.gay/seria/drama/s7/","Драмы"},
		{"https://filmix.gay/seria/game/s7/","Игра"},
		{"https://filmix.gay/seria/istoricheskie/s7/","Исторический"},
		{"https://filmix.gay/seria/komedia/s7/","Комедии"},
		{"https://filmix.gay/seria/kriminaly/s7/","Криминал"},
		{"https://filmix.gay/seria/melodrama/s7/","Мелодрамы"},
		{"https://filmix.gay/seria/mistika/s7/","Мистика"},
		{"https://filmix.gay/seria/music/s7/","Музыка"},
		{"https://filmix.gay/seria/muzkl/s7/","Мюзикл"},
		{"https://filmix.gay/seria/novosti/s7/","Новости"},
		{"https://filmix.gay/seria/original/s7/","Оригинал"},
		{"https://filmix.gay/seria/otechestvennye/s7/","Отечественные"},
		{"https://filmix.gay/seria/tvs/s7/","Передачи с ТВ"},
		{"https://filmix.gay/seria/prikluchenija/s7/","Приключения"},
		{"https://filmix.gay/seria/realnoe_tv/s7/","Реальное ТВ"},
		{"https://filmix.gay/seria/semejnye/s7/","Семейный"},
		{"https://filmix.gay/seria/sitcom/s7/","Ситком"},
		{"https://filmix.gay/seria/sports/s7/","Спорт"},
		{"https://filmix.gay/seria/tok_show/s7/","Ток-шоу"},
		{"https://filmix.gay/seria/triller/s7/","Триллеры"},
		{"https://filmix.gay/seria/uzhasu/s7/","Ужасы"},
		{"https://filmix.gay/seria/fantastiks/s7/","Фантастика"},
		{"https://filmix.gay/seria/fjuntezia/s7/","Фэнтези"},
		{"https://filmix.gay/seria/engl/s7/","На английском"},
		{"https://filmix.gay/seria/ukraine/s7/","На украинском"},

		{"https://filmix.gay/mults/","TOP"},
		{"https://filmix.gay/mults/animes/s14/","Аниме"},
		{"https://filmix.gay/mults/biografia/s14/","Биография"},
		{"https://filmix.gay/mults/boevik/s14/","Боевики"},
		{"https://filmix.gay/mults/vesterny/s14/","Вестерн"},
		{"https://filmix.gay/mults/voennyj/s14/","Военный"},
		{"https://filmix.gay/mults/detektivy/s14/","Детектив"},
		{"https://filmix.gay/mults/detskij/s14/","Детский"},
		{"https://filmix.gay/mults/for_adults/s14/","Для взрослых"},
		{"https://filmix.gay/mults/dokumentalenyj/s14/","Документальные"},
		{"https://filmix.gay/mults/drama/s14/","Драмы"},
		{"https://filmix.gay/mults/istoricheskie/s14/","Исторический"},
		{"https://filmix.gay/mults/komedia/s14/","Комедии"},
		{"https://filmix.gay/mults/kriminaly/s14/","Криминал"},
		{"https://filmix.gay/mults/melodrama/s14/","Мелодрамы"},
		{"https://filmix.gay/mults/mistika/s14/","Мистика"},
		{"https://filmix.gay/mults/music/s14/","Музыка"},
		{"https://filmix.gay/mults/muzkl/s14/","Мюзикл"},
		{"https://filmix.gay/mults/original/s14/","Оригинал"},
		{"https://filmix.gay/mults/otechestvennye/s14/","Отечественные"},
		{"https://filmix.gay/mults/prikluchenija/s14/","Приключения"},
		{"https://filmix.gay/mults/semejnye/s14/","Семейный"},
		{"https://filmix.gay/mults/sports/s14/","Спорт"},
		{"https://filmix.gay/mults/triller/s14/","Триллеры"},
		{"https://filmix.gay/mults/uzhasu/s14/","Ужасы"},
		{"https://filmix.gay/mults/fantastiks/s14/","Фантастика"},
		{"https://filmix.gay/mults/fjuntezia/s14/","Фэнтези"},
		{"https://filmix.gay/mults/engl/s14/","На английском"},
		{"https://filmix.gay/mults/ukraine/s14/","На украинском"},

		{"https://filmix.gay/multserialy/","TOP"},
		}

	local ganre1,ganre2,ganre3,ganre4,k1,k2,k3 = {},{},{},{},1,1,1
	for k = 1,#tt do
		if tt[k][1]:match('/filmi/') then
			ganre1[k1] = {}
			ganre1[k1].Id = k1
			ganre1[k1].Address = tt[k][1]
			ganre1[k1].Name = tt[k][2]
			k1 = k1 + 1
		end
		if tt[k][1]:match('/seria/') then
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
		if tt[k][1]:match('/multserialy/') then
			ganre4[1] = {}
			ganre4[1].Id = 1
			ganre4[1].Address = tt[k][1]
			ganre4[1].Name = tt[k][2]
		end
		k = k + 1
	end

	local title,ganre = '',{}

	if con == 'filmi' then title = 'Кино' ganre = ganre1
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
	m_simpleTV.Control.ExecuteAction(37)
	local title
	if url:match('filmi/') then title = 'Кино'
	elseif url:match('seria/') then title = 'Сериалы'
	elseif url:match('multserialy/') then title = 'Мультсериалы'
	elseif url:match('mults/') then title = 'Мульты'
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
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
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
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
		local adr,logo,name,desc
		adr = w:match('itemprop="url" href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('%&nbsp%;',' ')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
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
	change_page('Watch',sim,t,title,title1)
end

function collection_filmix(url)
	m_simpleTV.Control.ExecuteAction(37)
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
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
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
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
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

function collection_filmix_url(url)
	m_simpleTV.Control.ExecuteAction(37)
	local title = 'Коллекция'
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')

	local page = url:match('/page/(%d+)/') or 1
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t,i,j = {},1,1
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
	local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = filmixsite, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})


	m_simpleTV.Http.SetTimeout(session, 8000)

	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end

		local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nAccept: application/json, text/javascript, */*; q=0.01\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url
		local body = filmixsite .. '/api/notifications/get'
		local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
		if rc ~= 200 then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/0.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/1.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/2.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/3.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/4.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/5.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/6.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
		end
--		m_simpleTV.Http.Close(session)
		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
		answer = answer:gsub('<br />', ''):gsub('\n', '')
		local title1 = answer:match('<title>(.-)</title>') or ''
		title1 = title1:gsub(' смотреть онлайн','')
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
		local adr,logo,name,desc
		adr = w:match('itemprop="url" href="(.-)"') or ''
		logo = w:match('<img src="(.-)"') or ''
		name = w:match('alt="(.-)"') or 'noname'
		desc = w:match('"description">(.-)<') or ''
			if not adr or not name or adr == '' then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('%&nbsp%;',' ')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix медиаконтент: ' .. name:gsub('%&nbsp%;',' ')
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
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
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Filmix (' .. #t .. ') ' .. title1 .. ' - стр. ' .. page,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
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

function person_filmix(url)
	m_simpleTV.Control.ExecuteAction(37)
	local title = 'Персоны'
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
	local page = url:match('/page/(%d+)/') or 1

	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t,i = {},1
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end

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
			left = url:gsub('/page/%d+/', '/page/' .. tonumber(page) - 1 .. '/')
		end
		if tonumber(page) < 9292 then
			right = url:gsub('/page/%d+/', '/page/' .. tonumber(page) + 1 .. '/')
		end
		if tonumber(page) == 1 then
			right = url .. '/page/2/'
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
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
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
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (' .. #t .. ') ' .. title1 .. ' - стр. ' .. page,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			person_content_filmix(t[id].Address)
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

function person_content_filmix(url)
	m_simpleTV.Control.ExecuteAction(37)
	local title = 'Персона'
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t,i,j = {},1,1
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
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
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="6.0" src="' .. logo_person .. '"', text = desc, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
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
		t[j].InfoPanelLogo = logo
		t[j].InfoPanelName = 'Filmix: ' .. name:gsub('%&nbsp%;',' ')
		j=j+1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Filmix (' .. #t .. ') ' .. title,0,t,10000,1+4+8+2)
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
end

function favorite_filmix()
	m_simpleTV.Control.ExecuteAction(37)
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	local url = 'https://filmix.ac/favorites'

---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
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
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('%&nbsp%;',' ')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix медиаконтент: ' .. name:gsub('%&nbsp%;',' ')
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = 'https://filmix.ac/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Filmix favorites (' .. #t .. ')',0,t,10000,1+4+8+2)
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
end

local function add_to_favorites(address,action)
	local id = address:match('/(%d+)')
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
	if not login or not password or login == '' or password == '' then
		login = decode64('bWV2YWxpbA')
		password = decode64('bTEyMzQ1Ng')
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
	rc,answer = m_simpleTV.Http.Request(session,{url = 'https://filmix.ac/engine/ajax/favorites.php?fav_id=' .. id .. '&action=' .. action .. '&skin=Filmix&alert=0', method = 'get', headers = 'Content-Type: text/html; charset=utf-8\nX-Requested-With: XMLHttpRequest\nMozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36\nReferer: ' .. address .. '\nCookie:' .. m_simpleTV.User.filmix.cookies})
	m_simpleTV.User.filmix.Favorites = find_in_favorites(address)
end

function similar_filmix(inAdr)
	m_simpleTV.Control.ExecuteAction(37)
	local host = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
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
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
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
	m_simpleTV.User.filmix.Favorites = find_in_favorites(inAdr)
--------------
	local logo = 'https://filmix.ac/templates/Filmix/media/img/filmix.png'
	local title = answer:match('<h1 class="name" itemprop="name">(.-)</h1>')

	local overview = answer:match('<div class="full%-story">(.-)</div>') or ''
	overview = overview:gsub('<.->','')
	local year = inAdr:match('(%d%d%d%d)%.html$') or answer:match('<a itemprop="copyrightYear".->(.-)</a>')
	if year then year = ', ' .. year else year = '' end
	local poster = answer:match('"og:image" content="([^"]+)') or logo
	local videodesc = show_filmix(answer)
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
	local answer_g = answer:match('<span class="label">Жанр:.-</div>') or ''
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
	local adr,name = ws:match('href="(.-)".-title="(.-)"')
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
				m_simpleTV.Control.ExecuteAction(37)
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
				m_simpleTV.Control.PlayAddressT({address = inAdr})
			end
		end
	end