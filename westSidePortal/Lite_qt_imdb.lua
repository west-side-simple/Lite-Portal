--IMDB portal - lite version west_side 20.05.25

	function get_adr_collections_plus()
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
			i = i + 1
		end
		k = k + 1
		end
		return t
	end

	function get_adr_collections()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 6000)
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
			t[i].logo = 'https://img.pris.cam/t/p/w500/' .. logo
			t[i].group = 'Collections'
			i = i + 1
		end
		k = k + 1
		end
		return t
	end

function Get_address_imdb(tf, name)
	if not tf or not name then return end
	local t1,j = {},1
	for i=1,#tf do
		if name == tf[i].group then
			t1[j] = {}
			t1[j].Id = j
			t1[j].Name = tf[i].name
			t1[j].Address = tf[i].address
			t1[j].Group = tf[i].group
			t1[j].Logo = tf[i].logo
--			debug_in_file(t1[j].Name .. '/' .. t1[j].Address .. '\n')
			j = j + 1
			i = i + 1
		end
	end
				if name == 'Collections' then
					m_simpleTV.User.TVPortal.stena_imdb_type = 'select_collection'
				elseif name == 'Collections+' then
					m_simpleTV.User.TVPortal.stena_imdb_type = 'select_collection_plus'
				elseif name == 'Favorite' then
					m_simpleTV.User.TVPortal.stena_imdb_type = 'select_favorite'
				else
					m_simpleTV.User.TVPortal.stena_imdb_type = 'select_genre'
				end

		m_simpleTV.User.TVPortal.stena_imdb_prev = nil
		m_simpleTV.User.TVPortal.stena_imdb_next = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_adr = ''
		m_simpleTV.User.TVPortal.stena_imdb = t1
		m_simpleTV.User.TVPortal.stena_imdb_genres = tf
		m_simpleTV.User.TVPortal.stena_imdb_title = 'IMDb: ' .. name
--		if create_stena_for_imdb then create_stena_for_imdb() end
		if create_stena_for_imdb then return create_stena_for_imdb() end


	t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' IMDB '}
	t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	m_simpleTV.Common.Sleep(200)
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Menu IMDb: ' .. name,0,t1,10000,1+4+8+2)
			if ret==1 then
				if t1[id].Group == 'Collections' then
					return content_tmdb(t1[id].Address, name .. ' / ' .. t1[id].Name)
				elseif t1[id].Group == 'Collections+' then
					return content_title(t1[id].Address, name .. ' / ' .. t1[id].Name)
				else
					return content_imdb(t1[id].Address, name .. ' / ' .. t1[id].Name)
				end
			end
			if ret==2 or ret==-1 then
				return run_lite_qt_imdb()
			end
			if ret==3 then
				return run_westSide_portal()
			end
end

