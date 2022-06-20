-- скрапер TVS для загрузки плейлиста "EX-FS NEW" для сайта https://ex-fs.net (30/08/21) - автор west_side
-- необходимы скрипты poisk_kinopoisk.lua, kinopoisk.lua - автор nexterr, ex-fs.lua  - автор west_side

	module('ex-fs_pls', package.seeall)
	local my_src_name = 'EX-FS select'
	local sqlstr = "DELETE FROM Channels WHERE ExtFilter IN ( SELECT Id FROM ExtFilter WHERE Name='".. my_src_name .."' );"


	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://ex-fs.net/templates/ex-fs/images/favicon.ico', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 3, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function LoadFromPage(pls, pls_name)
	local url = 'https://ex-fs.net'

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		local str, page, page_max = '', 1, 1
	while page <= tonumber(page_max) do
		local url = url .. pls .. 'page/' .. page .. '/'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('page/1/','')})
			if rc ~= 200 then break end
			if tonumber(page) == 1 then
			t1=os.time()
			page_max = answer:match('">(%d+)</a>   <span>Назад</span>') or answer:match('">(%d+)</a>    <span>Назад</span>') or 1 end
			str = str .. answer:gsub('\n', '')
			page = page + 1
			m_simpleTV.OSD.ShowMessageT({text = ' EX-FS (' .. pls_name .. ') - общий прогресс загрузки: ' .. math.floor((tonumber(page)-1)/tonumber(page_max)*100+0.5) .. ' %', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
	end
	t2=os.time()
	m_simpleTV.OSD.ShowMessageT({text = ' EX-FS (' .. pls_name .. ') - время загрузки: ' .. t2-t1 .. ' сек.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 30})
	 return str
	end

	local function LoadFromSite(pls, pls_name)
	local pagination = 'year'
	if not pls:match('/country/') then
		local pll1={
		{"year","Группировка по году"},
		{"country","Группировка по странам"},
		}
		local tt1={}
		for i=1,#pll1 do
			tt1[i] = {}
			tt1[i].Id = i
			tt1[i].Name = pll1[i][2]
			tt1[i].Action = pll1[i][1]
		end
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('EX-FS playlist - select pagination',0,tt1,9000,1+4+8)
		if id==nil then return end
		if ret == 1 then
			pagination = tt1[id].Action
		end
	end
		local t, i, page, answer = {}, 1, '', ''
		answer = LoadFromPage(pls, pls_name)

			for w in answer:gmatch('<div class="MiniPostAllForm MiniPostAllFormDop">.-</div> </div>') do
			local logo, adr, name, title1 = w:match('<img src="(.-)".-<a href="(.-)" title="(.-)".-title="(.-)"')
			local title2 = w:match('<img src=".-".-<a href=".-" title=".-".-title=".-".-title="(.-)"') or 'NN'
			local group = ''
					if not adr or not name then break end

				t[i] = {}
				t[i].name = name:gsub(' /.+', '') .. ' (' .. title1 .. ')'
				t[i].logo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
				t[i].address = adr
				if adr:match('/films/') then group = 'Фильмы: ' end
				if adr:match('/series/') then group = 'Сериалы: ' end
				if adr:match('/cartoon/') then group = 'Мультфильмы: ' end
				if adr:match('/show/') then group = 'Передачи и шоу: ' end
				if pagination == 'year'
				then
				t[i].group = group .. title1
				else
				t[i].group = group .. title2
				end
				t[i].video_title = title1 .. ', ' .. title2
				i = i + 1
			end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
			m_simpleTV.Database.ExecuteSql(sqlstr, false)
            m_simpleTV.PlayList.Refresh()
		local Source = TVSources_var.tmp.source[UpdateID]
		local pll={
		{"/films/","Фильмы"},
		{"/series/","Сериалы"},
		{"/cartoon/","Мультфильмы"},
		{"/show/","Передачи и шоу"},
		{"/country/%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F/","Российские"},
		{"/country/%D0%98%D0%BD%D0%B4%D0%B8%D1%8F/","Индийские"},
		{"/country/%D0%9A%D0%B0%D0%BD%D0%B0%D0%B4%D0%B0/","Канадские"},
		{"/country/%D0%A3%D0%BA%D1%80%D0%B0%D0%B8%D0%BD%D0%B0/","Украинские"},
		{"/country/%D0%A2%D1%83%D1%80%D1%86%D0%B8%D1%8F/","Турецкие"},
		{"/country/%D0%9A%D0%BE%D1%80%D0%B5%D1%8F_%D0%AE%D0%B6%D0%BD%D0%B0%D1%8F/","Корейские"},
		{"/country/%D0%A1%D0%A8%D0%90/","Американские"},
		{"/country/%D0%A4%D1%80%D0%B0%D0%BD%D1%86%D0%B8%D1%8F/","Французские"},
		{"/country/%D0%AF%D0%BF%D0%BE%D0%BD%D0%B8%D1%8F/","Японские"},
		{"/country/%D0%92%D0%B5%D0%BB%D0%B8%D0%BA%D0%BE%D0%B1%D1%80%D0%B8%D1%82%D0%B0%D0%BD%D0%B8%D1%8F/","Британские"},
		{"/country/%D0%93%D0%B5%D1%80%D0%BC%D0%B0%D0%BD%D0%B8%D1%8F/","Немецкие"},
		{"/country/%D0%A1%D0%A1%D0%A1%D0%A0/","СССР"},
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
  local tt={}
  for i=1,#pll do
    tt[i] = {}
    tt[i].Id = i
    tt[i].Name = pll[i][2]
    tt[i].Action = pll[i][1]
  end

  local playlist, pls_name
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('EX-FS - select playlist',0,tt,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = tt[id].Action
   pls_name = tt[id].Name
  end
		local t_pls = LoadFromSite(playlist, pls_name)
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end

		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')'
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})

		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')