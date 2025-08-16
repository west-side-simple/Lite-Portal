--EX-FS portal - lite version west_side 15.08.25

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.EXFS==nil then m_simpleTV.User.EXFS={} end
	if m_simpleTV.User.EXFS==nil then m_simpleTV.User.EXFS={} end

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

m_simpleTV.User.EXFS.stena_exfs_title_font = m_simpleTV.Config.GetValue('TitleFont','LiteConf.ini') or 'Segoe UI Black'

local function check_thumb(url, session)
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
--	debug_in_file(rc .. '\n' .. url .. '\n','c://1/th.txt')
	if rc == 200 then return true end
	return
end

local function get_is_thumb(id)

--	local url = 'https://api' .. os.time() .. '.synchroncode.com/embed/'
	local url = 'https://api.kinogram.best/embed/'
	if id:match('(tt)%d+') then
		url = url .. 'imdb/' .. id
	elseif id:match('(%d+)') then
		url = url .. 'kp/' .. id
	else
		return false
	end
--	debug_in_file(id .. '\n' .. url .. '\n','c://1/th.txt')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc == 200 and answer then
		local all_data = answer:match('preview: %{(.-)%}%,')
		if not all_data then
			m_simpleTV.Http.Close(session)
			return false
		end
		local src_pre, src_id = all_data:match("src:.-'(.-)'.-(%d+)")
		local firstNum = all_data:match("firstNum:.-(%d+)")
		local src = src_pre .. src_id .. '/desktop/'
		local check = check_thumb(src .. firstNum .. '.webp',session)
--		debug_in_file(all_data .. '\n' .. src .. firstNum .. '.webp' .. '\n','c://1/th.txt')
		m_simpleTV.Http.Close(session)
		if check then
			m_simpleTV.Http.Close(session)
			return true
		end
	end
	m_simpleTV.Http.Close(session)
	return false
end

local function get_logo_genres(name)
	local genres = {
		{"фантастика","Фантастика","Фантастика"},
		{"аниме","Аниме","Аниме"},
		{"биография","Биография","Исторические"},
		{"боевик","Боевик","Боевики"},
		{"вестерн","Вестерн","Вестерны"},
		{"военный","Военный","Военные"},
		{"детектив","Детектив","Детективы"},
		{"детский","Детский","Подростковые"},
		{"для_взрослых","Для взрослых","Семейные"},
		{"документальный","Документальный","Документальные"},
		{"драма","Драма","Драмы"},
		{"история","История","Исторические"},
		{"комедия","Комедия","Комедии"},
		{"короткометражка","Короткометражка","Короткометражные"},
		{"концерт","Концерт","Музыка"},
		{"криминал","Криминал","Криминал"},
		{"мелодрама","Мелодрама","Романтика"},
		{"музыка","Музыка","Музыка"},
		{"мюзикл","Мюзикл","Музыка"},
		{"новости","Новости","Новости"},
		{"приключения","Приключения","Приключения"},
		{"реальное_ТВ","Реальное ТВ","Реалити"},
		{"семейный","Семейный","Семейные"},
		{"спорт","Спорт","Спорт"},
		{"ток-шоу","Ток-шоу","Реалити"},
		{"триллер","Триллер","Триллеры"},
		{"ужасы","Ужасы","Ужасы"},
		{"фильм-нуар","Фильм-Нуар","Нуар"},
		{"игра","Игра","Реалити"},
		{"фэнтези","Фэнтези","Фантазия"},
		{"мультфильм","Мультфильм","Мультфильм"},
		}
		for i = 1, #genres do
--			debug_in_file(genres[i][1].. '=='.. name..'\n')
			if genres[i][1] == name then return genres[i][2] end
		end
		return genres[23][2]
end

local function Get_current_balanser_name(name)
 if not m_simpleTV.User.TVPortal then m_simpleTV.User.TVPortal = {} end
 if not m_simpleTV.User.EXFS then m_simpleTV.User.EXFS = {} end
-- debug_in_file((m_simpleTV.User.TVPortal.balanser or 'not') .. ' and ' .. name .. ' / ' .. (m_simpleTV.User.EXFS.TestAddress or 'not') .. ' and ' .. (m_simpleTV.User.EXFS.CurAddress or 'not') .. '\n','c://1/name.txt')
 if m_simpleTV.User.TVPortal.balanser and m_simpleTV.User.TVPortal.balanser == name and m_simpleTV.User.EXFS.TestAddress == m_simpleTV.User.EXFS.CurAddress then
  return 1
 end
  return 0
end

local function Get_rating(rating)
	if rating == nil or rating == '' or rating and tonumber(rating) == nil then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

