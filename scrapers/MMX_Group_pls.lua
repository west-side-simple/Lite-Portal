-- скрапер TVS для загрузки плейлиста "MMX Group" (Radio MMX Group) (17.04.2023)
-- автор westSide

	module('MMX_Group_pls', package.seeall)
	local my_src_name = 'MMX Group'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://multimediaholding.ru/wp-content/themes/mmh/icons/apple-touch-icon.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local tab = {
	{"nashe","https://www.nashe.ru/favicons/apple-touch-icon.png"},
	{"rock","https://www.rockfm.ru/favicons/apple-touch-icon.png"},
	{"jazz","https://radiojazzfm.ru/favicons/apple-touch-icon.png"},
	{"ultra","https://ultrapro.ru/apple-touch-icon.png"},
	}

	local function LoadFromNet()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 30000)
		local i,t=1,{}
		local url = 'https://www.nashe.ru'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
			if not answer then return end
			answer = answer:match('window%.streams = (%{.-%}%}%})')
			answer = answer:gsub('(%[%])', '""')
			for j=1,#tab do
				local group_name = tab[j][1]
				local answer1 = answer:match('"' .. group_name .. '".-%}%}')
				for w in answer1:gmatch('%{"station":".-%}') do
				local station,title,adres,logo = w:match('"station":"(.-)"%,"title":"(.-)"%,"stream_url":"(.-)"%,"cover_url":"(.-)"')
				if not adres then break end
--debug_in_file(unescape1(title) .. ' / ' .. adres:gsub('^https','http'):gsub('\\',''):gsub('18000','80') .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
					t[i] = {}
					t[i].name = unescape1(title)
					t[i].address = adres:gsub('^https','http'):gsub('\\',''):gsub('18000','80')
					t[i].group = unescape1(station)
					if logo == '' then t[i].logo = tab[j][2] else t[i].logo = logo:gsub('\\','') end
					t[i].group_is_unique = 1
					t[i].group_logo = tab[j][2]
					m_simpleTV.OSD.ShowMessage('Radio MMX Group: ' .. i,0xFF00,10)
					i=i+1
				end
			j=j+1
			end
		m_simpleTV.Http.Close(session)
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