-- скрапер TVS для загрузки плейлиста "AceStream" (20/11/24)
-- ## Переименовать каналы ##
local filter = {
	{'Наука', 'Наука UA'},
	{'Setanta Live 1', 'Setanta Sports 1'},
	{'Setanta Live 2', 'Setanta Sports 2'},
	}
-- ##

	module('AceStream_pls', package.seeall)
	local my_src_name = 'AceStream'

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
		return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS_trOY2f0iZeTLZQhqRRXrSkafJip0J5zaw&s', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 1}}
	end

	function GetVersion()
		return 2, 'UTF-8'
	end

	local function LoadFromSite(updated)
		local url = 'https://api.acestream.me/all?api_version=1.0&api_key=test_api_key'
		local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local rc, answer = m_simpleTV.Http.Request(session, {url=url})
		if rc~=200 then return end
--	debug_in_file(answer .. '\n')
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(unescape3 (answer))
		local t, i = {}, 1
			while true do
				if not tab[i] then break end
				t[i] = {}
				t[i].name = tab[i].name:gsub(' %[RU%]',''):gsub(' 1920x1080',''):gsub(' 720x576',''):gsub(' %(.-%)','')
				t[i].address = 'http://127.0.0.1:6878/ace/getstream?infohash=' .. tab[i].infohash
				if tab[i].categories and tab[i].categories[1] then
					t[i].group = tab[i].categories[1]
				else
					t[i].group = 'not group'
				end
				if t[i].name:match('18%+') or t[i].group:match('18') or t[i].name:match('RedTraffic') or t[i].name:match('Adult') or string.lower(t[i].name):match('visit') then
					t[i].group = '18+'
				end
				if string.lower(t[i].name):match('sport') or t[i].name:match('DAZN') or t[i].name:match('Матч') or t[i].name:match('Bundesliga') or t[i].name:match('Fight') or t[i].name:match('Motor') then
					t[i].group = 'sport'
				end
				if t[i].name:match('%[%S%S%]') then
					t[i].group = t[i].group .. ' ' .. t[i].name:match(' (%[.-%])')
				end
				t[i].logo = 'https://downloadr2.apkmirror.com/wp-content/uploads/2024/02/83/65cc9785be0a3_org.acestream.node-384x384.png'
				if not tab[i].availability_updated_at or tab[i].availability_updated_at and
				(os.time() - tab[i].availability_updated_at) > 3600 * updated then
					t[i] = nil
				end
				i = i + 1
			end
			local hash, t0 = {}, {}
			for j = 1, #t do
				if t[j] then
					if not hash[t[j].address]
					then
						t0[#t0 + 1] = t[j]
						hash[t[j].address] = true
					end
				end
			end
			if j == 1 then return end
	 return t0
	end
	function GetList(UpdateID, m3u_file)
		if not UpdateID then return end
		if not m3u_file then return end
		if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local updated = 1 -- время в часах проверки доступности ссылки
		local t_pls = LoadFromSite(updated)
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