local function Get_VF(id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://vibix.org/api/v1/catalog/data?draw=1&search[value]=' .. id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'post', headers = m_simpleTV.User.VF.headers})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	local url_out = answer:match('"iframe_video_id":(%d+)')
	local kp_id = answer:match('"kp_id":(%d+)') or 0
	local imdb_id = answer:match('"imdb_id":"(tt%d+)') or ''
	local base_url = answer:match('"iframe_base_url":"(.-)"')
	if base_url then base_url = base_url:gsub('\\','') end
--	debug_in_file(unescape1(answer) .. '\n','c://1/VX.txt')
	if url_out then
	local embed = '/embed/'
	if unescape1(answer):match('"type":"serial"') then embed = '/embed-serials/' end
	url_out = base_url .. embed .. url_out
	m_simpleTV.Http.Close(session)
	return url_out .. '&kp_id=' .. kp_id .. '&imdb_id=' .. imdb_id
	end
	m_simpleTV.Http.Close(session)
	return false
end

local function Get_ZF(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = decode64('aHR0cHM6Ly9oaWR4bGdsay5kZXBsb3kuY3gvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	if rc==200 and answer:match('data%-json') then
		m_simpleTV.Http.Close(session)
		return url
	end
	m_simpleTV.Common.Sleep(1000)
	rc,answer = m_simpleTV.Http.Request(session,{url = url})
	if rc==200 and answer:match('data%-json') then
		m_simpleTV.Http.Close(session)
		return url
	end
	m_simpleTV.Http.Close(session)
	return false
end

local function Get_Ashdi(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = 'https://api.manhan.one/lite/ashdi?kinopoisk_id=' .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	m_simpleTV.Http.Close(session)
	if rc==200 and answer:match('data%-json') then
		return url
	end
	return false
end

local function Get_Kodik(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cDovL2tvZGlrYXBpLmNvbS9nZXQtcGxheWVyP3Rva2VuPTQ0N2QxNzllODc1ZWZlNDQyMTdmMjBkMWVlMjE0NmJlJmtpbm9wb2lza0lEPQ') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('"link":"([^"]+)') then
--	debug_in_file(url .. '\n'..answer:match('"link":"([^"]+)'):gsub('^//','https://')..'\n', 'c://1/kod.txt')
		return answer:match('"link":"([^"]+)'):gsub('^//','https://')
	end
	return false
end

local function Get_FX(title, year, kp_id, imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = decode64('aHR0cHM6Ly9wcmlzLmNhbS9saXRlL2ZpbG1peD8=') .. 'title=' .. escape(title) .. '&year=' .. year .. '&source=tmdb&kinopoisk_id=' .. kp_id .. '&imdb_id=' .. imdb_id
--	debug_in_file(url .. '\n', 'c://1/fx1.txt')
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	m_simpleTV.Http.Close(session)
	if rc==200 and answer:match('data%-json') then
		return url
	end
	return false
end

local function Get_HDVB(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = decode64('aHR0cHM6Ly9hcGkubWFuaGFuLm9uZS9saXRlL2hkdmI/a2lub3BvaXNrX2lkPQ==') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = unescape3(unescape(answer))
	local t = {}
		for url, tr in answer:gmatch('"stream":"(.-)"%,"translate":"(.-)"') do
				t[#t + 1] = {}
				t[#t].Id = #t
				t[#t].Address = url:gsub('^.-iframe=','')
				t[#t].Name = tr
		end
	if #t ~= 0 then
	return t
	end
	return false
end

local function Get_Collaps(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = 'https://api.kinogram.best/embed/kp/' .. kp_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
--	debug_in_file(answer .. '\n')
	if answer:match('embedHost') then
		m_simpleTV.Http.Close(session)
		return url
	end
	m_simpleTV.Http.Close(session)
	return false
end

local function Get_Trailer(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = 'https://kp.pris.cam/https://widgets.kinopoisk.ru/discovery/api/trailers?params=' .. kp_id .. '%2C0%2C%200%2C%20rnd-0.07813094955279343&_=1749476824905'

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--	debug_in_file(rc .. '\n' .. answer .. '\n')
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('streamUrl":".-"') then
--		debug_in_file(answer:match('streamUrl":"(.-)"') .. '\n')
		return answer:match('streamUrl":"(.-)"')
	end
	return false
end

local function Get_VeoVeo(id)
	if not id then return false end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = 'https://p01--lampac--9dxms589q2gt.code.run/lite/veoveo?'
	if id:match('(tt%d+)') then
		url = url .. 'imdb_id=' .. id
	else
		url = url .. 'kinopoisk_id=' .. id
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--	debug_in_file(rc .. '\n' .. answer .. '\n')
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('"url":".-"') then
--		debug_in_file(answer:match('"url":"(.-)"') .. '\n')
--		return answer:match('"url":"(.-)"')
		return url
	end
	return false
end

local function check_pirr(id)
	if not id then return false,0 end
	local delta = os.clock()
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local url = 'http://api.vokino.tv/v2/torrents/' .. id .. '?token=' .. token
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		delta = os.clock() - delta
		return false,delta
	end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		delta = os.clock() - delta
		return false,delta
	end
	m_simpleTV.Http.Close(session)
	if not answer:match('Все') then
		delta = os.clock() - delta
		return false,delta
	end
	delta = os.clock() - delta
	return true,delta
end

local function Get_Pirring(title, year, kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	local url = decode64('aHR0cDovL2FwaS52b2tpbm8udHYvdjIvbGlzdD9uYW1lPSUyQg==') .. kp_id:gsub('77264','127608')
	local rc, answer = m_simpleTV.Http.Request(session, {url = url .. '&token=' .. decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')})
	if rc ~= 200 then return end
	m_simpleTV.Http.Close(session)
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
--	debug_in_file( '\n' .. url .. '\n' .. answer .. '\n', 'c://1/pir.txt', setnew )
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name then
		return
	end
	m_simpleTV.Http.Close(session)
	local t, i = {}, 1
	while true do
		if not tab.channels[i] or not tab.channels[i].details.id then
			break
		end
		local id = tab.channels[i].details.id
		local name = tab.channels[i].details.name or 'noname'
		local released = tab.channels[i].details.released or ''
		if name == title then return id end
		i=i+1
	end
	return
end

local function find_in_history_exfs(inAdr)
	local recentAddress = getConfigVal('exfs_history/adr') or ''
    local t,i={},1
	for w in string.gmatch(recentAddress,"[^%|]+") do
		local adr,bal = w:match('^(.-)%&bal=(.-)$')
--		debug_in_file(recentAddress .. ' ' .. bal .. ' ' .. adr .. '\n','c://1/kp.txt')
		t[i] = {}
		t[i].Address = w
		if inAdr == adr then
		return bal
		end
		i=i+1
    end
	return
end

function run_lite_qt_exfs()
--	stena_clear()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/media') or ''
	local tt = {
		{"","ПОИСК"},
		{"","История просмотра"},
		{"",". . ."},
		{"https://ex-fs.net/actors/","Актёры"},
		{"",". . ."},
		{"/film/","Фильмы"},
		{"/serials/","Сериалы"},
		{"/multfilm/","Мультфильмы"},
		{"/tv-show/","Передачи и шоу"},
		{"",". . . По странам"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Россия') .. "/","Российские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Индия') .. "/","Индийские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Канада') .. "/","Канадские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Украина') .. "/","Украинские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Турция') .. "/","Турецкие"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Корея_Южная') .. "/","Корейские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('США') .. "/","Американские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Франция') .. "/","Французские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Япония') .. "/","Японские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Великобритания') .. "/","Британские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Германия') .. "/","Немецкие"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('СССР') .. "/","СССР"},
		{"",". . . По жанрам"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фантастика') .. "/","Фантастика"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('аниме') .. "/","Аниме"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('биография') .. "/","Биография"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('боевик') .. "/","Боевик"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('вестерн') .. "/","Вестерн"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('военный') .. "/","Военный"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('детектив') .. "/","Детектив"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('детский') .. "/","Детский"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('для_взрослых') .. "/","Для взрослых"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('документальный') .. "/","Документальный"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('драма') .. "/","Драма"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('история') .. "/","История"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('комедия') .. "/","Комедия"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('короткометражка') .. "/","Короткометражка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('концерт') .. "/","Концерт"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('криминал') .. "/","Криминал"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('мелодрама') .. "/","Мелодрама"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('музыка') .. "/","Музыка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('мюзикл') .. "/","Мюзикл"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('новости') .. "/","Новости"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('приключения') .. "/","Приключения"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('реальное_ТВ') .. "/","Реальное ТВ"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('семейный') .. "/","Семейный"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('спорт') .. "/","Спорт"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('ток-шоу') .. "/","Ток-шоу"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('триллер') .. "/","Триллер"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('ужасы') .. "/","Ужасы"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фильм-нуар') .. "/","Фильм-Нуар"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('игра') .. "/","Игра"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фэнтези') .. "/","Фэнтези"},

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
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию EX-FS',0,t0,10000,1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		if t0[id].Name == 'ПОИСК' then
			search()
		elseif t0[id].Name == 'История просмотра' then
			EXFS_Get_History()
		elseif t0[id].Name == 'Актёры' then
			page_exfs(t0[id].Action)
		elseif t0[id].Action == '' then
			run_lite_qt_exfs()
		else
			page_exfs('https://ex-fs.net' .. t0[id].Action)
		end
	end
	if ret == 2 then
		media_info(last_adr)
	end
	if ret == 3 then
		run_westSide_portal()
	end
end

function page_exfs(inAdr)
--	debug_in_file(inAdr .. '\n------\n')
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name2,data2 = answer:match('ex%-fs%.net.+%s(_ym_uid)%s+(%S+)')
			local name3,data3 = answer:match('ex%-fs%.net.+%s(_ym_d)%s+(%S+)')
			local name4,data4 = answer:match('ex%-fs%.net.+%s(_ym_isad)%s+(%S+)')
			local name5,data5 = answer:match('ex%-fs%.net.+%s(PHPSESSID)%s+(%S+)')
			local name6,data6 = answer:match('ex%-fs%.net.+%s(dle_user_id)%s+(%S+)')
			local name7,data7 = answer:match('ex%-fs%.net.+%s(dle_password)%s+(%S+)')
			local name8,data8 = answer:match('ex%-fs%.net.+%s(dle_newpm)%s+(%S+)')

			if name2 and data2 and name3 and data3 and name4 and data4 and name5 and data5 and name6 and data6 and name7 and data7 and name8 and data8
			then str = name2 .. '=' .. data2 .. ';' .. name3 .. '=' .. data3 .. ';' .. name4 .. '=' .. data4 .. ';' .. name5 .. '=' .. data5 .. ';' .. name6 .. '=' .. data6 .. ';' .. name7 .. '=' .. data7 .. ';' .. name8 .. '=' .. data8
			else
			return ''
			end
			end
return str
end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local cookies = cookiesFromFile() or ''

	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.fromPercentEncoding(m_simpleTV.Common.multiByteToUTF8(inAdr,1251)), headers = 'Cookie: ' .. cookies})

		if rc ~= 200 then return end
--	m_simpleTV.Http.Close(session)
	answer = answer:gsub('\n%s+', '\n')
	local title = answer:match('<title>(.-)</title>') or 'EX-FS'

	if m_simpleTV.Common.isUTF8(title) == false then title = m_simpleTV.Common.multiByteToUTF8(title) end
	title = title:gsub('Смотреть кино ex ua, fs to фильмы онлайн бесплатно в хорошем HD качестве', 'Фильмы'):gsub(' смотреть онла.+', ''):gsub('^Сериал ', ''):gsub('%(.+', ''):gsub(' %&raquo;', ''):gsub('Смотреть ', ''):gsub(' онлайн бесплатно ', ''):gsub(' онлайн смотреть бесплатно в хорошем HD качестве', ''):gsub(' бесплатно в хорошем HD качестве', ''):gsub('Российские и Голливудские актеры%, актрисы%, знаменитости на EX%-FS%.NET', 'фильмы с актером | актрисой')
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t, i = {}, 1

			for w in answer:gmatch('<div class="MiniPostAllForm MiniPostAllFormDop.-">.-</div>\n</div>') do
			if w:match('<img src="') then
			local logo, adr, name = w:match('<img src="(.-)".-<a href="(.-)" title="(.-)"')
			local title1 = w:match('<img src=".-".-<a href=".-" title=".-".-title="(.-)"') or ''
			if title1 ~= '' then title1 = ' (' .. title1 .. ')' end
			local title2 = w:match('<img src=".-".-<a href=".-" title=".-".-title=".-".-title="(.-)"') or ''
			if title2 ~= '' then title2 = ', ' .. title2 end
			local group = ''
					if not adr or not name then break end
--				if m_simpleTV.Common.isUTF8(name) == false then name = m_simpleTV.Common.multiByteToUTF8(name) end
				t[i] = {}
				t[i].Id = i
--				t[i].Name = name:gsub(' /.+', '') .. title1
				t[i].Address = adr
				if not inAdr:match('/films/') and not inAdr:match('/series/') and not inAdr:match('/cartoon/') and not inAdr:match('/show/') then
				if adr:match('/film/') then group = ' - Фильм' end
				if adr:match('/serials/') then group = ' - Сериал' end
				if adr:match('/multfilm/') then group = ' - Мультфильм' end
				if adr:match('/tv%-show/') then group = ' - Передачи и шоу' end
				end
				t[i].Name = name:gsub(' /.+', '') .. title1 .. group
				t[i].InfoPanelLogo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
				t[i].InfoPanelName = name:gsub(' /.+', '') .. title1
				t[i].InfoPanelTitle = title1:gsub(' %(',''):gsub('%)','') .. title2
				t[i].InfoPanelShowTime = 10000

				i = i + 1
			end
			end
		if inAdr:match('/film/') then m_simpleTV.User.EXFS.stena_exfs_type = 'film'
		elseif inAdr:match('/serials/') then m_simpleTV.User.EXFS.stena_exfs_type = 'serials'
		elseif inAdr:match('/multfilm/') then m_simpleTV.User.EXFS.stena_exfs_type = 'multfilm'
		elseif inAdr:match('/tv%-show/') then m_simpleTV.User.EXFS.stena_exfs_type = 'show'
		elseif inAdr:match('/genre/') then m_simpleTV.User.EXFS.stena_exfs_type = 'genre'
		elseif inAdr:match('/country/') then m_simpleTV.User.EXFS.stena_exfs_type = 'genre'
		elseif inAdr:match('/year/') then m_simpleTV.User.EXFS.stena_exfs_type = 'genre'
		elseif inAdr:match('/producer/') then m_simpleTV.User.EXFS.stena_exfs_type = 'genre'
		elseif inAdr:match('/director/') then m_simpleTV.User.EXFS.stena_exfs_type = 'genre'
		elseif inAdr:match('/xfsearch/') then m_simpleTV.User.EXFS.stena_exfs_type = 'genre'
		elseif inAdr:match('/actors/') and not inAdr:match('/actors/%d+') then m_simpleTV.User.EXFS.stena_exfs_type = 'actors'
		elseif inAdr:match('/actors/%d+') then m_simpleTV.User.EXFS.stena_exfs_type = 'actor'
		end

		m_simpleTV.User.EXFS.stena_exfs_prev = nil
		m_simpleTV.User.EXFS.stena_exfs_next = nil
		m_simpleTV.User.EXFS.stena_exfs_current_page_karusel = nil
		m_simpleTV.User.EXFS.stena_exfs_current_page_adr = inAdr:gsub('/page/.-$','/')
		local prev_pg = answer:gsub('^.-<div class="navigations">',''):match('</a>   <a href="(.-)">Назад</a>') or answer:gsub('^.-<div class="navigations">',''):match('/span>    <a href="(.-)">Назад</a>')
		local next_pg = answer:gsub('^.-<div class="navigations">',''):match('</a> <a href="(.-)">Вперед</a>') or answer:gsub('^.-<div class="navigations">',''):match('/span><a href="(.-)">Вперед</a>')
		local all_pg = answer:match('"navigations"') and (answer:gsub('^.-<div class="navigations">',''):match('(%d+)</a>   ') or answer:gsub('^.-<div class="navigations">',''):match('<span>(%d+)</span>')) or 1
		local current_page = inAdr:match('/page/(%d+)/') or 1
		m_simpleTV.User.EXFS.stena_exfs_current_page = current_page
		m_simpleTV.User.EXFS.stena_exfs_all_pg = all_pg
		if tonumber(current_page) > 1 and not title:match('траница') then title = title .. ' страница - ' .. current_page end
		if next_pg then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.EXFS.stena_exfs_next = inAdr:gsub('/page/.-$',''):gsub('/$','') .. '/page/' .. current_page+1 .. '/'
		end
		if prev_pg then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.EXFS.stena_exfs_prev = inAdr:gsub('/page/.-$',''):gsub('/$','') .. '/page/' .. current_page-1 .. '/'
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		end

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		if inAdr:match('/actors/%d+') then
		all_pg = ' - ' .. #t
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '💾'}
		else all_pg = ' из ' .. all_pg .. ' стр.'
		end

		m_simpleTV.User.EXFS.stena_exfs = t
		m_simpleTV.User.EXFS.stena_exfs_title = title .. all_pg
		m_simpleTV.User.EXFS.stena_exfs_old_adr = inAdr
		if create_stena_for_exfs then return create_stena_for_exfs() end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. all_pg, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Address:match('/actors/') then
		page_exfs(t[id].Address)
		else
		media_info(t[id].Address)
		end
		end
		if ret == 2 then
		if prev_pg then
		page_exfs(inAdr:gsub('/page/.-$','/') .. 'page/' .. current_page-1 .. '/')
		elseif inAdr:match('/actors/%d+') then
		page_exfs('https://ex-fs.net/actors/')
		else
		run_lite_qt_exfs()
		end
		end
		if ret == 3 then
		if inAdr:match('/actors/%d+') then
		setConfigVal('person/rezka',inAdr)
		UpdatePersonEXFS()
		return
		else
		page_exfs(inAdr:gsub('/page/.-$','/') .. 'page/' .. current_page+1 .. '/')
		end
		end
		end

function get_media_info(inAdr)

	m_simpleTV.User.EXFS.TestAddress = inAdr
--		stena_clear()
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then
		tooltip_body = ''
	else
		tooltip_body = 'bgcolor="#434750"'
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local function cookiesFromFile()
		local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
		local file = io.open(path, 'r')
		if not file then
			return ''
			else
			local answer = file:read('*a')
			file:close()

			local name2,data2 = answer:match('ex%-fs%.net.+%s(_ym_uid)%s+(%S+)')
			local name3,data3 = answer:match('ex%-fs%.net.+%s(_ym_d)%s+(%S+)')
			local name4,data4 = answer:match('ex%-fs%.net.+%s(_ym_isad)%s+(%S+)')
			local name5,data5 = answer:match('ex%-fs%.net.+%s(PHPSESSID)%s+(%S+)')
			local name6,data6 = answer:match('ex%-fs%.net.+%s(dle_user_id)%s+(%S+)')
			local name7,data7 = answer:match('ex%-fs%.net.+%s(dle_password)%s+(%S+)')
			local name8,data8 = answer:match('ex%-fs%.net.+%s(dle_newpm)%s+(%S+)')

			if name2 and data2 and name3 and data3 and name4 and data4 and name5 and data5 and name6 and data6 and name7 and data7 and name8 and data8 then
				str = name2 .. '=' .. data2 .. ';' .. name3 .. '=' .. data3 .. ';' .. name4 .. '=' .. data4 .. ';' .. name5 .. '=' .. data5 .. ';' .. name6 .. '=' .. data6 .. ';' .. name7 .. '=' .. data7 .. ';' .. name8 .. '=' .. data8
			else
				return ''
			end
		end
		return str
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local cookies = cookiesFromFile() or ''

	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.fromPercentEncoding(m_simpleTV.Common.multiByteToUTF8(inAdr,1251)), headers = 'Cookie: ' .. cookies})

		if rc ~= 200 then return end
--	m_simpleTV.Http.Close(session)
--	answer = answer:gsub('\n', ' ')
	local kp_id = answer:match('data%-kinopoisk="(%d+)"') or answer:match('/kp/(%d+)') or answer:match('kp_id=(%d+)')
	local imdb_id = answer:match('(tt%d+)')
	m_simpleTV.User.EXFS.collaps = nil
	m_simpleTV.User.EXFS.lumex = nil
	local collaps = answer:match('<iframe src="(https://api%..-)"')
	local lumex = answer:match('<iframe src="(//p%..-)"')
	if collaps then
		m_simpleTV.User.EXFS.collaps = collaps:gsub('https://.-/','https://api.kinogram.best/')
	end
	if lumex then
		lumex = 'https:' .. lumex
		m_simpleTV.User.EXFS.lumex = lumex
	end
	local desc = answer:match('<meta name="description" content="(.-)"') or ''
	local poster = answer:match('<div class="FullstoryForm">.-<img src="(.-)"') or ''
	poster = 'https://ex-fs.net' .. poster:gsub('https://ex%-fs%.net','')
	local title_rus = answer:match('<h1 class="view%-caption">(.-)</h1>') or ''
	title_rus = title_rus:gsub(' смотреть онлайн','')
	local title_eng = answer:match('<h2 class="view%-caption2">(.-)</h2>') or ''
	local kpr = answer:match('<div class="in_name_kp">(.-)</div>') or ''
	local imdbr = answer:match('<div class="in_name_imdb">(.-)</div>') or ''
	local year = answer:match('<p class="FullstoryInfoin"><a href="/year/.-" title="(.-)"') or ''
	local age = answer:match('infoi_age">(.-)</p>') or '0+'
	local all_time = answer:match('Время%:</h4>.-"FullstoryInfoin">(.-)</p>') or ''
	local desc1 = answer:match('<div class="FullstorySubFormText">(.-)</div>') or desc
	local desc_right = answer:match('<div class="TabDopInfoRight">(.-)<div class="clear">') or ''
	desc_right = desc_right:gsub(':</div>',': '):gsub('<.->',''):gsub('\n%s+','\n'):gsub('\n\n','\n'):gsub('\n\n','\n'):gsub('\n\n','\n'):gsub('\n\n','\n'):gsub('^\n',''):gsub('%,\n','\n'):gsub('\n$','')
--	debug_in_file(desc_right .. '\n---------\n')
	if not m_simpleTV.User.EXFS then
		m_simpleTV.User.EXFS = {}
	end
	m_simpleTV.User.EXFS.desc_right = desc_right
	m_simpleTV.User.EXFS.logo = poster
	m_simpleTV.User.EXFS.title1 = title_rus
	m_simpleTV.User.EXFS.EXFS_overview = desc1:gsub('&nbsp%;', ' '):gsub('<br />', ''):gsub('\n%s+', '\n'):gsub('\n\n', '\n'):gsub('\n\n', '\n')
	m_simpleTV.User.EXFS.all_time = ''
	if all_time ~= '' then
		m_simpleTV.User.EXFS.all_time = ' ● ' .. all_time
	end

	if mpaa ~= '' then
		m_simpleTV.User.EXFS.age = ' ● ' .. age
	end
	m_simpleTV.User.EXFS.title = title_rus:gsub(' /.-$','')
	m_simpleTV.User.EXFS.original_title = title_eng
	m_simpleTV.User.EXFS.EXFS_country = {}
	m_simpleTV.User.EXFS.EXFS_genres = {}
	m_simpleTV.User.EXFS.EXFS_person = {}
	m_simpleTV.User.EXFS.EXFS_dir = {}
	m_simpleTV.User.EXFS.year = year
	m_simpleTV.User.EXFS.EXFS_ret_KP = kpr
	m_simpleTV.User.EXFS.EXFS_ret_imdb = imdbr
	m_simpleTV.User.EXFS.id_KP = kp_id
	m_simpleTV.User.EXFS.id_IMDB = imdb_id
	m_simpleTV.User.EXFS.EXFS_zf = nil
	m_simpleTV.User.EXFS.EXFS_vf = nil
	m_simpleTV.User.EXFS.EXFS_tr = nil
	m_simpleTV.User.EXFS.EXFS_vv = nil
	m_simpleTV.User.EXFS.EXFS_mg = nil
	m_simpleTV.User.EXFS.EXFS_hdvb = nil
	m_simpleTV.User.hdvb = {}
	m_simpleTV.User.EXFS.EXFS_ashdi = nil
	m_simpleTV.User.EXFS.EXFS_fx = nil
	m_simpleTV.User.EXFS.EXFS_kodik = nil
	m_simpleTV.User.EXFS.EXFS_is_thumb = nil
	m_simpleTV.User.EXFS.balansers = nil
	m_simpleTV.User.EXFS.trackers = nil
	m_simpleTV.User.EXFS.country = ''
	m_simpleTV.User.EXFS.genres = ''
	m_simpleTV.User.EXFS.person = ''
	m_simpleTV.User.EXFS.dir = ''

	desc1 = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. title_rus:gsub(' /.-$','') .. '</font></h4><h5><font color=#BBBBBB>' .. title_eng .. '</font></h5><h5><font color=#E0FFFF>' .. year .. ' • ' .. age .. ' • Кинопоиск: ' .. kpr .. ' • IMDb: ' .. imdbr .. '</font></h5><h5><font color=#E0FFFF>' .. all_time .. '</font></h5><h4><font color=#EBEBEB>' .. desc1:gsub('<br />','<p>') .. '</font></h4></td></tr></table>'
	local answer1 = answer:match('<div class="FullstoryInfo">(.-)</div>') or ''
	local answer2 = answer:match('<div class="FullstoryKadrFormImgAc">(.-)</div>') or ''
	local answer3 = answer:match('<div class="RelatedFormTitle">(.-)<script') or ''
	local title = title_rus:gsub(' /.-$','') .. ' (' .. year .. ')'
	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title or 'EX-FS info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. desc1 .. '</body></html>'
		t1[1].InfoPanelTitle = desc
		t1[1].InfoPanelShowTime = 10000

		if kp_id and kp_id~=0 then
			local balanser = Get_Trailer(kp_id)
			if balanser then
			m_simpleTV.User.EXFS.EXFS_tr = inAdr .. '&' .. balanser
			t1[j] = {}
			t1[j].Id = j
--			t1[j].Address = balanser
			t1[j].Address = 'kp_trailer=' .. kp_id .. '&' .. inAdr
			t1[j].Name = 'Online: Trailer'
			j = j + 1
			end
		end

		if kp_id and kp_id~=0 then
			local balanser = Get_ZF(kp_id)
			if balanser then
			m_simpleTV.User.EXFS.EXFS_zf = inAdr .. '&' .. balanser


			t1[j] = {}
			t1[j].Id = j
			t1[j].Address = balanser
			t1[j].Name = 'Online: ZF'
			j = j + 1
			end
		end

		if kp_id and kp_id~=0 or imdb_id then
			local my_id = kp_id or imdb_id
			local balanser = Get_VF(my_id)
			if balanser then
			m_simpleTV.User.EXFS.EXFS_vf = inAdr .. '&' .. balanser


			t1[j] = {}
			t1[j].Id = j
			t1[j].Address = balanser
			t1[j].Name = 'Online: VF'
			j = j + 1
			end
			m_simpleTV.User.EXFS.EXFS_is_thumb = get_is_thumb(my_id)
		end
--		Get_Collaps(kp_id)
--[[
		if kp_id and kp_id~=0 then
			local balanser = Get_VeoVeo(kp_id)
			if balanser then
			m_simpleTV.User.EXFS.EXFS_vv = inAdr .. '&' .. balanser


			t1[j] = {}
			t1[j].Id = j
			t1[j].Address = balanser
			t1[j].Name = 'Online: VV'
			j = j + 1
			end
		end
			local add_kp, add_imdb
			if not kp_id or kp_id==0 then add_kp = '' else add_kp = kp_id end
			if not imdb_id then add_imdb = '' else add_imdb = imdb_id end
			local balanser = Get_FX(title_rus:gsub(' /.-$',''), year, add_kp, add_imdb)
			if balanser then
			m_simpleTV.User.EXFS.EXFS_fx = inAdr .. '&' .. balanser
			t1[j] = {}
			t1[j].Id = j
			t1[j].Address = balanser
			t1[j].Name = 'Online: FX'
			j = j + 1
			end--]]

		local c, g, p, r = 1, 1, 1, 1
		for w1 in answer1:gmatch('<a href=".-</a>') do
		local adr,name = w1:match('<a href="(.-)" title="(.-)"')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://ex-fs.net' .. adr
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
			if adr:match('/country/') then
				m_simpleTV.User.EXFS.EXFS_country[c] = t1[j]
				m_simpleTV.User.EXFS.EXFS_country[c].Id = c
				m_simpleTV.User.EXFS.country = m_simpleTV.User.EXFS.country .. m_simpleTV.User.EXFS.EXFS_country[c].Name .. ', '
				c=c+1
			end
			if adr:match('/genre/') and not name:match('на украинском') and not name:match('українська мова') then
				m_simpleTV.User.EXFS.EXFS_genres[g] = t1[j]
				m_simpleTV.User.EXFS.EXFS_genres[g].Id = g
				m_simpleTV.User.EXFS.genres = m_simpleTV.User.EXFS.genres .. m_simpleTV.User.EXFS.EXFS_genres[g].Name .. ', '
				g=g+1
			end
		j=j+1
		end
		for w2 in answer2:gmatch('<a href=".-</a>') do
		local adr,logo,name = w2:match('<a href="(.-)".-<img src="(.-)".-title="(.-)"')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
		t1[j].InfoPanelLogo = 'https://ex-fs.net' .. logo:gsub('^.-ex%-fs%.net','')
		t1[j].InfoPanelName = t1[j].Name
		t1[j].InfoPanelShowTime = 10000
		if adr:match('/actors/') then
			m_simpleTV.User.EXFS.EXFS_person[p] = t1[j]
			m_simpleTV.User.EXFS.EXFS_person[p].Id = p
			m_simpleTV.User.EXFS.person = m_simpleTV.User.EXFS.person .. m_simpleTV.User.EXFS.EXFS_person[p].Name .. ', '
			p=p+1
		end
		j=j+1
		end
		for w3 in answer3:gmatch('<img src=".-<a href=".-</a>') do
		local logo,adr,name = w3:match('<a href="(.-)".-<img src="(.-)".-title="(.-)"')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = 'Похожий контент: ' .. name:gsub('&#039;',"'"):gsub('&amp;',"&")
		t1[j].InfoPanelLogo = 'https://ex-fs.net' .. logo:gsub('^https://ex%-fs%.net','')
		t1[j].InfoPanelName = t1[j].Name
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end
		for w4 in answer:gmatch('<div class="TabDopInfoBlockOne">.-</div>\n') do
			local name1 = w4:match('<div class="TabDopInfoBlockOneTitle">(.-)</div>')
			if not name1 or name1:match('Зрители') then break end
			m_simpleTV.User.EXFS.dir = m_simpleTV.User.EXFS.dir .. name1 .. ' '
			for w5 in w4:gmatch('<a href=.-</a>') do
				local adr,name = w5:match('<a href="(.-)".->(.-)<')
				if not adr or not name then break end
				t1[j] = {}
				t1[j].Id = j
				t1[j].Address = 'https://ex-fs.net' .. adr:gsub('https://ex%-fs%.net', '')
				t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
				t1[j].InfoPanelName = name1
--				if adr:match('/produser/') then
					m_simpleTV.User.EXFS.EXFS_dir[r] = t1[j]
					m_simpleTV.User.EXFS.EXFS_dir[r].Id = r
					m_simpleTV.User.EXFS.dir = m_simpleTV.User.EXFS.dir .. m_simpleTV.User.EXFS.EXFS_dir[r].Name .. ', '
					r=r+1
--				end
				j=j+1
			end
			m_simpleTV.User.EXFS.dir = m_simpleTV.User.EXFS.dir:gsub('%, $', '\n')
		end
--		debug_in_file(m_simpleTV.User.EXFS.dir .. '\n')
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀 '}
		if kp_id and kp_id~=0 then
			t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Кинопоиск'}
		end
		for j=1,#t1 do
			t1[j].Id = j
--			debug_in_file(t1[j].Id .. ' ' .. t1[j].Name .. ' ' .. t1[j].Address .. '\n' )
		end
--		debug_in_file('\n`````````````````\n' )
--		info_exfs()
		return t1, title
end

function media_info(inAdr)
		local t1, title = get_media_info(inAdr)
		dofile(m_simpleTV.MainScriptDir .. 'user/westSidePortal/startup/Lite_qt_exfs.lua')
		if info_exfs then return info_exfs() end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('EX-FS: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
				media_info(inAdr)
			elseif t1[id].Name:match('Похожий контент') then
				media_info(t1[id].Address)
			elseif t1[id].Name:match('Online:') then
				setConfigVal('info/media',inAdr)
				setConfigVal('info/scheme','EXFS')
				m_simpleTV.Control.PlayAddressT({address=t1[id].Address, title=title})
			else
				page_exfs(t1[id].Address .. '/')
			end
		end
		if ret == 2 then
			if m_simpleTV.User.EXFS.stena_exfs_old_adr then
				page_exfs(m_simpleTV.User.EXFS.stena_exfs_old_adr)
			else
				run_lite_qt_exfs()
			end
		end
		if ret == 3 then
			m_simpleTV.Control.PlayAddressT({address=inAdr, title=title})
--			Get_Kinopoisk(title_rus, year, kp_id, inAdr)
		end
end

function Get_Kinopoisk(title_rus, year, kp_id, inAdr, logo)

	local function is_balanser(name)

		local tname = {}

		if not m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini') or tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 1 then
-- сокращенная база
			tname = {
-- сортировать: поменять порядок строк
-- отключить: поставить в начале строки --
					'VF',
					'ZF',
--					'HDVB',
--					'Kodik',
--					'FX',
--					'Ashdi',
--					'Magnets',
--					'Trailer',
					}
		elseif tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 2 then
-- полная база
			tname = {
					'VF',
					'ZF',
					'HDVB',
					'Kodik',
					'FX',
					'Ashdi',
					'Magnets',
--					'Trailer',
					}
		end

		for i = 1,#tname do
			if tname[i] == name then
				return true
			end
		end
		return false
	end

	local t,i = {},1
	local VF, ZF, HDVB, Collaps, FX, Ashdi, Magnets, Trailer
	if is_balanser('VF') then
		VF = Get_VF(kp_id)
		if VF then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'VF'
			t[i].Address = VF
			i = i + 1
		end
	end
	if is_balanser('ZF') then
		ZF = Get_ZF(kp_id)
		if ZF then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'ZF'
			t[i].Address = ZF
			i = i + 1
		end
	end
	if is_balanser('HDVB') then
		HDVB = Get_HDVB(kp_id)
		if HDVB then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'HDVB'
			t[i].Address = HDVB
			i = i + 1
		end
	end
	if is_balanser('Collaps') then
		Collaps = Get_Collaps(kp_id)
		if Collaps then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'Collaps'
			t[i].Address = Collaps
			i = i + 1
		end
	end
	if is_balanser('FX') then
		FX = Get_FX(title_rus, year, kp_id)
		if FX then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'FX'
			t[i].Address = FX
			i = i + 1
		end
	end
	if is_balanser('Ashdi') then
		Ashdi = Get_Ashdi(kp_id)
		if Ashdi then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'Ashdi'
			t[i].Address = Ashdi
			i = i + 1
		end
	end
	if is_balanser('Magnets') then
		Magnets = Get_Pirring(title_rus, year, kp_id)
		if Magnets then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'Magnets'
			t[i].Address = Magnets
			i = i + 1
		end
	end
	if is_balanser('Trailer') then
		Trailer = Get_Trailer(kp_id)
		if Trailer then
			t[i] = {}
			t[i].Id = i
			t[i].Name = 'Trailer'
			t[i].Address = 'kp_trailer=' .. kp_id
			i = i + 1
		end
	end
	local current_id = 1
	local current_bal = find_in_history_exfs(inAdr)
	if current_bal then
		for j = 1,#t do
			if current_bal == t[j].Name then
				current_id = j
				break
			end
		end
	end
	if #t == 0 then
		if not m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini') or tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 1 then
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'EX-FS: Задействуйте полную базу', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			return mediabaze()
		elseif tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 2 then
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'EX-FS: Медиаконтент пока не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			return media_info(inAdr)
		end
	end
	if #t > 1 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' EX-FS '}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('🎬 ' .. title_rus .. ' (' .. year .. ')',tonumber(current_id)-1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end

		if ret == 1 then
			add_to_history_exfs(inAdr .. '&bal=' .. t[id].Name, title_rus .. ' (' .. year .. ')', logo)
			if type(t[id].Address) == 'table' then
				local t1 = t[id].Address
				if #t1 > 1 then
				local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', 0, t1, 10000, 1 + 4 + 8 + 2)
				id = id or 1
				if ret == 1 then
					if not m_simpleTV.User.hdvb then
						m_simpleTV.User.hdvb = {}
					end
					m_simpleTV.User.hdvb.transl_selected = true
					m_simpleTV.User.hdvb.transl_name = t1[id].Name
					m_simpleTV.Control.SetNewAddressT({address= t1[id].Address, title=title_rus .. ' (' .. year .. ')'})
				end
				else
					m_simpleTV.Control.SetNewAddressT({address= t[id].Address[1].Address, title=title_rus .. ' (' .. year .. ')'})
				end
			elseif t[id].Name == 'Magnets' then
				content(t[id].Address)
			else
				m_simpleTV.Control.SetNewAddressT({address= t[id].Address, title=title_rus .. ' (' .. year .. ')'})
			end
		end
		if ret == 2 then
			return media_info(inAdr)
		end
		if ret == 3 then
			return run_lite_qt_exfs()
		end
	else
		add_to_history_exfs(inAdr .. '&bal=' .. t[1].Name, title_rus .. ' (' .. year .. ')', logo)
		if type(t[1].Address) == 'table' then
			local t1 = t[1].Address
			if #t1 > 1 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', 0, t1, 10000, 1 + 4 + 8 + 2)
			id = id or 1
			if ret == 1 then
				if not m_simpleTV.User.hdvb then
					m_simpleTV.User.hdvb = {}
				end
				m_simpleTV.User.hdvb.transl_selected = true
				m_simpleTV.User.hdvb.transl_name = t1[id].Name
				m_simpleTV.Control.SetNewAddressT({address= t1[id].Address, title=title_rus .. ' (' .. year .. ')'})
			end
			else
				m_simpleTV.Control.SetNewAddressT({address= t[1].Address[1].Address, title=title_rus .. ' (' .. year .. ')'})
			end
		elseif t[1].Name == 'Magnets' then
			content(t[1].Address)
		else
			m_simpleTV.Control.SetNewAddressT({address= t[1].Address, title=title_rus .. ' (' .. year .. ')'})
		end
	end
end

function EXFS_Get_History()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- wafee code for history

    local recentName = getConfigVal('exfs_history/title') or ''
    local recentAddress = getConfigVal('exfs_history/adr') or ''
	local recentLogo = getConfigVal('exfs_history/logo') or ''

     local t,i={},1

   if recentName~='' and recentLogo~='' and recentAddress~='' then
     for w in string.gmatch(recentName,"[^%|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
	   t[i].InfoPanelName = w
	   t[i].InfoPanelShowTime = 10000
       i=i+1
     end
     i=1
     for w in string.gmatch(recentAddress,"[^%|]+") do
       t[i].Address = w
	   t[i].InfoPanelTitle = w:match('%&bal=(.-)$')
       i=i+1
     end
	 i=1
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t[i].InfoPanelLogo = w
       i=i+1
     end
   end

		m_simpleTV.User.EXFS.stena_exfs_type = 'view'
		m_simpleTV.User.EXFS.stena_exfs_prev = nil
		m_simpleTV.User.EXFS.stena_exfs_next = nil
		m_simpleTV.User.EXFS.stena_exfs_current_page_karusel = nil
		m_simpleTV.User.EXFS.stena_exfs_current_page_adr = nil
		m_simpleTV.User.EXFS.stena_exfs = t
		m_simpleTV.User.EXFS.stena_exfs_title = 'EX-FS: история просмотра - ' .. #t
		m_simpleTV.User.EXFS.stena_exfs_current_page = 1
		m_simpleTV.User.EXFS.stena_exfs_all_pg = 1
		if create_stena_for_exfs then return create_stena_for_exfs() end

   t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
   t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Cleane '}
   local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('EX-FS: История просмотра',0,t,9000,1+4+8)
   if id==nil then
   run_westSide_portal()
   end
   if ret==1 then
      m_simpleTV.Control.PlayAddressT({address = t[id].Address:gsub('%&bal=.-$',''),title = t[id].Name})
   end
   if ret==2 then
	  run_westSide_portal()
   end
   if ret==3 then
      setConfigVal('exfs_history/title','')
	  setConfigVal('exfs_history/logo','')
	  setConfigVal('exfs_history/adr','')
	  start_page_mediaportal()
   end
end

function add_to_history_exfs(adr,title,logo)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- wafee code for history
	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = getConfigVal('exfs_history/title') or ''
    local recentAddress = getConfigVal('exfs_history/adr') or ''
	local recentLogo = getConfigVal('exfs_history/logo') or ''
     local t={}
     local tt={}
     local i=2
	 t[1] = {}
     t[1].Id = 1
     t[1].Name = title
	 t[1].Address = adr
	 t[1].Logo = logo
   if recentName~='' and recentLogo~='' and recentAddress~='' then

     for w in string.gmatch(recentName,"[^%|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
       i=i+1
     end
     i=2
     for w in string.gmatch(recentAddress,"[^%|]+") do
       t[i].Address = w
       i=i+1
     end
	 i=2
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t[i].Logo = w
       i=i+1
     end

     local function isExistAdr()
       for i=2,#t do
         if adr:gsub('%&bal=.-$','')==t[i].Address:gsub('%&bal=.-$','') then
           return true, i
         end
       end
       return false
     end

     local isExist,i=isExistAdr()
     if isExist then
       table.remove(t,i)
     end

     recentName=''
     recentAddress = ''
     recentLogo = ''

	 if #t <= tonumber(max_history) then
		cur_max = #t
	 else
		cur_max = tonumber(max_history)
	 end

     for i=1,cur_max  do
      local name = t[i].Name
      t[i].Name = t[i].Name:gsub('@@@@@',',')
      recentName = recentName .. name .. '|'
      recentAddress = recentAddress .. t[i].Address .. '|'
	  recentLogo = recentLogo .. t[i].Logo .. '|'
      t[i].Id = i
--      debug_in_file('fromOSDmenu = ' .. t[i].Id .. ' ' .. t[i].Name .. ' ' .. t[i].Address .. '\n','c://1/kp.txt')
     end

	 setConfigVal('exfs_history/title',recentName)
	 setConfigVal('exfs_history/logo',recentLogo)
	 setConfigVal('exfs_history/adr',recentAddress)

	 else

	 setConfigVal('exfs_history/title',title .. '|')
	 setConfigVal('exfs_history/logo',logo .. '|')
	 setConfigVal('exfs_history/adr',adr .. '|')

   end
end

function UpdatePersonEXFS()
	if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
		local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
		for SID, v in pairs(tmp_sources) do
			 if v.name:find('PERSONS') then
				tvs_core.UpdateSource(SID, false)
				tvs_func.OSD_mess('', -2)
			 end
		end
	end
end

function media_info_EXFS_from_stena(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if adr and adr ~= '' and not adr:match('/actors/') then
		return media_info(adr:match('^(http.-%.html)'))
	end
	if adr and adr ~= '' and adr:match('/actors/') then
		return page_exfs(adr)
	end
	return
end

function set_page_exfs()
	local t = {}
	for i = 1,tonumber(m_simpleTV.User.EXFS.stena_exfs_all_pg) do
		t[i] = {}
		t[i].Id = i
		t[i].Name = i
	end
	m_simpleTV.Common.Sleep(200)
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.EXFS.stena_exfs_current_page)-1, t, 5000, 'ALWAYS_OK | MODAL_MODE')
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		return page_exfs(m_simpleTV.User.EXFS.stena_exfs_current_page_adr:gsub('/page/.-$',''):gsub('/$','') .. '/page/' .. id .. '/')
	end
	return
end

function get_page_exfs(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if adr and adr ~= '' then
		return page_exfs(adr)
	end
	return
end

function create_stena_for_exfs()

--if m_simpleTV.User.EXFS.stena == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_exfs_use = true
	m_simpleTV.User.TVPortal.stena_exfs_info = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.cur_content_adr = nil
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
			m_simpleTV.OSD.RemoveElement('ID_DIV_TRAILER')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_EXFS_ID')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR3_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR4_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR5_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR6_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_EXFS_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_EXFS_WS')


	local  t, AddElement = {}, m_simpleTV.OSD.AddElement

				 t = {}
				 t.id = 'STENA_CLEAR1_TOOLTIP_EXFS_WS'
				 t.cx=15
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=80
				 t.top=0
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x000000ff --for test
--				 t.backcolor1 = 0x66000000 --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_EXFS_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR2_TOOLTIP_EXFS_WS'
				 t.cx=15
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=95
				 t.top=0
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x66000000 --for test
--				 t.backcolor1 = 0x000000ff --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_EXFS_WS'
				 AddElement(t)

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
				 t.mousePressEventFunction = 'start_page_mediaportal'
				 AddElement(t,'ID_DIV_STENA_1')

				 t = {}
				 t.id = 'SELECT_TITLE_STENA_ID'
				 t.cx= 60
				 t.cy= 60
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/font.png'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=30
				 t.top=100
				 t.transparency = 255
				 t.zorder=2
				 t.isInteractive = true
				 t.borderwidth = 2
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
				 t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				 t.mousePressEventFunction = 'get_title_font'
				 AddElement(t,'ID_DIV_STENA_1')

				 t={}
				 t.id = 'TEXT_STENA_TITLE_ID'
				 t.cx=-66
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0102
				 if m_simpleTV.User.EXFS.stena_exfs_type == 'actor' or m_simpleTV.User.EXFS.stena_exfs_type == 'view' then
				 t.text = m_simpleTV.User.EXFS.stena_exfs_title .. ' (' .. (m_simpleTV.User.EXFS.stena_exfs_current_page_karusel or 1) .. '/' .. math.ceil(#m_simpleTV.User.EXFS.stena_exfs/30) .. ')'
				 else
				 t.text = m_simpleTV.User.EXFS.stena_exfs_title
				 end
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or "Segoe UI Black"
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
--				 t.isInteractive = true
--				 t.cursorShape = 13
--				 t.mousePressEventFunction = 'get_title_font'
				 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'EXFS_MOVIE_IMG_ID&https://ex-fs.net/film/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/movie.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 180
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
				if m_simpleTV.User.EXFS.stena_exfs_type == 'film' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'EXFS_TV_IMG_ID&https://ex-fs.net/serials/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tv.png'
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
				if m_simpleTV.User.EXFS.stena_exfs_type == 'serials' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'EXFS_MULT_IMG_ID&https://ex-fs.net/multfilm/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/mult.png'
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
				if m_simpleTV.User.EXFS.stena_exfs_type == 'multfilm' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SHOW_IMG_ID&https://ex-fs.net/tv-show/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/multserial.png'
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
				if m_simpleTV.User.EXFS.stena_exfs_type == 'show' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
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
				if m_simpleTV.User.EXFS.stena_exfs_type:match('genre') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'select_genres'
--				t.mousePressEventFunction = 'run_lite_qt_exfs'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_PERSONS_IMG_ID&https://ex-fs.net/actors/'
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
				if m_simpleTV.User.EXFS.stena_exfs_type:match('actor') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_EXFS_IMG_ID'
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'stena_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_HISTORY_EXFS_IMG_ID'
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_history_of_search'
				AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.EXFS.stena_exfs_type == 'actor' or m_simpleTV.User.EXFS.stena_exfs_type == 'search' or m_simpleTV.User.EXFS.stena_exfs_type == 'view' then

				if m_simpleTV.User.EXFS.stena_exfs_type == 'actor' then
					t = {}
					t.id = 'STENA_UPDATE_PERSON_EXFS_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/saveplst.png'
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
					t.mousePressEventFunction = 'UpdatePersonEXFS_id'
					AddElement(t,'ID_DIV_STENA_1')
				end
				if m_simpleTV.User.EXFS.stena_exfs_type == 'view' then
					t = {}
					t.id = 'STENA_VIEW_HISTORY_EXFS_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/View_History.png'
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
					if m_simpleTV.User.EXFS.stena_exfs_type == 'view' then
					t.bordercolor = -1250336
					t.borderwidth = 4
					end
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
					t.mousePressEventFunction = 'EXFS_Get_History'
					AddElement(t,'ID_DIV_STENA_1')
				end
				m_simpleTV.User.EXFS.stena_exfs_max_num_karusel = math.ceil(#m_simpleTV.User.EXFS.stena_exfs/30)

				m_simpleTV.User.EXFS.stena_exfs_prev_karusel_num = nil
				m_simpleTV.User.EXFS.stena_exfs_next_karusel_num = nil

				m_simpleTV.User.EXFS.stena_exfs_current_page_karusel = m_simpleTV.User.EXFS.stena_exfs_current_page_karusel or 1

				if tonumber(m_simpleTV.User.EXFS.stena_exfs_current_page_karusel) < tonumber(m_simpleTV.User.EXFS.stena_exfs_max_num_karusel) then
					m_simpleTV.User.EXFS.stena_exfs_next_karusel_num = tonumber(m_simpleTV.User.EXFS.stena_exfs_current_page_karusel) + 1
				end
				if tonumber(m_simpleTV.User.EXFS.stena_exfs_current_page_karusel) > 1 then
					m_simpleTV.User.EXFS.stena_exfs_prev_karusel_num = tonumber(m_simpleTV.User.EXFS.stena_exfs_current_page_karusel) - 1
				end
				if m_simpleTV.User.EXFS.stena_exfs_prev_karusel_num then
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'for_create_stena_for_exfs'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.EXFS.stena_exfs_next_karusel_num then
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'for_create_stena_for_exfs'
				AddElement(t,'ID_DIV_STENA_1')
				end
			else
				if m_simpleTV.User.EXFS.stena_exfs_all_pg and tonumber(m_simpleTV.User.EXFS.stena_exfs_all_pg) > 1 then
				t = {}
				t.id = 'STENA_SELECT_PAGE_EXFS_IMG_ID'
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'set_page_exfs'
				AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'STENA_SELECT_PAGE_EXFS_TXT_ID'
					t.cx=60
					t.cy=60
					t.class="TEXT"
					t.text = m_simpleTV.User.EXFS.stena_exfs_current_page
					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 60
					t.left = 0
					t.top  = -15
					t.zorder=2
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
--					t.mouseMoveEventFunction = 'tooltip_WS'
--[[					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'select_other_rezka_page'
					else
						t.mousePressEventFunction = 'select_rezka_page'
					end--]]
					AddElement(t,'STENA_SELECT_PAGE_EXFS_IMG_ID')

				end
			end

				if m_simpleTV.User.EXFS.stena_exfs_prev then
				t = {}
				t.id = 'STENA_PREV_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs_prev
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.EXFS.stena_exfs_next then
				t = {}
				t.id = 'STENA_NEXT_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs_next
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_page_exfs'
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
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'stena_clear'
				AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.EXFS.stena_exfs_type ~= 'select_genre' then
				local dn = 10
				local dx = 1800/dn
				local dy = 1800/dn*1.5
				local j_start, j_end = 1, 30
				if m_simpleTV.User.EXFS.stena_exfs_type == 'actor' or m_simpleTV.User.EXFS.stena_exfs_type == 'search' or m_simpleTV.User.EXFS.stena_exfs_type == 'view' then
					j_start = (tonumber(m_simpleTV.User.EXFS.stena_exfs_current_page_karusel) - 1) * 30 + 1
					j_end = tonumber(j_start) + 29
				end
				for j = j_start, j_end do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil((j - j_start + 1)/dn)

					if not m_simpleTV.User.EXFS.stena_exfs[j] then break end
					t = {}
					t.id = j .. '_STENA_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 55
					t.class="IMAGE"
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 55) + 100
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					t.background_UnderMouse = 2
					t.backcolor1_UnderMouse = 0x994169E1
					t.backcolor0_UnderMouse = 0x224169E1
					t.mousePressEventFunction = 'media_info_EXFS_from_stena'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = j .. '_STENA_EXFS_LOGO_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address
					t.cx=dx-10
					t.cy=dy-10
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.EXFS.stena_exfs[j].InfoPanelLogo
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0102
					t.left = 1
					t.top  = 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address)

					if m_simpleTV.User.EXFS.stena_exfs_type == 'actor' or m_simpleTV.User.EXFS.stena_exfs_type == 'genre' or m_simpleTV.User.EXFS.stena_exfs_type == 'search' or m_simpleTV.User.EXFS.stena_exfs_type == 'view' then


						t = {}
						t.id = 'STENA_EXFS_PICON_BACK_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address
						t.cx= 80
						t.cy= 50
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
						t.minresx=-1
						t.minresy=-1
						if m_simpleTV.User.EXFS.stena_exfs_type == 'view' then
						t.align = 0x0101
						else
						t.align = 0x0103
						end
						t.left= 0
						t.top= 0
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 1
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
						AddElement(t,j .. '_STENA_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address)

						t = {}
						t.id = 'STENA_EXFS_PICON_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address
						t.class="IMAGE"
						if m_simpleTV.User.EXFS.stena_exfs[j].Address:match('/film/') then
						t.cx= 21 * 1.5
						t.cy= 16 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/films.svg'
						elseif m_simpleTV.User.EXFS.stena_exfs[j].Address:match('/serials/') then
						t.cx= 21 * 1.5
						t.cy= 16 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/series.svg'
						elseif m_simpleTV.User.EXFS.stena_exfs[j].Address:match('/multfilm/') then
						t.cx= 19 * 1.5
						t.cy= 17 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.svg'
						elseif m_simpleTV.User.EXFS.stena_exfs[j].Address:match('/tv%-show/') then
						t.cx= 17 * 1.5
						t.cy= 17 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/anime.svg'
						elseif m_simpleTV.User.EXFS.stena_exfs[j].Address:match('/actors/') then
						t.cx= 17 * 1.5
						t.cy= 17 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/DefaultArtist.png'
						end

						t.minresx=-1
						t.minresy=-1
						t.align = 0x0202
						t.left = 0
						t.top  = 0
						t.transparency = 200
						t.zorder=1
--						t.borderwidth = 2
--						t.bordercolor = -6250336
--						t.backroundcorner = 3*3
--						t.borderround = 3
						AddElement(t,'STENA_EXFS_PICON_BACK_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address)

						if m_simpleTV.User.EXFS.stena_exfs_type == 'view' then
						t = {}
						t.id = 'EX-FS&STENA_START_CLEANE_ITEM&' .. j
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
						AddElement(t,j .. '_STENA_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address)
						end
					end

					t = {}
					t.id = j .. '_STENA_EXFS_TEXT_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address
					t.cx=dx-30
					t.cy=dy-30 + 65
					t.class="TEXT"
					t.text = m_simpleTV.User.EXFS.stena_exfs[j].InfoPanelName
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = 'Segoe UI Black'
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
					t.mousePressEventFunction = 'media_info_EXFS_from_stena'
					AddElement(t,j .. '_STENA_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.stena_exfs[j].Address)

				end

			elseif m_simpleTV.User.EXFS.stena_exfs_type == 'select_genre' then

					t = {}
					t.id = 'STENA_VIEW_HISTORY_EXFS_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/View_History.png'
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
					if m_simpleTV.User.TVPortal.stena_imdb_type == 'view' then
					t.bordercolor = -1250336
					t.borderwidth = 4
					end
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
					t.mousePressEventFunction = 'EXFS_Get_History'
					AddElement(t,'ID_DIV_STENA_1')

				t={}
				t.id = 'TEXT_STENA_GENRE_TITLE_ID'
				t.cx=0
				t.cy=50
				t.class="TEXT"
				t.align = 0x0102
				t.text = '    Жанры    '
				t.color = -2113993
				t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.boundWidth = 50
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
				t.textparam = 0x00000001
				t.left = 0
				t.top  = 95
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.backroundcorner = 3*3
				t.background = 2
				t.backcolor0 = 0xEE4169E1
				t.backcolor1 = 0xEE00008B
				AddElement(t,'ID_DIV_STENA_2')

				local dn = 10
				local dx = 1800/dn
				local dy = 80
				for j = 1, #m_simpleTV.User.EXFS.stena_exfs_genres do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.EXFS.stena_exfs_genres[j][1] then break end
					t = {}
					t.id = j .. '_STENA_EXFS_GENRE_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_genres[j][1]
					t.cx=dx-10
					t.cy=dy-10 + 25
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 25) + 160
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'get_page_exfs'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = j .. '_STENA_EXFS_GENRE_LOGO_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_genres[j][1]
					t.cx=dx-8
					t.cy=dy-8
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/EXFS_pack/' .. m_simpleTV.User.EXFS.stena_exfs_genres[j][2] .. '.png'
--					t.minresx=-1
--					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = -2
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
--					t.backroundcorner = 3*3
--					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_EXFS_GENRE_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_genres[j][1])

					t = {}
					t.id = j .. '_STENA_EXFS_GENRE_TEXT_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_genres[j][1]
					t.cx=dx-30
					t.cy=dy-30 + 40
					t.class="TEXT"
					t.text = m_simpleTV.User.EXFS.stena_exfs_genres[j][2]:gsub('Документальный','Документ-ный'):gsub('Короткометражка','Кор-метражка')
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
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
					t.mousePressEventFunction = 'get_page_exfs'
					AddElement(t,j .. '_STENA_EXFS_GENRE_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_genres[j][1])
				end

				t={}
				t.id = 'TEXT_STENA_COUNTRY_TITLE_ID'
				t.cx=0
				t.cy=50
				t.class="TEXT"
				t.align = 0x0102
				t.text = '    Страны    '
				t.color = -2113993
				t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.boundWidth = 50
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
				t.textparam = 0x00000001
				t.left = 0
				t.top  = 485
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.backroundcorner = 3*3
				t.background = 2
				t.backcolor0 = 0xEE4169E1
				t.backcolor1 = 0xEE00008B
				AddElement(t,'ID_DIV_STENA_2')

				local dn = 10
				local dx = 1800/dn
				local dy = 80
				for j = 1, #m_simpleTV.User.EXFS.stena_exfs_country do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.EXFS.stena_exfs_country[j][1] then break end
					t = {}
					t.id = j .. '_STENA_EXFS_COUNTRY_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_country[j][1]
					t.cx=dx-10
					t.cy=dy-10 + 25
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 25) + 550
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'get_page_exfs'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = j .. '_STENA_EXFS_COUNTRY_LOGO_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_country[j][1]
					t.cx=dx-20
					t.cy=dy-20
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/IMDB_pack/' .. m_simpleTV.User.EXFS.stena_exfs_country[j][3] .. '.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = 0
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_EXFS_COUNTRY_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_country[j][1])

					t = {}
					t.id = j .. '_STENA_EXFS_COUNTRY_TEXT_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_country[j][1]
					t.cx=dx-30
					t.cy=dy-30 + 40
					t.class="TEXT"
					t.text = m_simpleTV.User.EXFS.stena_exfs_country[j][2]
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
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
					t.mousePressEventFunction = 'get_page_exfs'
					AddElement(t,j .. '_STENA_EXFS_COUNTRY_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_country[j][1])
				end

				t={}
				t.id = 'TEXT_STENA_YEAR_TITLE_ID'
				t.cx=0
				t.cy=50
				t.class="TEXT"
				t.align = 0x0102
				t.text = '    Релиз    '
				t.color = -2113993
				t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.boundWidth = 50
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
				t.textparam = 0x00000001
				t.left = 0
				t.top  = 770
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.backroundcorner = 3*3
				t.background = 2
				t.backcolor0 = 0xEE4169E1
				t.backcolor1 = 0xEE00008B
				AddElement(t,'ID_DIV_STENA_2')

				local dn = 10
				local dx = 1800/dn
				local dy = 80
				for j = 1, #m_simpleTV.User.EXFS.stena_exfs_year do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.EXFS.stena_exfs_year[j][1] then break end
					t = {}
					t.id = j .. '_STENA_EXFS_YEAR_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_year[j][1]
					t.cx=dx-10
					t.cy=dy-10 + 3
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 3) + 835
					t.transparency = 100
					t.zorder=1
--					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = 0x77777777
--					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'get_page_exfs'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = j .. '_STENA_EXFS_YEAR_LOGO_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_year[j][1]
					t.cx=dx-10
					t.cy=dy-10
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/IMDB_pack/' .. m_simpleTV.User.EXFS.stena_exfs_year[j][3] .. '.svg'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'get_page_exfs'
					AddElement(t,j .. '_STENA_EXFS_YEAR_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_year[j][1])

					t = {}
					t.id = j .. '_STENA_EXFS_YEAR_TEXT_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_year[j][1]
					t.cx=dx-30
					t.cy=dy-30 + 40
					t.class="TEXT"
					t.text = m_simpleTV.User.EXFS.stena_exfs_year[j][2]
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
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
					t.mousePressEventFunction = 'get_page_exfs'
--					AddElement(t,j .. '_STENA_EXFS_YEAR_BACK_IMG_ID&https://ex-fs.net' .. m_simpleTV.User.EXFS.stena_exfs_year[j][1])
				end
			end
end

function UpdatePersonEXFS_id()
	setConfigVal('person/rezka',m_simpleTV.User.EXFS.stena_exfs_current_page_adr)
	UpdatePersonEXFS()
end

function for_create_stena_for_exfs(id)
	if not id then return end
	if id:match('PREV') then
		m_simpleTV.User.EXFS.stena_exfs_current_page_karusel = m_simpleTV.User.EXFS.stena_exfs_current_page_karusel - 1
	elseif id:match('NEXT') then
		m_simpleTV.User.EXFS.stena_exfs_current_page_karusel = m_simpleTV.User.EXFS.stena_exfs_current_page_karusel + 1
	end
	return create_stena_for_exfs()
end

function select_genres()

	m_simpleTV.User.EXFS.stena_exfs_genres = {
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фантастика') .. "/","Фантастика","Фантастика"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('аниме') .. "/","Аниме","Аниме"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('биография') .. "/","Биография","Исторические"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('боевик') .. "/","Боевик","Боевики"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('вестерн') .. "/","Вестерн","Вестерны"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('военный') .. "/","Военный","Военные"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('детектив') .. "/","Детектив","Детективы"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('детский') .. "/","Детский","Подростковые"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('для_взрослых') .. "/","Для взрослых","Семейные"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('документальный') .. "/","Документальный","Документальные"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('драма') .. "/","Драма","Драмы"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('история') .. "/","История","Исторические"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('комедия') .. "/","Комедия","Комедии"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('короткометражка') .. "/","Короткометражка","Короткометражные"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('концерт') .. "/","Концерт","Музыка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('криминал') .. "/","Криминал","Криминал"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('мелодрама') .. "/","Мелодрама","Романтика"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('музыка') .. "/","Музыка","Музыка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('мюзикл') .. "/","Мюзикл","Музыка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('новости') .. "/","Новости","Новости"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('приключения') .. "/","Приключения","Приключения"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('реальное_ТВ') .. "/","Реальное ТВ","Реалити"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('семейный') .. "/","Семейный","Семейные"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('спорт') .. "/","Спорт","Спорт"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('ток-шоу') .. "/","Ток-шоу","Реалити"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('триллер') .. "/","Триллер","Триллеры"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('ужасы') .. "/","Ужасы","Ужасы"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фильм-нуар') .. "/","Фильм-Нуар","Нуар"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('игра') .. "/","Игра","Реалити"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фэнтези') .. "/","Фэнтези","Фантазия"},
		}

	m_simpleTV.User.EXFS.stena_exfs_country = {
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Россия') .. "/","Российские","Россия"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Индия') .. "/","Индийские","Индия"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Канада') .. "/","Канадские","Канада"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Украина') .. "/","Украинские","Украина"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Турция') .. "/","Турецкие","Турция"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Корея_Южная') .. "/","Корейские","Корея Южная"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('США') .. "/","Американские","США"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Франция') .. "/","Французские","Франция"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Япония') .. "/","Японские","Япония"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Великобритания') .. "/","Британские","Великобритания"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Германия') .. "/","Немецкие","Германия"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('СССР') .. "/","СССР","СССР"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Италия') .. "/","Итальянские","Италия"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Испания') .. "/","Испанские","Испания"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Китай') .. "/","Китайские","Китай"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Австралия') .. "/","Австралийские","Австралия"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Швеция') .. "/","Швецкие","Швеция"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Дания') .. "/","Датские","Дания"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('ЮАР') .. "/","ЮАР","ЮАР"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Бельгия') .. "/","Бельгийские","Бельгия"},
		}

		m_simpleTV.User.EXFS.stena_exfs_year = {
		{"/year/" .. 2025 .. "/","2025","2025"},
		{"/year/" .. 2024 .. "/","2024","2024"},
		{"/year/" .. 2023 .. "/","2023","2023"},
		{"/year/" .. 2022 .. "/","2022","2022"},
		{"/year/" .. 2021 .. "/","2021","2021"},
		{"/year/" .. 2020 .. "/","2020","2020"},
		{"/year/" .. 2019 .. "/","2019","2019"},
		{"/year/" .. 2018 .. "/","2018","2018"},
		{"/year/" .. 2017 .. "/","2017","2017"},
		{"/year/" .. 2016 .. "/","2016","2016"},
		{"/year/" .. 2015 .. "/","2015","2015"},
		{"/year/" .. 2014 .. "/","2014","2014"},
		{"/year/" .. 2013 .. "/","2013","2013"},
		{"/year/" .. 2012 .. "/","2012","2012"},
		{"/year/" .. 2011 .. "/","2011","2011"},
		{"/year/" .. 2010 .. "/","2010","2010"},
		{"/year/" .. 2009 .. "/","2009","2009"},
		{"/year/" .. 2008 .. "/","2008","2008"},
		{"/year/" .. 2007 .. "/","2007","2007"},
		{"/year/" .. 2006 .. "/","2006","2006"},
		{"/year/" .. 2005 .. "/","2005","2005"},
		{"/year/" .. 2004 .. "/","2004","2004"},
		{"/year/" .. 2003 .. "/","2003","2003"},
		{"/year/" .. 2002 .. "/","2002","2002"},
		{"/year/" .. 2001 .. "/","2001","2001"},
		{"/year/" .. 2000 .. "/","2000","2000"},
		{"/year/" .. 1999 .. "/","1999","1999"},
		{"/year/" .. 1998 .. "/","1998","1998"},
		{"/year/" .. 1997 .. "/","1997","1997"},
		{"/year/" .. 1996 .. "/","1996","1996"},
		}
	m_simpleTV.User.EXFS.stena_exfs_all_pg = 1
	m_simpleTV.User.EXFS.stena_exfs_prev = nil
	m_simpleTV.User.EXFS.stena_exfs_next = nil
	m_simpleTV.User.EXFS.stena_exfs_current_page_karusel = nil
	m_simpleTV.User.EXFS.stena_exfs_type = 'select_genre'
	m_simpleTV.User.EXFS.stena_exfs = t
	m_simpleTV.User.EXFS.stena_exfs_title = 'Фильтры контента EX-FS'
	create_stena_for_exfs()
end

function get_title_font()
	m_simpleTV.Common.Sleep(200)
	m_simpleTV.User.EXFS.stena_exfs_title_font = m_simpleTV.Interface.FontPicker((m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'),'Выбрать шрифт')
	m_simpleTV.Config.SetValue('TitleFont',m_simpleTV.User.EXFS.stena_exfs_title_font,'LiteConf.ini')
	create_stena_for_exfs()
end

function tooltip_clear_EXFS_WS(ObjectName,EventName,data)
--[[	debug_in_file('name:' .. ObjectName .. '\n')
	debug_in_file('envent:' .. EventName .. '\n');

	if EventName == 'mousePressEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('button:' .. data.button .. '\n');
	elseif EventName == 'mouseReleaseEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('button:' .. data.button .. '\n');
	elseif EventName == 'mouseDoubleClickEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('button:' .. data.button .. '\n');
	elseif EventName == 'mouseMoveEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('buttons:' .. data.buttons .. '\n');
	end

	debug_in_file('\n\n\n');--]]
	m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_EXFS_ID')
end

function tooltip_EXFS_WS(ObjectName,EventName,data)
	if not ObjectName then return end
	local x
	local y
	local mes
	local  t, AddElement = {}, m_simpleTV.OSD.AddElement
	if ObjectName:match('SELECT_TITLE') then
		mes = 'TitleFont'
		x = 100
		y = 20
	end
	if ObjectName:match('/film/') then
		mes = 'Фильмы'
		x = 100
		y = 100
	end
	if ObjectName:match('/serials/') then
		mes = 'Сериалы'
		x = 100
		y = 180
	end
	if ObjectName:match('/multfilm/') then
		mes = 'Мульты'
		x = 100
		y = 260
	end
	if ObjectName:match('/tv%-show/') then
		mes = 'ТВ шоу'
		x = 100
		y = 340
	end
	if ObjectName:match('GENRES') then
		mes = 'Фильтры'
		x = 100
		y = 420
	end

	if ObjectName:match('VIEW_HISTORY') then
		mes = 'ViewHistory'
		x = 100
		y = 740
	end
	if ObjectName:match('FAVORITE_IMDB') then
		mes = 'Favorite'
		x = 100
		y = 180
	end
	if ObjectName:match('COL_IMDB') then
		mes = 'Collection'
		x = 100
		y = 260
	end
	if ObjectName:match('COL_PLUS_IMDB') then
		mes = 'Collection+'
		x = 100
		y = 340
	end
	if ObjectName:match('GENRES_IMDB') then
		mes = 'Жанры'
		x = 100
		y = 420
	end

	if ObjectName:match('PERSONS') then
		mes = 'Персоны'
		x = 100
		y = 500
	end
	if ObjectName:match('SEARCH') then
		mes = 'Поиск'
		x = 100
		y = 580
	end
	if ObjectName:match('STENA_HISTORY') then
		mes = 'Поиск ⟲'
		x = 100
		y = 660
	end
	if ObjectName:match('PAGE_EXFS_IMG') then
		mes = 'Страница'
		x = 100
		y = 740
	end
	if ObjectName:match('PREV_IMG') then
		mes = 'Предыдущая'
		x = 100
		y = 820
	end
	if ObjectName:match('NEXT_IMG') then
		mes = 'Следующая'
		x = 100
		y = 900
	end
	if ObjectName:match('CLEAR_IMG') then
		mes = 'Очистить'
		x = 100
		y = 980
	end
	if mes then
		m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_EXFS_ID')

			     t = {}
				 t.id = 'STENA_TOOLTIP_EXFS_ID'
				 t.cx=160
				 t.cy=40
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=x
				 t.top=y
				 t.once=1
				 t.zorder=1
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				t={}
				t.id = 'IMG_STENA_TOOLTIP_EXFS_ID'
				t.cx=160
				t.cy=40
				t.class="IMAGE"
				t.zorder=2
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 0
				t.top  = 0
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'STENA_TOOLTIP_EXFS_ID')

				 t={}
				 t.id = 'TEXT_STENA_TOOLTIP_EXFS_ID'
				 t.cx=150
				 t.cy=0
				 t.class="TEXT"
				 t.zorder=2
				 t.align = 0x0202
				 t.text = mes
				 t.color = ARGB (255, 36, 36, 36)
				 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
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
				 t.top  = 0
--				 t.glow = 2 -- коэффициент glow эффекта
--				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'STENA_TOOLTIP_EXFS_ID')

	end
end

function info_exfs()
			m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
			m_simpleTV.OSD.RemoveElement('ID_DIV_TRAILER')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_EXFS_ID')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR3_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR4_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR5_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR6_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_EXFS_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_EXFS_WS')
			m_simpleTV.User.TVPortal.stena_exfs_info = true
			m_simpleTV.User.TVPortal.stena_exfs_use = false
			m_simpleTV.User.TVPortal.stena_rezka_info = false
			m_simpleTV.User.TVPortal.stena_rezka_use = false
			m_simpleTV.User.TVPortal.stena_rezka_busy = false
			m_simpleTV.User.TVPortal.stena_filmix_use = false
			m_simpleTV.User.TVPortal.stena_filmix_info = false
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_search_use = false
			m_simpleTV.User.TVPortal.stena_genres = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = false
			m_simpleTV.User.stena_rezka.back.old_request = false

			local  t, AddElement = {}, m_simpleTV.OSD.AddElement

			local add = 0

			 t = {}
			 t.id = 'ID_DIV_TRAILER'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=-150
			 t.once=1
			 t.zorder=0
			 t.background = 1
			 t.backcolor0, t.backcolor1 = get_scheme_color()
			 AddElement(t)

			 t = {}
			 t.id = 'USER_LOGO_TRAILER_ID'
			 t.cx= 470
			 t.cy= 670
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.EXFS.logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=30
			 t.top=337
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 20
			 AddElement(t,'ID_DIV_TRAILER')

			if m_simpleTV.User.EXFS.EXFS_is_thumb then
			 t = {}
			 t.id = 'USER_THUMB_TRAILER_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/cadr.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=-2
			 t.top=-2
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 20
			 t.background = 1
			 t.backcolor0, t.backcolor1 = get_scheme_color()
			 AddElement(t,'USER_LOGO_TRAILER_ID')
			end

			if m_simpleTV.User.EXFS.EXFS_tr then
			 t = {}
			 t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_tr
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
--			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left=-2
			 t.top=-2
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 2
--			 t.borderwidth = Get_current_balanser_name('Trailer')
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 20
			 t.background = 2
			 t.backcolor0, t.backcolor1 = get_scheme_color()
			 t.isInteractive = true
			 t.background_UnderMouse = 2
			 t.backcolor1_UnderMouse = 0x994169E1
			 t.backcolor0_UnderMouse = 0x224169E1
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.mousePressEventFunction = 'play_exfs'
			 AddElement(t,'USER_LOGO_TRAILER_ID')

			 t = {}
			 t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_tr
			 t.cx= 75
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Trailer.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left=17
			 t.top=-2
			 t.transparency = 200
			 t.zorder=1
			 AddElement(t,'USER_LOGO_TRAILER_ID')
			end

			 t = {}
			 t.id = 'RKP_IMG_TRAILER_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/kinopoisk.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
