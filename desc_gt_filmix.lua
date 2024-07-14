--Filmix desc west_side 01.07.24

local function Get_rating(rating)
	if rating == nil or rating == '' then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

local function ARGB(A,R,G,B)
   local a = A*256*256*256+R*256*256+G*256+B
   if A<128 then return a end
   return a - 4294967296
end

local function Get_length(str)
	return m_simpleTV.Common.lenUTF8(str)
end

local function find_in_favorites2(adr)
	local id = adr:match('/(%d+)')
	if id == nil then return false end
	if m_simpleTV.User.TVPortal.stena_filmix_favorite_str and m_simpleTV.User.TVPortal.stena_filmix_favorite_str:match(' ' .. id .. ' ') then
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

local function get_request(url)
--	m_simpleTV.User.TVPortal.stena_filmix.cur_actors_logo = nil
--	m_simpleTV.User.TVPortal.stena_filmix.cur_actors_desc = nil
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.biz'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)

	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
		login = decode64('TWluaW9uc1RW')
		password = decode64('cXdlcnZjeHo=')
		end

			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = filmixsite, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})
--		debug_in_file(answer .. '\n','c://1/filmix2.txt')
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then
			return
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		answer = answer:gsub('<br />', ''):gsub('\n', '')

		local logo_person = answer:match('<meta property="og:image" content="(.-)"')
		local desc_person = answer:match('<div class="full min">.-</div>	</div>') or ''
		desc_person = desc_person:gsub('</div>','\n'):gsub('<.->','')
			rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite .. '/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
			m_simpleTV.Http.Close(session)
		m_simpleTV.User.TVPortal.stena_filmix.cur_actors_logo = logo_person
		m_simpleTV.User.TVPortal.stena_filmix.cur_actors_desc = desc_person
end

local function get_cat_item_for_url(url)

-- films
		local tt1 = {
		{"https://filmix.biz/films/","Все"},
		{"https://filmix.biz/films/animes/","Аниме"},
		{"https://filmix.biz/films/biografia/","Биография"},
		{"https://filmix.biz/films/boevik/","Боевики"},
		{"https://filmix.biz/films/vesterny/","Вестерн"},
		{"https://filmix.biz/films/voennyj/","Военный"},
		{"https://filmix.biz/films/detektivy/","Детектив"},
		{"https://filmix.biz/films/detskij/","Детский"},
		{"https://filmix.biz/films/for_adults/","Для взрослых"},
		{"https://filmix.biz/films/dokumentalenyj/","Документальные"},
		{"https://filmix.biz/films/drama/","Драмы"},
		{"https://filmix.biz/films/istoricheskie/","Исторический"},
		{"https://filmix.biz/films/komedia/","Комедии"},
		{"https://filmix.biz/films/korotkometragka/","Короткометражка"},
		{"https://filmix.biz/films/kriminaly/","Криминал"},
		{"https://filmix.biz/films/melodrama/","Мелодрамы"},
		{"https://filmix.biz/films/mistika/","Мистика"},
		{"https://filmix.biz/films/music/","Музыка"},
		{"https://filmix.biz/films/muzkl/","Мюзикл"},
		{"https://filmix.biz/films/novosti/","Новости"},
		{"https://filmix.biz/films/original/","Оригинал"},
		{"https://filmix.biz/films/otechestvennye/","Отечественные"},
		{"https://filmix.biz/films/tvs/","Передачи с ТВ"},
		{"https://filmix.biz/films/prikluchenija/","Приключения"},
		{"https://filmix.biz/films/realnoe_tv/","Реальное ТВ"},
		{"https://filmix.biz/films/semejnye/","Семейный"},
		{"https://filmix.biz/films/sports/","Спорт"},
		{"https://filmix.biz/films/tok_show/","Ток-шоу"},
		{"https://filmix.biz/films/triller/","Триллеры"},
		{"https://filmix.biz/films/uzhasu/","Ужасы"},
		{"https://filmix.biz/films/fantastiks/","Фантастика"},
		{"https://filmix.biz/films/film_noir/","Фильм-нуар"},
		{"https://filmix.biz/films/fjuntezia/","Фэнтези"},
		{"https://filmix.biz/films/engl/","На английском"},
		{"https://filmix.biz/films/ukraine/","На украинском"},
		{"https://filmix.biz/films/c6/","Русские"},
		{"https://filmix.biz/films/c64/","Советские"},
		{"https://filmix.biz/films/y2024/","2024"},
		{"https://filmix.biz/films/y2023/","2023"},
		{"https://filmix.biz/films/q4/","4K (PRO, PRO+)"},
		}
