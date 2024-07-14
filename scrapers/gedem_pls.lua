-- скрапер TVS для загрузки плейлиста "IPTV# GEDEMTV Wizard" (11/03/24)

-- ## Переименовать каналы ##
local filter = {
	{'Наука', 'Наука UA'},
	}
-- ##

	module('gedem_pls', package.seeall)
	local my_src_name = 'PortalPLL'
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
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 0, HDGroup = 0, AutoSearch = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 2, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function check_adr(adr,session)
		local rc, answer = m_simpleTV.Http.Request(session, {url = adr})
		if rc == 200 then
			return true
		end
		return false
	end
	local function LoadFromSite()

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)

		local urls = {
					'https://bit.ly/lidwizard',
--					'https://bit.do/Karnei4-liwizard',
--					'https://bit.ly/liwizard-tvitv',
					'https://suzukantv.at.ua/IPTV.lidwizard',
					'https://edemtv.my1.ru/IPTV.lidwizard',
					'https://edemtv.my1.ru/lidwizard-suzus.noext',
					'https://cutt.ly/dKHI6KN',
					 }

		local t, i, k = {}, 1, 1
		for j = 1,#urls do
			local url = urls[j]
			local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc == 200 then
				for w in answer:gmatch('<playlist>.-</playlist>') do
					local title = w:match('<name>(.-)</name>')
					local adr = w:match('<url>(.-)</url>')
					local logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
					if not adr or not title then break end
					m_simpleTV.OSD.ShowMessageT({text = 'Общий прогресс загрузки / source: ' .. j .. '(' .. #urls .. ') / check: ' .. k .. ' / good: ' .. i - 1, color = ARGB(255, 255, 255, 255), showTime = 1000 * 30})
					k = k + 1
					if check_adr(adr,session) then
						t[i] = {}
						t[i].name = title
						t[i].address = 'portalTV_playlist=' .. adr
						t[i].logo = logo
						i = i + 1
					end
				end
			end
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
		local t_pls = LoadFromSite()
			if not t_pls or t_pls == 0 then
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
		t_pls = ProcessFilterTableLocal(t_pls)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')