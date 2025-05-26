-- скрапер TVS для сайта https://www.lostfilmtv2.site от west_side (15/08/24)
-- ## прокси ##
local prx = ''
-- '' - нет
--  'http://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ##
	module('lostfilm_WS_pls', package.seeall)
	local my_src_name = 'LOSTFILM WS'
	local url1 = 'https://www.lostfilm.tv'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://www.lostfilmtv2.site/favicon.ico', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 1, AutoBuildDay = {1, 1, 1, 1, 1, 1, 1}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1 ,AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function LoadFromPage()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.2785.143 Safari/537.36', prx, false)
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
	local str,page,page_max = '',1,20
	while page <= page_max do
	local url = url1 ..'/new/page_' .. page
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		str = str .. answer:gsub('\n', ' ')
		page = page + 1
		m_simpleTV.OSD.ShowMessageT({text = 'LOSTFILM NEW: (' .. math.floor((page-1)/page_max*100) .. '%)' ,0xFF00,3})
	end
	 return str
	end


	local function LoadFromSite()
		local t, i = {}, 1
		local name, ser_name, ser, adr, logo
		local answer = LoadFromPage()
		if not answer then return end
			for w in answer:gmatch('<div class="row">(.-)markEpisodeAsWatched') do
				name = w:match('<div class="name%-ru">(.-)</div>')
				name = name:gsub(',', ' '):gsub('%s%s+', ' ')
				name_eng = w:match('<div class="name%-en">(.-)</div>')
				name_eng = name_eng:gsub(',', ' '):gsub('%s%s+', ' ')
				ser_name = w:match('<div class="alpha">(.-)</div>') or ''
				ser_name_eng = w:match('<div class="beta">(.-)</div>') or ''
				ser = w:match('<div class="left%-part">(.-)</div>') or ''
				adr = w:match('href="(.-)"') or ''
				da = w:match('<div class="right%-part">(.-)</div>') or ''
				rtg = w:match('Lostfilm.TV">(.-)</div>') or ''
				logo = w:match('<img src="(.-)"') or ''
					if not name or not adr or not ser_name or not ser then break end
				icon = logo:gsub('image', 'icon'):gsub('^//', 'https://')
				adr_all = url1 .. adr:gsub('season.-$', '')
				t[i] = {}
				if ser == 'Фильм' then
				t[i].group = my_src_name .. ' Фильмы'
				t[i].group_logo = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTf62u9THO-Nape0PwdC4w33vlMh6zmkyiLfg&usqp=CAU'
				else
				t[i].group = my_src_name .. '/' .. name
				t[i].group_logo = icon
				end
				t[i].logo = logo:gsub('^//', 'https://')
				t[i].name = name:gsub(',', ' '):gsub('%s%s+', ' ') .. ' (' .. ser .. ')'
				t[i].address = url1 .. adr
				t[i].video_title = da .. ' | ' .. ser .. ' "' .. ser_name:gsub('%&nbsp%;','Фильмовый контент') .. '" | LFR: ' .. rtg
				t[i].video_title = t[i].video_title:gsub('"', '%%22')
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
			if not t_pls then m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'}) return end
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr:gsub('%#EXTM3U ','#EXTM3U $BorpasFileFormat="1" $NestedGroupsSeparator="/" '))
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')