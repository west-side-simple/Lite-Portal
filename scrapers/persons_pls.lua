-- скрапер TVS для загрузки плейлистов фильмографий для SimpleTV (02/11/21)

	module('persons_pls', package.seeall)
	local my_src_name = 'PERSONS'

	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://img1.freepng.ru/20180624/pwi/kisspng-persona-5-shin-megami-tensei-persona-4-video-game-persona-5-5b301f19757fd0.2713683415298803454813.jpg', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 1, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end


local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name2,data2 = answer:match('ex%-fs%.net.+%s(_ym_uid)%s+(%S+)')
			local name3,data3 = answer:match('ex%-fs%.net.+%s(_ym_d)%s+(%S+)')
			local name4,data4 = answer:match('ex%-fs%.net.+%s(_ym_isad)%s+(%S+)')
			local name5,data5 = answer:match('ex%-fs%.net.+%s(PHPSESSID)%s+(%S+)')
			local name6,data6 = answer:match('ex%-fs%.net.+%s(dle_user_id)%s+(%S+)')
			local name7,data7 = answer:match('ex%-fs%.net.+%s(dle_password)%s+(%S+)')
			local name8,data8 = answer:match('ex%-fs%.net.+%s(dle_newpm)%s+(%S+)')

			if name2 and data2 and name3 and data3 and name4 and data4 and name5 and data5 and name6 and data6 and name7 and data7 and name8 and data8
			then str = name2 .. '=' .. data2 .. ';' .. name3 .. '=' .. data3 .. ';' .. name4 .. '=' .. data4 .. ';' .. name5 .. '=' .. data5 .. ';' .. name6 .. '=' .. data6 .. ';' .. name7 .. '=' .. data7 .. ';' .. name8 .. '=' .. data8
			else
			return ''
			end
			end
return str
end


	local function LoadFromSite()

		--формирование адреса для сайтов пока Rezka, EX-FS
		local url = getConfigVal('person/rezka')
--      '#https://rezka.ag/person/7066-keyt-bekinseyl/'
--      'https://ex-fs.net/actors/15099-bill-skarsgard.html'

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		local t = {}
	if url:match('rezkery%.com') or 
	url:match('kinopub%.me') or 
	url:match('upivi%.com') or 
	url:match('metaivi%.com') or 
	url:match('rd8j1em1zxge%.org') or 
	url:match('hdrezka19139%.org') or 
	url:match('m85rnv8njgwv%.org')
	then
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('^#','')})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end

		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')

		local title = answer:match('<h1 itemprop="name">([^<]+)') or answer:match('<h1><span class="t1" itemprop="name">([^<]+)') or answer:match('<head><title>(.-)</title>') or 'Person'
		local poster = answer:match('<meta property="og:image" content="(.-)"') or 'https://hdrezka.by/themes/default/public/mobile/logo.png'
		if poster:match('/i/share%.jpg') then poster = 'https://hdrezka.by/themes/default/public/mobile/logo.png' end
		local genres_str = answer:match('<td class="l"><h2>Карьера</h2>:(.-)<td class="l">') or ''
		local name_eng = answer:match('alternativeHeadline">(.-)</div>') or ''


------------------
		t[1] = {}
		t[1].name = title
		t[1].group = 'Rezka'
		t[1].logo = poster
		t[1].address = '#' .. url
		t[1].video_title = name_eng:gsub('<.->', '') .. genres_str:gsub('<.->', '')
------------------
	elseif url:match('ex%-fs%.') then
		local cookies = cookiesFromFile() or ''

		local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Cookie: ' .. cookies})

		if rc ~= 200 then return end

		answer = answer:gsub('\n', ' ')
		local title = answer:match('<h1 class="view%-caption">(.-)</h1>') or 'Person'
		local poster = answer:match('<div class="FullstoryForm">.-<img src="(.-)"') or ''
		local genres_str = answer:match('<p class="FullstoryInfoinAct">(.-)</p>') or ''
		local name_eng = answer:match('<h2 class="view%-caption2">(.-)</h2>') or ''

------------------
		t[1] = {}
		t[1].name = title
		t[1].group = 'EX-FS'
		t[1].logo = 'https://ex-fs.net' .. poster:gsub('https://ex%-fs%.net','')
		t[1].address = url
		t[1].video_title = name_eng .. ': ' .. genres_str
	end
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