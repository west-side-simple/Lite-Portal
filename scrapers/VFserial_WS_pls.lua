-- скрапер TVS для балансера Vibix serial от west_side (22/05/25)

-- ## Переименовать каналы ##
	local filter = {
	{'ZeeTV', 'Zee TV'},
	}
-- ## Переименовать группы ##
	local filter_grp = {
	{'мультфильм','Мультфильмы'},
	{'боевик','Боевики'},
	{'вестерн','Вестерны'},	
	{'мелодрама','Романтика'},
	{'драма','Драмы'},
	{'короткометражка','Короткометражные'},
	{'семейный','Семейные'},
	{'военный','Военные'},
	{'детектив','Детективы'},
	{'документальный','Документальные'},
	{'комедия','Комедии'},
	{'мюзикл','Музыка'},
	{'триллер','Триллеры'},
	{'фэнтези','Фантазия'},
	{'биография','Исторические'},
	{'история','Исторические'},
	{'реальное ТВ','Реалити'},
	{'ток-шоу','Реалити'},
	{'Мультфильмыы','мультфильмы'},
	{'-','base'},
	}

	module('VFserial_WS_pls', package.seeall)
	local my_src_name = 'VFSERIAL WS'	

	function GetSettings()
		return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Vibix.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1 ,AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	end

	function GetVersion()
		return 2, 'UTF-8'
	end

	local function Clean_VF()
		local sqlstr = "DELETE FROM Channels WHERE ExtFilter IN ( SELECT Id FROM ExtFilter WHERE Name='".. my_src_name .."' );"
		m_simpleTV.Database.ExecuteSql(sqlstr, true)
		sqlstr = "UPDATE ExtFilter SET Comment='" .. my_src_name .. "' WHERE Name='".. my_src_name .."';"
		m_simpleTV.Database.ExecuteSql(sqlstr, true)
		m_simpleTV.PlayList.Refresh()
	end

	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
			t[i].group = tvs_core.tvs_clear_double_space(t[i].group)
			for _, fg in ipairs(filter_grp) do
				if (type(fg) == 'table' and t[i].group == fg[1]) then
					t[i].group = fg[2]
				end
			end
			for _, fg in ipairs(filter_grp) do
				if (type(fg) == 'table' and t[i].group_logo:match(fg[1])) then
					t[i].group_logo = t[i].group_logo:gsub(fg[1],fg[2])
				end
			end
		end
	 return t
	end

	local function LoadFromPage()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local str,page,page_max = '',0,50
		while page <= page_max do
			local url = 'https://vibix.org/api/v1/catalog/data?draw=1&columns[0][data]=uploaded_at&columns[0][name]=&columns[0][searchable]=true&columns[0][orderable]=true&columns[0][search][value]=&columns[0][search][regex]=false&columns[1][data]=id&columns[1][name]=&columns[1][searchable]=true&columns[1][orderable]=true&columns[1][search][value]=&columns[1][search][regex]=false&columns[2][data]=name&columns[2][name]=&columns[2][searchable]=true&columns[2][orderable]=true&columns[2][search][value]=&columns[2][search][regex]=false&columns[3][data]=info&columns[3][name]=&columns[3][searchable]=true&columns[3][orderable]=true&columns[3][search][value]=&columns[3][search][regex]=false&columns[4][data]=genre&columns[4][name]=&columns[4][searchable]=true&columns[4][orderable]=true&columns[4][search][value]=&columns[4][search][regex]=false&columns[5][data]=year&columns[5][name]=&columns[5][searchable]=true&columns[5][orderable]=true&columns[5][search][value]=&columns[5][search][regex]=false&columns[6][data]=country&columns[6][name]=&columns[6][searchable]=true&columns[6][orderable]=true&columns[6][search][value]=&columns[6][search][regex]=false&columns[7][data]=imdb_rating&columns[7][name]=&columns[7][searchable]=true&columns[7][orderable]=true&columns[7][search][value]=&columns[7][search][regex]=false&columns[8][data]=kp_rating&columns[8][name]=&columns[8][searchable]=true&columns[8][orderable]=true&columns[8][search][value]=&columns[8][search][regex]=false&columns[9][data]=kp_votes&columns[9][name]=&columns[9][searchable]=true&columns[9][orderable]=true&columns[9][search][value]=&columns[9][search][regex]=false&columns[10][data]=10&columns[10][name]=&columns[10][searchable]=true&columns[10][orderable]=true&columns[10][search][value]=&columns[10][search][regex]=false&columns[11][data]=11&columns[11][name]=&columns[11][searchable]=true&columns[11][orderable]=true&columns[11][search][value]=&columns[11][search][regex]=false&columns[12][data]=12&columns[12][name]=&columns[12][searchable]=true&columns[12][orderable]=true&columns[12][search][value]=&columns[12][search][regex]=false&order[0][column]=0&order[0][dir]=desc&start=' .. tonumber(page)*100 .. '&length=100&search[value]=&search[regex]=false&filter[type][]=serial&filter[activity][]=1'
			local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'post', headers = m_simpleTV.User.VF.headers})
			if rc ~= 200 or not answer or not answer:match('"id"') then break end
			if tonumber(page) == 0 then Clean_VF() end
			str = str .. unescape3(answer):gsub('\n', ' '):gsub('"\\"', '"«'):gsub('\\"', '»')
			page = page + 1
			m_simpleTV.OSD.ShowMessageT({text = 'VFSERIAL : (стр. ' .. (tonumber(page)) .. ' из ' .. (tonumber(page_max+1)) .. ')' ,0xFF00,3})
		end
		return str
	end

	local function LoadFromSite(variant)
		local t, i = {}, 1
		local answer = LoadFromPage()
		if not answer then return end
			for w in answer:gmatch('%{(.-)"tags":.-%[.-%]') do
				local name, year, adr, imdb_id, kp_id, genre, data_pub, genre_title, suf, country, country_title
				local embed = ''
				name = w:match('"name":"(.-)"')
				adr = w:match('"iframe_video_id":.-(%d+)')
				year = w:match('"year":.-"(.-)"') or 'base'
				imdb_id = w:match('"imdb_id":.-"(tt.-)"')
				kp_id = w:match('"kp_id":(%d+)')
				genre = w:match('"genre":.-"(.-)"') or 'неопределен'
				if genre == '' then genre = 'неопределен' end
				genre_title = genre:gsub('%,.-$','')
				country = w:match('"country":.-"(.-)"') or ''
				country_title = country:gsub('%,.-$','')
				if country_title == '' then country_title = 'нетфлага' end
				--костыли
				if tonumber(adr) == 1955 then genre_title = 'мелодрама' end
				if tonumber(adr) == 2026 then year = '2025' end
				if tonumber(adr) == 640 then year = '2024' end
				if tonumber(adr) == 627 then year = '2024' end
				if tonumber(adr) == 2299 then country_title = 'Великобритания' end
				if tonumber(adr) == 2389 then country_title = 'Великобритания' year = '2025' end
				if tonumber(adr) == 2230 then country_title = 'Австралия' end
				if tonumber(adr) == 1881 then country_title = 'Великобритания' end
				if tonumber(adr) == 2331 then country_title = 'Россия' genre_title = 'триллер' end
				if tonumber(adr) == 2288 then country_title = 'Россия' end
				if tonumber(adr) == 12 then genre_title = 'комедия' end
				if tonumber(adr) == 623 then genre_title = 'триллер' end
				if tonumber(adr) == 2368 then year = '2025' end
				if tonumber(adr) == 2122 then year = '2025' end
				if tonumber(adr) == 2612 then country_title = 'Чехия' end
				if tonumber(adr) == 2550 then year = '2025' end
				if tonumber(adr) == 2566 then year = '2025' end
				if tonumber(adr) == 2435 then year = '2025' end
				if tonumber(adr) == 2517 then year = '2025' end
				if tonumber(adr) == 2698 then year = '2025' end
				if tonumber(adr) == 2346 then year = '2025' end
				if tonumber(adr) == 2437 then year = '2025' end
				if tonumber(adr) == 1998 then year = '2024' end
				if tonumber(adr) == 2038 then year = '2025' end
				if tonumber(adr) == 2655 then year = '2025' end
				if tonumber(adr) == 1970 then year = '2024' end
				if tonumber(adr) == 2348 then year = '2025' end
				if tonumber(adr) == 2544 then year = '2025' end
				if tonumber(adr) == 1958 then year = '2023' end
				if tonumber(adr) == 2589 then year = '2015' end
				if tonumber(adr) == 2436 then year = '2025' end

				data_pub = w:match('"uploaded_at":.-"(.-)"')
				if name and adr then
					if imdb_id then
						imdb_id = '&imdb_id=' .. imdb_id
						embed = embed .. imdb_id
					end
					if kp_id then
						kp_id = '&kp_id=' .. kp_id
						embed = embed .. kp_id
					end
					t[i] = {}
					if tonumber(variant) == 0 then
						t[i].group = genre_title
						suf = '.png'
					elseif tonumber(variant) == 1 then
						t[i].group = year
						suf = '.svg'
					elseif tonumber(variant) == 2 then
						t[i].group = country_title
						suf = '.png'
					end
					if country:match('Россия') and tonumber(variant) ~= 2 then t[i].group = 'Российские сериалы' suf = '.png' end
					if country:match('СССР') and tonumber(variant) ~= 2 then t[i].group = 'Советские сериалы' suf = '.png' end
					t[i].logo = './luaScr/user/show_mi/pause/Vibix.png'
					t[i].name = name:gsub('\\u2013', '-'):gsub('\\u2014', '-'):gsub('\\u2026', '...'):gsub('\\u00ab', '«'):gsub('\\u00bb', '»'):gsub('\\u2116', '№'):gsub('\\u2019', '`'):gsub('\\/', '/') .. ' (' .. year .. ')'
					t[i].address = 'https://672723821.videoframe1.com/embed-serials/' .. adr .. embed
					t[i].video_title = data_pub .. ' | ' .. genre
					t[i].group_logo = './luaScr/user/show_mi/IMDB_pack/' .. t[i].group .. suf
					i = i + 1
				end
			end
			if i == 1 then return end
		return t
	end

	function GetList(UpdateID, m3u_file)
		if not UpdateID then return end
		if not m3u_file then return end
		if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local pll={
		{0,"группировка по титульному жанру"},
		{1,"группировка по году"},
		{2,"группировка по титульной стране"},
		}

		local t={}
		for i=1,#pll do
			t[i] = {}
			t[i].Id = i
			t[i].Name = pll[i][2]
			t[i].Action = pll[i][1]
		end

		local playlist
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('VibixSerial - select playlist',0,t,9000,1+4+8)
		if id==nil then return end
		if ret == 1 then
			playlist = t[id].Action
		end
		local t_pls = LoadFromSite(playlist)
		if not t_pls then m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'}) return end
		t_pls = ProcessFilterTableLocal(t_pls)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
		if not handle then return end
		handle:write(m3ustr:gsub('%#EXTM3U ','#EXTM3U $BorpasFileFormat="1" $NestedGroupsSeparator="/" '))
		handle:close()
		return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')