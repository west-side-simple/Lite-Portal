-- скрапер TVS для загрузки плейлиста "Web Radio" (10.05.2023)
-- автор westSide

	module('web_radio_pls', package.seeall)
	local my_src_name = 'Web Radio'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/Simple-AUDIO_WS3.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local tab = {
				{"DI.FM","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/di-8cf523ebe8d26478fc652ebce3b3a664e7b123b7bddc44297b4fa48d4160b634.png","https://www.di.fm/",1,"di"},
				{"ZenRadio.com","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/zenradio-af07a05b99ddcb1866bd02818101d100d87cc2d819ad43138b7a79f44f2e14dd.png","https://www.zenradio.com/",16,"zenradio"},
				{"RadioTunes","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/radiotunes-ed9fd41b62f6b11c1bae26f1b04dd5a7c338bd3cfca7be070529a41ad5b95bff.png","https://www.radiotunes.com/",2,"radiotunes"},
				{"ROCKRADIO.com","https://cdn.audioaddict.com/rockradio.com/assets/logo-sm@1x-ca7f1c479be6d367be3ec8a655540eda6137f5ed92bcdd3a2387158aa3589b60.png","https://www.rockradio.com/",13,"rockradio"},
				{"JAZZRADIO.com","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/jazzradio-a504eebc30c18ae4adddf491043b3c7cd9b931ef3dea61fcb5cd72b4478bb109.png","https://www.jazzradio.com/",12,"jazzradio"},
				{"ClassicalRadio.com","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/classicalradio-63494e32ee7162b7e9a7be21ebfe5964a927f164c46a01faa9645aa71ba87212.png","https://www.classicalradio.com/",15,"classicalradio"},
				}

	local function LoadFromNet()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 30000)
		local i,t=1,{}
		for j=1,#tab do
		local url = tab[j][3]
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
			require('json')
			if not answer then return end
			answer = answer:match('di%.app%.start%((.-%})%)%;')
			answer = answer:gsub('(%[%])', '""')
			local tt = json.decode(answer)
			local k = 1
			if tt and tt.channels and tt.channels[1] and tt.channels[1].network_id and tt.channels[1].id then
			while true do
			if not tt.channels[k] or not tt.channels[k].network_id or not tt.channels[k].id then break end
			t[i] = {}
			t[i].name = tt.channels[k].name:gsub('\\u0026','&'):gsub('\\u0027',"'")
			t[i].address = 'webradio_network_id=' .. tt.channels[k].network_id .. '&id=' .. tt.channels[k].id
			t[i].group = tab[j][1]
			t[i].logo = 'http:' .. tt.channels[k].asset_url .. '?size=178x178'
			t[i].group_is_unique = 1
			t[i].group_logo = tab[j][2]
			m_simpleTV.OSD.ShowMessage('Web Radio: ' .. t[i].group .. ', Channels: ' .. k .. ', All: ' .. i,0xFF00,10)
        i=i+1
		k=k+1
		end
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