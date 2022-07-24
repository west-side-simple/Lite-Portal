--kinokong portal - lite version west_side 15.07.22

function run_lite_qt_kinokong()
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/kinokong') or ''
		local pll={
		{"","Подборки KinoKong"},
		{"","Актёры"},
		{"/filmes/","Фильмы - последние поступления"},
		{"/filmes/boeviky/","Боевик"},
		{"/filmes/vestern/","Вестерн"},
		{"/filmes/voennyy/","Военный"},
		{"/filmes/detektiv/","Детектив"},
		{"/filmes/drama/","Драма"},
		{"/filmes/istoricheskiy/","Исторический"},
		{"/filmes/komedian/","Комедия"},
		{"/filmes/kriminal/","Криминал"},
		{"/filmes/melodrama/","Мелодрама"},
		{"/filmes/priklyucheniya/","Приключения"},
		{"/filmes/semeynyy/","Семейный"},
		{"/filmes/triller/","Триллер"},
		{"/filmes/horrors/","Ужасы"},
		{"/filmes/fantastic/","Фантастика"},
		{"/filmes/fentezii/","Фэнтези"},
		{"/filmes/2022/","2022 года"},
		{"/filmes/kino-2021/","2021 года"},
		{"/filmes/2020-gods/","2020 года"},
		{"/filmes/otechestvennyy/","Русские"},
--		{"/films-4k/","4K"},
		{"/seriez/","Сериалы - последние поступления"},
		{"/cartoons/","Мультфильмы"},
		{"/animes/","Аниме"},
		{"/doc/","ТВ - шоу"},
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
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию KinoKong',0,t,9000,1+4+8)

  if ret == -1 or not id then
   return
  end
  if ret == 1 then
   if t[id].Name == 'ПОИСК' then
	search()
   elseif t[id].Name == 'Подборки KinoKong' then
	kinokong()
   elseif t[id].Name == 'Актёры' then
	page_actors_kinokong('https://ex-fs.net/actors/')
   else
    page_kinokong('https://kinokong.pro' .. t[id].Action .. 'page/' .. 1 .. '/')
   end
  end
  if ret == 2 then
   kinokong_info(last_adr)
  end
  if ret == 3 then
   run_westSide_portal()
  end
end

function kinokong()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://kinokong.pro/podborka.html'})
		if rc ~= 200 then return end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')

		local t,i={},1
			for w in answer:gmatch('<div class="podborki%-item%-block">.-</div>') do
				local name = w:match('<span class="podborki%-title">(.-)</span>')
				local adr = w:match('href="(.-)"')
				local logo = w:match('src="(.-)"')
				if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://kinokong.pro/' .. logo
				t[i].Name = name:gsub('%&quot%;','"')
				t[i].Address = 'https://kinokong.pro' .. adr
				t[i].InfoPanelName = 'KinoKong подборка: ' .. name
				t[i].InfoPanelShowTime = 30000
			    i = i + 1
			end

		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Подборки KinoKong (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			page_kinokong(t[id].Address)
		end
		if ret == 2 then
		  run_lite_qt_kinokong()
		end
end

function page_kinokong(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
		local title = answer:match('<title>(.-)</title>') or ''
		title = title:gsub(' смотреть.-$',''):gsub('Смотреть.-$','')
		if url:match('/index%.php%?do=actors%&actor=(.-)$') then
		title = m_simpleTV.Common.multiByteToUTF8(unescape(url:match('/index%.php%?do=actors%&actor=(.-)$')))
		title = title:gsub('_',' ')
		end
		if url:match('/index%.php%?do=directors%&director=(.-)$') then
		title = m_simpleTV.Common.multiByteToUTF8(unescape(url:match('/index%.php%?do=directors%&director=(.-)$')))
		title = title:gsub('_',' ')
		end
		local t,i={},1
			for w in answer:gmatch('<div class="main%-sliders%-shadow">.-</h2>') do
				local adr,name = w:match('<h2 class="main%-sliders%-title"><a href="(.-)">(.-)</a>')
				local logo = w:match('data%-src="(.-)"')
				local overview = w:match('<noindex>(.-)</noindex>') or ''
				if not logo or not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://kinokong.pro' .. logo
				t[i].Name = name:gsub('%&quot%;','"')
				t[i].Address = adr
				t[i].InfoPanelName = 'KinoKong info: ' .. name
				t[i].InfoPanelShowTime = 30000
				t[i].InfoPanelTitle = overview:gsub('^\n     ','')
			    i = i + 1
			end
		local current =	url:match('page/(%d+)/') or 1
		local last = answer:match('<div class="nextprev">.-</div>') or ''
		local last_end = 1
		local all = answer:match('<span class="nav_ext">.-rel="nofollow">(.-)</a></div>') or answer:match('<span class="thide pprev">.-<a href=".-page/(%d+)/"') or 1
		for w in last:gmatch('<a.-</a>') do
		if w:match('page/(%d+)/') and tonumber(w:match('page/(%d+)/')) > tonumber(current) then last_end = w:match('page/(%d+)/')
		end
		end
		local prev_pg, next_pg
		if tonumber(current) > 1 then
		prev_pg = 'page/' .. tonumber(current) - 1 .. '/'
		end
		if last_end and tonumber(current) < tonumber(last_end) then
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (стр. '.. current .. ' из ' .. all .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			kinokong_info(t[id].Address)
		end
		if ret == 2 then
		if prev_pg then
		  page_kinokong(url:gsub('page/.-/','') .. prev_pg)
		else
		  run_lite_qt_kinokong()
		end
		end
		if ret == 3 then
		  page_kinokong(url:gsub('page/.-/','') .. next_pg)
		end
		end

function kinokong_info(url)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local title = answer:match('<h1 itemprop="name">(.-)</h1>') or 'KinoKong'
	local poster = answer:match('<div class="full%-poster">.-src="(.-)"')
	poster = 'https://kinokong.pro/' .. poster
	local country = answer:match('<div><span>Страна:</span> <b>(.-)</b></div>') or ''
	local kp = answer:match('<span class="main%-sliders%-kp" data%-name="KP">(.-)</span>')
	local imdb = answer:match('<span class="main%-sliders%-imdb" data%-name="IMDb">(.-)</span>')
	local rating = ''
	if kp then rating = 'KP: ' .. kp .. ' • ' end
	if imdb then rating = rating .. 'IMDB: ' .. imdb .. ' ' end
	if country and country ~= '' then country = country .. ' • ' end
	local overview = answer:match('itemprop="description">(.-)<br />') or ''
	overview = overview:gsub('<br>', ''):gsub('\n                ',''):gsub('<.->',''):gsub('Чтобы отключить.-$','')
	local overwiew_min = answer:match('<meta name="description" content="(.-)" />')
	local all_tag = answer:match('<div class="kkch">(.-)</div>') or ''
	local all_tag_1 = answer:match('<div class="full%-kino%-info1">(.-)<a class="full_btn_podborka"') or ''
	local videodesc= '<table width="100%"><tr><td style="padding: 5px 5px 0px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 5px 5px 0px; color: #AAAAAA; vertical-align: middle;"><h3><font color=#00FA9A>' .. title .. '</font></h3><h4>' .. country .. rating .. '</h4><h4>' .. overview .. '</h4></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')
	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title .. ': KinoKong info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t1[1].InfoPanelTitle = overwiew_min
		t1[1].InfoPanelShowTime = 10000
		for w in all_tag:gmatch('<a.-</a>') do
		local adr,name = w:match('href="(.-)">(.-)<')
		if name and name ~= 'Главная' and name ~= 'Фильмы 4к' then
		if not adr or not name then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = name
		j=j+1
		end
		end
		for w in all_tag_1:gmatch('<a.-</a>') do
		local adr,name = w:match('href="/index%.php%?do=actors%&actor=(.-)".-<br />(.-)<')
		if not adr or not name then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = 'https://kinokong.pro/index.php?do=actors&actor=' .. escape(m_simpleTV.Common.string_fromUTF8(adr))
		t1[j].Name = 'В ролях: ' .. name
		j=j+1
		end
		for w in all_tag_1:gsub('^.-</script>',''):gmatch('<a.-</a>') do
		local adr,name = w:match('href="/index%.php%?do=directors%&director=(.-)".-itemprop="name">(.-)<')
		if not adr or not name then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = 'https://kinokong.pro/index.php?do=directors&director=' .. escape(m_simpleTV.Common.string_fromUTF8(adr))
		t1[j].Name = 'Режиссёр: ' .. name
		j=j+1
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('KinoKong: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			 kinokong_info(url)
			else
			 page_kinokong(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_kinokong()
		end
		if ret == 3 then
			setConfigVal('info/kinokong',url)
			retAdr = url
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
		end
end

function page_actors_kinokong(inAdr)

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
	answer = answer:gsub('\n', ' ')
	local title = answer:match('<title>(.-)</title>') or 'KinoKong'

	if m_simpleTV.Common.isUTF8(title) == false then title = m_simpleTV.Common.multiByteToUTF8(title) end
	title = title:gsub('Смотреть кино ex ua, fs to фильмы онлайн бесплатно в хорошем HD качестве', 'Фильмы'):gsub(' смотреть онла.+', ''):gsub('^Сериал ', ''):gsub('%(.+', ''):gsub(' %&raquo;', ''):gsub('Смотреть ', ''):gsub(' онлайн бесплатно ', ''):gsub(' онлайн смотреть бесплатно в хорошем HD качестве', ''):gsub('Российские и Голливудские актеры%, актрисы%, знаменитости на EX%-FS%.NET', 'фильмы с актером | актрисой')
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t, i = {}, 1

			for w in answer:gmatch('<div class="MiniPostAllForm MiniPostAllFormDop.-">.-</div>  </div>') do

			local logo, adr, name = w:match('<img src="(.-)".-<a href="(.-)" title="(.-)"')

					if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Address = 'https://kinokong.pro/index.php?do=actors&actor=' .. escape(m_simpleTV.Common.string_fromUTF8(m_simpleTV.Common.fromPercentEncoding(name:gsub(' /.+', ''):gsub(' ', '_'))))
				t[i].Name = name:gsub(' /.+', '')
				t[i].InfoPanelLogo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
				t[i].InfoPanelName = name:gsub(' /.+', '')
				t[i].InfoPanelTitle = title
				t[i].InfoPanelShowTime = 10000
				i = i + 1
			end

		local prev_pg = answer:gsub('^.-<div class="navigations">',''):match('</a>   <a href="(.-)">Назад</a>')
		local next_pg = answer:gsub('^.-<div class="navigations">',''):match('</a> <a href="(.-)">Вперед</a>')
		local all_pg = answer:gsub('^.-<div class="navigations">',''):match('(%d+)</a>   ') or 1
		local current_page = inAdr:match('/page/(%d+)/') or 1
		if tonumber(current_page) > 1 and not title:match('траница') then title = title .. ' стр. ' .. current_page end
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
		all_pg = ' из ' .. all_pg
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. all_pg, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		page_kinokong(t[id].Address)
		end
		if ret == 2 then
		if prev_pg then
		page_actors_kinokong(inAdr:gsub('/page/.-$','/') .. 'page/' .. current_page-1 .. '/')
		else
		run_lite_qt_kinokong()
		end
		end
		if ret == 3 then
		page_actors_kinokong(inAdr:gsub('/page/.-$','/') .. 'page/' .. current_page+1 .. '/')
		end
end