-- serials
		local tt2 = {
		{"https://filmix.biz/seria/","Все"},
		{"https://filmix.biz/seria/animes/s7/","Аниме"},
		{"https://filmix.biz/seria/biografia/s7/","Биография"},
		{"https://filmix.biz/seria/boevik/s7/","Боевики"},
		{"https://filmix.biz/seria/vesterny/s7/","Вестерн"},
		{"https://filmix.biz/seria/voennyj/s7/","Военный"},
		{"https://filmix.biz/seria/detektivy/s7/","Детектив"},
		{"https://filmix.biz/seria/detskij/s7/","Детский"},
		{"https://filmix.biz/seria/for_adults/s7/","Для взрослых"},
		{"https://filmix.biz/seria/dokumentalenyj/s7/","Документальные"},
		{"https://filmix.biz/seria/dorama/s7/","Дорамы"},
		{"https://filmix.biz/seria/drama/s7/","Драмы"},
		{"https://filmix.biz/seria/game/s7/","Игра"},
		{"https://filmix.biz/seria/istoricheskie/s7/","Исторический"},
		{"https://filmix.biz/seria/komedia/s7/","Комедии"},
		{"https://filmix.biz/seria/kriminaly/s7/","Криминал"},
		{"https://filmix.biz/seria/melodrama/s7/","Мелодрамы"},
		{"https://filmix.biz/seria/mistika/s7/","Мистика"},
		{"https://filmix.biz/seria/music/s7/","Музыка"},
		{"https://filmix.biz/seria/muzkl/s7/","Мюзикл"},
		{"https://filmix.biz/seria/novosti/s7/","Новости"},
		{"https://filmix.biz/seria/original/s7/","Оригинал"},
		{"https://filmix.biz/seria/otechestvennye/s7/","Отечественные"},
		{"https://filmix.biz/seria/tvs/s7/","Передачи с ТВ"},
		{"https://filmix.biz/seria/prikluchenija/s7/","Приключения"},
		{"https://filmix.biz/seria/realnoe_tv/s7/","Реальное ТВ"},
		{"https://filmix.biz/seria/semejnye/s7/","Семейный"},
		{"https://filmix.biz/seria/sitcom/s7/","Ситком"},
		{"https://filmix.biz/seria/sports/s7/","Спорт"},
		{"https://filmix.biz/seria/tok_show/s7/","Ток-шоу"},
		{"https://filmix.biz/seria/triller/s7/","Триллеры"},
		{"https://filmix.biz/seria/uzhasu/s7/","Ужасы"},
		{"https://filmix.biz/seria/fantastiks/s7/","Фантастика"},
		{"https://filmix.biz/seria/fjuntezia/s7/","Фэнтези"},
		{"https://filmix.biz/seria/ukraine/s7/","На украинском"},
		{"https://filmix.biz/series/c6/","Русские"},
		{"https://filmix.biz/series/c64/","Советские"},
		{"https://filmix.biz/series/y2024/","2024"},
		{"https://filmix.biz/top250s/","TOP сериалы Filmix"},
		{"https://filmix.biz/series/q4/","4K (PRO, PRO+)"},
		}

		local tt3 = {
		{"https://filmix.biz/mults/","Все"},
		{"https://filmix.biz/mults/animes/s14/","Аниме"},
		{"https://filmix.biz/mults/biografia/s14/","Биография"},
		{"https://filmix.biz/mults/boevik/s14/","Боевики"},
		{"https://filmix.biz/mults/vesterny/s14/","Вестерн"},
		{"https://filmix.biz/mults/voennyj/s14/","Военный"},
		{"https://filmix.biz/mults/detektivy/s14/","Детектив"},
		{"https://filmix.biz/mults/detskij/s14/","Детский"},
		{"https://filmix.biz/mults/for_adults/s14/","Для взрослых"},
		{"https://filmix.biz/mults/dokumentalenyj/s14/","Документальные"},
		{"https://filmix.biz/mults/drama/s14/","Драмы"},
		{"https://filmix.biz/mults/istoricheskie/s14/","Исторический"},
		{"https://filmix.biz/mults/komedia/s14/","Комедии"},
		{"https://filmix.biz/mults/kriminaly/s14/","Криминал"},
		{"https://filmix.biz/mults/melodrama/s14/","Мелодрамы"},
		{"https://filmix.biz/mults/mistika/s14/","Мистика"},
		{"https://filmix.biz/mults/music/s14/","Музыка"},
		{"https://filmix.biz/mults/muzkl/s14/","Мюзикл"},
		{"https://filmix.biz/mults/original/s14/","Оригинал"},
		{"https://filmix.biz/mults/otechestvennye/s14/","Отечественные"},
		{"https://filmix.biz/mults/prikluchenija/s14/","Приключения"},
		{"https://filmix.biz/mults/semejnye/s14/","Семейный"},
		{"https://filmix.biz/mults/sports/s14/","Спорт"},
		{"https://filmix.biz/mults/triller/s14/","Триллеры"},
		{"https://filmix.biz/mults/uzhasu/s14/","Ужасы"},
		{"https://filmix.biz/mults/fantastiks/s14/","Фантастика"},
		{"https://filmix.biz/mults/fjuntezia/s14/","Фэнтези"},
		{"https://filmix.biz/mults/engl/s14/","На английском"},
		{"https://filmix.biz/mults/ukraine/s14/","На украинском"},
		{"https://filmix.biz/mults/c6/","Русские"},
		{"https://filmix.biz/mults/c64/","Советские"},
		{"https://filmix.biz/mults/y2024/","2024"},
		{"https://filmix.biz/mults/y2023/","2023"},
		{"https://filmix.biz/mults/y2022/","2022"},
		{"https://filmix.biz/mults/y2021/","2021"},
		{"https://filmix.biz/mults/y2021/","2020"},
		{"https://filmix.biz/mults/y2021/","2019"},
		{"https://filmix.biz/mults/y2021/","2018"},
		{"https://filmix.biz/top250m/","TOP мульты Filmix"},
		{"https://filmix.biz/mults/q4/","4K (PRO, PRO+)"},
		}

		local tt4 = {
		{"https://filmix.biz/multseries/","Все"},
		{"https://filmix.biz/multseries/animes/s93/","Аниме"},
		{"https://filmix.biz/multseries/biografia/s93/","Биография"},
		{"https://filmix.biz/multseries/boevik/s93/","Боевики"},
		{"https://filmix.biz/multseries/vesterny/s93/","Вестерн"},
		{"https://filmix.biz/multseries/voennyj/s93/","Военный"},
		{"https://filmix.biz/multseries/detektivy/s93/","Детектив"},
		{"https://filmix.biz/multseries/detskij/s93/","Детский"},
		{"https://filmix.biz/multseries/for_adults/s93/","Для взрослых"},
		{"https://filmix.biz/multseries/dokumentalenyj/s93/","Документальные"},
		{"https://filmix.biz/multseries/dorama/s93/","Дорамы"},
		{"https://filmix.biz/multseries/drama/s93/","Драмы"},
		{"https://filmix.biz/multseries/istoricheskie/s93/","Исторический"},
		{"https://filmix.biz/multseries/komedia/s93/","Комедии"},
		{"https://filmix.biz/multseries/kriminaly/s93/","Криминал"},
		{"https://filmix.biz/multseries/melodrama/s93/","Мелодрамы"},
		{"https://filmix.biz/multseries/mistika/s93/","Мистика"},
		{"https://filmix.biz/multseries/music/s93/","Музыка"},
		{"https://filmix.biz/multseries/muzkl/s93/","Мюзикл"},
		{"https://filmix.biz/multseries/otechestvennye/s93/","Отечественные"},
		{"https://filmix.biz/multseries/tvs/s93/","Передачи с ТВ"},
		{"https://filmix.biz/multseries/prikluchenija/s93/","Приключения"},
		{"https://filmix.biz/multseries/semejnye/s93/","Семейный"},
		{"https://filmix.biz/multseries/sitcom/s93/","Ситком"},
		{"https://filmix.biz/multseries/sports/s93/","Спорт"},
		{"https://filmix.biz/multseries/triller/s93/","Триллеры"},
		{"https://filmix.biz/multseries/uzhasu/s93/","Ужасы"},
		{"https://filmix.biz/multseries/fantastiks/s93/","Фантастика"},
		{"https://filmix.biz/multseries/fjuntezia/s93/","Фэнтези"},
		{"https://filmix.biz/multseries/ukraine/s93/","На украинском"},
		{"https://filmix.biz/multseries/c6/","Русские"},
		{"https://filmix.biz/multseries/c64/","Советские"},
		{"https://filmix.biz/multseries/y2024/","2024"},
		{"https://filmix.biz/multseries/y2023/","2023"},
		{"https://filmix.biz/multseries/y2022/","2022"},
		{"https://filmix.biz/multseries/y2021/","2021"},
		{"https://filmix.biz/multseries/y2020/","2020"},
		{"https://filmix.biz/multseries/y2019/","2019"},
		{"https://filmix.biz/multseries/y2018/","2018"},
		{"https://filmix.biz/multseries/q4/","4K (PRO, PRO+)"},
		}

		for i = 1,#tt1 do
			if tt1[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/','') then
				return 'film',i
			end
		end
		for i = 1,#tt2 do
			if tt2[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/',''):gsub('series/','seria/') then
				return 'serial',i
			end
		end
		for i = 1,#tt3 do
			if tt3[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/',''):gsub('multes/','mults/') then
				return 'mult',i
			end
		end
		for i = 1,#tt4 do
			if tt4[i][1]:gsub('^http.-//.-/','') == url:gsub('^http.-//.-/','') then
				return 'multserial',i
			end
		end
end

function Get_filmix_stena_info(cat, item, page)

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

	local url, cat_name, item_name
	if m_simpleTV.User.TVPortal.stena_filmix == nil then m_simpleTV.User.TVPortal.stena_filmix = {} end
	if cat == 'film' then
		cat_name = 'Фильмы: '
		url = tt1[tonumber(item)][1]
		item_name = tt1[tonumber(item)][2]
	elseif cat == 'serial' then
		cat_name = 'Сериалы: '
		url = tt2[tonumber(item)][1]
		item_name = tt2[tonumber(item)][2]
	elseif cat == 'mult' then
		cat_name = 'Мультфильмы: '
		url = tt3[tonumber(item)][1]
		item_name = tt3[tonumber(item)][2]
	elseif cat == 'multserial' then
		cat_name = 'Мультсериалы: '
		url = tt4[tonumber(item)][1]
		item_name = tt4[tonumber(item)][2]
	end
	m_simpleTV.User.TVPortal.stena_filmix_genres_name = item_name
	if tonumber(page) > 1 then
		if url:match('/top250') then
			url = url .. 'page/' .. page .. '/'
		else
			url = url .. 'pages/' .. page
		end
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.fm'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
---------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
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
			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite .. '\nCookie:' .. m_simpleTV.User.filmix.cookies})
		end
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then
			return
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
--		debug_in_file(answer .. '\n','c://1/filmix1.txt')
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
		m_simpleTV.User.TVPortal.stena_filmix_next = {cat, item, tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_next = nil
		end
		if tonumber(prev_pg) > 0 then
		m_simpleTV.User.TVPortal.stena_filmix_prev = {cat, item, tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_filmix_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_filmix_page = {max, page, cat, item}

		m_simpleTV.User.TVPortal.stena_filmix_title = cat_name .. m_simpleTV.User.TVPortal.stena_filmix_genres_name .. ' (стр. ' .. page .. ' из '  .. max .. ')'

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
				t[i].Reting = ret*10
				t[i].Qual = qual:gsub(' $','')
--				t[i].Fav = find_in_favorites2(adr)
--				t[i].Fav = true
			i = i + 1
		end
	m_simpleTV.User.TVPortal.stena_filmix = t
	m_simpleTV.User.TVPortal.stena_filmix.type = cat



	rc, answer = m_simpleTV.Http.Request(session, {body = url, url = filmixsite ..'/api/notifications/get', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url .. '\nCookie:' .. m_simpleTV.User.filmix.cookies })
	m_simpleTV.Http.Close(session)
	stena_filmix()
end

function stena_filmix()
	if m_simpleTV.User.TVPortal.stena_filmix == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_filmix_use = true
				m_simpleTV.OSD.RemoveElement('ID_DIV_1')
				m_simpleTV.OSD.RemoveElement('ID_DIV_2')
				m_simpleTV.OSD.RemoveElement('STENA_FILMIX_FOR_PERSONA_IMG_ID')
				m_simpleTV.OSD.RemoveElement('STENA_FILMIX_FOR_PERSONA_TXT_ID')

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
				 t.text = m_simpleTV.User.TVPortal.stena_filmix_title
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = "Segoe UI Black"
				 t.textparam = 0x00000001
				 t.boundWidth = 15 -- bound to screen
				 t.row_limit=1 -- row limit
				 t.scrollTime = 20 --for ticker (auto scrolling text)
				 t.scrollFactor = 4
				 t.text_elidemode = 2
				 t.scrollWaitStart = 40
				 t.scrollWaitEnd = 100
				 t.left = 0
				 t.top  = 100
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_MOVIE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/movie.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 90
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'film' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'movie_genres_filmix1'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_TV_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tv.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 170
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'serial' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'tv_genres_filmix1'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_MULT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/mult.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 250
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'mult' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'mult_genres_filmix1'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_MULTSERIAL_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/multserial.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 330
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'multserial' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'multserial_genres_filmix1'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_COLLECTIONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 410
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_filmix_collections'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_PERSONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/persons.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 490
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'person_filmix'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_FAVORITE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/ratingStarFull.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 570
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'favorite' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'favorite_filmix'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_AVATAR_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.filmix.avatar
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 820
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_AVATAR_TXT_ID'
				t.cx=0
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.filmix.pro
				t.color = ARGB(255 ,152, 251, 152)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.boundWidth = 15
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 900
			    t.top  = 180
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_SEARCH_IMG_ID'
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
				t.id = 'STENA_SEARCH_CONTENT_FILMIX_IMG_ID'
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
				t.mousePressEventFunction = 'search_filmix_media'
				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena_filmix_page then
				t = {}
				t.id = 'STENA_FILMIX_SELECT_PAGE_IMG_ID'
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
				t.mousePressEventFunction = 'select_filmix_page'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_filmix_prev then
				t = {}
				t.id = 'STENA_FILMIX_PREV_IMG_ID'
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
				t.mousePressEventFunction = 'stena_filmix_prev'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_filmix_next then
				t = {}
				t.id = 'STENA_FILMIX_NEXT_IMG_ID'
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
				t.mousePressEventFunction = 'stena_filmix_next'
				AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_FILMIX_CLEAR_IMG_ID'
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
		{"https://filmix.fm/mults/y2021/","2020"},
		{"https://filmix.fm/mults/y2021/","2019"},
		{"https://filmix.fm/mults/y2021/","2018"},
		{"https://filmix.fm/mults/q4/","4K (PRO, PRO+)"},
		}

				if m_simpleTV.User.TVPortal.stena_filmix.type == 'film' then
				for j=1,#tt1 do
					local dx = 1920/8
					local dy = 160/5
					local nx = j - (math.ceil(j/8) - 1)*8
					local ny = math.ceil(j/8)
					 t={}
					 t.id = 'TEXT_MOVIE_GENRES_FILMIX_' .. j .. '_ID'
					 t.cx=200
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. tt1[j][2] .. ' '
					 if m_simpleTV.User.TVPortal.stena_filmix_genres_name == tt1[j][2] then
					 t.color = ARGB(255, 255, 215, 0)
					 else
					 t.color = ARGB(255, 192, 192, 192)
					 end
					 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0
					 t.left = nx*dx - 220
					 t.top  = ny*dy + 210
					 t.glow = 1.2
					 t.glowcolor = 0xFF000077
					 t.borderwidth = 1
					 t.backroundcorner = 2*2
					 t.isInteractive = true
					 t.color_UnderMouse = ARGB(255, 255, 215, 0)
					 t.glowcolor_UnderMouse = 0xFF0000FF
					 t.glow_samples_UnderMouse = 2
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xBB4169E1
					 t.backcolor1_UnderMouse = 0xBB00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'movie_genres_filmix' .. j
					 AddElement(t,'ID_DIV_STENA_1')
				end
				end

				if m_simpleTV.User.TVPortal.stena_filmix.type == 'serial' then
				for j=1,#tt2 do
					local dx = 1920/8
					local dy = 160/5
					local nx = j - (math.ceil(j/8) - 1)*8
					local ny = math.ceil(j/8)
					 t={}
					 t.id = 'TEXT_TV_GENRES_FILMIX_' .. j .. '_ID'
					 t.cx=200
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. tt2[j][2] .. ' '
					 if m_simpleTV.User.TVPortal.stena_filmix_genres_name == tt2[j][2] then
					 t.color = ARGB(255, 255, 215, 0)
					 else
					 t.color = ARGB(255, 192, 192, 192)
					 end
					 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0
					 t.left = nx*dx - 220
					 t.top  = ny*dy + 210
					 t.glow = 2
					 t.glowcolor = 0xFF000077
					 t.borderwidth = 1
					 t.backroundcorner = 2*2
					 t.isInteractive = true
					 t.color_UnderMouse = ARGB(255, 255, 215, 0)
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xBB4169E1
					 t.backcolor1_UnderMouse = 0xBB00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'tv_genres_filmix' .. j
					 AddElement(t,'ID_DIV_STENA_1')
				end
				end

				if m_simpleTV.User.TVPortal.stena_filmix.type == 'mult' then
				for j=1,#tt3 do
					local dx = 1920/8
					local dy = 160/5
					local nx = j - (math.ceil(j/8) - 1)*8
					local ny = math.ceil(j/8)
					 t={}
					 t.id = 'TEXT_MULT_GENRES_FILMIX_' .. j .. '_ID'
					 t.cx=200
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. tt3[j][2] .. ' '
					 if m_simpleTV.User.TVPortal.stena_filmix_genres_name == tt3[j][2] then
					 t.color = ARGB(255, 255, 215, 0)
					 else
					 t.color = ARGB(255, 192, 192, 192)
					 end
					 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0
					 t.left = nx*dx - 220
					 t.top  = ny*dy + 210
					 t.glow = 2
					 t.glowcolor = 0xFF000077
					 t.borderwidth = 1
					 t.backroundcorner = 2*2
					 t.isInteractive = true
					 t.color_UnderMouse = ARGB(255, 255, 215, 0)
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xBB4169E1
					 t.backcolor1_UnderMouse = 0xBB00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'mult_genres_filmix' .. j
					 AddElement(t,'ID_DIV_STENA_1')
				end
				end

				if m_simpleTV.User.TVPortal.stena_filmix.type == 'multserial' then
				for j=1,#tt4 do
					local dx = 1920/8
					local dy = 160/5
					local nx = j - (math.ceil(j/8) - 1)*8
					local ny = math.ceil(j/8)
					 t={}
					 t.id = 'TEXT_MULT_GENRES_FILMIX_' .. j .. '_ID'
					 t.cx=200
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. tt4[j][2] .. ' '
					 if m_simpleTV.User.TVPortal.stena_filmix_genres_name == tt4[j][2] then
					 t.color = ARGB(255, 255, 215, 0)
					 else
					 t.color = ARGB(255, 192, 192, 192)
					 end
					 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0
					 t.left = nx*dx - 220
					 t.top  = ny*dy + 210
					 t.glow = 2
					 t.glowcolor = 0xFF000077
					 t.borderwidth = 1
					 t.backroundcorner = 2*2
					 t.isInteractive = true
					 t.color_UnderMouse = ARGB(255, 255, 215, 0)
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xBB4169E1
					 t.backcolor1_UnderMouse = 0xBB00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'multserial_genres_filmix' .. j
					 AddElement(t,'ID_DIV_STENA_1')
				end
				end

			if m_simpleTV.User.TVPortal.stena_filmix.type == 'persona' then
				t = {}
				t.id = 'STENA_FILMIX_PERSONA_IMG_ID'
				t.cx=110
				t.cy=165
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_filmix_logo_person
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 450
			    t.top  = 160
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_FILMIX_PERSONA_TXT_ID'
				t.cx=1100
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_filmix_desc_person:gsub('\n',' '):gsub('%s%s%s%s',' '):gsub('%s%s%s',' '):gsub('%s%s','; ') .. '\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=6
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 600
			    t.top  = 155
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')
			end

			if m_simpleTV.User.TVPortal.stena_filmix.type:match('search') then

			local t1 = {
			{'Поиск медиа: ','search media',},
			{'Поиск персон: ','search persons',},
			{'Поиск подборок: ','search collections',},
			}

				for j = 1,3 do

					t = {}
					t.id = 'SEARCH_FILMIX_STENA_' .. j .. '_IMG_ID'
					t.cx= 300 / 1*1.25
					t.cy= 30 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 25
					t.top  = 200 + (j-1)*40
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
					t.mousePressEventFunction = 'search_stena_filmix' .. j
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'SEARCH_FILMIX_STENA_' .. j .. '_TEXT_ID'
					t.cx=280 / 1*1.25
					t.cy=0
					t.class="TEXT"
					t.text = t1[j][1] .. m_simpleTV.User.TVPortal.stena_filmix_search_count[j]
					t.align = 0x0101
					if m_simpleTV.User.TVPortal.stena_filmix.type == t1[j][2] then
					 t.color = ARGB(255, 255, 215, 0)
					else
					 t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 35
					t.top  = 200 + (j-1)*40
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'search_stena_filmix' .. j
					AddElement(t,'ID_DIV_STENA_2')

				end

			end

			for j = 1,#m_simpleTV.User.TVPortal.stena_filmix do

			    local dx = 1920/8
				local dy = 740/2
				local nx = j - (math.ceil(j/8) - 1)*8
				local ny = math.ceil(j/8)
				t = {}
				t.id = 'STENA_FILMIX_B_' .. j .. '_IMG_ID'
				t.cx=200
				t.cy=270
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 220
			    t.top  = ny*dy + 60
				t.transparency = 0
				t.zorder=2
				t.isInteractive = true
				if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons'
					or m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' then
					t.enterEventFunction = 'get_info_for_persona'
				elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'favorite'
					or m_simpleTV.User.TVPortal.stena_filmix.type == 'collection'
					or m_simpleTV.User.TVPortal.stena_filmix.type:match('search') then
					t.enterEventFunction = 'get_info_for_favorite'
				end
				t.mousePressEventFunction = 'content_filmix' .. j

				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena_filmix[j].Reting then
			    local dx = 1920/8
				local dy = 740/2
				local nx = j - (math.ceil(j/8) - 1)*8
				local ny = math.ceil(j/8)
				t = {}
				t.id = 'STENA_FILMIX_RETING_' .. j .. '_IMG_ID'
				t.cx= 120
				t.cy= 24
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars1/' .. Get_rating(m_simpleTV.User.TVPortal.stena_filmix[j].Reting) .. '.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 180
			    t.top  = ny*dy + 65
				t.transparency = 200
				t.bordercolor = -6250336
				t.borderwidth = 1
				t.backroundcorner = 2*2
				t.background = 2
				t.backcolor0 = 0xBB4169E1
				t.backcolor1 = 0xBB00008B
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')
				end

			if m_simpleTV.User.TVPortal.stena_filmix.type ~= 'persons'
				and m_simpleTV.User.TVPortal.stena_filmix.type ~= 'collections' then
				local action
			    local dx = 1920/8
				local dy = 740/2
				local nx = j - (math.ceil(j/8) - 1)*8
				local ny = math.ceil(j/8)
				t = {}
				t.cx= 26
				t.cy= 26
				t.class="IMAGE"
				if find_in_favorites2(m_simpleTV.User.TVPortal.stena_filmix[j].Address) == true then
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-on.png'
				action = '&minus'
				else
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-off.png'
				action = '&plus'
				end
				t.id = 'STENA_FILMIX_FAV_' .. j .. '_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_filmix[j].Address .. action
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 51
			    t.top  = ny*dy + 329
				t.transparency = 200
				t.bordercolor = -6250336
				t.borderwidth = 1
				t.backroundcorner = 13*13
				t.background = 2
				t.backcolor0 = 0xEEFFFFFF
				t.backcolor1 = 0xBB00008B
				t.zorder=2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.borderround = 13
				t.mousePressEventFunction = 'add_to_favorites'

				AddElement(t,'ID_DIV_STENA_1')
			end

				t = {}
				t.id = 'STENA_QUAL_FILMIX_' .. j .. '_TEXT_ID'
				t.cx=200
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_filmix[j].Qual
				t.align = 0x0101
				t.color = ARGB(255 ,152, 251, 152)
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.font_height = -7 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = nx*dx - 220
			    t.top  = ny*dy + 89
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FILMIX_' .. j .. '_TEXT_ID'
				t.cx=200
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_filmix[j].Name .. '\n\n\n'
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = nx*dx - 220
			    t.top  = ny*dy + 358
				t.row_limit=2
				t.text_elidemode = 2
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				AddElement(t,'ID_DIV_STENA_1')


			    local dx = 1920/8
				local dy = 740/2
				local nx = j - (math.ceil(j/8) - 1)*8
				local ny = math.ceil(j/8)
				t = {}
				t.id = 'STENA_FILMIX_' .. j .. '_IMG_ID'
				t.cx=200
				t.cy=300
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_filmix[j].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = nx*dx - 220
			    t.top  = ny*dy + 60
				t.transparency = 200
				t.zorder=1
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 3*3
				t.borderround = 3

				AddElement(t,'ID_DIV_STENA_1')

			end

	if m_simpleTV.User.TVPortal.stena_filmix_need_recall == true then
		m_simpleTV.User.TVPortal.stena_filmix_need_recall = false
		stena_callback(1)
		stena_filmix()
	end
end

function filmix_info()
			m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.User.TVPortal.stena_filmix_info = true
			m_simpleTV.User.TVPortal.stena_filmix_use = false
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_search_use = false
			m_simpleTV.User.TVPortal.stena_genres = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = false

			local favorite = find_in_favorites2(m_simpleTV.User.TVPortal.stena_filmix.current_address)
			local action
			 if favorite then
			  action = '&minus'
			 else
			  action = '&plus'
			 end
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			local add = 0

			 t.BackColor = 0
			 t.BackColorEnd = 255
			 t.PictFileName = m_simpleTV.User.TVPortal.stena_filmix.background
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
			 t.imagepath = m_simpleTV.User.TVPortal.stena_filmix.logo
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

			 t={}
			 t.id = 'TEXT_STENA_QUAL_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena_filmix.qual
			 t.color = ARGB(255 ,152, 251, 152)
			 t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 35 / 1*1.25
			 t.top = 260 / 1*1.25
			 t.zorder=1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'IMG_STENA_FAV_ID&' .. m_simpleTV.User.TVPortal.stena_filmix.current_address .. action
			 t.cx= 40 / 1*1.25
			 t.cy= 40 / 1*1.25
			 t.class="IMAGE"
			 if favorite then
			  t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-on.png'
			 else
			  t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-off.png'
			 end
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 270 / 1*1.25
			 t.top= 260 / 1*1.25
			 t.transparency = 255
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = ARGB(0, 0, 0, 0)
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xBBBBBBBB
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFFFFFFFF
			 t.backroundcorner = 20*20
			 t.borderround = 20
			 t.mousePressEventFunction = 'add_to_favorites'
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
			 t.mousePressEventFunction = 'movie_genres_filmix1'
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
			 if m_simpleTV.User.TVPortal.stena_filmix.type then
			  t.mousePressEventFunction = 'stena_filmix'
			 else
			  t.mousePressEventFunction = 'movie_genres_filmix1'
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
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena_filmix.ret_imdb) .. '.png'
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
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena_filmix.ret_KP) .. '.png'
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
			 t.id = 'RFILMIX_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/FilmixRaiting.png'
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
			 t.id = 'R_FILMIX_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena_filmix.ret_filmix) .. '.png'
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
			 t.id = 'REZKA_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(360+100) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'search_rezka_from_filmix'
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

			 t = {}
			 t.id = 'TMDB_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/TMDB_.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(360+200) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'search_tmdb_from_filmix'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'PLAY_IMG_STENA_BACK_ID'
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
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_filmix'
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'PLAY_IMG_STENA_ID'
			 t.cx= 60 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Play.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= (170+200) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_0_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena_filmix.slogan
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
			 t.text = m_simpleTV.User.TVPortal.stena_filmix.title
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
			 t.text = m_simpleTV.User.TVPortal.stena_filmix.title_en:gsub('%&nbsp%;',' ')
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
			 t.text = m_simpleTV.User.TVPortal.stena_filmix.year .. ' ● ' .. m_simpleTV.User.TVPortal.stena_filmix.country .. (m_simpleTV.User.TVPortal.stena_filmix.age or '') ..  (m_simpleTV.User.TVPortal.stena_filmix.time_all or '')
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
			 t.id = 'TEXT_STENA_5_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = -2113993
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.TVPortal.stena_filmix.overview .. '\n\n\n'
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
			if m_simpleTV.User.TVPortal.stena_filmix.genres and #m_simpleTV.User.TVPortal.stena_filmix.genres then
			 for j=1,#m_simpleTV.User.TVPortal.stena_filmix.genres do

			 t={}
			 t.id = 'TEXT_GENRES_STENA_' .. j .. '_ID'
			 t.cx=0
			 t.cy=0
			 t.once = 0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = ' ● ' .. m_simpleTV.User.TVPortal.stena_filmix.genres[j].genre_name .. ' '
			 t.color = -2113993
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
			 t.background_UnderMouse = 2
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0xEE00008B
			 t.bordercolor_UnderMouse = 0xEE4169E1
			 t.cursorShape = 13
			 local cat, item = get_cat_item_for_url(m_simpleTV.User.TVPortal.stena_filmix.genres[j].genre_adr)
			 if cat == 'film' then
			 t.mousePressEventFunction = 'movie_genres_filmix' .. item
			 elseif cat == 'serial' then
			 t.mousePressEventFunction = 'tv_genres_filmix' .. item
			 elseif cat == 'mult' then
			 t.mousePressEventFunction = 'mult_genres_filmix' .. item
			 elseif cat == 'serial' then
			 t.mousePressEventFunction = 'multserial_genres_filmix' .. item
			 end
			 AddElement(t,'ID_DIV_STENA_1')
			end
			end

			local max = 10
			if 	m_simpleTV.User.TVPortal.stena_filmix.actors and
				m_simpleTV.User.TVPortal.stena_filmix.actors[1]	then
				if #m_simpleTV.User.TVPortal.stena_filmix.actors < max then
					max = #m_simpleTV.User.TVPortal.stena_filmix.actors
				end
				for j = 1,max do
			 t = {}
			 t.id = 'PERSON_STENA_' .. j .. '_IMG_ID'
			 t.cx= 115 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left = 425 + (j-1)*150
			 t.top  = 760
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mouseMoveEventFunction = 'get_request_for_persona'
			 t.mousePressEventFunction = 'personWork_stena_filmix' .. j
			 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'PERSON_STENA_' .. j .. '_TEXT_ID'
				t.cx=105 / 1*1.25
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_filmix.actors[j].actors_name:gsub('    ','') .. '\n\n'
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 430 + (j-1)*150
			    t.top  = 760
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'personWork_stena_filmix' .. j
				AddElement(t,'ID_DIV_STENA_1')
				end
			end

			local max = 4
			if 	m_simpleTV.User.TVPortal.stena_filmix.collections and
				m_simpleTV.User.TVPortal.stena_filmix.collections[1]	then
				if #m_simpleTV.User.TVPortal.stena_filmix.collections < max then
					max = #m_simpleTV.User.TVPortal.stena_filmix.collections
				end
				for j = 1,max do

			 t = {}
			 t.id = 'COLLECTION_STENA_' .. j .. '_IMG_ID'
			 t.cx= 300 / 1*1.25
			 t.cy= 30 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left = 25
			 t.top  = 1000 + (j-1)*40
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
			 t.mousePressEventFunction = 'collection_stena_filmix' .. j
			 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'COLLECTION_STENA_' .. j .. '_TEXT_ID'
				t.cx=280 / 1*1.25
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_filmix.collections[j].Name
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000020
				t.boundWidth = 15
				t.left = 35
			    t.top  = 1000 + (j-1)*40
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'collection_stena_filmix' .. j
				AddElement(t,'ID_DIV_STENA_1')
				end
			end

