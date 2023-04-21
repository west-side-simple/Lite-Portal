-- скрапер TVS для загрузки плейлиста "NRJ Group" (Radio NRJ Group) (25.03.2023)
-- автор westSide

	module('NRJ_Group_pls', package.seeall)
	local my_src_name = 'NRJ Group'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://www.nrj-play.fr/build/play/img/logo-nrjplay.svg', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local tab = {
	{"Nostalgie","https://www.nostalgie.fr/uploads/assets/nostalgie/icons/android-icon-192x192.png","https://www.nostalgie.fr/onair"},
	{"NRJ","https://www.nrj.fr/uploads/assets/nrj/icons/android-icon-192x192.png","https://www.nrj.fr/onair"},
	{"Rire et Chansons","https://www.rireetchansons.fr/uploads/assets/rire/icons/android-icon-192x192.png","https://www.rireetchansons.fr/onair"},
	{"Chérie FM","https://www.cheriefm.fr/uploads/assets/cherie/icons/android-icon-192x192.png","https://www.cheriefm.fr/onair"},
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
			answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '""')
			local tt = json.decode(answer)
			local k = 1
			if not tt or not tt[1] or not tt[1].name then return end
			while true do
			if not tt[k] or not tt[k].name then break end
			local adr = tt[k].url_hd_aac or ''
			if adr == '' then adr = tt[k].url_128k_mp3 end
			if adr == '' then adr = tt[k].url_64k_mp3 end
			t[i] = {}
			t[i].name = tt[k].name:gsub('\\u0026','&'):gsub('\\u0027',"'")
			t[i].address = adr .. '?origine=playernostalgie&aw_0_req.userConsentV2=&aw_0_1st.station=' .. tt[k].awparams
			t[i].group = tab[j][1]
			t[i].logo = tt[k].logo:gsub('\\u0026','&')
			t[i].group_is_unique = 1
			t[i].group_logo = tab[j][2]
			m_simpleTV.OSD.ShowMessage('Radio NRG Group: ' .. t[i].group .. ', Channels: ' .. k .. ', All: ' .. i,0xFF00,10)
        i=i+1
		k=k+1
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