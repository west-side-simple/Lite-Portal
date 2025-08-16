--kinogo portal - lite version west_side 01.04.25

local function get_al_t_y(title, year)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGkuYXBidWdhbGwub3JnLz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzE=') .. '&name=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&year=' .. year
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = unescape1(answer)
	local id_imdb = answer:match('"id_imdb":"(tt.-)"')
--	debug_in_file(title .. ' ' .. year .. '\n' .. answer .. '\n','c://1/content.txt')
	if id_imdb then
--	debug_in_file( 'id_imdb=' .. id_imdb .. '\n', 'c://1/content.txt')
	return id_imdb
	end
	return false
end

local function get_hdvb(title, year)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGl2Yi5pbmZvL2FwaS92aWRlb3MuanNvbj90b2tlbj01ZTJmZTRjNzBiYWZkOWE3NDE0YzRmMTcwZWUxYjE5MiZ0aXRsZT0=') .. m_simpleTV.Common.toPercentEncoding(title)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = unescape1(answer)
--	debug_in_file(title .. ' ' .. year .. '\n' .. answer .. '\n','c://1/content.txt')
	local t = {}
		for ru_title, en_title, in_year, kp_id, tr, url in answer:gmatch('"title_ru":"(.-)".-"title_en":"(.-)".-"year":(%d%d%d%d).-"kinopoisk_id":(%d+).-"translator":"(.-)".-"iframe_url":"(.-)"') do
			if (ru_title and ru_title == title or en_title and en_title == title) and tonumber(in_year) == tonumber(year) then
				t[#t + 1] = {}
				t[#t].Id = #t
				t[#t].Address = url:gsub('\\','')
				t[#t].Name = tr
				t[#t].kp_id = kp_id
--	debug_in_file(tr .. ' ' .. url:gsub('\\','') .. '\n','c://1/content.txt')
			end
		end
	if #t ~= 0 then
--	debug_in_file( 'kp_id=' .. t[1].kp_id .. '\n', 'c://1/content.txt', setnew )
	return t, t[1].kp_id
	end
	return false
end

	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

function run_lite_qt_kinogo()
	stena_clear()
	local last_adr = getConfigVal('info/kinogo') or ''
			local pll={
		{"","Подборки KinoGo"},
		{"/rekomenduem-posmotret/","KinoGo рекомендует"},
		{"/filmy/","Фильмы - последние поступления"},
		{"/filmy/genre-filmy-biograficheskiy/","Биография"},
		{"/filmy/genre-filmy-boevik/","Боевик"},
		{"/filmy/genre-filmy-vestern/","Вестерн"},
		{"/filmy/genre-filmy-voennyy/","Военный"},
		{"/filmy/genre-filmy-detektiv/","Детектив"},
		{"/filmy/genre-filmy-dokumentalnyy/","Док.фильм"},
		{"/filmy/genre-filmy-drama/","Драма"},
		{"/filmy/genre-filmy-istoricheskiy/","Исторический"},
		{"/filmy/genre-filmy-komediya/","Комедия"},
		{"/filmy/genre-filmy-korotkometrazhnyy/","Короткамет."},
		{"/filmy/genre-filmy-kriminal/","Криминал"},
		{"/filmy/genre-filmy-melodrama/","Мелодрама"},
		{"/filmy/genre-filmy-myuzikl/","Мюзикл"},
		{"/filmy/genre-filmy-priklyucheniya/","Приключения"},
		{"/filmy/genre-filmy-semeynyy/","Семейный"},
		{"/filmy/genre-filmy-triller/","Триллер"},
		{"/filmy/genre-filmy-uzhasy/","Ужасы"},
		{"/filmy/genre-filmy-fantastika/","Фантастика"},
		{"/filmy/genre-filmy-fentezi/","Фэнтези"},
		{"/filmy/genre-filmy-erotika/","Эротика"},
		{"/filmy/years-filmy-2024/","2024 года"},
		{"/filmy/years-filmy-2023/","2023 года"},
		{"/filmy/years-filmy-2022/","2022 года"},
		{"/filmy/years-filmy-2021/","2021 года"},
		{"/filmy/years-filmy-2020/","2020 года"},
		{"/filmy/years-filmy-2019/","2019 года"},
		{"/filmy/years-filmy-2018/","2018 года"},
		{"/filmy/country-filmy-rossiya/","Русские"},
		{"/serialy/","Сериалы - последние поступления"},
		{"/multfilmy/","Мультфильмы"},
		{"/multserialy/","Мультсериалы"},
		{"/anime-multfilmy/","Аниме"},
		{"/anime-serialy/","Аниме сериалы"},
		{"/tv-shou/","ТВ - шоу"},
		{"","ПОИСК"},
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]  end

  if last_adr and last_adr ~= '' then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
  end
  t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию KinoGo',0,t,9000,1+4+8)

  if ret == -1 or not id then
   return
  end
  if ret == 1 then
   if t[id].Name == 'ПОИСК' then
	search()
   elseif t[id].Name == 'Подборки KinoGo' then
	kinogo()
   else
    page_kinogo('https://kinogo.cc' .. t[id].Action .. 'page/' .. 1 .. '/')
   end
  end
  if ret == 2 then
   kinogo_info(last_adr)
  end
  if ret == 3 then
   run_westSide_portal()
  end
end

function kinogo()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://kinogo.cc/podborki.html'})
		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
		local answer1 = answer:match('<div class="oformlenie">(.-)</div>')
		local t,i={},1
			for w in answer1:gmatch('<a href.-</a>') do
				local name = w:match('title="(.-)"')
				local adr = w:match('href="(.-)"')
				local logo = w:match('src="(.-)"')
				if adr == '/collection-dc/' then name = name:gsub('BBC','DC') end
				if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://kinogo.cc' .. logo
				t[i].Name = name:gsub('%&quot%;','"')
				t[i].Address = 'https://kinogo.cc' .. adr
				t[i].InfoPanelName = 'KinoGo подборка: ' .. name
				t[i].InfoPanelShowTime = 30000
			    i = i + 1
			end

		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Подборки KinoGo (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			page_kinogo(t[id].Address)
		end
		if ret == 2 then
		  run_lite_qt_kinogo()
		end
end

function page_kinogo(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
		local t,i={},1
			for w in answer:gmatch('<div class="shortimg">.-<div class="icons">') do
				local name = w:match('title="(.-)"')
				local year = name:match('%((%d+)') or 0
				local adr = w:match('href="(.-)"')
				local logo = w:match('src="(.-)"')
				local overview = w:match('<br>(.-)<br>') or ''
				if not logo or not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://kinogo.cc' .. logo
				t[i].Name = name:gsub('%&quot%;','"')
				t[i].Address = adr
				t[i].InfoPanelName = 'KinoGo info: ' .. name
				t[i].InfoPanelShowTime = 30000
				t[i].InfoPanelTitle = overview:gsub('^\n     ','')
			    i = i + 1
			end
		local current =	url:match('page/(%d+)/') or 1
		local last = answer:match('<div class="bot%-hikinogo_navigation".-</div>') or ''
		for w in last:gmatch('<a.-</a>') do
		if not w:match('Позже') then
		last = w:match('<a href="(.-)"')
		end
		end
		last = last:match('page/(%d+)/') or 1
		local prev_pg, next_pg
		if tonumber(current) > 1 then
		prev_pg = 'page/' .. tonumber(current) - 1 .. '/'
		end
		if tonumber(current) < tonumber(last) then
		next_pg = 'page/' .. tonumber(current) + 1 .. '/'
		end
		if next_pg then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg then
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('(страница '.. current .. ' из ' .. last .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			kinogo_info(t[id].Address)
		end
		if ret == 2 then
		if prev_pg then
		  page_kinogo(url:gsub('page/.-/','') .. prev_pg)
		else
		  run_lite_qt_kinogo()
		end
		end
		if ret == 3 then
		  page_kinogo(url:gsub('page/.-/','') .. next_pg)
		end
end

function kinogo_info(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local title = answer:match('<font color="yellow">(.-)</font>') or answer:match('<title>(.-)</title>') or 'hdkinoteatr'
	title = title:gsub('%).-$', ')')
	local poster = answer:match('itemprop="image" src="(.-)"')
	poster = 'https://kinogo.cc/' .. poster
	local overview = answer:match('<div itemprop="description"><i>(.-)</i></div>') or ''
	overview = overview:gsub('<br>', ''):gsub('\n                ',''):gsub('<.->',''):gsub('\n','')
	local all_tag = answer:match('<br>\n(.-)<div itemprop="description">') or ''
	local all_tag_txt = all_tag:gsub('<a.->', ''):gsub('<div.->', ''):gsub('</div>', ''):gsub('<font.->', ''):gsub('</font>', ''):gsub('\n', ''):gsub('\b', ''):gsub('<br/><br/>', '<br>'):gsub('<br/><br/><br/>', '<br>'):gsub('         <br>', ''):gsub('<br><br/>', '')
	local videodesc= '<table width="100%"><tr><td style="padding: 5px 5px 0px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 5px 5px 0px; color: #AAAAAA; vertical-align: middle;"><h3><font color=#00FA9A>' .. title .. '</font></h3><h5>' .. all_tag_txt .. '</h5></td></tr></table><table width="100%"><tr><td style="padding: 0px 5px 0px; color: #FFFFFF; vertical-align: middle;"><h4>' .. overview .. '</h4></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')
	local all_plus = answer:match('<div class="relatednews">(.-)<div style="clear:both">') or ''
	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title .. ': KinoGo info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t1[1].InfoPanelTitle = overview
		t1[1].InfoPanelShowTime = 10000
		for w in all_tag:gmatch('<a.-</a>') do
		local adr,name = w:match('href="(.-)">(.-)<')
		if not adr or not name then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = adr
		if adr:match('/actors/') then name = 'В ролях: ' .. name end
		if adr:match('/director/') then name = 'Режиссёр: ' .. name end
		t1[j].Name = name
		j=j+1
		end
		for w in all_plus:gmatch('<a.-</a>') do
		local adr,name,logo = w:match('href="(.-)".-title="(.-)".-src="(.-)"')
		local year
		if not adr or not name or not logo then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = adr
		year = adr:match('%-(%d%d%d%d)%.html')
		t1[j].Name = 'Похожий контент: ' .. name .. ((' (' .. year .. ')') or '')
		t1[j].InfoPanelLogo = 'https://kinogo.cc' .. logo
		t1[j].InfoPanelName = name .. ((' (' .. year .. ')') or '')
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		local name_title = title:gsub(' %(.-$','')
		local year_title = title:match('%((%d%d%d%d)%)')
--[[		local hdvb, kp_id = get_hdvb(name_title, year_title)
		if hdvb~=false then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		end--]]
		local id_imdb = get_al_t_y(name_title, year_title)
		if id_imdb~=false then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('KinoGo: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			 kinogo_info(url)
			elseif t1[id].Name:match('Похожий контент: ') then
			 kinogo_info(t1[id].Address)
			else
			 page_kinogo(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_kinogo()
		end
		if ret == 3 then
			setConfigVal('info/kinogo',url)
--[[			if not m_simpleTV.User.hdvb then
				m_simpleTV.User.hdvb = {}
			end
			if m_simpleTV.Control.MainMode == 0 then
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster, TypeBackColor = 0, UseLogo = 3, Once = 1})
				m_simpleTV.User.hdvb.poster = poster
			end
			if #hdvb > 1 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', 0, hdvb, 10000, 1 + 4 + 8 + 2)
			id = id or 1
			if ret == 1 then

				m_simpleTV.User.hdvb.transl_selected = true
				m_simpleTV.User.hdvb.transl_name = hdvb[id].Name
				m_simpleTV.Control.PlayAddressT({address=hdvb[id].Address .. '&kinogo=' .. url, title=title})
			end
			else
				m_simpleTV.Control.PlayAddressT({address=hdvb[1].Address .. '&kinogo=' .. url, title=title})
			end--]]
			m_simpleTV.Control.PlayAddressT({address='https://www.imdb.com/title/' .. id_imdb, title=title})
		end
end