-- скрапер TVS для загрузки плейлиста "IMDB" (17/05/25)

	module('imdb_cat_pls', package.seeall)
	local my_src_name = 'IMDb WS'



	function GetSettings()
		return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuIMDb.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchLogo = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 1}}
	end

	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function get_collections_plus()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local t, i = {}, 1
		for k =1,5 do
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://api.vokino.tv/v2/compilations/list?page=' .. k})
		if not answer then break end
		answer = answer:gsub(' \\"',' «'):gsub('\\"','»')
		for w in answer:gmatch('%{"playlist_url".-%}') do
--		debug_in_file(w .. '\n','c://1/tmdb_int.txt')
		local adr, name, logo = w:match('"playlist_url":"(.-)".-"name":"(.-)".-"poster":"(.-)"')
			if not adr then break end
			t[i] = {}
			t[i].name = name
			t[i].address = adr
			t[i].logo = logo
			t[i].group = 'Collections+'
			t[i].group_is_unique = 1
			t[i].group_logo = './luaScr/user/show_mi/IMDB_pack/' .. t[i].group .. '.png'
			i = i + 1
		end
		k = k + 1
		end
		return t
	end

	local function get_collections()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local t, i = {}, 1
		for k =1,2 do
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://ws.pris.cam/api/collections/list?page=' .. k})
		if not answer then break end
		
		for w in answer:gmatch('%{.-%}') do
--		debug_in_file(w .. '\n','c://1/tmdb_int.txt')
		local adr, name, logo = w:match('"hpu":"(.-)".-"title":"(.-)".-"img":"(.-)"')
			if not adr then break end
			t[i] = {}
			t[i].name = name
			t[i].address = 'https://ws.pris.cam/api/collections/view/' .. adr
			t[i].logo = 'https://img.pris.cam/t/p/w500' .. logo
			t[i].group = 'Collections'
			t[i].group_is_unique = 1
			t[i].group_logo = './luaScr/user/show_mi/IMDB_pack/' .. t[i].group .. '.png'
			i = i + 1
		end
		k = k + 1
		end
		return t
	end

	local function get_content(adr, name1)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64(adr)})
		if not answer then return end
		answer = unescape3(answer)
		answer = answer:gsub('\\','')
		debug_in_file(answer.. '\n')
		local t, i = {}, 1
		for w in answer:gmatch('"last_season".-".-"poster":".-"') do
		local name, year, adr, logo = w:match('"name":"(.-)".-"year":(.-)%,.-"id_imdb":"(.-)".-"poster":"(.-)"')
			if not name then break end
			t[i] = {}
			t[i].name = name .. ' (' .. (year or 0) .. ')'
			t[i].address = 'https://www.imdb.com/title/' .. adr
			t[i].group = name1
			t[i].logo = logo or ''
			i = i + 1
		end
		return t
	end


	local function LoadFromFile()

		local add = {
		{'aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmb3JkZXI9ZGF0ZSZsaXN0PW1vdmllJnBhZ2U9MQ==', 'Фильмы - поступления'},
	{'aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmb3JkZXI9cmF0aW5nX2ltZGImbGlzdD1tb3ZpZSZwYWdlPTE=', 'Фильмы - рейтинг'},
		{'aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmb3JkZXI9ZGF0ZSZsaXN0PXNlcmlhbCZwYWdlPTE=', 'Сериалы - поступления'},
	{'aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmb3JkZXI9cmF0aW5nX2ltZGImbGlzdD1zZXJpYWwmcGFnZT0x', 'Сериалы - рейтинг'},
	{'aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmb3JkZXI9ZGF0ZSZsaXN0PWFuaW1lJnBhZ2U9MQ==', 'Аниме - поступления'},
	{'aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmb3JkZXI9cmF0aW5nX2ltZGImbGlzdD1hbmltZSZwYWdlPTE=', 'Аниме - рейтинг'}
		}

		local tt = {
		{'https://www.imdb.com/chart/top/?ref_=nv_mv_250', 'Top Movie', 'Top movie.png'},
		{'https://www.imdb.com/chart/moviemeter/?ref_=nv_mv_mpm', 'Most Popular Movie', 'Popular movie.png'},
		{'https://www.imdb.com/chart/toptv/?ref_=nv_tvv_250', 'Top Series', 'Top TV.png'},
		{'https://www.imdb.com/chart/tvmeter/?ref_=nv_tvv_mptv', 'Most Popular Series', 'Popular TV.png'},
		{'https://www.imdb.com/chart/boxoffice/', 'Top Box Office (US)', 'Popular IMDB.png'},
		{'https://www.imdb.com/chart/top-english-movies/', 'Top Rated English Movies', 'Top IMDB.png'}
		}

		local t, i = {}, 1
--[[
		for j = 1, #add do
			local t1 = get_content(add[j][1],add[j][2])
			for k = 1, #t1 do
				t[i] = {}
				t[i].name = t1[k].name
				t[i].address = t1[k].address
				t[i].group = t1[k].group
				t[i].logo = t1[k].logo
				i = i + 1
				k = k + 1
			end
		end--]]
		local t1 = get_collections()

		for j = 1,#t1 do
			t[i] = t1[j]
			i = i + 1
		end
		
		local t2 = get_collections_plus()

		for j = 1,#t2 do
			t[i] = t2[j]
			i = i + 1
		end

		for j = 1, #tt do
			t[i] = {}
			t[i].name = tt[j][2]
			t[i].address = tt[j][1]
			t[i].group = 'Favorite'
			t[i].logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/TOP_POPULAR/' .. tt[j][3]
			t[i].group_is_unique = 1
			t[i].group_logo = './luaScr/user/show_mi/IMDB_pack/' .. t[i].group .. '.png'
			i = i + 1
			j = j + 1
		end

		local answer
		local search = 'IMDb.csv'
		local path = m_simpleTV.MainScriptDir .. 'user/TVSources/core/' .. search
		local file = io.open(path, 'r')
		if not file then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuIMDb.png"', text = ' необходимо скачать файл ' .. m_simpleTV.MainScriptDir .. 'user/TVSources/core/IMDb.csv', color = ARGB(255, 127, 63, 255), showTime = 1000 * 30})
		answer = '' else
		answer = file:read('*a')
		file:close()
		end
		answer = m_simpleTV.Common.multiByteToUTF8(answer)
		i = #t + 1
			for w in answer:gmatch('%d+.-\n') do
				local adr, grp, title, logo = w:match('(.-);(.-);(.-);(.-)\n')
				if not adr then break end
				t[i] = {}
				t[i].name = title
				t[i].address = 'https://www.imdb.com/interest/in0000' .. adr
				t[i].group = grp
				t[i].logo = logo
				t[i].group_is_unique = 1
				t[i].group_logo = './luaScr/user/show_mi/IMDB_pack/' .. grp .. '.png'
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

		local t_pls = LoadFromFile()
			if not t_pls or t_pls and #t_pls and #t_pls == 0 then
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