end

function movie_genres_filmix1()
	Get_filmix_stena_info('film', 1, 1)
end

function movie_genres_filmix2()
	Get_filmix_stena_info('film', 2, 1)
end

function movie_genres_filmix3()
	Get_filmix_stena_info('film', 3, 1)
end

function movie_genres_filmix4()
	Get_filmix_stena_info('film', 4, 1)
end

function movie_genres_filmix5()
	Get_filmix_stena_info('film', 5, 1)
end

function movie_genres_filmix6()
	Get_filmix_stena_info('film', 6, 1)
end

function movie_genres_filmix7()
	Get_filmix_stena_info('film', 7, 1)
end

function movie_genres_filmix8()
	Get_filmix_stena_info('film', 8, 1)
end

function movie_genres_filmix9()
	Get_filmix_stena_info('film', 9, 1)
end

function movie_genres_filmix10()
	Get_filmix_stena_info('film', 10, 1)
end

function movie_genres_filmix11()
	Get_filmix_stena_info('film', 11, 1)
end

function movie_genres_filmix12()
	Get_filmix_stena_info('film', 12, 1)
end

function movie_genres_filmix13()
	Get_filmix_stena_info('film', 13, 1)
end

function movie_genres_filmix14()
	Get_filmix_stena_info('film', 14, 1)
