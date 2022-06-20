-- скрапер TVS для загрузки плейлиста "EX-FS NEW" для сайта https://ex-fs.net (30/08/21) - автор west_side
-- необходимы скрипты poisk_kinopoisk.lua, kinopoisk.lua - автор nexterr, ex-fs.lua  - автор west_side

	module('ex-fs_new_pls', package.seeall)
	local my_src_name = 'EX-FS NEW'

	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://ex-fs.net/templates/ex-fs/images/favicon.ico', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromSite()

		local url = 'https://ex-fs.net'

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local t, i, page, answer = {}, 1, '', ''
		for j = 1,4 do
			if j == 1 then page = '/films/' end
			if j == 2 then page = '/series/' end
			if j == 3 then page = '/cartoon/' end
			if j == 4 then page = '/show/' end
		local rc, answer0 = m_simpleTV.Http.Request(session, {url = url .. page})
		if j == 4 then m_simpleTV.Http.Close(session) end
			if rc ~= 200 then return end
			answer = answer .. answer0
			j = j + 1
		end
		answer = answer:gsub('\n','')
			for w in answer:gmatch('<div class="MiniPostAllForm MiniPostAllFormDop">.-</div> </div>') do
			local logo, adr, name, title1, title2 = w:match('<img src="(.-)".-<a href="(.-)" title="(.-)".-title="(.-)".-title="(.-)"')
					if not adr or not name then break end
				t[i] = {}
				t[i].name = name:gsub(' /.+', '') .. ' (' .. title1 .. ')'
				t[i].logo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
				t[i].address = adr
				if i <= 30 then
				t[i].group = 'Фильмы'
				elseif 30 < i and i <= 60 then
				t[i].group = 'Сериалы'
				elseif 60 < i and i <= 90 then
				t[i].group = 'Мультфильмы'
				elseif 90 < i and i <= 120 then
				t[i].group = 'Передачи и шоу'
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
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
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