--			 t.left=540
--			 t.top=250
			 t.left=25
			 t.top=1105
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'R_KP_IMG_TRAILER_ID'
			 t.cx= 100
			 t.cy= 20
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.EXFS.EXFS_ret_KP) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left=0
			 t.top=17
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'RKP_IMG_TRAILER_ID')

			 t = {}
			 t.id = 'RIMDB_IMG_TRAILER_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/imdb.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=147
			 t.top=1105
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'R_IMDB_IMG_TRAILER_ID'
			 t.cx= 100
			 t.cy= 20
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.EXFS.EXFS_ret_imdb) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left=0
			 t.top=17
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'RIMDB_IMG_TRAILER_ID')

			 t = {}
			 t.id = 'FILMIX_IMG_STENA_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=25
			 t.top=250
			 t.transparency = 200
			 t.zorder=1
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
			 t.mousePressEventFunction = 'search_filmix_from_exfs'
			 AddElement(t,'ID_DIV_TRAILER')


			 t = {}
			 t.id = 'FILMIX_IMG_STENA_ID'
			 t.cx= 75
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Filmix.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'FILMIX_IMG_STENA_BACK_ID')

			 t = {}
			 t.id = 'REZKA_IMG_STENA_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=147
			 t.top=250
			 t.transparency = 200
			 t.zorder=1
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
			 t.mousePressEventFunction = 'search_rezka_from_exfs'
			 AddElement(t,'ID_DIV_TRAILER')


			 t = {}
			 t.id = 'REZKA_IMG_STENA_ID'
			 t.cx= 75
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/HDRezka.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'REZKA_IMG_STENA_BACK_ID')

			 t = {}
			 t.id = 'TMDB_IMG_STENA_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/TMDB_.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 269
			 t.top= 250
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
			 t.mousePressEventFunction = 'search_tmdb_from_exfs'

			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'YOUTUBE_IMG_STENA_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=391
			 t.top=250
			 t.transparency = 200
			 t.zorder=1
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
			 t.mousePressEventFunction = 'search_youtube_from_exfs'
			 AddElement(t,'ID_DIV_TRAILER')


			 t = {}
			 t.id = 'YOUTUBE_IMG_STENA_ID'
			 t.cx= 75
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/menuYT.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'YOUTUBE_IMG_STENA_BACK_ID')

			 t={}
			 t.id = 'TEXT_TRAILER_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.EXFS.title:gsub(' %- Украинский','')
			 t.color = -2123993
			 t.font_height = -35 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_underline = 1
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0 --1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 530
			 t.top  = 330
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')

			 t={}
			 t.id = 'TEXT_TRAILER_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.EXFS.original_title:gsub(' watch online','')
			 t.color = -2113993
			 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 530
			 t.top  = 420
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')

			 t={}
			 t.id = 'TEXT_TRAILER_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = 'Год: ' .. m_simpleTV.User.EXFS.year .. m_simpleTV.User.EXFS.age .. m_simpleTV.User.EXFS.all_time
			 t.color = ARGB(255, 222, 222, 222)
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.boundWidth = 15
			 t.left = 530
			 t.top  = 490
			 t.glow = 4 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