end

function movie_genres_filmix15()
	Get_filmix_stena_info('film', 15, 1)
end

function movie_genres_filmix16()
	Get_filmix_stena_info('film', 16, 1)
end

function movie_genres_filmix17()
	Get_filmix_stena_info('film', 17, 1)
end

function movie_genres_filmix18()
	Get_filmix_stena_info('film', 18, 1)
end

function movie_genres_filmix19()
	Get_filmix_stena_info('film', 19, 1)
end

function movie_genres_filmix20()
	Get_filmix_stena_info('film', 20, 1)
end

function movie_genres_filmix21()
	Get_filmix_stena_info('film', 21, 1)
end

function movie_genres_filmix22()
	Get_filmix_stena_info('film', 22, 1)
end

function movie_genres_filmix23()
	Get_filmix_stena_info('film', 23, 1)
end

function movie_genres_filmix24()
	Get_filmix_stena_info('film', 24, 1)
end

function movie_genres_filmix25()
	Get_filmix_stena_info('film', 25, 1)
end

function movie_genres_filmix26()
	Get_filmix_stena_info('film', 26, 1)
end

function movie_genres_filmix27()
	Get_filmix_stena_info('film', 27, 1)
end

function movie_genres_filmix28()
	Get_filmix_stena_info('film', 28, 1)