function run_lite_qt_imdb(ID)
	stena_clear()
	local tt = {
	{'https://www.imdb.com/chart/top/?ref_=nv_mv_250', 'Top Movie'},
	{'https://www.imdb.com/chart/moviemeter/?ref_=nv_mv_mpm', 'Most Popular Movie'},
	{'https://www.imdb.com/chart/toptv/?ref_=nv_tvv_250', 'Top Series'},
	{'https://www.imdb.com/chart/tvmeter/?ref_=nv_tvv_mptv', 'Most Popular Series'},
	{'https://www.imdb.com/chart/boxoffice/', 'Top Box Office (US)'},
	{'https://www.imdb.com/chart/top-english-movies/', 'Top Rated English Movies'}
	}

	local t, i = {}, 1

	local t1 = get_adr_collections()
	if t1 then
		for j = 1,#t1 do
			t[i] = t1[j]
			i = i + 1
		end
	end
	local t2 = get_adr_collections_plus()
	if t2 then
		for j = 1,#t2 do
			t[i] = t2[j]
			i = i + 1
		end
	end
	for j = 1, #tt do
			t[i] = {}
			t[i].name = tt[j][2]
			t[i].address = tt[j][1]
			t[i].group = 'Favorite'
			t[i].logo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuIMDb.png'
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
--	i = #t + 1
		for w in answer:gmatch('%d+.-\n') do
			local adr, grp, title, logo = w:match('(.-);(.-);(.-);(.-)\n')
			if not adr then break end
			t[i] = {}
			t[i].name = title
			t[i].address = 'https://www.imdb.com/interest/in0000' .. adr
			t[i].group = grp
			t[i].logo = logo
			i = i + 1
		end

	local hash, t0 = {}, {}
		for i = 1, #t do
			if not hash[t[i].group]
			then
				t0[#t0 + 1] = t[i]
				hash[t[i].group] = true
			end
		end
		table.sort(t0, function(a, b) return tostring(a.group) < tostring(b.group) end)
		for i = 1, #t0 do
			t0[i].Id = i
			t0[i].Name = t0[i].group
		end

		m_simpleTV.User.TVPortal.stena_imdb_prev = nil
		m_simpleTV.User.TVPortal.stena_imdb_next = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_adr = ''
		m_simpleTV.User.TVPortal.stena_imdb = t
		m_simpleTV.User.TVPortal.stena_imdb_genres = t0
		if ID and ID:match('FAVORITE') then return Get_address_imdb(t, 'Favorite') end
		if ID and ID:match('COL_IMDB') then return Get_address_imdb(t, 'Collections') end
		if ID and ID:match('COL_PLUS_IMDB') then return Get_address_imdb(t, 'Collections+') end
		m_simpleTV.User.TVPortal.stena_imdb_type = 'select_genres'
		m_simpleTV.User.TVPortal.stena_imdb_title = 'IMDb: Жанры'
--		if create_stena_for_imdb then create_stena_for_imdb() end
		if create_stena_for_imdb then return create_stena_for_imdb() end
		t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}

		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IMDb: Жанры',0,t0,10000,1+4+8+2)
			if ret==1 then
				return Get_address_imdb(t, t0[id].Name)
			end
			if ret==2 or ret==-1 then
				return run_westSide_portal()
			end

end

function content_imdb(url, name)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local cookies = 'lc-main=ru_RU'
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Cookie: ' .. cookies})
	answer = answer:match('<script id="__NEXT_DATA__" type="application/json">(.-)</script>')
	answer = unescape3(answer)

			if not answer then return end
			answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
--			debug_in_file(answer,'c://1/imdb_int.txt')

			local t, i = {}, 1
			for w in answer:gmatch('"id":"tt.-"runtime"') do
			local address, Title, Type, originalTitle, logo, year = w:match('"id":"(tt.-)".-"text":"(.-)".-"text":"(.-)".-"text":"(.-)".-"url":"(.-)".-"year":(%d%d%d%d)')
			if not address then break end
				t[i]={}
				t[i].Id = i
				t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
				t[i].Address = 'https://www.imdb.com/title/' .. address
				t[i].InfoPanelTitle = Title .. ' / ' .. originalTitle .. ' (' .. year .. ') - ' .. Type
				t[i].InfoPanelLogo = logo
				t[i].Title = Title .. ' (' .. year .. ')'
				t[i].Type = Type
				i = i + 1
			end

			if #t == 0 then
				for w in answer:gmatch('"id":"tt.-"imageType":".-"') do
					local address, Title, year, logo, Type = w:match('"id":"(tt.-)".-"titleNameText":"(.-)".-"titleReleaseText":"(.-)".-"url":"(.-)".-"imageType":"(.-)"')
					if not address then break end
					t[i]={}
--					t[i].Id = i
					t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
					t[i].Address = 'https://www.imdb.com/title/' .. address
					t[i].InfoPanelTitle = Title .. ' (' .. year .. ') - ' .. Type
					t[i].InfoPanelLogo = logo
					t[i].Title = Title .. ' (' .. year .. ')'
					t[i].Type = Type
					i = i + 1
				end
			end

			if #t == 0 then
				for w in answer:gmatch('"id":"tt.-"titleType":%{"id":".-"') do
					local address, Title, originalTitle, logo, year, Type = w:match('"id":"(tt.-)".-"text":"(.-)".-"text":"(.-)".-"url":"(.-)".-%((%d%d%d%d)%)".-"titleType":%{"id":"(.-)"')
					if not address then break end
					t[i]={}
					t[i].Id = i
					t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
					t[i].Address = 'https://www.imdb.com/title/' .. address
					t[i].InfoPanelTitle = Title .. ' / ' .. originalTitle .. ' (' .. year .. ') - ' .. Type
					t[i].InfoPanelLogo = logo
					t[i].Title = Title .. ' (' .. year .. ')'
					t[i].Type = Type
					i = i + 1
				end
			end

			local hash, t0 = {}, {}
				for i = 1, #t do
					if not hash[t[i].Address]
