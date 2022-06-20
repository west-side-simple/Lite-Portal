
	module('m24portal_pls', package.seeall)
	local my_src_name = 'Media Portal 24'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'http://m24.do.am/images/portallogo.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromSite()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL20yNC5kby5hbS9DSC9wbGF5bGlzdC50eHQ=')})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		answer = answer .. '\n'
		local tab, i = {}, 1
			for w in answer:gmatch('#EXTINF:(.-\n.-)%c') do
				local title = w:match(',(.-)\n')
				local adr = w:match('\n(.+)')
				if adr and title then
					tab[i] = {}
					tab[i].address = adr
					tab[i].name = title
					tab[i].logo = w:match('tvg%-logo="([^"]+)')
					tab[i].video_title = w:match('video%-title="([^"]+)')
					tab[i].video_desc = w:match('video%-desk="([^"]+)')
					tab[i].group = w:match('group%-title="([^"]+)')
					i = i + 1
				end
			end
			if i == 1 then return end
	 return tab
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 0, 0)
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