end

function movie_genres_filmix29()
	Get_filmix_stena_info('film', 29, 1)
end

function movie_genres_filmix30()
	Get_filmix_stena_info('film', 30, 1)
end

function movie_genres_filmix31()
	Get_filmix_stena_info('film', 31, 1)
end

function movie_genres_filmix32()
	Get_filmix_stena_info('film', 32, 1)
end

function movie_genres_filmix33()
	Get_filmix_stena_info('film', 33, 1)
end

function movie_genres_filmix34()
	Get_filmix_stena_info('film', 34, 1)
end

function movie_genres_filmix35()
	Get_filmix_stena_info('film', 35, 1)
end

function movie_genres_filmix36()
	Get_filmix_stena_info('film', 36, 1)
end

function movie_genres_filmix37()
	Get_filmix_stena_info('film', 37, 1)
end

function movie_genres_filmix38()
	Get_filmix_stena_info('film', 38, 1)
end

function movie_genres_filmix39()
	Get_filmix_stena_info('film', 39, 1)
end

function movie_genres_filmix40()
	Get_filmix_stena_info('film', 40, 1)
end

function tv_genres_filmix1()
	Get_filmix_stena_info('serial', 1, 1)
end

function tv_genres_filmix2()
	Get_filmix_stena_info('serial', 2, 1)
