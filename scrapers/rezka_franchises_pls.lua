-- скрапер TVS для загрузки плейлиста "Franchises" https://hdrezka.ag/franchises/ (07/08/22)
-- author west_side
-- ## необходим ##
-- видеоскрипт: hdrezka.lua - mod west_side for lite version
-- ## Переименовать каналы ##
local filter = {
	}
-- ##
	local my_src_name = 'Franchises'
	module('rezka_franchises_pls', package.seeall)
	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
		end
	 return t
	end
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 1, show_progress = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function showMsg(str, color)
		local t = {text = str, showTime = 1000 * 5, color = color, id = 'channelName'}
		m_simpleTV.OSD.ShowMessageT(t)
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:86.0) Gecko/20100101 Firefox/86.0', prx, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

	local function LoadFromSite()
	local zerkalo = m_simpleTV.Config.GetValue('zerkalo/rezka','LiteConf.ini') or ''
	if zerkalo == '' then zerkalo = 'https://hdrezka.ag/' end
	local t,i,j,all_pg = {},1,1,1
	while j<=tonumber(all_pg) do
		local rc,answer = m_simpleTV.Http.Request(session,{url= zerkalo .. 'franchises/' .. 'page/' .. j .. '/'})
		if rc ~= 200 then
			m_simpleTV.Common.Sleep(500)
			rc,answer = m_simpleTV.Http.Request(session,{url= zerkalo .. 'franchises/' .. 'page/' .. j .. '/'})
		end
		if rc ~= 200 then
			m_simpleTV.Common.Sleep(500)
			rc,answer = m_simpleTV.Http.Request(session,{url= zerkalo .. 'franchises/' .. 'page/' .. j .. '/'})
		end
		if rc ~= 200 then
			return t
		end
		if j==1 then
		 all_pg=answer:match('<span class="nav_ext">%.%.%.</span> <a href=".-(%d+)<')
		end
		for w in answer:gmatch('<div class="b%-content__collections_item".-</div></div>') do
			local adr,logo,num,name = w:match('url="(.-)".-src="(.-)".-tooltip">(%d+).-"title">(.-)<')
			local grp = 'Фильмы'
            local grp_logo = 'http://m24.do.am/images/drama.png'
			if not adr or not name then break end
					t[i] = {}
					t[i].name = name
					t[i].address = adr
					t[i].logo = logo
					if name:match('аниме') then grp = 'Аниме' grp_logo = 'http://m24.do.am/images/anime.png'
					elseif name:match('мультсериал') then grp = 'Мультфильмы' grp_logo = 'http://m24.do.am/Logo/mult.png'
					elseif name:match('сериал') then grp = 'Сериалы' grp_logo = 'http://m24.do.am/images/mix.png'
					elseif name:match('мультфильм') then grp = 'Мультфильмы' grp_logo = 'http://m24.do.am/Logo/mult.png'
					end
					t[i].name = t[i].name:gsub('Все части мультфильма ',''):gsub('Все части мультсериала ',''):gsub('Все мультфильмы про ','Про '):gsub('Все мультфильмы франшизы ',''):gsub('Все мультфильмы ',''):gsub('Все части фильма ',''):gsub('Все части сериала ',''):gsub('все части сериала ',''):gsub('Все части документального сериала ',''):gsub('Все фильмы про ','Про '):gsub('Все части франшизы ',''):gsub('Все части аниме ',''):gsub('Все мультфильмы серии ',''):gsub('Все фильмы серии ',''):gsub('%%2C','!') .. ' (' .. num .. ')'
					t[i].group = grp
					t[i].group_logo = grp_logo
				showMsg('Загрузка: ' .. j .. ' из ' .. all_pg .. ' / ' .. i, ARGB(255, 153, 255, 153))
--				debug_in_file(i .. ' (' .. j .. '), ' .. t[i].name .. '\n','c://1/frch.txt')
				i=i+1
			end
		j=j+1
	end
	if #t == 0 then return end
	 return t
	end

	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				showMsg(Source.name .. ' ошибка загрузки плейлиста', ARGB(255, 255, 102, 0))
			 return
			end
		showMsg(Source.name .. ' (' .. #t_pls .. ')', ARGB(255, 153, 255, 153))
		t_pls = ProcessFilterTableLocal(t_pls)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')