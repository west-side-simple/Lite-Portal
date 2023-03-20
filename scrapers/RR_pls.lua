-- скрапер TVS для загрузки плейлиста "RR" (Radio Record) (08.03.2023)
-- автор westSide

	module('RR_pls', package.seeall)
	local my_src_name = 'Radio Record'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://www.radiorecord.ru/icons/favicon.ico', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromNet()
		local url = 'http://www.radiorecord.ru/api/stations/'
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 30000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		require('json')
		answer = answer:gsub('%[%]','""'):gsub('\u0','\\u0')
		local tab = json.decode(answer)
		if not tab or not tab.result or not tab.result.stations
		then
		return
		end
		local t,i = {},1
		while true do
			if not tab.result.stations[i]
				then
				break
				end
				local title = tab.result.stations[i].title
				local adr = tab.result.stations[i].stream_320
				local logo =tab.result.stations[i].icon_fill_white
				logo = logo:gsub('https://www%.radiorecord%.ru/upload/stations_images/','')
					if not adr or not title or not logo then break end
				t[i] = {}
				t[i].name = title:gsub('%,','.')
				t[i].address = adr:gsub('^https','http')
				t[i].logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/LogoRecord/' .. logo
				t[i].group = tab.result.stations[i].genre[1].name
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
		local t_pls = LoadFromNet()
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