--			 AddElement(t,'ID_DIV_TRAILER')

			 t={}
			 t.id = 'TEXT_TRAILER_3_ID&https://ex-fs.net/year/' .. m_simpleTV.User.EXFS.year
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = 'Год: ' .. m_simpleTV.User.EXFS.year .. m_simpleTV.User.EXFS.age .. m_simpleTV.User.EXFS.all_time
			 t.color = ARGB(255, 222, 222, 222)
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "MS Shell Dlg 2"
			 t.color_UnderMouse = ARGB(255, 255, 192, 222)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 35
					t.top  = 160
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'get_page_exfs'
			 t.left = 530
			 t.top  = 490
--			 t.glow = 4 -- коэффициент glow эффекта
--			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')

			if not m_simpleTV.User.EXFS.EXFS_is_posters then
			 t={}
			 t.id = 'TEXT_TRAILER_4_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = 'Страны: ' .. m_simpleTV.User.EXFS.country:gsub('%, $','')
			 t.color = ARGB(255, 222, 222, 222)
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.boundWidth = 15
			 t.left = 530
			 t.top  = 540
			 t.glow = 4 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')

			 t={}
			 t.id = 'TEXT_TRAILER_5_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 192, 255, 192)
			 t.font_height = -16 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = 'Жанры: ' .. m_simpleTV.User.EXFS.genres:gsub('"%,"',', '):gsub('"',''):gsub('%, $',''):gsub('%, на украинском',''):gsub('%, українська мова','')
			 t.boundWidth = 50
			 t.row_limit=1
			 t.text_elidemode = 1
			 t.glow = 4 -- коэффициент glow эффекта
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.left = 530
			 t.top  = 585
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')
			end

			local delta = 0
			if m_simpleTV.User.EXFS.person ~= '' and not m_simpleTV.User.EXFS.EXFS_is_posters then
			 delta = 85
			 t={}
			 t.id = 'TEXT_TRAILER_6_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 192, 192, 255)
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = 'Состав: ' .. m_simpleTV.User.EXFS.person:gsub('"%,"',', '):gsub('"',''):gsub('%, $','') .. '\n'
			 t.boundWidth = 50
			 t.row_limit=4
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.left = 530
			 t.top  = 810
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')

			 t={}
			 t.id = 'TEXT_TRAILER_61_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 255, 192, 255)
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.EXFS.dir:gsub('%, $','') .. '\n\n\n\n\n\n\n\n\n'
			 t.boundWidth = 50
			 t.row_limit=8
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.left = 530
			 t.top  = 635
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_TRAILER')

			 m_simpleTV.User.EXFS.EXFS_overview = m_simpleTV.User.EXFS.EXFS_overview or ''
			 t={}
			 t.id = 'TEXT_TRAILER_7_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 222, 222, 222)
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = 'Описание: ' .. m_simpleTV.User.EXFS.EXFS_overview:gsub('<.->',''):gsub('&nbsp%;','-'):gsub('&#96%;',"'")
			 .. '\n\n\n\n\n\n'
			 t.boundWidth = 50
			 t.row_limit=5
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.left = 530
			 t.top  = 810 + delta
			 t.glow = 4 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта

			 AddElement(t,'ID_DIV_TRAILER')
			end

			t={}
			 t.id = 'TEXT_TRAILER_8_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 222, 222, 222)
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.EXFS.desc_right
			 .. '\n\n\n\n\n\n\n'
			 t.boundWidth = 50
			 t.row_limit=6
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "MS Shell Dlg 2"
			 t.textparam = 0--1+4
			 t.left = 270
			 t.top  = 1105
			 t.glow = 4 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта

			 AddElement(t,'ID_DIV_TRAILER')



			 t = {}
			 t.id = 'HOME_IMG_STENA_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=25
			 t.top=1020
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
			 t.mousePressEventFunction = 'select_genres'
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'HOME_IMG_STENA_ID'
			 t.cx= 60
			 t.cy= 60
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/home.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'HOME_IMG_STENA_BACK_ID')


			 t = {}
			 t.id = 'BACK_IMG_STENA_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=147
			 t.top=1020
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
			 if m_simpleTV.User.EXFS.stena_exfs_type then
			 t.mousePressEventFunction = 'create_stena_for_exfs'
			 else
			 t.mousePressEventFunction = 'select_genres'
			 end
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'BACK_IMG_STENA_ID'
			 t.cx= 60
			 t.cy= 60
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'BACK_IMG_STENA_BACK_ID')

			 t = {}
			 t.id = 'STENA_CLEAR_IMG_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=269
			 t.top=1020
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
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'STENA_CLEAR_IMG_ID'
			 t.cx= 60
			 t.cy= 60
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Clear.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'STENA_CLEAR_IMG_BACK_ID')

			 t = {}
			 t.id = 'STENA_POSTER_IMG_BACK_ID'
			 t.cx= 113
			 t.cy= 75
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=391
			 t.top=1020
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
			 t.mousePressEventFunction = 'stena_info_chainge'
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'STENA_POSTER_IMG_ID'
			 t.cx= 60
			 t.cy= 60
			 t.class="IMAGE"
			 if m_simpleTV.User.EXFS.EXFS_is_posters then
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/plst.png'
			 else
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/plst_p.png'
			 end
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0202
			 t.left= 0
			 t.top= 0
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'STENA_POSTER_IMG_BACK_ID')