end

function tv_genres_filmix3()
	Get_filmix_stena_info('serial', 3, 1)
end

function tv_genres_filmix4()
	Get_filmix_stena_info('serial', 4, 1)
end

function tv_genres_filmix5()
	Get_filmix_stena_info('serial', 5, 1)
end

function tv_genres_filmix6()
	Get_filmix_stena_info('serial', 6, 1)
end

function tv_genres_filmix7()
	Get_filmix_stena_info('serial', 7, 1)
end

function tv_genres_filmix8()
	Get_filmix_stena_info('serial', 8, 1)
end

function tv_genres_filmix9()
	Get_filmix_stena_info('serial', 9, 1)
end

function tv_genres_filmix10()
	Get_filmix_stena_info('serial', 10, 1)
end

function tv_genres_filmix11()
	Get_filmix_stena_info('serial', 11, 1)
end

function tv_genres_filmix12()
	Get_filmix_stena_info('serial', 12, 1)
end

function tv_genres_filmix13()
	Get_filmix_stena_info('serial', 13, 1)
end

function tv_genres_filmix14()
	Get_filmix_stena_info('serial', 14, 1)
end

function tv_genres_filmix15()
	Get_filmix_stena_info('serial', 15, 1)
end

function tv_genres_filmix16()
	Get_filmix_stena_info('serial', 16, 1)
end

function tv_genres_filmix17()
	Get_filmix_stena_info('serial', 17, 1)
end

function tv_genres_filmix18()
	Get_filmix_stena_info('serial', 18, 1)
end

function tv_genres_filmix19()
	Get_filmix_stena_info('serial', 19, 1)
end

function tv_genres_filmix20()
	Get_filmix_stena_info('serial', 20, 1)
end

function tv_genres_filmix21()
	Get_filmix_stena_info('serial', 21, 1)
end

function tv_genres_filmix22()
	Get_filmix_stena_info('serial', 22, 1)
end

function tv_genres_filmix23()
	Get_filmix_stena_info('serial', 23, 1)
end

function tv_genres_filmix24()
	Get_filmix_stena_info('serial', 24, 1)
end

function tv_genres_filmix25()
	Get_filmix_stena_info('serial', 25, 1)
end

function tv_genres_filmix26()
	Get_filmix_stena_info('serial', 26, 1)
end

function tv_genres_filmix27()
	Get_filmix_stena_info('serial', 27, 1)
end

function tv_genres_filmix28()
	Get_filmix_stena_info('serial', 28, 1)
end

function tv_genres_filmix29()
	Get_filmix_stena_info('serial', 29, 1)
end

function tv_genres_filmix30()
	Get_filmix_stena_info('serial', 30, 1)
end

function tv_genres_filmix31()
	Get_filmix_stena_info('serial', 31, 1)
end

function tv_genres_filmix32()
	Get_filmix_stena_info('serial', 32, 1)
end

function tv_genres_filmix33()
	Get_filmix_stena_info('serial', 33, 1)
end

function tv_genres_filmix34()
	Get_filmix_stena_info('serial', 34, 1)
end

function tv_genres_filmix35()
	Get_filmix_stena_info('serial', 35, 1)
end

function tv_genres_filmix36()
	Get_filmix_stena_info('serial', 36, 1)
end

function tv_genres_filmix37()
	Get_filmix_stena_info('serial', 37, 1)
end

function tv_genres_filmix38()
	Get_filmix_stena_info('serial', 38, 1)
end

function tv_genres_filmix39()
	Get_filmix_stena_info('serial', 39, 1)
end

function tv_genres_filmix40()
	Get_filmix_stena_info('serial', 40, 1)
end

function mult_genres_filmix1()
	Get_filmix_stena_info('mult', 1, 1)
end

function mult_genres_filmix2()
	Get_filmix_stena_info('mult', 2, 1)
end

function mult_genres_filmix3()
	Get_filmix_stena_info('mult', 3, 1)
end

function mult_genres_filmix4()
	Get_filmix_stena_info('mult', 4, 1)
end

function mult_genres_filmix5()
	Get_filmix_stena_info('mult', 5, 1)
end

function mult_genres_filmix6()
	Get_filmix_stena_info('mult', 6, 1)
end

function mult_genres_filmix7()
	Get_filmix_stena_info('mult', 7, 1)
end

function mult_genres_filmix8()
	Get_filmix_stena_info('mult', 8, 1)
end

function mult_genres_filmix9()
	Get_filmix_stena_info('mult', 9, 1)
end

function mult_genres_filmix10()
	Get_filmix_stena_info('mult', 10, 1)
end

function mult_genres_filmix11()
	Get_filmix_stena_info('mult', 11, 1)
end

function mult_genres_filmix12()
	Get_filmix_stena_info('mult', 12, 1)
end

function mult_genres_filmix13()
	Get_filmix_stena_info('mult', 13, 1)
end

function mult_genres_filmix14()
	Get_filmix_stena_info('mult', 14, 1)
end

function mult_genres_filmix15()
	Get_filmix_stena_info('mult', 15, 1)
end

function mult_genres_filmix16()
	Get_filmix_stena_info('mult', 16, 1)
end

function mult_genres_filmix17()
	Get_filmix_stena_info('mult', 17, 1)
end

function mult_genres_filmix18()
	Get_filmix_stena_info('mult', 18, 1)
end

function mult_genres_filmix19()
	Get_filmix_stena_info('mult', 19, 1)
end

function mult_genres_filmix20()
	Get_filmix_stena_info('mult', 20, 1)
end

function mult_genres_filmix21()
	Get_filmix_stena_info('mult', 21, 1)
end

function mult_genres_filmix22()
	Get_filmix_stena_info('mult', 22, 1)
end

function mult_genres_filmix23()
	Get_filmix_stena_info('mult', 23, 1)
end

function mult_genres_filmix24()
	Get_filmix_stena_info('mult', 24, 1)
end

function mult_genres_filmix25()
	Get_filmix_stena_info('mult', 25, 1)
end

