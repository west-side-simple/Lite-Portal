-- скрапер TVS для загрузки плейлиста "SPORT PUB TV ($)" с сайта https://kino.pub (20/08/22)

-- ## Переименовать каналы ##
local filter = {
	{'Наука', 'Наука UA'},
	}
-- ##

	module('sportpub_pls', package.seeall)
	local my_src_name = 'SPORT PUB TV ($)'
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
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://cdn.service-kp.com/logo.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 1, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name1,data1 = answer:match('kino%.pub.+%s(_csrf)%s+(%S+)')
			local name2,data2 = answer:match('kino%.pub.+%s(token)%s+(%S+)')
			local name3,data3 = answer:match('kino%.pub.+%s(_identity)%s+(%S+)')

			if
				name1 and data1 and
				name2 and data2 and
				name3 and data3
			then
				str =
				name1 .. '=' .. data1 .. ';' ..
				name2 .. '=' .. data2 .. ';' ..
				name3 .. '=' .. data3
			else
				return ''
			end
		end
	return str
	end

	local function getname(adr)
	local proxy = ''
-- '' - нет
-- 'http://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ##
	local session1 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0', proxy, false)
		if not session then return end
		m_simpleTV.Http.SetTimeout(session1, 80000)
	local cookies = cookiesFromFile()
		local rc1, answer = m_simpleTV.Http.Request(session1, {url = 'https://kino.pub' .. adr, headers = 'Cookie: ' .. cookies})
		if rc1 ~= 200 then return end
		m_simpleTV.Http.Close(session1)
		local title = answer:match('<title>(.-)</title>')
	return title
	end

	local function LoadFromSite()
	local proxy = 'http://proxy-nossl.antizapret.prostovpn.org:29976'
-- '' - нет
-- 'http://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ##
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0', proxy, false)
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		local cookies = cookiesFromFile()
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://kino.pub/sport', headers = 'Cookie: ' .. cookies})
		if rc ~= 200 then return end
		m_simpleTV.Http.Close(session)
		answer = answer:gsub('\n', ' ')
		local t, i = {}, 1

			for w in answer:gmatch('<a href="/tv/view/.-class=') do
				local title
				local adr,logo = w:match('<a href="(.-)"><img src="(.-)" class=')
					if not adr then break end
				t[i] = {}
				title = getname(adr)
				t[i].name = title
				t[i].address = 'https://kino.pub' .. adr
				t[i].group = 'Sport'
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
				m_simpleTV.OSD.ShowMessageT({text = 'необходимо перегенерировать cookies'
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