-----------------------------
				if m_simpleTV.User.EXFS.EXFS_is_posters == true then
					local dn = 9
					local dx = (1920-550)/dn
					local dy = (1920-550)/dn*1.5
					for j = 1, 9 do
						local nx = j - (math.ceil(j/dn) - 1)*dn

						if not m_simpleTV.User.EXFS.EXFS_person[j] then break end
						t = {}
						t.id = j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_person[j].Address
						t.cx=dx-10
						t.cy=dy-10 + 55
						t.class="IMAGE"
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0101
						t.left = (nx - 1)*(dx + 0) + 530
						t.top  = 823
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 1
						t.isInteractive = true
						t.cursorShape = 13
						t.bordercolor_UnderMouse = 0xFFFFFFFF
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
						t.background_UnderMouse = 2
						t.backcolor1_UnderMouse = 0x994169E1
						t.backcolor0_UnderMouse = 0x224169E1
						t.mousePressEventFunction = 'media_info_EXFS_from_stena'
						AddElement(t,'ID_DIV_TRAILER')

						t = {}
						t.id = j .. '_INFO_EXFS_LOGO_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_person[j].Address
						t.cx=dx-10
						t.cy=dy-10
						t.class="IMAGE"
						t.imagepath = m_simpleTV.User.EXFS.EXFS_person[j].InfoPanelLogo
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0102
						t.left = 1
						t.top  = -2
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 2
	--					t.isInteractive = true
	--					t.cursorShape = 13
	--					t.bordercolor_UnderMouse = 0xFFFFFFFF
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
	--					t.mouseMoveEventFunction = 'get_request_for_content'
	--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_person[j].Address)

						t = {}
						t.id = j .. '_INFO_EXFS_TEXT_ID&' .. m_simpleTV.User.EXFS.EXFS_person[j].Address
						t.cx=dx-30
						t.cy=dy-30 + 65
						t.class="TEXT"
						t.text = m_simpleTV.User.EXFS.EXFS_person[j].InfoPanelName
	--					t.align = 0x0202
						t.color = ARGB(255, 192, 192, 192)
						t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
						t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
						t.font_name = 'Segoe UI Black'
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
						t.mousePressEventFunction = 'media_info_EXFS_from_stena'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_person[j].Address)
					end

					dn = 7
					dx = (1920-550)/7
					dy = 70

					for j = 1, 7 do
						local nx = j - (math.ceil(j/dn) - 1)*dn

						if not m_simpleTV.User.EXFS.EXFS_country[j] then break end
						t = {}
						t.id = j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_country[j].Address
						t.cx=dx-10
						t.cy=dy-10 + 25
						t.class="IMAGE"
						t.minresx=0
						t.minresy=0
						t.align = 0x0101
						t.left = (nx - 1)*(dx + 0) + 530
						t.top  = 540
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 1
						t.isInteractive = true
						t.cursorShape = 13
						t.bordercolor_UnderMouse = 0xFFFFFFFF
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
						t.mousePressEventFunction = 'get_page_exfs'
						AddElement(t,'ID_DIV_TRAILER')

						t = {}
						t.id = j .. '_INFO_EXFS_LOGO_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_country[j].Address
						t.cx=dx-20
						t.cy=dy-20
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/IMDB_pack/' .. m_simpleTV.User.EXFS.EXFS_country[j].Name .. '.png'
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0102
						t.left = 1
						t.top  = 0
						t.transparency = 200
						t.zorder=1
	--					t.borderwidth = 2
	--					t.isInteractive = true
	--					t.cursorShape = 13
	--					t.bordercolor_UnderMouse = 0xFFFFFFFF
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
	--					t.mouseMoveEventFunction = 'get_request_for_content'
	--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_country[j].Address)

						t = {}
						t.id = j .. '_INFO_EXFS_TEXT_ID&' .. m_simpleTV.User.EXFS.EXFS_country[j].Address
						t.cx=dx-30
						t.cy=dy+5
						t.class="TEXT"
						t.text = m_simpleTV.User.EXFS.EXFS_country[j].Name
	--					t.align = 0x0202
						t.color = ARGB(255, 192, 192, 192)
						t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
						t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
						t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
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
						t.mousePressEventFunction = 'get_page_exfs'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_country[j].Address)
					end

					dy = 75

					for j = 1, 7 do
						local nx = j - (math.ceil(j/dn) - 1)*dn

						if not m_simpleTV.User.EXFS.EXFS_genres[j] then break end
						t = {}
						t.id = j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_genres[j].Address
						t.cx=dx-10
						t.cy=dy-10 + 25
						t.class="IMAGE"
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0101
						t.left = (nx - 1)*(dx + 0) + 530
						t.top  = 635
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 1
						t.isInteractive = true
						t.cursorShape = 13
						t.bordercolor_UnderMouse = 0xFFFFFFFF
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
						t.mousePressEventFunction = 'get_page_exfs'
						AddElement(t,'ID_DIV_TRAILER')

						t = {}
						t.id = j .. '_INFO_EXFS_LOGO_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_genres[j].Address
						t.cx=dx-6
						t.cy=dy-6
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/EXFS_pack/' .. get_logo_genres(m_simpleTV.User.EXFS.EXFS_genres[j].Name) .. '.png'
						t.minresx=0
						t.minresy=0
						t.align = 0x0102
						t.left = 0
						t.top  = -2
						t.transparency = 200
						t.zorder=1
	--					t.borderwidth = 2
	--					t.isInteractive = true
	--					t.cursorShape = 13
	--					t.bordercolor_UnderMouse = 0xFFFFFFFF
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
	--					t.mouseMoveEventFunction = 'get_request_for_content'
	--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_genres[j].Address)

						t = {}
						t.id = j .. '_INFO_EXFS_TEXT_ID&' .. m_simpleTV.User.EXFS.EXFS_genres[j].Address
						t.cx=dx-30
						t.cy=dy-30 + 40
						t.class="TEXT"
						t.text = m_simpleTV.User.EXFS.EXFS_genres[j].Name
	--					t.align = 0x0202
						t.color = ARGB(255, 192, 192, 192)
						t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
						t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
						t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
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
						t.mousePressEventFunction = 'get_page_exfs'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_genres[j].Address)
					end

					dn = 9
					dx = (1920-550)/dn
					dy = 60

					for j = 1, 9 do
						local nx = j - (math.ceil(j/dn) - 1)*dn
						local ny = math.ceil(j/dn)
						if not m_simpleTV.User.EXFS.EXFS_dir[j] then break end
						t = {}
						t.id = j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_dir[j].Address
						t.cx=dx-10
						t.cy=dy-10 + 25
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0101
						t.left = (nx - 1)*(dx + 0) + 530
						t.top  = (ny - 1)*(dy + 25) + 735
						t.transparency = 50
						t.zorder=1
						t.borderwidth = 1
						t.isInteractive = true
						t.cursorShape = 13
	--					t.borderwidth = 2
						t.bordercolor = -6250336
	--					t.isInteractive = true
						t.background_UnderMouse = 2
						t.backcolor1_UnderMouse = 0xEE4169E1
						t.backcolor0_UnderMouse = 0x774169E1
	--					t.cursorShape = 13
						t.bordercolor_UnderMouse = 0xFF4169E1
	--					t.bordercolor_UnderMouse = 0xFFFFFFFF
	--					t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
						t.mousePressEventFunction = 'get_page_exfs'
						AddElement(t,'ID_DIV_TRAILER')

						t = {}
						t.id = j .. '_INFO_EXFS_NAME_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_dir[j].Address
						t.cx=dx-20
						t.cy=dy-6
						t.class="TEXT"
						t.text = m_simpleTV.User.EXFS.EXFS_dir[j].Name .. '\n\n\n'
	--					t.align = 0x0202
						t.color = ARGB(255, 222, 222, 222)
						t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
						t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
						t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
						t.textparam = 0x00000001
						t.boundWidth = 15
						t.left = 5
						t.top  = 0
						t.row_limit=2
						t.text_elidemode = 2
						t.zorder=1
						t.glow = 2 -- коэффициент glow эффекта
						t.glowcolor = 0xFF000077 -- цвет glow эффекта
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_dir[j].Address)

						t = {}
						t.id = j .. '_INFO_EXFS_TEXT_ID&' .. m_simpleTV.User.EXFS.EXFS_dir[j].Address
						t.cx=dx-30
						t.cy=dy-30 + 40
						t.class="TEXT"
						t.text = m_simpleTV.User.EXFS.EXFS_dir[j].InfoPanelName:gsub(':','')
	--					t.align = 0x0202
						t.color = ARGB(255, 255, 192, 255)
						t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
						t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
						t.font_name = m_simpleTV.User.EXFS.stena_exfs_title_font or 'Segoe UI Black'
						t.textparam = 0x00000008
						t.boundWidth = 15
						t.left = 20
						t.top  = 0
						t.text_elidemode = 2
						t.zorder=1
						t.glow = 2 -- коэффициент glow эффекта
						t.glowcolor = 0xFF000077 -- цвет glow эффекта
						t.isInteractive = true
						t.cursorShape = 13
						t.color_UnderMouse = ARGB(255 ,255, 192, 63)
						t.mousePressEventFunction = 'get_page_exfs'
						AddElement(t,j .. '_INFO_EXFS_BACK_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_dir[j].Address)
					end
				end
-------------------------------------------------------balansers
			local add = 423
			if m_simpleTV.User.EXFS.lumex then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.lumex
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
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
				t.mousePressEventFunction = 'play_exfs_in_browser'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.lumex
				t.cx= 80 / 1*1.25
				t.cy= 80 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/VideoCDN.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.lumex)
				add = add + 97
			end
			if m_simpleTV.User.EXFS.collaps then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.collaps
				t.cx= 113
				t.cy= 75
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
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
				t.mousePressEventFunction = 'play_exfs_in_browser'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.collaps
				t.cx= 100
				t.cy= 100
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Collaps.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.collaps)
			end