function mult_genres_filmix26()
	Get_filmix_stena_info('mult', 26, 1)
end

function mult_genres_filmix27()
	Get_filmix_stena_info('mult', 27, 1)
end

function mult_genres_filmix28()
	Get_filmix_stena_info('mult', 28, 1)
end

function mult_genres_filmix29()
	Get_filmix_stena_info('mult', 29, 1)
end

function mult_genres_filmix30()
	Get_filmix_stena_info('mult', 30, 1)
end

function mult_genres_filmix31()
	Get_filmix_stena_info('mult', 31, 1)
end

function mult_genres_filmix32()
	Get_filmix_stena_info('mult', 32, 1)
end

function mult_genres_filmix33()
	Get_filmix_stena_info('mult', 33, 1)
end

function mult_genres_filmix34()
	Get_filmix_stena_info('mult', 34, 1)
end

function mult_genres_filmix35()
	Get_filmix_stena_info('mult', 35, 1)
end

function mult_genres_filmix36()
	Get_filmix_stena_info('mult', 36, 1)
end

function mult_genres_filmix37()
	Get_filmix_stena_info('mult', 37, 1)
end

function mult_genres_filmix38()
	Get_filmix_stena_info('mult', 38, 1)
end

function mult_genres_filmix39()
	Get_filmix_stena_info('mult', 39, 1)
end

function mult_genres_filmix40()
	Get_filmix_stena_info('mult', 40, 1)
end

function multserial_genres_filmix1()
	Get_filmix_stena_info('multserial', 1, 1)
end

function multserial_genres_filmix2()
	Get_filmix_stena_info('multserial', 2, 1)
end

function multserial_genres_filmix3()
	Get_filmix_stena_info('multserial', 3, 1)
end

function multserial_genres_filmix4()
	Get_filmix_stena_info('multserial', 4, 1)
end

function multserial_genres_filmix5()
	Get_filmix_stena_info('multserial', 5, 1)
end

function multserial_genres_filmix6()
	Get_filmix_stena_info('multserial', 6, 1)
end

function multserial_genres_filmix7()
	Get_filmix_stena_info('multserial', 7, 1)
end

function multserial_genres_filmix8()
	Get_filmix_stena_info('multserial', 8, 1)
end

function multserial_genres_filmix9()
	Get_filmix_stena_info('multserial', 9, 1)
end

function multserial_genres_filmix10()
	Get_filmix_stena_info('multserial', 10, 1)
end

function multserial_genres_filmix11()
	Get_filmix_stena_info('multserial', 11, 1)
end

function multserial_genres_filmix12()
	Get_filmix_stena_info('multserial', 12, 1)
end

function multserial_genres_filmix13()
	Get_filmix_stena_info('multserial', 13, 1)
end

function multserial_genres_filmix14()
	Get_filmix_stena_info('multserial', 14, 1)
end

function multserial_genres_filmix15()
	Get_filmix_stena_info('multserial', 15, 1)
end

function multserial_genres_filmix16()
	Get_filmix_stena_info('multserial', 16, 1)
end

function multserial_genres_filmix17()
	Get_filmix_stena_info('multserial', 17, 1)
end

function multserial_genres_filmix18()
	Get_filmix_stena_info('multserial', 18, 1)
end

function multserial_genres_filmix19()
	Get_filmix_stena_info('multserial', 19, 1)
end

function multserial_genres_filmix20()
	Get_filmix_stena_info('multserial', 20, 1)
end

function multserial_genres_filmix21()
	Get_filmix_stena_info('multserial', 21, 1)
end

function multserial_genres_filmix22()
	Get_filmix_stena_info('multserial', 22, 1)
end

function multserial_genres_filmix23()
	Get_filmix_stena_info('multserial', 23, 1)
end

function multserial_genres_filmix24()
	Get_filmix_stena_info('multserial', 24, 1)
end

function multserial_genres_filmix25()
	Get_filmix_stena_info('multserial', 25, 1)
end

function multserial_genres_filmix26()
	Get_filmix_stena_info('multserial', 26, 1)
end

function multserial_genres_filmix27()
	Get_filmix_stena_info('multserial', 27, 1)
end

function multserial_genres_filmix28()
	Get_filmix_stena_info('multserial', 28, 1)
end

function multserial_genres_filmix29()
	Get_filmix_stena_info('multserial', 29, 1)
end

function multserial_genres_filmix30()
	Get_filmix_stena_info('multserial', 30, 1)
end

function multserial_genres_filmix31()
	Get_filmix_stena_info('multserial', 31, 1)
end

function multserial_genres_filmix32()
	Get_filmix_stena_info('multserial', 32, 1)
end

function multserial_genres_filmix33()
	Get_filmix_stena_info('multserial', 33, 1)
end

function multserial_genres_filmix34()
	Get_filmix_stena_info('multserial', 34, 1)
end

function multserial_genres_filmix35()
	Get_filmix_stena_info('multserial', 35, 1)
end

function multserial_genres_filmix36()
	Get_filmix_stena_info('multserial', 36, 1)
end

function multserial_genres_filmix37()
	Get_filmix_stena_info('multserial', 37, 1)
end

function multserial_genres_filmix38()
	Get_filmix_stena_info('multserial', 38, 1)
end

function multserial_genres_filmix39()
	Get_filmix_stena_info('multserial', 39, 1)
end

function multserial_genres_filmix40()
	Get_filmix_stena_info('multserial', 40, 1)
end

function stena_filmix_prev()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'film' or m_simpleTV.User.TVPortal.stena_filmix.type == 'serial' or m_simpleTV.User.TVPortal.stena_filmix.type == 'mult' or m_simpleTV.User.TVPortal.stena_filmix.type == 'multserial' then
		Get_filmix_stena_info(m_simpleTV.User.TVPortal.stena_filmix_prev[1], m_simpleTV.User.TVPortal.stena_filmix_prev[2],m_simpleTV.User.TVPortal.stena_filmix_prev[3])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'persona' then
		person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix_prev[1], m_simpleTV.User.TVPortal.stena_filmix_prev[2])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' then
		person_filmix(m_simpleTV.User.TVPortal.stena_filmix_prev[1])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'collection' then
		collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix_prev[1], m_simpleTV.User.TVPortal.stena_filmix_prev[2])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' then
		stena_filmix_collections(m_simpleTV.User.TVPortal.stena_filmix_prev[1])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'favorite' then
		favorite_filmix(m_simpleTV.User.TVPortal.stena_filmix_prev[1])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'search media' then
		search_filmix_medias(m_simpleTV.User.TVPortal.stena_filmix_prev[1])
	end
end

function stena_filmix_next()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'film' or m_simpleTV.User.TVPortal.stena_filmix.type == 'serial' or m_simpleTV.User.TVPortal.stena_filmix.type == 'mult' or m_simpleTV.User.TVPortal.stena_filmix.type == 'multserial' then
		Get_filmix_stena_info(m_simpleTV.User.TVPortal.stena_filmix_next[1], m_simpleTV.User.TVPortal.stena_filmix_next[2],m_simpleTV.User.TVPortal.stena_filmix_next[3])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'persona' then
		person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix_next[1], m_simpleTV.User.TVPortal.stena_filmix_next[2])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' then
		person_filmix(m_simpleTV.User.TVPortal.stena_filmix_next[1])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'collection' then
		collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix_next[1], m_simpleTV.User.TVPortal.stena_filmix_next[2])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' then
		stena_filmix_collections(m_simpleTV.User.TVPortal.stena_filmix_next[1])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'favorite' then
		favorite_filmix(m_simpleTV.User.TVPortal.stena_filmix_next[1])
	elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'search media' then
		search_filmix_medias(m_simpleTV.User.TVPortal.stena_filmix_next[1])
	end
end

