-- скрапер TVS для загрузки плейлиста https://discobonus-radio.ru/ (Radio discobonus) (14.07.2024)
-- автор westSide

	module('discobonus_pls', package.seeall)
	local my_src_name = 'DiscoBonus'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'http://casseta-disco.ru:1030/media/servers/Logo512.jpg', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function LoadFromNet()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 30000)
		local i,t=1,{}
		local url = 'https://casseta-disco.ru:1030/api/v2/servers/'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
		if not answer then return end
		answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '""'):gsub('%&quot%;','"'):gsub('null','""')
--		debug_in_file(answer .. '\n','c://1/db.txt')
		for w in answer:gmatch('%{.-%}') do
			t[i] = {}
			t[i].address,t[i].name,t[i].logo = w:match('"id":(%d+).-"title":"(.-)".-"image":"(.-)"')
			if not tonumber(t[i].address) then break end
			if (tonumber(t[i].address)) == 1 then
			t[i].address = 'https://casseta-disco.ru:1030/discobonus/1/winamp.m3u' .. '$OPT:NO-STIMESHIFT'
			elseif (tonumber(t[i].address)) == 3 then
			t[i].address = 'https://casseta-disco.ru:1030/discobonus/4/winamp.m3u' .. '$OPT:NO-STIMESHIFT'
			elseif (tonumber(t[i].address)) == 10 then
			t[i].address = 'https://casseta-disco.ru:1030/discobonus/12/winamp.m3u' .. '$OPT:NO-STIMESHIFT'
			elseif (tonumber(t[i].address)) == 11 then
			t[i].address = 'https://casseta-disco.ru:1030/discobonus/13/winamp.m3u' .. '$OPT:NO-STIMESHIFT'
			t[i].logo = 'http://casseta-disco.ru:1030/media/servers/Logo512.jpg'
			end
			i=i+1
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