---------------------------------------------------------------
			 add = 23
			 t = {}
			 t.id = 'TRACKERS_IMG_STENA_BACK_ID'
			 t.cx= 38 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
--			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 200 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.bordercolor = -6250336
			 t.backroundcorner = 5*5
			 t.borderround = 5
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 5*5
			 t.borderround = 5
			 t.mousePressEventFunction = 'change_trackers_exfs'
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'TRACKERS_IMG_STENA_ID'
			 t.cx= 100 / 1*1.25
			 t.cy= 110 / 1*1.25
			 t.class="IMAGE"
			 if m_simpleTV.User.EXFS.trackers then
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev_.png'
			 else
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next_.png'
			 end
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add-31) / 1*1.25
			 t.top= 175 / 1*1.25
--			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_TRAILER')
---------------------------------------------------------------
			add = add + 46

			if m_simpleTV.User.EXFS.trackers then

				local Magnets
				if m_simpleTV.User.EXFS.id_KP
					and tonumber(m_simpleTV.User.EXFS.id_KP)
					and tonumber(m_simpleTV.User.EXFS.id_KP) > 0
					then
					Magnets = Get_Pirring(m_simpleTV.User.EXFS.title:gsub(' %- Украинский',''), m_simpleTV.User.EXFS.year, m_simpleTV.User.EXFS.id_KP)
				end

				if Magnets then m_simpleTV.User.EXFS.EXFS_mg = m_simpleTV.User.EXFS.TestAddress .. '&magnet:' .. Magnets end

					if m_simpleTV.User.EXFS.EXFS_mg then
						t = {}
						t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_mg
						t.cx= 90 / 1*1.25
						t.cy= 60 / 1*1.25
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left= (add) / 1*1.25
						t.top= 200 / 1*1.25
						t.transparency = 200
						t.zorder=1
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
						t.mousePressEventFunction = 'play_exfs'
						AddElement(t,'ID_DIV_TRAILER')

						t = {}
						t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_mg
						t.cx= 80 / 1*1.25
						t.cy= 80 / 1*1.25
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Trackers.png'
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left= (add + 5) / 1*1.25
						t.top= 190 / 1*1.25
						t.transparency = 200
						t.zorder=1
						AddElement(t,'ID_DIV_TRAILER')
						add = add + 97
					end
				end

			if m_simpleTV.User.EXFS.EXFS_vf then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_vf
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
				t.borderwidth = Get_current_balanser_name('Vibix')
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_vf
				t.cx= 80 / 1*1.25
				t.cy= 80 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Vibix.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add + 5) / 1*1.25
				t.top= 190 / 1*1.25
				t.transparency = 200
				t.zorder=1
				AddElement(t,'ID_DIV_TRAILER')
				add = add + 97
			end

			if m_simpleTV.User.EXFS.EXFS_zf then
				t = {}
				t.id = 'BALANSERZF_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_zf
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_zf
				t.cx= 80 / 1*1.25
				t.cy= 80 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Zetflix.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add + 5) / 1*1.25
				t.top= 190 / 1*1.25
				t.transparency = 200
				t.zorder=1
				AddElement(t,'ID_DIV_TRAILER')
				add = add + 97
			end
