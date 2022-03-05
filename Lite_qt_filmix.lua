--Filmix portal - lite version west_side 05.03.22

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

function run_lite_qt_filmix()

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
			elseif t0[id].Name:match('одборки') then
				collection_filmix(t0[id].Action)
			elseif t0[id].Name:match('Избранное') then
				run_lite_qt_filmix()
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

function type_filmix(con)

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
	local title
	if url:match('filmi/') then title = 'Кино'
	elseif url:match('seria/') then title = 'Сериалы'
	elseif url:match('multserialy/') then title = 'Мультсериалы'
	elseif url:match('mults/') then title = 'Мульты'
	end
	local filmixsite = 'https://filmix.gay'
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
			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixsite})
		end
---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
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
		m_simpleTV.Http.Close(session)
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
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
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
			sim[j].Name = sim_title
			sim[j].Address = sim_adr
			sim[j].InfoPanelLogo = sim_img
			sim[j].InfoPanelName = 'Filmix медиаконтент: ' .. sim_title
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
				t[i].Name = name
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix медиаконтент: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
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
			m_simpleTV.Control.PlayAddress(sim[id].Address)
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
			m_simpleTV.Control.PlayAddress(t[id].Address)
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
	local filmixsite = 'https://filmix.gay'
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
	if left then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите коллекцию Filmix (' .. #t .. ') ' .. title .. ' ' .. title1,0,t,10000,1+4+8+2)
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
	local title = 'Коллекция'
	local filmixsite = 'https://filmix.gay'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
	local page = url:match('/page/(%d+)/') or 1
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t,i,j = {},1,1
	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not sessionFilmix then return end
	m_simpleTV.Http.SetTimeout(sessionFilmix, 8000)

	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end

		local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nAccept: application/json, text/javascript, */*; q=0.01\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url
		local body = filmixsite .. '/api/notifications/get'
		local rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = body, url = url, method = 'post', headers = headers})
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
		rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = body, url = url, method = 'post', headers = headers})
		end
		m_simpleTV.Http.Close(sessionFilmix)
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
				t[i].Name = name
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Filmix медиаконтент: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	if left then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите медиаконтент Filmix (' .. #t .. ') ' .. title .. ': ' .. title1 .. ' - страница ' .. page,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.PlayAddress(t[id].Address)
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
	local title = 'Персоны'
	local filmixsite = 'https://filmix.gay'
	url = url:gsub('https?://filmix%..-/', filmixsite .. '/')
	local page = url:match('/page/(%d+)/') or 1

	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t,i = {},1
	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not sessionFilmix then return end
	m_simpleTV.Http.SetTimeout(sessionFilmix, 8000)

	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end

		local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nAccept: application/json, text/javascript, */*; q=0.01\nX-Requested-With: XMLHttpRequest\nReferer: ' .. url
		local body = filmixsite .. '/api/notifications/get'
		local rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = body, url = url, method = 'post', headers = headers})
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
		rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = body, url = url, method = 'post', headers = headers})
		end
		m_simpleTV.Http.Close(sessionFilmix)
		answer = m_simpleTV.Common.multiByteToUTF8(answer,1251)
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
				t[i].InfoPanelName = 'Filmix персоны: ' .. name
				t[i].InfoPanelTitle = desc
				t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
	if left then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите персону Filmix (' .. #t .. ') ' .. title .. ': ' .. title1 .. ' - страница ' .. page,0,t,10000,1+4+8+2)
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
	local title = 'Персона'
	local filmixsite = 'https://filmix.gay'
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
		m_simpleTV.Http.Close(session)
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
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		answer = answer:gsub('<br />', ''):gsub('\n', '')
		title = title .. (': ' .. answer:match('<div class="name" itemprop="name">(.-)</div>') or '')
		local j,t = 1,{}
		for ws in answer:gmatch('<li class="slider%-item">.-</li>') do
		local adr,logo,name = ws:match('href="(.-)".-src="(.-)".-title="(.-)"')
		if not adr or not name then break end
		local year = adr:match('(%d%d%d%d)%.html$')
		if year then year = ', ' .. year else year = '' end
		t[j] = {}
		t[j].Id = j
		t[j].Name = name .. year
		t[j].Address = adr
		t[j].InfoPanelLogo = logo
		t[j].InfoPanelName = 'Filmix медиаконтент: ' .. name
		j=j+1
		end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите медиаконтент Filmix (' .. #t .. ') ' .. title,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.PlayAddress(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_filmix()
		end
end

function search_filmix_media()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local filmixsite = 'https://filmix.gay'
	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(sessionFilmix, 8000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end

			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl
			local body = 'scf=fx&story=' .. search_ini .. '&search_start=0&do=search&subaction=search&years_ot=&years_do=&kpi_ot=&kpi_do=&imdb_ot=&imdb_do=&sort_name=asc&undefined=asc&sort_date=&sort_favorite='
			local rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})
			m_simpleTV.Http.Close(sessionFilmix)

					local otvet = answer:match('<article.-<script>') or ''
					local i, t = 1, {}
					for w in otvet:gmatch('<article.-</article>') do
					local logo, name, adr = w:match('<a class="fancybox" href="(.-)".-alt="(.-)".-<a class="watch icon%-play" itemprop="url" href="(.-)"')
					if not logo or not adr or not name then break end
							t[i] = {}
							t[i].Id = i
							t[i].Address = adr
							t[i].Name = name
							t[i].InfoPanelLogo = logo:gsub('/orig/','/thumbs/w220/')
							t[i].InfoPanelName = name
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено Filmix: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.PlayAddress(t[id].Address)
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			search_all()
		end
	end