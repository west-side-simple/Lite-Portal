-- скрапер TVS для загрузки плейлиста 'Советский кинематограф' сайт https://film.arjlover.net/ (24/01/22)
	local my_src_name = 'Кино СССР'
	module('sovkino_pls', package.seeall)
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://bigenc.ru/media/2016/10/27/1238802452/31624.jpg.262x-.png', TypeSource = 0, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, show_progress = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 1}, STV = {add = 1, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function showMsg(str, color)
		local t = {text = str, showTime = 1000 * 5, color = color, id = 'channelName'}
		m_simpleTV.OSD.ShowMessageT(t)
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local function LoadFromSite()
	local tt = {
--	{'http://audio.arjlover.net/audio/','Аудиосказки'},
	{'http://film.arjlover.net/film/','Фильмы СССР','http://m24.do.am/images/sssr.png'},
	{'http://filmiki.arjlover.net/filmiki/','Фильмы СССР для детей','http://m24.do.am/images/kidsssr.png'},
--	{'http://radioteatr.arjlover.net/','Радио-Театр'},
	{'http://multiki.arjlover.net/multiki/','Мультфильмы СССР','http://m24.do.am/images/kids.png'},
	}
	local t,i = {},1
	for j=1,#tt do
	local url,grp,grp_logo = tt[j][1],tt[j][2],tt[j][3]
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then return end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		for w in answer:gmatch('<td class=a>.-</tr>') do
				local name,adr = w:match('href=.->(.-)<.-href="(.-)"')
				if adr and name then
					t[i] = {}
					t[i].name = name
					t[i].address = url:gsub('%.net.-$','.net') .. adr
					t[i].logo = url:gsub('%.net.-$','.net/ap') .. adr:gsub('/.-/','/') .. '/' .. adr:gsub('/.-/','') .. '.thumb1.jpg'
					t[i].group_logo = grp_logo
					t[i].group = grp
				end
				showMsg('Загрузка: '.. i, ARGB(255, 153, 255, 153))
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
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')