------------
		if m_simpleTV.User.EXFS.balansers then
			local cur_id
			if m_simpleTV.User.EXFS.id_KP
			    and tonumber(m_simpleTV.User.EXFS.id_KP)
			    and tonumber(m_simpleTV.User.EXFS.id_KP) > 0
				then cur_id = m_simpleTV.User.EXFS.id_KP
			elseif m_simpleTV.User.EXFS.id_IMDB
			    and m_simpleTV.User.EXFS.id_IMDB:match('(tt%d+)')
				then cur_id = m_simpleTV.User.EXFS.id_IMDB
			end
			local balanser = Get_VeoVeo(cur_id)
			if balanser then m_simpleTV.User.EXFS.EXFS_vv = m_simpleTV.User.EXFS.TestAddress .. '&' .. balanser end
			if m_simpleTV.User.EXFS.EXFS_vv then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_vv
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
				t.borderwidth = Get_current_balanser_name('VideoDB')
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_vv
				t.cx= 100
				t.cy= 100
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/VideoDB.png'
--				t.minresx=-1
--				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_vv)
				add = add + 97
			end
			if m_simpleTV.User.EXFS.id_KP
			    and tonumber(m_simpleTV.User.EXFS.id_KP)
			    and tonumber(m_simpleTV.User.EXFS.id_KP) > 0
				then cur_id = m_simpleTV.User.EXFS.id_KP
			end
			m_simpleTV.User.hdvb = Get_HDVB(cur_id)
			if m_simpleTV.User.hdvb then m_simpleTV.User.EXFS.EXFS_hdvb = m_simpleTV.User.EXFS.TestAddress .. '&' .. 'HDVB' end
			if m_simpleTV.User.EXFS.EXFS_hdvb then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_hdvb
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_hdvb
				t.cx= 100
				t.cy= 100
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/HDVB.png'
--				t.minresx=-1
--				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_hdvb)
				add = add + 97
			end
			balanser = Get_Ashdi(cur_id)
			if balanser then
				m_simpleTV.User.EXFS.EXFS_ashdi = m_simpleTV.User.EXFS.TestAddress .. '&' .. balanser
			end
			if m_simpleTV.User.EXFS.EXFS_ashdi then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_ashdi
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_ashdi
				t.cx= 100
				t.cy= 100
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/ASHDI.png'
--				t.minresx=-1
--				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_ashdi)
				add = add + 97
			end

			balanser = Get_Kodik(cur_id)
			if balanser then
				m_simpleTV.User.EXFS.EXFS_kodik = m_simpleTV.User.EXFS.TestAddress .. '&' .. balanser
			end
			if m_simpleTV.User.EXFS.EXFS_kodik then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_kodik
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_kodik
				t.cx= 100
				t.cy= 100
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Kodik.png'
--				t.minresx=-1
--				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_kodik)
				add = add + 97
			end

			balanser = Get_FX(m_simpleTV.User.EXFS.title:gsub(' %- Украинский',''), m_simpleTV.User.EXFS.year, (m_simpleTV.User.EXFS.id_KP or ''), (m_simpleTV.User.EXFS.id_IMDB or ''))
			if balanser then
				m_simpleTV.User.EXFS.EXFS_fx = m_simpleTV.User.EXFS.TestAddress .. '&' .. balanser
			end
			if m_simpleTV.User.EXFS.EXFS_fx then
				t = {}
				t.id = 'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_fx
				t.cx= 90 / 1*1.25
				t.cy= 60 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left= (add) / 1*1.25
				t.top= 200 / 1*1.25
				t.transparency = 200
				t.zorder=1
				t.borderwidth = Get_current_balanser_name('FXLite')
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
				t.mousePressEventFunction = 'play_exfs'
				AddElement(t,'ID_DIV_TRAILER')

				t = {}
				t.id = 'BALANSER_IMG_ID&' .. m_simpleTV.User.EXFS.EXFS_fx
				t.cx= 100
				t.cy= 100
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/FXLite.png'
--				t.minresx=-1
--				t.minresy=-1
				t.align = 0x0202
				t.left= 0
				t.top= 0
				t.transparency = 200
				t.zorder=1
				AddElement(t,'BALANSER_IMG_BACK_ID&' .. m_simpleTV.User.EXFS.EXFS_fx)
				add = add + 97
			end
		end
