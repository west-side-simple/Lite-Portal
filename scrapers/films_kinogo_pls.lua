-- скрапер TVS для сайта https://kinogo.cc/ от west_side (03/08/21)

	module('films_kinogo_pls', package.seeall)
	local my_src_name = 'Фильмы KinoGo'

	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://kinogo.cc/templates/kinogo/images/kinogo_orig.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	end

	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function LoadFromPage(pls, pls_name)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.2785.143 Safari/537.36', prx, false)
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 120000)
		local str, page = '', 1
	while page <= 110 do
	local url = 'https://kinogo.cc' .. pls .. 'page/' .. page .. '/'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('page/1/','')})
			if rc ~= 200 then break end
			str = str .. answer:gsub('\n', ' ')
			page = page + 1
			m_simpleTV.OSD.ShowMessageT({text = ' KinoGo (' .. pls_name .. ') - общий прогресс загрузки: ' .. page-1, color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
	end
	 return str
	end

	local function LoadFromSite(pls, pls_name)
		local t, i = {}, 1
		local answer = LoadFromPage(pls, pls_name)
			for w in answer:gmatch('<div class="hikinogo_lenta">.-<div class="icons">') do
			if i <= 1000 then
				local name = w:match('title="(.-)"')
				year = name:match('%((%d+)') or 0
				local adr = w:match('href="(.-)"')
				local logo = w:match('src="(.-)"') or ''
				t[i] = {}
				t[i].group = year
				t[i].logo = 'https://kinogo.cc' .. logo
				t[i].name = name
				t[i].address = adr
			    i = i + 1
			end
			end
	 return t
	end

	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]

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
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('KinoGo - select playlist',0,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = t[id].Action
   pls_name = t[id].Name
  end

		local t_pls = LoadFromSite(playlist, pls_name)
			if not t_pls then m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'}) return end
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')