--					and t[i].Type ~= 'Video'
					then
						t0[#t0 + 1] = t[i]
						hash[t[i].Address] = true
					end
				end

				for i = 1, #t0 do
					t0[i].Id = i
				end
		m_simpleTV.User.TVPortal.stena_imdb_type = 'genre'
		m_simpleTV.User.TVPortal.stena_imdb_prev = nil
		m_simpleTV.User.TVPortal.stena_imdb_next = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_adr = url
		m_simpleTV.User.TVPortal.stena_imdb = t0
		m_simpleTV.User.TVPortal.stena_imdb_title = name .. ' - ' .. #t0
		if create_stena_for_imdb then return create_stena_for_imdb() end

		local AutoNumberFormat, FilterType
			if #t0 > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' IMDB '}
		t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
		t0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		if #t0 > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('IMDb: ' .. name, 0, t0, 30000, 1 + 4 + 8 + 2)
			if ret == 1 then
				m_simpleTV.Control.PlayAddressT({address=t0[id].Address, title=t0[id].Name})
			end
			if ret == 2 then
				return run_lite_qt_imdb()
			end
			if ret==3 or ret==-1 then
				return run_westSide_portal()
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'IMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function content_tmdb(url, name)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local t, i = {}, 1
	for k =1,10 do
		local rc, answer = m_simpleTV.Http.Request(session, {url = url .. '?page=' .. k})
		if not answer then break end
--			debug_in_file(answer,'c://1/tmdb_int.txt')


			for w in answer:gmatch('%{.-%}') do

			local tv
			local address = w:match('"id":.-(%d+)')
			local Title = w:match('"title":.-"(.-)"') or w:match('"name":.-"(.-)"')
			local originalTitle = w:match('"original_title":.-"(.-)"') or w:match('"original_name":.-"(.-)"')
			local overview = w:match('"overview":.-"(.-)"') or ''
			local Type = w:match('"media_type":.-"(.-)"')
			if Type and Type == 'movie' then tv = 0 else tv = 1 end
			local logo = w:match('"poster_path":.-"(.-)"') or ''
			logo = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. logo
			local year = w:match('"release_date":.-"(%d%d%d%d)') or w:match('"first_air_date":.-"(%d%d%d%d)') or 0
			if not address then break end
				t[i]={}
				t[i].Id = i
				t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
				t[i].Address = 'tmdb_id=' .. address .. '&tv=' .. tv .. '&'
				t[i].InfoPanelTitle = overview
				t[i].InfoPanelName = Title .. ' / ' .. originalTitle .. ' (' .. year .. ') - ' .. Type
				t[i].InfoPanelLogo = logo
				t[i].Title = Title .. ' (' .. year .. ')'
				t[i].Type = Type
--				debug_in_file(t[i].Address .. '\n','c://1/tmdb_int.txt')
				i = i + 1
			end
		k = k + 1
	end
			local hash, t0 = {}, {}
				for i = 1, #t do
					if not hash[t[i].Address]
					then
						t0[#t0 + 1] = t[i]
						hash[t[i].Address] = true
					end
				end

				for i = 1, #t0 do
					t0[i].Id = i
				end
		m_simpleTV.User.TVPortal.stena_imdb_type = 'collection'
		m_simpleTV.User.TVPortal.stena_imdb_prev = nil
		m_simpleTV.User.TVPortal.stena_imdb_next = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_adr = url
		m_simpleTV.User.TVPortal.stena_imdb = t0
		m_simpleTV.User.TVPortal.stena_imdb_title = name .. ' - ' .. #t0
		if create_stena_for_imdb then return create_stena_for_imdb() end

		local AutoNumberFormat, FilterType
			if #t0 > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' IMDB '}
		t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
		t0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		if #t0 > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('TMDB: ' .. name, 0, t0, 30000, 1 + 4 + 8 + 2)
			if ret == 1 then
				m_simpleTV.Control.PlayAddressT({address=t0[id].Address, title=t0[id].Name})
			end
			if ret == 2 then
				return run_lite_qt_imdb()
			end
			if ret==3 or ret==-1 then
				return run_westSide_portal()
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'IMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function content_title(url, title)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})

			if not answer then return end

			require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
--	local title = tab.title
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id
	local name = tab.channels[i].details.name
	local poster = tab.channels[i].details.poster
	local originalname = tab.channels[i].details.originalname
	local released = tab.channels[i].details.released
	local about = tab.channels[i].details.about
	local genre = tab.channels[i].details.genre
	local type = tab.channels[i].details.type
	t[i].Id = i
	t[i].Name = name .. ' (' .. released .. ') - ' .. type
	t[i].InfoPanelLogo = poster
	t[i].Address = 'title=' .. m_simpleTV.Common.toPercentEncoding(name) .. '&year=' .. released
	t[i].InfoPanelName = name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
	t[i].InfoPanelTitle = about
	t[i].Title = name .. ' (' .. released .. ')'
--	debug_in_file(name .. '\n' .. m_simpleTV.Common.multiByteToUTF8(name) .. '\n' .. m_simpleTV.Common.UTF8ToMultiByte(name) .. '\n','c://1/content.txt')
	t[i].Type = type
    i=i+1
	end

			local hash, t0 = {}, {}
				for i = 1, #t do
					if not hash[t[i].Address]
					then
						t0[#t0 + 1] = t[i]
						hash[t[i].Address] = true
					end
				end

				for i = 1, #t0 do
					t0[i].Id = i
				end
		m_simpleTV.User.TVPortal.stena_imdb_type = 'collection_plus'
		m_simpleTV.User.TVPortal.stena_imdb_prev = nil
		m_simpleTV.User.TVPortal.stena_imdb_next = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_adr = url
		m_simpleTV.User.TVPortal.stena_imdb = t0
		m_simpleTV.User.TVPortal.stena_imdb_title = title .. ' - ' .. #t0
		if create_stena_for_imdb then return create_stena_for_imdb() end

		local AutoNumberFormat, FilterType
			if #t0 > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' IMDB '}
		t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
		t0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		if #t0 > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('IMDB: ' .. title, 0, t0, 30000, 1 + 4 + 8 + 2)
			if ret == 1 then
				m_simpleTV.Control.PlayAddressT({address=t0[id].Address, title=t0[id].Name})
			end
			if ret == 2 then
				return run_lite_qt_imdb()
			end
			if ret==3 or ret==-1 then
				return run_westSide_portal()
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'IMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function IMDB_Get_History()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- wafee code for history

    local recentName = getConfigVal('imdb_history/title') or ''
    local recentAddress = getConfigVal('imdb_history/adr') or ''
	local recentLogo = getConfigVal('imdb_history/logo') or ''

     local t,i={},1

   if recentName~='' and recentLogo~='' and recentAddress~='' then
     for w in string.gmatch(recentName,"[^%|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
	   t[i].InfoPanelName = w
	   t[i].Title = w
	   t[i].InfoPanelShowTime = 10000
       i=i+1
     end
     i=1
     for w in string.gmatch(recentAddress,"[^%|]+") do
       t[i].Address = w
	   t[i].InfoPanelTitle = w:match('%&bal=(.-)$')
       i=i+1
     end
	 i=1
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t[i].InfoPanelLogo = w
       i=i+1
     end
   end
		m_simpleTV.User.TVPortal.stena_imdb_type = 'view'
		m_simpleTV.User.TVPortal.stena_imdb_prev = nil
		m_simpleTV.User.TVPortal.stena_imdb_next = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = nil
		m_simpleTV.User.TVPortal.stena_imdb_current_page_adr = url
		m_simpleTV.User.TVPortal.stena_imdb = t
		m_simpleTV.User.TVPortal.stena_imdb_title = 'IMDB: история просмотра - ' .. #t
		if create_stena_for_imdb then return create_stena_for_imdb() end

   t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
   t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Cleane '}
   local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IMDB: История просмотра',0,t,9000,1+4+8)
   if id==nil then
   run_westSide_portal()
   end
   if ret==1 then
      m_simpleTV.Control.PlayAddressT({address = t[id].Address:gsub('%&bal=.-$',''),title = t[id].Name})
   end
   if ret==2 then
	  run_westSide_portal()
   end
   if ret==3 then
      setConfigVal('imdb_history/title','')
	  setConfigVal('imdb_history/logo','')
	  setConfigVal('imdb_history/adr','')
	  start_page_mediaportal()
   end
end

function add_to_history_imdb(adr, title, logo)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- wafee code for history
	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = getConfigVal('imdb_history/title') or ''
    local recentAddress = getConfigVal('imdb_history/adr') or ''
	local recentLogo = getConfigVal('imdb_history/logo') or ''
	local current_id = adr:match('/(tt%d+)')
     local t={}
     local tt={}
     local i=2
	 t[1] = {}
     t[1].Id = 1
     t[1].Name = title
	 t[1].Address = adr
	 t[1].Logo = logo or 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT89hQjoryKk0JDGGngnnV3bLpSTv61LwpYAg&s'
   if recentName~='' and recentLogo~='' and recentAddress~='' then

     for w in string.gmatch(recentName,"[^%|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
       i=i+1
     end
     i=2
     for w in string.gmatch(recentAddress,"[^%|]+") do
       t[i].Address = w
       i=i+1
     end
	 i=2
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t[i].Logo = w
       i=i+1
     end

     local function isExistAdr()
       for i=2,#t do
	     local from_all_id = t[i].Address:match('/(tt%d+)')
         if from_all_id == current_id then
           return true, i
         end
       end
       return false
     end

     local isExist,i=isExistAdr()
     if isExist then
       table.remove(t,i)
     end

     recentName=''
     recentAddress = ''
     recentLogo = ''

	 if #t <= tonumber(max_history) then
		cur_max = #t
	 else
		cur_max = tonumber(max_history)
	 end

     for i=1,cur_max  do
      local name = t[i].Name
      t[i].Name = t[i].Name:gsub('@@@@@',',')
      recentName = recentName .. name .. '|'
      recentAddress = recentAddress .. t[i].Address .. '|'
	  recentLogo = recentLogo .. t[i].Logo .. '|'
      t[i].Id = i
--      debug_in_file('fromOSDmenu = ' .. t[i].Id .. ' ' .. t[i].Name .. ' ' .. t[i].Address .. '\n','c://1/kp.txt')
     end

	 setConfigVal('imdb_history/title',recentName)
	 setConfigVal('imdb_history/logo',recentLogo)
	 setConfigVal('imdb_history/adr',recentAddress)

	 else

	 setConfigVal('imdb_history/title',title .. '|')
	 setConfigVal('imdb_history/logo',logo .. '|')
	 setConfigVal('imdb_history/adr',adr .. '|')

   end
end

function create_stena_for_imdb()

--if m_simpleTV.User.TVPortal.stena == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_imdb_use = true
	m_simpleTV.User.TVPortal.stena_exfs_use = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.cur_content_adr = nil
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_EXFS_ID')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR3_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR4_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR5_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR6_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_EXFS_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_EXFS_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_IMDB_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_IMDB_WS')


	local  t, AddElement = {}, m_simpleTV.OSD.AddElement

				 t = {}
				 t.id = 'STENA_CLEAR1_TOOLTIP_IMDB_WS'
				 t.cx=15
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=80
				 t.top=0
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x000000ff --for test
--				 t.backcolor1 = 0x66000000 --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_EXFS_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR2_TOOLTIP_IMDB_WS'
				 t.cx=15
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=95
				 t.top=0
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x66000000 --for test
--				 t.backcolor1 = 0x000000ff --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_EXFS_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_STENA_1'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=-70 / m_simpleTV.Interface.GetScale()*1.5
				 t.once=1
				 t.zorder=1
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_STENA_2'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=0
				 t.once=1
				 t.zorder=0
				 t.background = 1
				 t.backcolor0 = 0x440000FF
--				 t.backcolor1 = 0x77FFFFFF
				 AddElement(t)

				 t = {}
				 t.id = 'FON_STENA_ID'
				 t.cx= -100
				 t.cy= -100
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="150" delay="60" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/cerberus/cerberus%1.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=0
				 t.top=0
				 t.transparency = 255
				 t.zorder=1
				 AddElement(t,'ID_DIV_STENA_2')

				 t = {}
				 t.id = 'GLOBUS_STENA_ID'
				 t.cx= 60
				 t.cy= 60
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d/d%0.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0103
				 t.left=15
				 t.top=110
				 t.transparency = 255
				 t.zorder=2
				 t.isInteractive = true
				 t.cursorShape = 13
				 t.mousePressEventFunction = 'start_page_mediaportal'
				 AddElement(t,'ID_DIV_STENA_1')

				 t={}
				 t.id = 'TEXT_STENA_TITLE_ID'
				 t.cx=-66
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0102
				 if not m_simpleTV.User.TVPortal.stena_imdb_type:match('select') then
				 t.text = m_simpleTV.User.TVPortal.stena_imdb_title .. ' (' .. (m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel or 1) .. '/' .. math.ceil(#m_simpleTV.User.TVPortal.stena_imdb/30) .. ')'
				 else
				 t.text = m_simpleTV.User.TVPortal.stena_imdb_title
				 end
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = m_simpleTV.User.TVPortal.stena_exfs_title_font or 'Segoe UI Black'
				 t.textparam = 0x00000001
				 t.boundWidth = 15 -- bound to screen
				 t.row_limit=1 -- row limit
				 t.scrollTime = 20 --for ticker (auto scrolling text)
				 t.scrollFactor = 4
				 t.text_elidemode = 2
				 t.scrollWaitStart = 40
				 t.scrollWaitEnd = 100
				 t.left = 0
				 t.top  = 100
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
--				 t.isInteractive = true
--				 t.cursorShape = 13
				 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'IMDB_VIEW_IMDB_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/home.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 180
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'view' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'IMDB_Get_History'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_FAVORITE_IMDB_IMG_ID'
				t.cx=64
				t.cy=64
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/favorite.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 260
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_favorite' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'run_lite_qt_imdb'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_COL_IMDB_IMG_ID'
				t.cx=64
				t.cy=64
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 340
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_collection' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'run_lite_qt_imdb'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_COL_PLUS_IMDB_IMG_ID'
				t.cx=64
				t.cy=64
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections_plus.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 420
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_collection_plus' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'run_lite_qt_imdb'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_GENRES_IMDB_IMG_ID'
				t.cx=64
				t.cy=64
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 500
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_genres' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'run_lite_qt_imdb'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_IMDB_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 660
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'stena_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_HISTORY_IMDB_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search_History.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 740
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'get_history_of_search'
				AddElement(t,'ID_DIV_STENA_1')

			if not m_simpleTV.User.TVPortal.stena_imdb_type:match('select') then
				m_simpleTV.User.TVPortal.stena_imdb_max_num_karusel = math.ceil(#m_simpleTV.User.TVPortal.stena_imdb/30)

				m_simpleTV.User.TVPortal.stena_imdb_prev_karusel_num = nil
				m_simpleTV.User.TVPortal.stena_imdb_next_karusel_num = nil

				m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel or 1

				if tonumber(m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel) < tonumber(m_simpleTV.User.TVPortal.stena_imdb_max_num_karusel) then
					m_simpleTV.User.TVPortal.stena_imdb_next_karusel_num = tonumber(m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel) + 1
				end
				if tonumber(m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel) > 1 then
					m_simpleTV.User.TVPortal.stena_imdb_prev_karusel_num = tonumber(m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel) - 1
				end
				if m_simpleTV.User.TVPortal.stena_imdb_prev_karusel_num then
				t = {}
				t.id = 'STENA_PREV_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 900
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'for_create_stena_for_imdb'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_imdb_next_karusel_num then
				t = {}
				t.id = 'STENA_NEXT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 980
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'for_create_stena_for_imdb'
				AddElement(t,'ID_DIV_STENA_1')
				end
			end
				t = {}
				t.id = 'STENA_CLEAR_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Clear.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 30
			    t.top  = 1060
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.background = 2
			    t.backcolor0 = 0xFFB0C4DE
			    t.backcolor1 = 0xFF1E213D
				t.background_UnderMouse = 2
				t.backcolor0_UnderMouse = 0xFF4287FF
				t.backcolor1_UnderMouse = 0xFF00008B
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_EXFS_WS'
				t.mousePressEventFunction = 'stena_clear'
				AddElement(t,'ID_DIV_STENA_1')

	if not m_simpleTV.User.TVPortal.stena_imdb_type:match('select') then
				local dn = 10
				local dx = 1800/dn
				local dy = 1800/dn*1.5
				local j_start = (tonumber(m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel) - 1) * 30 + 1
				local j_end = tonumber(j_start) + 29
				for j = j_start, j_end do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil((j - j_start + 1)/dn)

					if not m_simpleTV.User.TVPortal.stena_imdb[j] then break end
					t = {}
					t.id = j .. '_STENA_IMDB_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 55
					t.class="IMAGE"
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 55) + 100
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'play_media_IMDB_from_stena'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = j .. '_STENA_EXFS_LOGO_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.TVPortal.stena_imdb[j].InfoPanelLogo
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = -2
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_IMDB_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

					if m_simpleTV.User.TVPortal.stena_imdb_type == 'view' then
					t = {}
					t.id = 'IMDb&STENA_START_CLEANE_ITEM&' .. j
					t.cx=50
					t.cy=50
					t.class="TEXT"
					t.text = '  '
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 15
					t.left = dx-60
					t.top  = 5
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=2
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 0, 0)
					t.mousePressEventFunction = 'history_stena_cleane_item'
					AddElement(t,j .. '_STENA_IMDB_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)
					end

					t = {}
					t.id = j .. '_STENA_IMDB_TEXT_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-30
					t.cy=dy-30 + 65
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_imdb[j].Title
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = 'Segoe UI Black'
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'play_media_IMDB_from_stena'
					AddElement(t,j .. '_STENA_IMDB_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

					if m_simpleTV.User.TVPortal.stena_imdb[j].Type then
						t = {}
						t.id = 'STENA_IMDB_PICON_BACK_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
						t.cx= 80
						t.cy= 50
						t.class="IMAGE"
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left= 0
						t.top= 0
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 1
						t.bordercolor = -6250336
						t.backroundcorner = 3*3
						t.borderround = 3
						AddElement(t,j .. '_STENA_IMDB_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

						t = {}
						t.id = 'STENA_IMDB_PICON_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
						t.class="IMAGE"
						if m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'Movie' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'movie' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'documovie' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'Video' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'video' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'tvMovie' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'TV Movie' then
						t.cx= 21 * 1.5
						t.cy= 16 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/films.svg'
						elseif m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'TV Series' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'TV Mini Series' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'tv' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'serial' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'docuserial' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'tvSeries' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'tvMiniSeries' then
						t.cx= 21 * 1.5
						t.cy= 16 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/series.svg'
						elseif m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'multfilm' or m_simpleTV.User.TVPortal.stena_imdb[j].Type == 'multserial' then
						t.cx= 19 * 1.5
						t.cy= 17 * 1.5
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.svg'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0202
						t.left = 0
						t.top  = 0
						t.transparency = 200
						t.zorder=1
--						t.borderwidth = 2
--						t.bordercolor = -6250336
--						t.backroundcorner = 3*3
--						t.borderround = 3
						AddElement(t,'STENA_IMDB_PICON_BACK_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)
					end

				end
	elseif m_simpleTV.User.TVPortal.stena_imdb_type:match('select') then

		if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_genres' then
				local dn = 5
				local dx = 1800/dn
				local dy = 140
				for j = 4, #m_simpleTV.User.TVPortal.stena_imdb_genres do
					local nx = j - 3 - (math.ceil((j - 3)/dn) - 1)*dn
					local ny = math.ceil((j - 3)/dn)

					if not m_simpleTV.User.TVPortal.stena_imdb_genres[j] then break end
					t = {}
					t.id = j .. '_STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name)
					t.cx=dx-10
					t.cy=dy-10 + 25
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 25) + 90
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'get_page_imdb'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = j .. '_STENA_IMDB_GENRE_LOGO_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name
					t.cx=dx-8
					t.cy=dy-8
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/IMDB_pack/' .. m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name .. '.png'
--					t.minresx=-1
--					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = -2
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
--					t.backroundcorner = 3*3
--					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name))

					t = {}
					t.id = j .. '_STENA_IMDB_GENRE_TXT_ID&' .. m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name
					t.cx=dx-30
					t.cy=dy-30 + 40
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'get_page_imdb'
					AddElement(t,j .. '_STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb_genres[j].Name))
				end
		end
		if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_genre' then
				local dn = 5
				local dx = 1800/dn
				local dy = 200
				for j = 1, #m_simpleTV.User.TVPortal.stena_imdb do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.TVPortal.stena_imdb[j] then break end
					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 35
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 100
					t.top  = (ny - 1)*(dy + 35) + 100
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'create_stena_for_col'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_LOGO_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-12
					t.cy=dy-12
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.TVPortal.stena_imdb[j].Logo
--					t.minresx=-1
--					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = -2
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_TXT_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-30
					t.cy=dy-30 + 48
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_imdb[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -11 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'create_stena_for_col'
					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)
				end
		end
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_favorite' then
				local dn = 3
				local dx = 1800/dn
				local dy = 350
				for j = 1, #m_simpleTV.User.TVPortal.stena_imdb do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.TVPortal.stena_imdb[j] then break end
					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-100
					t.cy=dy-100 + 50
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 150
					t.top  = (ny - 1)*(dy + 50) + 100
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'create_stena_for_col'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_LOGO_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-340
					t.cy=dy-100
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/IMDB_pack/' .. m_simpleTV.User.TVPortal.stena_imdb[j].Name .. '.png'
--					t.minresx=-1
--					t.minresy=-1
					t.align = 0x0102
					t.left = 0
					t.top  = -2
					t.transparency = 200
					t.zorder=1
--					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
--					t.backroundcorner = 3*3
--					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_TXT_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-100
					t.cy=dy-200 + 120
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_imdb[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -16 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 50
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'create_stena_for_col'
					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)
				end
		end
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_collection' then
				local dn = 7
				local dx = 1800/dn
				local dy = 160
				for j = 1, #m_simpleTV.User.TVPortal.stena_imdb do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.TVPortal.stena_imdb[j] then break end
					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 0
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 110
					t.top  = (ny - 1)*(dy + 0) + 100
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'create_stena_for_col'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_LOGO_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-12
					t.cy=dy-12
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.TVPortal.stena_imdb[j].Logo
--					t.minresx=-1
--					t.minresy=-1
					t.align = 0x0102
					t.left = 1
					t.top  = -1
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = 0x00FFFFFF
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_TXT_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 25
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_imdb[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'create_stena_for_col'
--					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)
				end
		end
				if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_collection_plus' then
				local dn = 14
				local dx = 1800/dn
				local dy = dx * 1.5
				for j = 1, #m_simpleTV.User.TVPortal.stena_imdb do
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)

					if not m_simpleTV.User.TVPortal.stena_imdb[j] then break end
					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 0
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = (nx - 1)*(dx + 0) + 110
					t.top  = (ny - 1)*(dy + 0) + 100
					t.transparency = 100
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
--					t.bordercolor = -6250336
					t.bordercolor = 0x77777777
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mousePressEventFunction = 'create_stena_for_col'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_LOGO_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-12
					t.cy=dy-12
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.TVPortal.stena_imdb[j].Logo
--					t.minresx=-1
--					t.minresy=-1
					t.align = 0x0102
					t.left = 1
					t.top  = -1
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = 0x00FFFFFF
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)

					t = {}
					t.id = m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_TXT_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 25
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_imdb[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'create_stena_for_col'
--					AddElement(t,m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_imdb[j].Name) .. '&STENA_IMDB_GENRE_BACK_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_imdb[j].Address)
				end
		end
	end
end

function get_page_imdb(id)
	if not id then return end
	local adr = id:match('&(.-)$')
--	debug_in_file(m_simpleTV.Common.UTF8ToMultiByte(adr) .. '\n\n')
	if adr and adr ~= '' then
		return Get_address_imdb(m_simpleTV.User.TVPortal.stena_imdb, m_simpleTV.Common.UTF8ToMultiByte(adr))
	end
	return
end

function media_info_IMDb_from_stena(id)
	if not id then return end
	return play_media_IMDB_from_stena(id)
end

function play_media_IMDB_from_stena(id)
	if not id then return end
--	debug_in_file(id .. '\n\n')
	local adr = id:match('&(.-)$')
	if adr and adr ~= '' then
		stena_clear()
		m_simpleTV.Control.PlayAddressT({address=m_simpleTV.Common.fromPercentEncoding(adr)})
	end
	return
end

function for_create_stena_for_imdb(id)
	if not id then return end
	if id:match('PREV') then
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel - 1
	elseif id:match('NEXT') then
		m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel = m_simpleTV.User.TVPortal.stena_imdb_current_page_karusel + 1
	end
	return create_stena_for_imdb()
end

function create_stena_for_col(id)
	if not id then return end
--	debug_in_file(id .. '\n\n')
	local name, adr = id:match('^(.-)&.-&(.-)$')
	if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_collection' then
		return content_tmdb(adr, 'IMDB Collections / ' .. m_simpleTV.Common.fromPercentEncoding(name))
	end
	if m_simpleTV.User.TVPortal.stena_imdb_type == 'select_collection_plus' then
		return content_title(adr, 'IMDB Collections+ / ' .. m_simpleTV.Common.fromPercentEncoding(name))
	end
	return content_imdb(adr, 'IMDB Жанры / ' .. m_simpleTV.Common.fromPercentEncoding(name))
end