----------------
			 t = {}
			 t.id = 'BALANSERS_IMG_STENA_BACK_ID'
			 t.cx= 38 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
--			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add) / 1*1.25
			 t.top= 200 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.bordercolor = -6250336
			 t.backroundcorner = 5*5
			 t.borderround = 5
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 5*5
			 t.borderround = 5
			 t.mousePressEventFunction = 'change_balansers_exfs'
			 AddElement(t,'ID_DIV_TRAILER')

			 t = {}
			 t.id = 'BALANSERS_IMG_STENA_ID'
			 t.cx= 100 / 1*1.25
			 t.cy= 110 / 1*1.25
			 t.class="IMAGE"
			 if m_simpleTV.User.EXFS.balansers then
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next_.png'
			 else
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev_.png'
			 end
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= (add-30) / 1*1.25
			 t.top= 175 / 1*1.25
--			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_TRAILER')
end

function play_exfs(id)
	if not id then return end
	local adr = id:match('&(.-)$')

	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.User.TVPortal.stena_exfs_use = false
	m_simpleTV.User.TVPortal.stena_exfs_info = false
	m_simpleTV.User.EXFS.position = m_simpleTV.Control.GetPosition() or 0

	if adr:match('yandex%.ru') or m_simpleTV.User.TVPortal.balanser == 'Trailer' or m_simpleTV.User.EXFS.CurAddress ~= m_simpleTV.User.EXFS.TestAddress then
		m_simpleTV.User.EXFS.position = 0
	end
--	debug_in_file(id .. '\n' .. adr .. '\n')
	local balanser = ''
	if adr:match('yandex%.ru') then
	balanser = 'Trailer'
	elseif adr:match('videoframe%d+%.com/embed') then
	balanser = 'VF'
	elseif adr:match('/lite/zetflix') then
	balanser = 'ZF'
	elseif adr:match('/lite/ashdi') then
	balanser = 'Ashdi'
	elseif adr:match('kodik%.info') then
	balanser = 'Kodik'
	elseif adr:match('/lite/filmix') then
	balanser = 'FX'
	elseif adr:match('/lite/veoveo') or adr:match('/movies/files/episodes/') then
	balanser = 'VideoDB'
	m_simpleTV.User.TVPortal.balanser = 'VideoDB'
	elseif adr:match('HDVB') then
	balanser = 'HDVB'
	m_simpleTV.User.TVPortal.balanser = 'HDVB'
	elseif adr:match('magnet:') then
	balanser = 'Magnets'
	m_simpleTV.User.TVPortal.balanser = 'Trackers'
	end
	add_to_history_exfs(adr:match('^(http.-%.html)') .. '&bal=' .. balanser, m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')', m_simpleTV.User.EXFS.logo)
	if adr:match('magnet:') then
		content(adr:gsub('^http.-%.html&magnet:',''))
	elseif adr:match('HDVB') then
--	debug_in_file(adr:gsub('&HDVB','&') .. m_simpleTV.User.hdvb[1].Address .. '\n')
		if #m_simpleTV.User.hdvb > 1 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', 0, m_simpleTV.User.hdvb, 10000, 1 + 4 + 8 + 2)
			id = id or 1
			if ret == 1 then
				m_simpleTV.User.hdvb.transl_selected = true
				m_simpleTV.User.hdvb.transl_name = m_simpleTV.User.hdvb[id].Name
				m_simpleTV.Control.PlayAddressT({address= adr:gsub('&HDVB','&') .. m_simpleTV.User.hdvb[id].Address, title=m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')', position=m_simpleTV.User.EXFS.position})
			end
		else
			m_simpleTV.Control.PlayAddressT({address= adr:gsub('&HDVB','&') .. m_simpleTV.User.hdvb[1].Address, title=m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')', position=m_simpleTV.User.EXFS.position})
		end
	else
		m_simpleTV.Control.PlayAddressT({address= adr, title=m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')', position=m_simpleTV.User.EXFS.position})
	end
end

function stena_info_chainge()
	if m_simpleTV.User.EXFS.EXFS_is_posters then
	m_simpleTV.User.EXFS.EXFS_is_posters = false
	else
	m_simpleTV.User.EXFS.EXFS_is_posters = true
	end
	return info_exfs()
end

function play_exfs_in_browser(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	return m_simpleTV.Interface.OpenLink(adr)
end

function search_filmix_from_exfs()
	m_simpleTV.OSD.RemoveElement('ID_DIV_TRAILER')
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.EXFS.title:gsub(' %- Украинский','')),'LiteConf.ini')
	add_to_history_of_search()
	search_filmix_media()
end

function search_rezka_from_exfs()
	m_simpleTV.OSD.RemoveElement('ID_DIV_TRAILER')
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.EXFS.title:gsub(' %- Украинский','')),'LiteConf.ini')
	add_to_history_of_search()
	search_rezka()
end

function search_tmdb_from_exfs()
	m_simpleTV.OSD.RemoveElement('ID_DIV_TRAILER')
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.EXFS.title:gsub(' %- Украинский','')),'LiteConf.ini')
	add_to_history_of_search()
	search_tmdb()
end

function search_youtube_from_exfs()
	m_simpleTV.OSD.RemoveElement('ID_DIV_TRAILER')
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.EXFS.title:gsub(' %- Украинский','')),'LiteConf.ini')
	add_to_history_of_search()
	search_youtube()
end

function change_balansers_exfs()
	if m_simpleTV.User.EXFS.balansers == true then
		m_simpleTV.User.EXFS.balansers = false
	else
		m_simpleTV.User.EXFS.balansers = true
	end
	info_exfs()
end

function change_trackers_exfs()
	if m_simpleTV.User.EXFS.trackers == true then
		m_simpleTV.User.EXFS.trackers = false
	else
		m_simpleTV.User.EXFS.trackers = true
	end
	info_exfs()
end
-------------------------------------------------------------------
----[[
if m_simpleTV.User.EXFS.menu then
	m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.EXFS.menu)
end
 local t1={}
 t1.utf8 = true
 t1.name = 'EX-FS меню'
 t1.luastring = 'select_genres()'
 t1.lua_as_scr = true
 t1.key = string.byte('K')
 t1.ctrlkey = 3
 t1.location = 0
 t1.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/exfs_logo.ico'
 m_simpleTV.User.EXFS.menu = m_simpleTV.Interface.AddExtMenuT(t1)
--]]
-----------------------------------------------------------------