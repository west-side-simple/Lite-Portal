-- скрапер TVS для загрузки плейлиста "LIGHT IPTV" (24/11/21)
-- логин, пароль установить в 'Password Manager', для ID - lightiptv

-- ## Переименовать каналы ##
local filter = {
	{'Наука', 'Наука UA'},
	}
-- ##

	module('light_iptv_pls', package.seeall)
	local my_src_name = 'Light IPTV ($)'
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
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '../Channel/logo/extFiltersLogo/light_iptv.jpg', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 1, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromSite()
		local url
			local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('lightiptv') end, err)
		if not login or not password or login == '' or password == '' then return
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://ottbill.cc/images/favicon.png"', text = ' Внесите данные в менеджере паролей для ID lightiptv', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
		else
		url = 'https://lightiptv.cc/playlist/hls/' .. password .. '.m3u'
		end

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		answer = answer .. '\n'
		local t, i = {}, 1

			for w in answer:gmatch('%#EXTINF:.-\n.-\n') do
				local title = w:match(',(.-)\n')
				local adr = w:match('\n(.-)\n')
				local logo = w:match('tvg%-logo="(.-)"')
					if not adr or not title then break end
				t[i] = {}
				t[i].name = title
				t[i].address = adr
				t[i].RawM3UString = w:match('(catchup.-),')
				t[i].RawM3UString = t[i].RawM3UString:gsub('duration','offset')
				t[i].group = w:match('group%-title="([^"]+)')
				t[i].logo = logo
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
			if t_pls == 0 then
				m_simpleTV.OSD.ShowMessageT({text = 'логин/пароль установить\nв дополнении "Password Manager"\для id - lightiptv'
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