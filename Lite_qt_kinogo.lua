--kinogo portal - lite version west_side 18.03.22

function run_lite_qt_kinogo()

			local pll={
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

  local playlist, pls_name
  t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию KinoGo',0,t,9000,1+4+8)

  if ret == -1 or not id then
   return
  end
  if ret == 1 then
   if t[id].Name == 'ПОИСК' then
	search()
   else
    page_kinogo('https://kinogo.cc' .. t[id].Action .. 'page/' .. 1 .. '/')
   end
  end
  if ret == 2 then
   run_westSide_portal()
  end
end

function page_kinogo(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
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
				t[i].InfoPanelTitle = overview
			    i = i + 1
			end
		local current =	url:match('page/(%d+)/')
		local last = answer:match('<div class="bot%-hikinogo_navigation".-</div>')
		for w in last:gmatch('<a.-</a>') do
		if not w:match('Позже') then
		last = w:match('<a href="(.-)"')
		end
		end
		last = last:match('page/(%d+)/')
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
			retAdr = t[id].Address
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
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