-- скрапер TVS для загрузки плейлиста радио "SR" (Selivanoff) (09.03.2023)
-- автор westSide

	module('SR_pls', package.seeall)
	local my_src_name = 'Selivanoff'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/Simple-AUDIO_WS2.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromNet()
		local url = decode64('aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3dlc3Qtc2lkZS1zaW1wbGUvcGxheWxpc3RzL21haW4vUk1HLm0zdTg=')
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 30000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end

		answer = answer .. '\n'

		local t,i = {},1
		for w in answer:gmatch('%#EXTINF:.-\n.-\n') do
			local title = w:match(',(.-)\n')
			local adr = w:match('\n(.-)\n')
			local group = title:gsub(' %(',' - '):gsub('%)',''):gsub(' %-.-$','')
			local name = title:gsub(' %(',' - '):gsub('%)',''):gsub('^.- %- ','')
			if name == '' then name = group end
				if not adr or not name then break end
			t[i] = {}
			t[i].name = name
			t[i].address = adr
			t[i].group = group
			t[i].logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/Simple-AUDIO_WS1.png'
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