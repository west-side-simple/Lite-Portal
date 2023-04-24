-- Плагин для трекеров lite portal 22.04.23
-- author west_side

function start_page()

		local last_adr = m_simpleTV.Config.GetValue('info/torrent','LiteConf.ini') or ''
		local tt = {
		{"http://api.vokino.tv/v2/list?sort=popular&page=1","В тренде"},
		{"http://api.vokino.tv/v2/list?sort=updatings&page=1","Обновления"},
		{"http://api.vokino.tv/v2/list?sort=new&type=movie&page=1","Новинки фильмов"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=movie&page=1","Фильмы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=serial&page=1","Сериалы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=multfilm&page=1","Мультфильмы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=multserial&page=1","Мультсериалы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=documovie&page=1","Документальные фильмы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=docuserial&page=1","Документальные сериалы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=anime&page=1","Аниме"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=tvshow&page=1","ТВ Шоу"},
		{"http://api.vokino.tv/v2/compilations/list?page=","Подборки"},
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
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'Подборки' then
				content_compilation_page(1)
			else
				content_adr_page(t0[id].Action)
			end
		end
		if ret == 2 then
		content(last_adr)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function content_compilation_page(page)
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'http://api.vokino.tv/v2/compilations/list?page='
	.. page .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id
	local name = tab.channels[i].details.name
	local poster = tab.channels[i].details.poster
	t[i].Id = i
	t[i].Name = name
	t[i].InfoPanelLogo = poster
	t[i].Address = id
	t[i].InfoPanelName = name
    i=i+1
	end
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = title .. ' (страница ' .. page .. ')'
		if next_pg <= 36 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
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

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		content_compilation(t[id].Address)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		content_compilation_page(tonumber(page)-1)
		else
		start_page()
		end
		end
		if ret == 3 then
		content_compilation_page(tonumber(page)+1)
		end
end

function content_compilation(list_id)
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'http://api.vokino.tv/v2/compilations/content/list?id='	.. list_id .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id
	local name = tab.channels[i].details.name
	local poster = tab.channels[i].details.poster
	local originalname = tab.channels[i].details.originalname
	local released = tab.channels[i].details.released
	local about = tab.channels[i].details.about
	local genre = tab.channels[i].details.genre
	local type = tab.channels[i].details.type
	t[i].Id = i
	t[i].Name = name .. ' (' .. released .. ') - ' .. type
	t[i].InfoPanelLogo = poster
	t[i].Address = id
	t[i].InfoPanelName = name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
	t[i].InfoPanelTitle = about
    i=i+1
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Подборки '}
		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		content(t[id].Address)
		end
		if ret == 2 then
		content_compilation_page(1)
		end
end

function content(content_id)
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'http://api.vokino.tv/v2/view?id='	.. content_id .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.torrent then
		m_simpleTV.User.torrent = {}
	end
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.details or not tab.details.id or not tab.details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local id = tab.details.id
	local name = tab.details.name
	local poster = tab.details.poster
	local background = tab.details.bg_poster.backdrop
	if poster then poster = poster:gsub('w600_and_h900','w300_and_h450')
		else poster = 'http://m24.do.am/images/logoport.png'
	end
	if background then background = background:gsub('original','w500')
		else background = 'http://m24.do.am/images/logoport.png'
	end
	local originalname = tab.details.originalname or ''
	local released = tab.details.released or ''
	local duration = tab.details.duration or ''
	local director = tab.details.director or ''
	local country = tab.details.country or ''
	local about = tab.details.about or ''
	local genre = tab.details.genre or ''
	local age = tab.details.age or 0
	local rating_kp = tab.details.rating_kp or 0
	local rating_imdb = tab.details.rating_imdb or 0
	local videodesc= '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="300"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. name .. '</font></h4><h5><font color=#BBBBBB>' .. originalname .. '</font></h5><h5><font color=#EBEBEB>' ..  country .. ' • </font><font color=#E0FFFF>' .. released .. '</font></h5><h5><font color=#EBEBEB>' .. genre .. '</font> • ' .. age .. '+</h5><h5>Кинопоиск: ' .. rating_kp .. ', IMDB: ' .. rating_imdb .. '</h5><h5><font color=#E0FFFF>' .. duration .. '</font></h5><h5>Режиссеры: <font color=#EBEBEB>' .. director .. '</font></h5><h5><font color=#EBEBEB>' .. about .. '</font></h5></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')
	local title = name:gsub(' $','') .. ' (' .. released .. ')'
		local t,j={},3
		t[1] = {}
		t[1].Id = 1
		t[1].Address = ''
		t[1].Name = '.: info :.'
		t[1].InfoPanelLogo = background
		t[1].InfoPanelName =  name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
		t[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t[1].InfoPanelTitle = about
		t[1].InfoPanelShowTime = 10000

		t[2] = {}
		t[2].Id = 2
		t[2].Name = 'Online: TMDB'

		if tab.online and tab.online.Filmix then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: Filmix'
		j=j+1
		end

		if tab.online and tab.online.HDRezka then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: HDRezka'
		j=j+1
		end

		if tab.countrys and tab.countrys[1] then
		local i = 1
		while true do
		if not tab.countrys[i]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.countrys[i].playlist_url
		t[j].Name = tab.countrys[i].title
		i=i+1
		j=j+1
		end
		end

		if tab.genres and tab.genres[1] then
		local k = 1
		while true do
		if not tab.genres[k]
		then
		break
		end
		if not tab.genres[k].playlist_url:match('%+') then
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.genres[k].playlist_url
		t[j].Name = tab.genres[k].title
		end
		k=k+1
		j=j+1
		end
		end

		if tab.directors and tab.directors[1] then
		local m = 1
		while true do
		if not tab.directors[m]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.directors[m].playlist_url
		t[j].Name = 'Director: ' .. tab.directors[m].title
		m=m+1
		j=j+1
		end
		end

		if tab.casts and tab.casts[1] then
		local n = 1
		while true do
		if not tab.casts[n]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.casts[n].playlist_url
		t[j].Name = 'Casts: ' .. tab.casts[n].title
		t[j].InfoPanelLogo = tab.casts[n].poster or ''
		t[j].InfoPanelLogo = t[j].InfoPanelLogo:gsub('w600_and_h900_bestv2','w500_and_h282_face')
		t[j].InfoPanelName =  tab.casts[n].title .. ' (' ..  (tab.casts[n].birthday or 'not info') .. ') ' .. (tab.casts[n].place_of_birth or '')
		t[j].InfoPanelTitle = tab.casts[n].biography
		t[j].InfoPanelShowTime = 10000
		n=n+1
		j=j+1
		end
		end

		if tab.similars and tab.similars[1] and tab.similars[1].details and tab.similars[1].details.id then
		local o = 1
		while true do
		if not tab.similars[o]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.similars[o].details.id
		t[j].Name = 'Similar: ' .. tab.similars[o].details.name .. ' - ' .. tab.similars[o].details.type
		if not tab.similars[o].details.wide_poster or tab.similars[o].details.wide_poster == '' then
			t[j].InfoPanelLogo = tab.similars[o].details.poster
		else
			t[j].InfoPanelLogo = tab.similars[o].details.wide_poster
		end
		t[j].InfoPanelName =  tab.similars[o].details.name .. ' / ' .. tab.similars[o].details.originalname .. ' (' .. tab.similars[o].details.released .. ') ' .. (tab.similars[o].details.genre or '')
		t[j].InfoPanelTitle = tab.similars[o].details.about
		t[j].InfoPanelShowTime = 10000
		o=o+1
		j=j+1
		end
		end

		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Главная '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Трекеры'}
		local current_id = m_simpleTV.User.torrent.id_balanser or 1
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, tonumber(current_id) - 1, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Name:match('Similar: ') then
			content(t[id].Address)
		elseif t[id].Name:match('TMDB') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			search_tmdb()
		elseif t[id].Name:match('Filmix') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			search_filmix_media()
		elseif t[id].Name:match('HDRezka') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			search_rezka()
		else
		content_adr_page(t[id].Address)
		end
		end
		if ret == 2 then
		start_page()
		end
		if ret == 3 then
		torrents(tab.torrents .. 'seed_desc')
		end
end

function content_adr_page(adr)
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = adr .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title or 'Media'
	local page = tab.page.current
	local t, i = {}, 1
	while true do
	if not tab.channels[i] or not tab.channels[i].details.id
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id or ''
	local name = tab.channels[i].details.name or 'noname'
	local poster = tab.channels[i].details.poster or ''
	local originalname = tab.channels[i].details.originalname or ''
	local released = tab.channels[i].details.released or ''
	local about = tab.channels[i].details.about or ''
	local genre = tab.channels[i].details.genre or ''
	local type = tab.channels[i].details.type or ''
	local address = tab.channels[i].playlist_url
	t[i].Id = i
	t[i].Name = name .. ' (' .. released .. ') - ' .. type
	t[i].InfoPanelLogo = poster
	t[i].Address = id
	t[i].InfoPanelName = name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
	t[i].InfoPanelTitle = about
    i=i+1
	end
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		title = title .. ' (страница ' .. page .. ')'
		if next_pg <= 36 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
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

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Name == 'noname' then
			content_adr_page(adr)
		end
			content(t[id].Address)
		end
		if ret == 2 then
			if tonumber(prev_pg) > 0 then
				content_adr_page(adr:gsub('%&page=.-$','') .. '&page=' .. tonumber(page)-1) else
				start_page()
			end
		end
		if ret == 3 then
			content_adr_page(adr:gsub('%&page=.-$','') .. '&page=' .. tonumber(page)+1)
		end
end

function torrents(adr)
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = adr:gsub('sorting=','sortings=') .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local content_id = adr:match('id=(.-)%&')
	if not tab or not tab.menu or not tab.menu[1] or not tab.menu[1].title or not tab.menu[1].submenu or not tab.menu[1].submenu[1] or not tab.menu[1].submenu[1].playlist_url
	then
	return end
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
			content(content_id)
		end
end

function torrents_tracker(adr)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.torrent then
		m_simpleTV.User.torrent = {}
	end
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = adr:gsub('sorting=','sortings=') .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local content_id = url:match('id=(.-)%&')
	local title = url:match('tracker=(.-)%&') or 'Все трекеры'
	if title == '' then title = 'Все трекеры' end
	local poster = 'http://proxy.vokino.tv/image/t/p/w600_and_h900_bestv2' .. tab.details.poster
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].trackerName or not tab.channels[1].magnet
	then
	return end
	m_simpleTV.Http.Close(session)
	local current_id=1
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local name = tab.channels[i].title
	local sid = tab.channels[i].sid or ''
	local pir = tab.channels[i].pir or ''
	local bitrate = tab.channels[i].bitrate or ''
	local bitrat = tab.channels[i].bitrat or ''
	local trackerName = tab.channels[i].trackerName
	local sizeName = tab.channels[i].sizeName
	local address = tab.channels[i].magnet
	local createTime = tab.channels[i].createTime
	t[i].Id = i
	t[i].Name = name
	t[i].InfoPanelLogo = poster
	t[i].Address = address
	t[i].InfoPanelName = name
	t[i].InfoPanelTitle = trackerName .. ' • ' .. bitrate .. '/' .. bitrat .. ' ' .. sizeName .. ' sid/pir: ✅ ' .. sid .. '  🔻 ' .. pir .. ' • ' .. createTime
	t[i].InfoPanelShowTime = 30000
	if m_simpleTV.User.torrent.address and address == m_simpleTV.User.torrent.address then current_id = i end
    i=i+1
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Трекеры '}
		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, tonumber(current_id-1), t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=t[id].Name})
		end
		if ret == 2 then
			torrents(adr)
		end
end