function select_filmix_page()
	local t = {}
	for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_filmix_page[1]) do
		t[i] = {}
		t[i].Id = i
		t[i].Name = i
	end
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_filmix_page[2])-1, t, 5000, 'ALWAYS_OK | MODAL_MODE')
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		if m_simpleTV.User.TVPortal.stena_filmix.type == 'film' or m_simpleTV.User.TVPortal.stena_filmix.type == 'serial' or m_simpleTV.User.TVPortal.stena_filmix.type == 'mult' or m_simpleTV.User.TVPortal.stena_filmix.type == 'multserial' then
			Get_filmix_stena_info(m_simpleTV.User.TVPortal.stena_filmix_page[3], m_simpleTV.User.TVPortal.stena_filmix_page[4],id)
		elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'persona' then
			person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix_page[3], id)
		elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' then
			person_filmix(id)
		elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'collection' then
			collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix_page[3], id)
		elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' then
			stena_filmix_collections(id)
		elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'favorite' then
			favorite_filmix(id)
		elseif m_simpleTV.User.TVPortal.stena_filmix.type == 'search media' then
			search_filmix_medias(id)
		end
	end
end

function content_filmix1()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[1].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[1].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[1].Address)
end

function content_filmix2()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[2].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[2].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[2].Address)
end

function content_filmix3()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[3].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[3].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[3].Address)
end

function content_filmix4()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[4].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[4].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[4].Address)
end

function content_filmix5()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[5].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[5].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[5].Address)
end

function content_filmix6()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[6].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[6].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[6].Address)
end

function content_filmix7()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[7].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[7].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[7].Address)
end

function content_filmix8()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[8].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[8].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[8].Address)
end

function content_filmix9()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[9].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[9].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[9].Address)
end

function content_filmix10()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[10].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[10].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[10].Address)
end

function content_filmix11()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[11].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[11].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[11].Address)
end

function content_filmix12()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[12].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[12].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[12].Address)
end

function content_filmix13()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[13].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[13].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[13].Address)
end

function content_filmix14()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[14].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[14].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[14].Address)
end

function content_filmix15()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[15].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[15].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[15].Address)
end

function content_filmix16()
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'persons' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search persons' then
		return person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix[16].Address, 1)
	end
	if m_simpleTV.User.TVPortal.stena_filmix.type == 'collections' or
	m_simpleTV.User.TVPortal.stena_filmix.type == 'search collections' then
		return collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix[16].Address, 1)
	end
	similar_filmix(m_simpleTV.User.TVPortal.stena_filmix[16].Address)
end

function personWork_stena_filmix1()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[1].actors_adr,1)
end

function personWork_stena_filmix2()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[2].actors_adr,1)
end

function personWork_stena_filmix3()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[3].actors_adr,1)
end

function personWork_stena_filmix4()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[4].actors_adr,1)
end

function personWork_stena_filmix5()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[5].actors_adr,1)
end

function personWork_stena_filmix6()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[6].actors_adr,1)
end

function personWork_stena_filmix7()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[7].actors_adr,1)
end

function personWork_stena_filmix8()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[8].actors_adr,1)
end

function personWork_stena_filmix9()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[9].actors_adr,1)
end

function personWork_stena_filmix10()
	person_content_filmix(m_simpleTV.User.TVPortal.stena_filmix.actors[10].actors_adr,1)
end

function collection_stena_filmix1()
	collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix.collections[1].Address)
end

function collection_stena_filmix2()
	collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix.collections[2].Address)
end

function collection_stena_filmix3()
	collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix.collections[3].Address)
end

function collection_stena_filmix4()
	collection_filmix_url(m_simpleTV.User.TVPortal.stena_filmix.collections[4].Address)
end

function search_tmdb_from_filmix()
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_filmix.title),'LiteConf.ini')
	search_tmdb()
end

function search_rezka_from_filmix()
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_filmix.title),'LiteConf.ini')
	search_rezka()
end

function search_stena_filmix1()
	search_filmix_medias(1)
end

function search_stena_filmix2()
	search_filmix_persons(1)
end

function search_stena_filmix3()
	search_filmix_collections(1)
end

function play_filmix()
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	stena_clear()
	local retAdr = m_simpleTV.User.TVPortal.stena_filmix.current_address
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.PlayAddress(retAdr)
	return
end

function get_info_for_persona(id_cur)
	local id = id_cur:match('(%d+)')
	local t, AddElement = {}, m_simpleTV.OSD.AddElement
	local t1 = m_simpleTV.User.TVPortal.stena_filmix
		if m_simpleTV.User.TVPortal.stena_filmix.cur_actors_adr == nil or
			t1[tonumber(id)].Address ~= m_simpleTV.User.TVPortal.stena_filmix.cur_actors_adr then
			m_simpleTV.User.TVPortal.stena_filmix.cur_actors_adr = t1[tonumber(id)].Address

				t = {}
				t.id = 'STENA_FILMIX_PERSONA_TT_IMG_ID'
				t.cx=110
				t.cy=165
				t.class="IMAGE"
				t.imagepath = t1[tonumber(id)].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 450
			    t.top  = 160
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_FILMIX_PERSONA_TT_TXT_ID'
				t.cx=1000
				t.cy=0
				t.class="TEXT"
				t.text = t1[tonumber(id)].InfoPanelTitle:gsub(' Всего фильмов.-$','') .. '\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=6
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 600
			    t.top  = 155
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

		end
end

function get_request_for_persona(id_cur)
	local id = id_cur:match('(%d+)')
	local t, AddElement = {}, m_simpleTV.OSD.AddElement
	local t1 = m_simpleTV.User.TVPortal.stena_filmix.actors
	if not t1 then return end
	local url = t1[tonumber(id)].actors_adr
--	debug_in_file(url .. '\n','c://1/filmix1.txt')

	if m_simpleTV.User.TVPortal.stena_filmix.cur_actors_adr == nil or
		url ~= m_simpleTV.User.TVPortal.stena_filmix.cur_actors_adr then
		m_simpleTV.User.TVPortal.stena_filmix.cur_actors_adr = url
		get_request(url)
	end
			if m_simpleTV.User.TVPortal.stena_filmix.cur_actors_logo then
				t = {}
				t.id = 'STENA_FILMIX_FOR_PERSONA_IMG_ID'
				t.cx=110
				t.cy=165
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_filmix.cur_actors_logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 425
			    t.top  = 750
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')
				m_simpleTV.User.TVPortal.stena_filmix.cur_actors_logo = nil
			end
			if m_simpleTV.User.TVPortal.stena_filmix.cur_actors_desc then
				t = {}
				t.id = 'STENA_FILMIX_FOR_PERSONA_TXT_ID'
				t.cx=900
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_filmix.cur_actors_desc:gsub('\n',' '):gsub('%s%s%s%s',' '):gsub('%s%s%s',' '):gsub('%s%s','; ') .. '\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=6
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 575
			    t.top  = 745
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')
				m_simpleTV.User.TVPortal.stena_filmix.cur_actors_desc = nil
			end
end

function get_info_for_favorite(id_cur)
	local id = id_cur:match('(%d+)')
	local t, AddElement = {}, m_simpleTV.OSD.AddElement
	local t1 = m_simpleTV.User.TVPortal.stena_filmix
		if m_simpleTV.User.TVPortal.stena_filmix.cur_content_adr == nil or
			t1[tonumber(id)].Address ~= m_simpleTV.User.TVPortal.stena_filmix.cur_content_adr then
			m_simpleTV.User.TVPortal.stena_filmix.cur_content_adr = t1[tonumber(id)].Address

				t = {}
				t.id = 'STENA_FILMIX_CONTENT_IMG_ID'
				t.cx=110
				t.cy=165
				t.class="IMAGE"
				t.imagepath = t1[tonumber(id)].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 500
			    t.top  = 160
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_FILMIX_CONTENT_TXT_ID'
				t.cx=800
				t.cy=0
				t.class="TEXT"
				t.text = t1[tonumber(id)].InfoPanelTitle .. '\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=6
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 650
			    t.top  = 155
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

		end
end
