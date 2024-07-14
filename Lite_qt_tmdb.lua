--TMDb portal - lite version west_side 04.07.24

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
	if m_simpleTV.User.ZF==nil then m_simpleTV.User.ZF={} end
	m_simpleTV.User.ZF.cookies = ''

local function Get_Reting(tmid)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmdG1kYj0=') .. tmid
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	m_simpleTV.User.TVPortal.stena.ret_KP = answer:match('"rating_kp":(.-)%,')
	m_simpleTV.User.TVPortal.stena.ret_imdb = answer:match('"rating_imdb":(.-)%,')
	m_simpleTV.Http.Close(session)
	return
end

local function Get_AL(imdb)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmaW1kYj0=') .. imdb
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	m_simpleTV.User.TVPortal.stena.kp = answer:match('"id_kp":(.-)%,')
	m_simpleTV.User.TVPortal.stena.ret_KP = answer:match('"rating_kp":(.-)%,')
	m_simpleTV.User.TVPortal.stena.ret_imdb = answer:match('"rating_imdb":(.-)%,')
--	debug_in_file(m_simpleTV.User.TVPortal.stena.kp .. ' ' .. m_simpleTV.User.TVPortal.stena.ret_KP .. ' ' .. 	m_simpleTV.User.TVPortal.stena.ret_imdb .. '\n','c://1/ans_ALL.txt')
	m_simpleTV.Http.Close(session)
	return
end


local function get_hdvb(title, year)
	m_simpleTV.User.TVPortal.stena.balanser5 = nil
	m_simpleTV.User.TVPortal.stena.kp = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGl2Yi5pbmZvL2FwaS92aWRlb3MuanNvbj90b2tlbj01ZTJmZTRjNzBiYWZkOWE3NDE0YzRmMTcwZWUxYjE5MiZ0aXRsZT0=') .. m_simpleTV.Common.toPercentEncoding(title)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = unescape1(answer)
--	debug_in_file(title .. ' ' .. year .. '\n' .. answer .. '\n','c://1/content.txt')
	local t = {}
		for ru_title, en_title, in_year, kp_id, tr, url in answer:gmatch('"title_ru":"(.-)".-"title_en":"(.-)".-"year":(%d%d%d%d).-"kinopoisk_id":(%d+).-"translator":"(.-)".-"iframe_url":"(.-)"') do
			if (ru_title and ru_title == title or en_title and en_title == title) and tonumber(in_year) == tonumber(year) then
				t[#t + 1] = {}
				t[#t].Id = #t
				t[#t].Address = url:gsub('\\','')
				t[#t].Name = tr
				t[#t].kp_id = kp_id
--	debug_in_file(tr .. ' ' .. url:gsub('\\','') .. '\n','c://1/content.txt')
			end
		end
	if #t ~= 0 then
--	debug_in_file( 'kp_id=' .. t[1].kp_id .. '\n', 'c://1/content.txt', setnew )
	m_simpleTV.User.TVPortal.stena.balanser5 = t
	m_simpleTV.User.TVPortal.stena.kp = t[1].kp_id
	return true
	end
	return false
end

local function Get_rating(rating,id)
	if m_simpleTV.User.TVPortal.cur_content_adr ~= id then return false end
	if rating == nil or rating == '' then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

local function check_online(tmdbid,tv,id)
	if m_simpleTV.User.TVPortal.cur_content_adr ~= id then return false end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local item, imdbid
	if tonumber(tv) == 0 then item = 'movie' else item = 'tv' end
	local url = 'https://api.themoviedb.org/3/' .. item .. '/' .. tmdbid .. decode64('L2V4dGVybmFsX2lkcz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if answer then imdbid = answer:match('"imdb_id":"(.-)"') end
	--fix
	if tonumber(tmdbid) == 120724 and tonumber(tv) == 1 then imdbid = 'tt15307130' end
	if tonumber(tmdbid) == 64281 and tonumber(tv) == 1 then imdbid = 'tt0245602' end
	--
	if not imdbid then
	m_simpleTV.Http.Close(session)
	return false end
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdbid
	--fix
	if imdbid == 'tt15307130' then
		url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmtpbm9wb2lza19pZD0=') .. 1101239
	end
	--
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
	if rc5==200 and answer_vn:match('data') then
		require('json')
		answer_vn = answer_vn:gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].iframe_src and m_simpleTV.User.TVPortal.cur_content_adr == id and m_simpleTV.User.TVPortal.stena_info ~= true and m_simpleTV.User.TVPortal.stena_genres ~= true and m_simpleTV.User.TVPortal.stena_home ~= true then
			m_simpleTV.Http.Close(session)
			return true
		end
	end
	local urlv = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmaW1kYj0=') .. imdbid
	local rcv,answerv = m_simpleTV.Http.Request(session,{url=urlv})
	if rcv==200 and answerv:match('"id_kp":(%d+)') and tonumber(answerv:match('"id_kp":(%d+)')) > 0 and m_simpleTV.User.TVPortal.cur_content_adr == id and m_simpleTV.User.TVPortal.stena_info ~= true and m_simpleTV.User.TVPortal.stena_genres ~= true and m_simpleTV.User.TVPortal.stena_home ~= true then
		m_simpleTV.Http.Close(session)
		return true
	end
	m_simpleTV.Http.Close(session)
	return false
end

local function check_cat()

	if m_simpleTV.User.TVPortal.stena_search == nil then
		m_simpleTV.User.TVPortal.stena_search = {}
	end

	if m_simpleTV.User.TVPortal.stena == nil then
		m_simpleTV.User.TVPortal.stena = {}
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)
	local title_year = tmdb_search:match(' %((%d%d%d%d)%)$') or tmdb_search:match(' (%d%d%d%d)$') or ''
	local title = tmdb_search:gsub(' %(%d%d%d%d%)$',''):gsub(' %(%)$',''):gsub(' %d%d%d%d$','')

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 10000)

	local url = {}
	m_simpleTV.User.TVPortal.search = {}

	url[1] = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&primary_release_year=' .. title_year

	url[2] = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. title_year

	url[3] = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvcGVyc29uP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmcGFnZT0xJmluY2x1ZGVfYWR1bHQ9ZmFsc2UmcXVlcnk9') .. m_simpleTV.Common.toPercentEncoding(tmdb_search)

	url[4] = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvY29sbGVjdGlvbj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9MSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(tmdb_search)

	for i=1,4 do

		local rc,answer = m_simpleTV.Http.Request(session,{url=url[i]})

		if rc~=200 then
			m_simpleTV.User.TVPortal.search[i] = 0
		else
			m_simpleTV.User.TVPortal.search[i] = answer:match('"total_results":(%d+)')
		end
		i = i + 1
	end
end

local function check_pirr(id)
	if not id then return false,0 end
	local delta = os.clock()
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local url = 'http://api.vokino.tv/v2/torrents/' .. id .. '?token=' .. token
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		delta = os.clock() - delta
		return false,delta
	end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		delta = os.clock() - delta
		return false,delta
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
--[[	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.menu or not tab.menu[1] or not tab.menu[1].title or not tab.menu[1].submenu or not tab.menu[1].submenu[1] or not tab.menu[1].submenu[1].playlist_url or not tab.menu[1].submenu[1].title or tab.menu[1].submenu[1].title ~= 'Все' --]]
	if not answer:match('Все')
	then
		delta = os.clock() - delta
		return false,delta
	end
	m_simpleTV.Http.Close(session)
	delta = os.clock() - delta
	return true,delta
end

local function Get_pirring_from_name(title, tv, year)
	m_simpleTV.User.TVPortal.stena.balanser1 = nil
	local delta = os.clock()
	local url = 'http://api.vokino.tv/v2/list?name=' .. title
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false,0 end
	m_simpleTV.Http.SetTimeout(session, 2000)
	url = url .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false,0
	end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
--	debug_in_file(url .. ': ' .. rc .. '\n' .. answer .. '\n','c://1/pirr.txt')
	local tab = json.decode(answer)
		if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id
	then
	return false,0 end
	m_simpleTV.Http.Close(session)
	local i = 1
	while true do
		if not tab.channels or not tab.channels[i] then break end
		if tab.channels[i] and tab.channels[i].details and tab.channels[i].details.id and tab.channels[i].details.name and tab.channels[i].details.released and (tab.channels[i].details.is_tv == false and tonumber(tv)== 0 or tab.channels[i].details.is_tv == true and tonumber(tv)== 1) and math.abs (tonumber(year) - tonumber(tab.channels[i].details.released))<=1 and title == tab.channels[i].details.name then
			local id = tab.channels[i].details.id
			local imdb_r = tab.channels[i].details.rating_imdb or 0
			local kp_r = tab.channels[i].details.rating_kp or 0
			if not m_simpleTV.User.TVPortal.stena.ret_KP then
				m_simpleTV.User.TVPortal.stena.ret_KP = kp_r
			end
			if not m_simpleTV.User.TVPortal.stena.ret_imdb then
				m_simpleTV.User.TVPortal.stena.ret_imdb = imdb_r
			end
			local check,timing = check_pirr(id)
			if check == true then
				m_simpleTV.User.TVPortal.stena.balanser1 = id
				return true,timing
			end
			return false,timing
		end
		i=i+1
	end
	return false,timing
end

local function Get_pirring(tmdb, tv, year)
	m_simpleTV.User.TVPortal.stena.balanser1 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false,0 end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cDovL2FwaS52b2tpbm8udHYvdjIvbGlzdD9uYW1lPSUyQg==') .. tmdb .. '&token=' .. decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false,0
	end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
--	debug_in_file(url .. ': ' .. rc .. '\n' .. answer .. '\n','c://1/pirr.txt')
	local tab = json.decode(answer)
		if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id
	then
	return false,0 end
	m_simpleTV.Http.Close(session)
	local i = 1
	while true do
		if tab.channels[i] and tab.channels[i].details and tab.channels[i].details.id and tab.channels[i].details.released and (tab.channels[i].details.is_tv == false and tonumber(tv)== 0 or tab.channels[i].details.is_tv == true and tonumber(tv)== 1) and tonumber(year) == tonumber(tab.channels[i].details.released) then
			local id = tab.channels[i].details.id
			local imdb_r = tab.channels[i].details.rating_imdb or 0
			local kp_r = tab.channels[i].details.rating_kp or 0
			m_simpleTV.User.TVPortal.stena.ret_KP = kp_r
			m_simpleTV.User.TVPortal.stena.ret_imdb = imdb_r
			local check,timing = check_pirr(id)
			if check == true then
				m_simpleTV.User.TVPortal.stena.balanser1 = id
				return true,timing
			end
			return false,timing
		end
		i=i+1
	end
	return false,timing
end

local function Get_Ashdi(kp_id)
	m_simpleTV.User.TVPortal.stena.balanser8 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cHM6Ly9id2EtY2xvdWQuYXBuLm1vbnN0ZXIvbGl0ZS9hc2hkaT9raW5vcG9pc2tfaWQ9') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('data%-json') then
		m_simpleTV.User.TVPortal.stena.balanser8 = url
		return true
	end
	return false
end

local function Get_Kodik(kp_id)
	m_simpleTV.User.TVPortal.stena.balanser7 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cDovL2tvZGlrYXBpLmNvbS9nZXQtcGxheWVyP3Rva2VuPTQ0N2QxNzllODc1ZWZlNDQyMTdmMjBkMWVlMjE0NmJlJmtpbm9wb2lza0lEPQ') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('"link":"([^"]+)') then
		m_simpleTV.User.TVPortal.stena.balanser7 = answer:match('"link":"([^"]+)'):gsub('^//','https://')
		return true
	end
	return false
end

local function Get_Collaps(kp_id)
	m_simpleTV.User.TVPortal.stena.balanser6 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = 'https://api' .. os.time() .. decode64('LnN5bmNocm9uY29kZS5jb20vZW1iZWQva3Av') .. kp_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: api.synchroncode.com'})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('embedHost') then
		m_simpleTV.User.TVPortal.stena.balanser6 = url
		return true
	end
	return false
end

local function Get_HDVB(kp_id)
	m_simpleTV.User.TVPortal.stena.balanser5 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = decode64('aHR0cHM6Ly9hcGl2Yi5pbmZvL2FwaS92aWRlb3MuanNvbj90b2tlbj01ZTJmZTRjNzBiYWZkOWE3NDE0YzRmMTcwZWUxYjE5MiZpZF9rcD0=') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = unescape1(answer)

	local t = {}
		for tr, url in answer:gmatch('"translator":"(.-)".-"iframe_url":"(.-)"') do
				t[#t + 1] = {}
				t[#t].Id = #t
				t[#t].Address = url:gsub('\\','')
				t[#t].Name = tr
--	debug_in_file(tr .. ' ' .. url:gsub('\\','') .. '\n','c://1/content.txt')
		end
	if #t ~= 0 then
	m_simpleTV.User.TVPortal.stena.balanser5 = t
--	debug_in_file( 'kp_id=' .. t[1].kp_id .. '\n', 'c://1/content.txt', setnew )
	return true
	end
	return false
end

local function Get_VB(imdb_id,kp_id)
	if not imdb_id and not kp_id then return false end
	if kp_id and kp_id ~= '' then kp_id = ',' .. kp_id end
	m_simpleTV.User.TVPortal.stena.balanser4 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	--fix
	if imdb_id == 'tt15307130' then imdb_id = 1101239 end
	--
	local urlv = 'https://voidboost.net/embed/' .. imdb_id .. kp_id
	local rcv,answerv = m_simpleTV.Http.Request(session,{url=urlv})
	if rcv~=200 then
	return false
	end
	m_simpleTV.User.TVPortal.stena.balanser4 = urlv
	return true
end

local function Get_ZF(id)
	m_simpleTV.User.TVPortal.stena.balanser3 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = decode64('aHR0cHM6Ly9nby56ZWZsaXgub25saW5lL2lwbGF5ZXIvdmlkZW9kYi5waHA/a3A9') .. id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36\nReferer: ' .. 'https://go.zeflix.online/iplayer/player.php\nCookie: ' .. m_simpleTV.User.ZF.cookies})
--	debug_in_file(url .. '\n' .. 'User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36\nReferer: ' .. 'https://go.zeflix.online/iplayer/player.php\nCookie: ' .. m_simpleTV.User.ZF.cookies .. '\n' .. answer,'c://1/deb_zf.txt')
	if rc==200 and answer:match('^<script>') then m_simpleTV.User.TVPortal.stena.balanser3 = '' return 'need_phpsesid' end
	if rc~=200 or answer:match('video_not_found') or (not answer:match('%.mp4') and not answer:match('%.m3u8')) then
		m_simpleTV.Http.Close(session)
		return false
	end
	m_simpleTV.User.TVPortal.stena.balanser3 = url
	return true
end

local function Get_ZF_new(id)
	m_simpleTV.User.TVPortal.stena.balanser3 = nil
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = decode64('aHR0cHM6Ly9id2EtY2xvdWQuYXBuLm1vbnN0ZXIvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	m_simpleTV.Http.Close(session)
--	debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
	if rc==200 and answer:match('data%-json') then
		m_simpleTV.User.TVPortal.stena.balanser3 = url
		return true
	end
	return false
end

local function Get_VCDN(imdbid)
	m_simpleTV.User.TVPortal.stena.balanser2 = nil
	m_simpleTV.User.TVPortal.stena.kp = nil
	if not imdbid then return false end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdbid
	--fix
	if imdbid == 'tt15307130' then
		url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmtpbm9wb2lza19pZD0=') .. 1101239
	end
	--
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
	if rc5~=200 or rc5==200 and not answer_vn:match('data') then
	url_vn = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmaW1kYj0=') .. imdbid
	rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
	if answer_vn and answer_vn:match('"id_kp":(%d+)') and tonumber(answer_vn:match('"id_kp":(%d+)')) > 0 then
	m_simpleTV.User.TVPortal.stena.kp = answer_vn:match('"id_kp":(%d+)')
	return true end
	return false
	end
--		debug_in_file('CDN: ' .. rc5 .. ' / ' .. url_vn .. '\n' .. answer_vn .. '\n','c://1/timing.txt')
	require('json')
	answer_vn = answer_vn:gsub('(%[%])', '"nil"')
	local tab_vn = json.decode(answer_vn)
	if tab_vn and tab_vn.data and tab_vn.data[1] then
		if tab_vn.data[1].kp_id then
			m_simpleTV.User.TVPortal.stena.kp = tab_vn.data[1].kp_id
		end
		if tab_vn.data[1].iframe_src then
			m_simpleTV.User.TVPortal.stena.balanser2 = 'https:' .. tab_vn.data[1].iframe_src
--			m_simpleTV.User.TVPortal.stena.balanser2 = 'https://32.svetacdn.in/fnXOUDB9nNSO?imdb_id=' .. imdbid
--			m_simpleTV.User.TVPortal.stena.balanser2 = decode64('aHR0cHM6Ly84MjA5LnN2ZXRhY2RuLmluL1BYazJRR2J2RVZtUz9rcF9pZD0') .. m_simpleTV.User.TVPortal.stena.kp
			return true
		end
	end
	return false
end
---------------------------------------
local function get_magnet(session,url)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	return answer:match('"(magnet:.-)"')
end

local function findrutor(name, year_name)

	local session2 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36', proxy, true)
	if not session2 then
		return false
	end
	m_simpleTV.Http.SetTimeout(session2, 12000)
	local url_ru = 'http://rutor.info/search/0/0/000/0/' .. escape(name)
	local rc_ru, answer_ru = m_simpleTV.Http.Request(session2, {url = url_ru})
	if rc_ru~=200 then
		return false
	end
--	debug_in_file('Rutor answer: ' .. url_ru .. '\n' .. answer_ru .. '\n-----------------\n','c://1/ruru.txt')
	local t, i, str_ru = {}, 1, ''
	answer_ru = answer_ru:match('<table width=".-</table>')
	if answer_ru then
		for w in answer_ru:gmatch('<tr class="gai">.-</tr>') do
			local data, adr, item, size, sids, pirs = w:match('<td>(.-)</td>.-<a href="(magnet.-)".-<a href="/torrent/.->(.-)<.-\n<td align="right">(.-)</td>.-alt="S" />(.-)<.-class="red">(.-)<')
			local year = item:match('%((%d%d%d%d)')
			t[i] = {}
--			t[i].Id = i
			t[i].Name = item
			t[i].InfoPanelLogo = m_simpleTV.User.TVPortal.stena.logo
			t[i].Address = adr
			t[i].InfoPanelName = item
			t[i].InfoPanelTitle = 'Rutor' .. ' • ' .. size:gsub('%&nbsp%;',' ') .. ' / sid/pir: ✅ ' .. sids:gsub('%&nbsp%;',' ') .. '  🔻 ' .. pirs:gsub('%&nbsp%;',' ') .. ' • ' .. data:gsub('%&nbsp%;',' ')
			t[i].InfoPanelShowTime = 30000
--			debug_in_file(t[i].InfoPanelName .. '\nyear: ' .. year .. '\n' .. t[i].InfoPanelTitle .. '\n' .. adr .. '\n-----------------\n','c://1/rutor.txt')
			i=i+1
		end
		if #t>0 then
			m_simpleTV.User.TVPortal.stena.balanser0 = {}
			m_simpleTV.User.TVPortal.stena.balanser0.rutor = t
			return true
		end
	end
	return false
end

local function findrutracker(name, year_name)

	local ret, login, pass = pm.GetTestPassword('rutracker', 'rutracker', true)
	if not login or not pass or login == '' or password == '' then
--		showError('2\в дополнении "Password Manager"\nвведите логин и пароль для rutracker')
		return false
	end

	local session1 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36', proxy, true)
		if not session1 then return false end
	m_simpleTV.Http.SetTimeout(session1, 12000)
	m_simpleTV.Http.SetRedirectAllow(session1, false)
	local url = 'https://rutracker.org/forum/login.php'
	login = m_simpleTV.Common.toPercentEncoding(login)
	pass = m_simpleTV.Common.toPercentEncoding(pass)

	local rc, answer = m_simpleTV.Http.Request(session1, {method = 'post', url = url, headers = '\nReferer: ' .. 'https://rutracker.org' .. '\nContent-Type: application/x-www-form-urlencoded', body = 'login_username=' .. login .. '&login_password=' .. pass .. '&login=%E2%F5%EE%E4'})
	if rc ~= 302 then
		m_simpleTV.Http.Close(session1)
--		showError('3\nперелогинтесь в браузере\nили пароль/логин неверны')
		return false
	end
	m_simpleTV.Http.SetRedirectAllow(session1, true)
	local url_rt = 'https://rutracker.org/forum/tracker.php?nm=' .. escape(name)
	local rc_rt, answer_rt = m_simpleTV.Http.Request(session1, {url = url_rt})
	if rc_rt~=200 then
		return false
	end
--	debug_in_file('Rutracker answer: ' .. url_rt .. '\n' .. m_simpleTV.Common.multiByteToUTF8(answer_rt) .. '\n-----------------\n','c://1/ruru.txt')
	local t, i, str_rt = {}, 1, ''
	answer_rt = m_simpleTV.Common.multiByteToUTF8(answer_rt)
	for w in answer_rt:gmatch('<tr id=".-</tr>') do
		if w:match('Video') or w:match('Видео') then
			local item, adr, size, sids, pirs, data = w:match('class="med tLink.-hl%-tags bold" href=".-">(.-)<.-<a class="small.-href="(.-)">(.-)<.-class="seedmed">(%d+).-title="Личи">(%d+).-<p>(.-)<')
			if item and adr and size and sids and pirs and data then
				local title = item:gsub(' /.-$',''):gsub('ё','е')
				local year = item:match('%[(%d%d%d%d)')
					adr = 'https://rutracker.org/forum/' .. adr
				if tonumber(year) == tonumber(year_name) then
					t[i] = {}
					t[i].Id = i
					t[i].Name = item
					t[i].InfoPanelLogo = m_simpleTV.User.TVPortal.stena.logo
					t[i].Address = get_magnet(session1,adr:gsub('forum/dl','forum/viewtopic'))
					t[i].InfoPanelName = item
					t[i].InfoPanelTitle = 'Rutracker' .. ' • ' .. size:gsub(' .-$',''):gsub('%&nbsp%;',' ') .. ' / sid/pir: ✅ ' .. sids .. '  🔻 ' .. pirs .. ' • ' .. data
					t[i].InfoPanelShowTime = 30000
--					debug_in_file(t[i].InfoPanelName .. '\nyear: ' .. year .. '\n' .. t[i].InfoPanelTitle .. '\n' .. adr .. '\n-----------------\n','c://1/rutracker.txt')
					i=i+1
				end
			end
		end
	end
	if #t>0 then
		if m_simpleTV.User.TVPortal.stena.balanser0 == nil then
			m_simpleTV.User.TVPortal.stena.balanser0 = {}
		end
		m_simpleTV.User.TVPortal.stena.balanser0.rutracker = t
		return true
	end
	return false
end

local function find_movie(title,title_year)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
m_simpleTV.Http.SetTimeout(session, 60000)
local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&primary_release_year=' .. title_year
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
local total_pages,total_results = answerd:match('"total_pages":(%d+),"total_results":(%d+)')
local answer = ''
if tonumber(total_pages) == 0 then total_pages = 1 end
for j = 1,total_pages do
local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&primary_release_year=' .. title_year .. '&page=' .. j
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
answer = answer .. answerd
j=j+1
end
require('json')
answer = answer:gsub('(%[%])', '"nil"'):gsub('%],"total_pages":%d+,"total_results":%d+%}%{"page":%d+,"results":%[', ',')
local tab = json.decode(answer)
local t, i, desc = {}, 1, ''
while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local id_media = tab.results[i].id or ''
    local rus = tab.results[i].title or ''
	local year = tab.results[i].release_date or ''
	local overview = tab.results[i].overview or ''
	local poster
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/Zaglushka_TMDB goriz v1.png'
	end

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - movie'
	t[i].Address = id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview

	i = i + 1
	end
	return t, i - 1
end

local function find_series(title,title_year)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
m_simpleTV.Http.SetTimeout(session, 60000)
local urld2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. title_year
local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
if rc2~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
local total_pages,total_results = answerd2:match('"total_pages":(%d+),"total_results":(%d+)')
local answer3 = ''
if tonumber(total_pages) == 0 then total_pages = 1 end
for j = 1,total_pages do
local urld3 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. title_year .. '&page=' .. j
local rc3,answerd3 = m_simpleTV.Http.Request(session,{url=urld3})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
answer3 = answer3 .. answerd3
j=j+1
end
require('json')
answer3 = answer3:gsub('(%[%])', '"nil"'):gsub('%],"total_pages":%d+,"total_results":%d+%}%{"page":%d+,"results":%[', ',')

local tab = json.decode(answer3)

local t, i, desc = {}, 1, ''
while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local id_media = tab.results[i].id or ''
    local ru_name = tab.results[i].name or ''
	local year = tab.results[i].first_air_date or ''
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local overview = tab.results[i].overview or ''
	local poster
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/Zaglushka_TMDB goriz v1.png'
	end

	t[i].Id = i
	t[i].Name = ru_name .. ' (' .. year .. ') - tv'
	t[i].Address = id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. ru_name .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview

	i = i + 1
	end
	return t, i - 1
end

local function findpersonIdByName(person)
	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvcGVyc29uP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmcGFnZT0xJmluY2x1ZGVfYWR1bHQ9ZmFsc2UmcXVlcnk9') .. m_simpleTV.Common.toPercentEncoding(person)
	local id, name, logo
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return '',0
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '',0 end

	local t, i, desc = {}, 1, ''
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	rus = tab.results[i].name or ''

	id_person = tab.results[i].id
	department = tab.results[i].known_for_department or ''
	department = department:gsub('Acting','Актёрское искусство: '):gsub('Directing','Режиссура: '):gsub('Writing','Сценарист: '):gsub('Creating','Продюсер: ')
	if tab.results[i].profile_path and tab.results[i].profile_path ~= 'null' then
	poster = tab.results[i].profile_path
	poster = 'http://image.tmdb.org/t/p/w180_and_h180_face' .. poster
	else poster = './luaScr/user/show_mi/Zaglushka_TMDB vert v2.png'
	end

	if tab.results[i].known_for and tab.results[i].known_for ~= 'nil' and (tab.results[i].known_for[1].title or tab.results[i].known_for[1].name)then
	known_for = tab.results[i].known_for[1].title or tab.results[i].known_for[1].name
	if tab.results[i].known_for[2] and (tab.results[i].known_for[2].title or tab.results[i].known_for[2].name) then
	known_for = known_for .. ', ' .. (tab.results[i].known_for[2].title or tab.results[i].known_for[2].name)
	end
	if tab.results[i].known_for[3] and (tab.results[i].known_for[3].title or tab.results[i].known_for[3].name) then
	known_for = known_for .. ', ' .. (tab.results[i].known_for[3].title or tab.results[i].known_for[3].name)
	end
	else
	known_for = ''
	end

	t[i].Id = i
	t[i].Name = rus
	t[i].Address = id_person
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = department .. known_for
    i=i+1
	end
	return t, i - 1
end

local function find_collections(title)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvY29sbGVjdGlvbj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9MSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
	local id, name, logo
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return  '',0
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '',0 end

	local t, i, desc = {}, 1, ''
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	rus = tab.results[i].name or ''

	id_collections = tab.results[i].id
	overview = tab.results[i].overview or ''
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/Zaglushka_TMDB goriz v1.png'
	end

	t[i].Id = i
	t[i].Name = rus
	t[i].Address = id_collections
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
    i=i+1
	end
	return t, i - 1
end

local function vb_asw(imdb_id)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local urlv = 'https://voidboost.net/embed/' .. imdb_id
	local rcv,answerv = m_simpleTV.Http.Request(session,{url=urlv})
	if rcv~=200 then
	return ''
	end
	return urlv
end

local function kpid(imdbid)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdbid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})

		if rc5~=200 then
		return vb_asw(imdbid)
		end
		require('json')
		answer_vn = answer_vn:gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)

		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].kp_id then
		return tab_vn.data[1].kp_id
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id then
		return 'https://32.svetacdn.in/fnXOUDB9nNSO?imdb_id=' .. imdbid
--		elseif vb_asw(imdbid) and vb_asw(imdbid) ~= '' then
--		return vb_asw(imdbid)
		else
		return ''
		end
end

local function imdbid(tmdbtvid)
--	debug_in_file('tv tmdb_id: ' .. tmdbtvid .. '\n','c://1/tmdb_id.txt')
	--fix
	if tonumber(tmdbtvid) == 120724 then return 'tt15307130' end
	if tonumber(tmdbtvid) == 64281 then return 'tt0245602' end
	--
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url_im = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbtvid .. decode64('L2V4dGVybmFsX2lkcz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
	local rc6,answer_im = m_simpleTV.Http.Request(session,{url=url_im})

		if rc6~=200 then
		return ''
		end
		require('json')
		answer_im = answer_im:gsub('(%[%])', '"nil"')
		local tab_im = json.decode(answer_im)

		if tab_im and tab_im.imdb_id then
		return tab_im.imdb_id
		else
		return ''
		end
end

local function country_name(name)
	local url, title
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	url = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy93YXRjaC9wcm92aWRlcnMvcmVnaW9ucz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
	return name
	end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local i = 1
	while true do
		if not tab.results[i] then
			break
		end
		local title = tab.results[i].iso_3166_1
		if title == name then
			return tab.results[i].native_name or tab.results[i].english_name or name
		end
		i=i+1
	end
	return name:gsub('SU','СССР')
end

local function network_name(network)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'https://api.themoviedb.org/3/network/' .. network .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQ=')
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	local name, country = answer:match('"name":"(.-)".-"origin_country":"(.-)"')
	return (name or '') .. ' ' .. (country or '')
end

local function genres_name(tv,id)
	if not m_simpleTV.User.TVPortal.stena then m_simpleTV.User.TVPortal.stena = {} end
	if not m_simpleTV.User.TVPortal.stena.movie_genres or not #m_simpleTV.User.TVPortal.stena.movie_genres or
	not m_simpleTV.User.TVPortal.stena.tv_genres or not #m_simpleTV.User.TVPortal.stena.tv_genres then
		genres_arr()
	end
	if tonumber(tv) == 0 then
	for i = 1,#m_simpleTV.User.TVPortal.stena.movie_genres do
		if m_simpleTV.User.TVPortal.stena.movie_genres[i].id == id then
			return m_simpleTV.User.TVPortal.stena.movie_genres[i].name
		end
	end
	elseif tonumber(tv) == 1 then
	for i = 1,#m_simpleTV.User.TVPortal.stena.tv_genres do
		if m_simpleTV.User.TVPortal.stena.tv_genres[i].id == id then
			return m_simpleTV.User.TVPortal.stena.tv_genres[i].name
		end
	end
	end
	local url_g1, tmdb_media
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	if tonumber(tv) == 0 then
	url_g1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9nZW5yZS9tb3ZpZS9saXN0P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
	tmdb_media = 'tmdb_movie_page=1'
	elseif tonumber(tv) == 1 then
	url_g1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9nZW5yZS90di9saXN0P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
	tmdb_media = 'tmdb_tv_page=1'
	end
	local rc7,answer_g1 = m_simpleTV.Http.Request(session,{url=url_g1})
		if rc7~=200 then
		return ''
		end
		require('json')
		answer_g1 = answer_g1:gsub('(%[%])', '"nil"')
		local tab_g1 = json.decode(answer_g1)
		local t, i, name = {}, 1, ''
		while true do
		if not tab_g1.genres[i]
				then
				break
				end
		t[i]={}
		t[i].id = tab_g1.genres[i].id
		t[i].name = tab_g1.genres[i].name
		if tonumber(tmdb_genres_id) == tonumber(tab_g1.genres[i].id) then
		name = t[i].name
		end
--		debug_in_file(t[i].name .. '\n','c://1/name_for_ln')
		i=i+1
		end
	return name
end

local function tmdb_id(imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc5~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local tmdb_id, tv
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then tmdb_id, tv = '', '' else
	if tab.movie_results[1] then
	tmdb_id, tv = tab.movie_results[1].id, 0
	elseif tab.tv_results[1] then
	tmdb_id, tv = tab.tv_results[1].id, 1
	end
	end
	return tmdb_id, tv
end

local function Get_person(tmdbid, tv)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltm
	if tonumber(tv) == 0 then
		urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPWNyZWRpdHMmbGFuZ3VhZ2U9cnU=')
	elseif tonumber(tv) == 1 then
		urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPWNyZWRpdHMmbGFuZ3VhZ2U9cnU=')
	end

	local rc4,answertm = m_simpleTV.Http.Request(session,{url=urltm})
	if rc4~=200 then
	  m_simpleTV.Http.Close(session)
	  return
	end
	require('json')
	answertm = answertm:gsub('(%[%])', '"nil"')
	local tab = json.decode(answertm)

	local t1,j={},0
	if tab and tab.credits and tab.credits.crew and tab.credits.crew[1] and tab.credits.crew[1].id then
	local j1 = 1
		while true do
			if not tab.credits.crew[j1]	then
				break
			end
			if tab.credits.crew[j1].job and tab.credits.crew[j1].job == 'Director' then
				local rus1 = tab.credits.crew[j1].name or ''
				local cha1 = tab.credits.crew[j1].job or ''
				local id_person1 = tab.credits.crew[j1].id
				local poster1
				if tab.credits.crew[j1].profile_path and tab.credits.crew[j1].profile_path ~= 'null' and j <= 1 then
					j=j+1
					poster1 = tab.credits.crew[j1].profile_path
					poster1 = 'http://image.tmdb.org/t/p/w100_and_h100_face' .. poster1
					t1[j] = {}
					t1[j].Name = rus1
					t1[j].Id = j
					t1[j].InfoPanelLogo = poster1
					t1[j].InfoPanelName = rus1 .. ' - ' .. cha1
					t1[j].InfoPanelShowTime = 10000
					t1[j].Address = id_person1
				end
			end
			j1=j1+1
		end
	end

	if tab and tab.credits and tab.credits.cast and tab.credits.cast[1] and tab.credits.cast[1].id then
		local j2 = 1
		while true do
			if not tab.credits.cast[j2]	then
				break
			end
			local rus = tab.credits.cast[j2].name or ''
			local cha = tab.credits.cast[j2].character or ''
			local id_person = tab.credits.cast[j2].id
			local poster
			if tab.credits.cast[j2].profile_path and tab.credits.cast[j2].profile_path ~= 'null' and j <= 9 then
				j=j+1
				poster = tab.credits.cast[j2].profile_path
				poster = 'http://image.tmdb.org/t/p/w100_and_h100_face' .. poster
				t1[j] = {}
				t1[j].Name = rus
				t1[j].Id = j
				t1[j].InfoPanelLogo = poster
				t1[j].InfoPanelName = rus .. ' - ' .. cha
				t1[j].InfoPanelShowTime = 10000
				t1[j].Address = id_person
			end
			j2=j2+1
		end
	end
	m_simpleTV.User.TVPortal.stena.persons = nil
	m_simpleTV.User.TVPortal.stena.persons = {}

--	debug_in_file('\n----- ' .. tmdbid ..', ' .. tv .. ' -----\n','c://1/person.txt')
	for j = 1,#t1 do
		m_simpleTV.User.TVPortal.stena.persons[j] = {}
		m_simpleTV.User.TVPortal.stena.persons[j].logo = t1[j].InfoPanelLogo
		m_simpleTV.User.TVPortal.stena.persons[j].name = t1[j].Name
		m_simpleTV.User.TVPortal.stena.persons[j].action = t1[j].Address
--		debug_in_file(t1[j].Id .. '. ' .. t1[j].Name .. ' ' .. m_simpleTV.User.TVPortal.persons[j] .. '\n','c://1/person.txt')
	end
	return
end

function search_persons(page)

	if m_simpleTV.User.TVPortal.stena_search == nil then
		m_simpleTV.User.TVPortal.stena_search = {}
	end

	if m_simpleTV.User.TVPortal.stena == nil then
		m_simpleTV.User.TVPortal.stena = {}
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvcGVyc29uP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmaW5jbHVkZV9hZHVsdD1mYWxzZSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(tmdb_search) .. '&page=' .. page

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc~=200 then
		return false
	end
	local total_pages,total_results = answer:match('"total_pages":(%d+).-"total_results":(%d+)')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')

	local tab = json.decode(answer)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name then
		return false
	end

	local t, i = {}, 1
	while true do
	if not tab.results[i] then
		break
	end
	t[i]={}
	local rus = tab.results[i].name or ''
	local id_person = tab.results[i].id
	local poster
	if tab.results[i].profile_path and tab.results[i].profile_path ~= 'null' then
	poster = tab.results[i].profile_path
	poster = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end

	t[i].Id = i
	t[i].Name = rus
	t[i].Address = id_person
	t[i].InfoPanelLogo = poster
    i=i+1
	end
	m_simpleTV.User.TVPortal.stena_search = t
	m_simpleTV.User.TVPortal.stena.type = 'search_persons'

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Персоны (стр. ' .. page .. ' из ' .. total_pages .. ')'
		m_simpleTV.User.TVPortal.stena_search_title = tmdb_search .. ' ● ' .. title
		if next_pg <= tonumber(total_pages) then
		m_simpleTV.User.TVPortal.stena_next = tonumber(page)+1
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = tonumber(page)-1
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
	return stena_search_content()
end

function search_collections(page)

	if m_simpleTV.User.TVPortal.stena_search == nil then
		m_simpleTV.User.TVPortal.stena_search = {}
	end

	if m_simpleTV.User.TVPortal.stena == nil then
		m_simpleTV.User.TVPortal.stena = {}
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvY29sbGVjdGlvbj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9MSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(tmdb_search) .. '&page=' .. page

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc~=200 then
		return false
	end
	local total_pages,total_results = answer:match('"total_pages":(%d+).-"total_results":(%d+)')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')

	local tab = json.decode(answer)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name then
		return false
	end

	local t, i, desc = {}, 1, ''
	while true do
	if not tab.results[i] then
		break
	end
	t[i]={}
	local rus = tab.results[i].name or ''
	local id_collections = tab.results[i].id
	local overview = tab.results[i].overview or ''
	local poster
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end

	t[i].Id = i
	t[i].Name = rus
	t[i].Address = id_collections
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = rus
	t[i].InfoPanelShowTime = 10000
	t[i].InfoPanelTitle = overview
    i=i+1
	end
	m_simpleTV.User.TVPortal.stena_search = t
	m_simpleTV.User.TVPortal.stena.type = 'search_collections'

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Коллекции (стр. ' .. page .. ' из ' .. total_pages .. ')'
		m_simpleTV.User.TVPortal.stena_search_title = tmdb_search .. ' ● ' .. title
		if next_pg <= tonumber(total_pages) then
		m_simpleTV.User.TVPortal.stena_next = tonumber(page)+1
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = tonumber(page)-1
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
	return stena_search_content()
end

function search_tv(page)
	if m_simpleTV.User.TVPortal.stena_search == nil then
		m_simpleTV.User.TVPortal.stena_search = {}
	end

	if m_simpleTV.User.TVPortal.stena == nil then
		m_simpleTV.User.TVPortal.stena = {}
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)
	local title_year = tmdb_search:match(' %((%d%d%d%d)%)$') or tmdb_search:match(' (%d%d%d%d)$') or ''
	local title = tmdb_search:gsub(' %(%d%d%d%d%)$',''):gsub(' %(%)$',''):gsub(' %d%d%d%d$','')
--	m_simpleTV.User.TVPortal.stena_search_title = tmdb_search

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. title_year .. '&page=' .. page
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
--	debug_in_file(answer .. '\n','c://1/search_tv.txt')
	local total_pages,total_results = answer:match('"total_pages":(%d+).-"total_results":(%d+)')
--	m_simpleTV.User.TVPortal.tv_search = total_results
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name then
		return false
	end

	local t, i = {}, 1
	while true do
		if not tab.results[i] then
			break
		end
		t[i]={}
		local id_media = tab.results[i].id or ''
		local rus = tab.results[i].name or ''
		local orig = tab.results[i].original_name or ''
		local year = tab.results[i].first_air_date or ''
		local reting = tab.results[i].vote_average or 0
		if year and year ~= '' then
		year = year:match('%d%d%d%d')
		else year = 0 end
		local overview = tab.results[i].overview or ''
		local poster,background
		if tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
		poster = tab.results[i].poster_path
		poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
		else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
		end
		if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
		background = tab.results[i].backdrop_path
		background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
		else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
		end

		t[i].Id = i
		t[i].Name = rus .. ' (' .. year .. ')'
		t[i].InfoPanelLogo = background
		t[i].Logo = poster
		t[i].Address = id_media
		t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
		t[i].InfoPanelTitle = overview
		t[i].InfoPanelShowTime = 10000
		t[i].Reting = reting
		t[i].Type = 1
		t[i].Rus = rus
		t[i].Orig = orig
		t[i].Year = year
		t[i].Genre = tab.results[i].genre_ids or ''
--		debug_in_file(t[i].Name .. ' - ' .. t[i].Address .. '/' .. t[i].InfoPanelLogo .. '\n','c://1/search_tv.txt')
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_search = t
	m_simpleTV.User.TVPortal.stena.type = 'search_tv'

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Сериалы (стр. ' .. page .. ' из ' .. total_pages .. ')'
		m_simpleTV.User.TVPortal.stena_search_title = tmdb_search .. ' ● ' .. title
		if next_pg <= tonumber(total_pages) then
		m_simpleTV.User.TVPortal.stena_next = tonumber(page)+1
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = tonumber(page)-1
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
	return stena_search_content()
end

function search_movie(page)
	if m_simpleTV.User.TVPortal.stena_search == nil then
		m_simpleTV.User.TVPortal.stena_search = {}
	end

	if m_simpleTV.User.TVPortal.stena == nil then
		m_simpleTV.User.TVPortal.stena = {}
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)
	local title_year = tmdb_search:match(' %((%d%d%d%d)%)$') or tmdb_search:match(' (%d%d%d%d)$') or ''
	local title = tmdb_search:gsub(' %(%d%d%d%d%)$',''):gsub(' %(%)$',''):gsub(' %d%d%d%d$','')
--	m_simpleTV.User.TVPortal.stena_search_title = tmdb_search

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&primary_release_year=' .. title_year .. '&page=' .. page
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
--	debug_in_file(answer .. '\n','c://1/search_movie.txt')
	local total_pages,total_results = answer:match('"total_pages":(%d+).-"total_results":(%d+)')
	m_simpleTV.User.TVPortal.movie_search = total_results
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].title then
		return false
	end

	local t, i = {}, 1
	while true do
		if not tab.results[i] then
			break
		end
		t[i]={}
		local rus = tab.results[i].title or ''
		local orig = tab.results[i].original_title or ''
		local year = tab.results[i].release_date or ''
		local reting = tab.results[i].vote_average or 0
		local poster,background
		if tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
		poster = tab.results[i].poster_path
		poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
		else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
		end
		if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
		background = tab.results[i].backdrop_path
		background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
		else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
		end
		local id_movie = tab.results[i].id
		local overview = tab.results[i].overview or ''
		if year and year ~= '' then
			year = year:match('%d%d%d%d')
		else
			year = 0
		end
		t[i].Id = i
		t[i].Name = rus .. ' (' .. year .. ')'
		t[i].InfoPanelLogo = background
		t[i].Logo = poster
		t[i].Address = id_movie
		t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
		t[i].InfoPanelTitle = overview
		t[i].InfoPanelShowTime = 10000
		t[i].Reting = reting
		t[i].Type = 0
		t[i].Rus = rus
		t[i].Orig = orig
		t[i].Year = year
		t[i].Genre = tab.results[i].genre_ids or ''
--		debug_in_file(t[i].Name .. ' - ' .. t[i].Address .. '/' .. t[i].InfoPanelLogo .. '\n','c://1/search_movie.txt')
		i=i+1
	end
	m_simpleTV.User.TVPortal.stena_search = t
	m_simpleTV.User.TVPortal.stena.type = 'search_movie'

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Фильмы (стр. ' .. page .. ' из ' .. total_pages .. ')'
		m_simpleTV.User.TVPortal.stena_search_title = tmdb_search .. ' ● ' .. title
		if next_pg <= tonumber(total_pages) then
		m_simpleTV.User.TVPortal.stena_next = tonumber(page)+1
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = tonumber(page)-1
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
	return stena_search_content()
end

function run_lite_qt_tmdb()

	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/imdb') or ''
	local tt = {
		{"","Фильмы"},
		{"","Сериалы"},
		{"","Мультфильмы"},
		{"","Персоны"},
		{"","Коллекции"},
		{"","ПОИСК"},
		}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
	if last_adr and last_adr ~= '' then
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
	end
	if stena then return stena_home() end
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию TMDb',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'Персоны' then
				tmdb_person_page(1)
			elseif t0[id].Name == 'Коллекции' then
				collection(1)
			elseif t0[id].Name == 'Фильмы' then
				tmdb_movie_page(1, t0[id].Action)
			elseif t0[id].Name == 'Сериалы' then
				tmdb_tv_page(1, t0[id].Action)
			elseif t0[id].Name == 'Мультфильмы' then
				tmdb_movie_page(1, 16)
			end
		end
		if ret == 2 then
		local tmdbid,tv = tmdb_id(last_adr)
		media_info_tmdb(tmdbid,tv)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function tmdb_movie_page(page, tmdb_genres_id, tmdb_country)
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltp = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9kaXNjb3Zlci9tb3ZpZT9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmluY2x1ZGVfYWR1bHQ9ZmFsc2UmaW5jbHVkZV92aWRlbz1mYWxzZSZsYW5ndWFnZT1ydS1SVSZwYWdlPQ==') .. page .. '&sort_by=popularity.desc&with_release_type=2|3&with_genres=' .. tmdb_genres_id .. '&with_origin_country=' .. tmdb_country
	local rc, answertp = m_simpleTV.Http.Request(session, {url = urltp})
	if rc~=200 then
	return ''
	end
	require('json')
	answertp = answertp:gsub('(%[%])', '"nil"')

	local tab = json.decode(answertp)
	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].title
	then
	return '' end

	local t, i = {}, 1
	local all_page = tab.total_pages or 500
	if tonumber(all_page) > 500 then all_page = 500 end
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local rus = tab.results[i].title or ''
	local orig = tab.results[i].original_title or ''
	local year = tab.results[i].release_date or ''
	local reting = tab.results[i].vote_average or 0
	local poster,background
	if tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
	end
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	background = tab.results[i].backdrop_path
	background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
	else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end
	local id_movie = tab.results[i].id
	local overview = tab.results[i].overview or ''
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].InfoPanelLogo = background
	t[i].Logo = poster
	t[i].Address = id_movie
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	t[i].Reting = reting
	t[i].Type = 0
	t[i].Rus = rus
	t[i].Orig = orig
	t[i].Year = year
	t[i].Genre = tab.results[i].genre_ids or ''
    i=i+1
	end
	m_simpleTV.User.TVPortal.stena = t
	m_simpleTV.User.TVPortal.stena.type = 'movie'

		local gnr_name = genres_name(0,tmdb_genres_id)
		if gnr_name ~= '' then gnr_name = ' ' .. gnr_name end
		local cou_name = country_name(tmdb_country)
		if cou_name ~= '' then cou_name = ' ' .. cou_name end
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Фильмы (стр. ' .. page .. ' из ' .. all_page .. ')'.. gnr_name .. cou_name
		if next_pg <= tonumber(all_page) then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.TVPortal.stena_next = {tonumber(page)+1, tmdb_genres_id, tmdb_country}
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.TVPortal.stena_prev = {tonumber(page)-1, tmdb_genres_id, tmdb_country}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_title = title
		m_simpleTV.User.TVPortal.stena_page = {all_page, page, tmdb_genres_id, tmdb_country}
		if stena then return stena() end
		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		media_info_tmdb(t[id].Address,0)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		tmdb_movie_page(tonumber(page)-1, tmdb_genres_id)
		else
		run_lite_qt_tmdb()
		end
		end
		if ret == 3 then
		tmdb_movie_page(tonumber(page)+1, tmdb_genres_id)
		end
		end

function tmdb_tv_page(page, tmdb_genres_id, tmdb_country, network)
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltp = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9kaXNjb3Zlci90dj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmluY2x1ZGVfYWR1bHQ9ZmFsc2UmaW5jbHVkZV9udWxsX2ZpcnN0X2Fpcl9kYXRlcz1mYWxzZSZsYW5ndWFnZT1ydS1SVSZwYWdlPQ==') .. page .. '&sort_by=popularity.desc&with_genres=' .. tmdb_genres_id .. '&with_origin_country=' .. tmdb_country .. '&with_networks=' .. network
	local rc, answertp = m_simpleTV.Http.Request(session, {url = urltp})
	if rc~=200 then
	return ''
	end
	require('json')
	answertp = answertp:gsub('(%[%])', '"nil"')

	local tab = json.decode(answertp)
		if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '' end

	local t, i, desc = {}, 1, ''
	local all_page = tab.total_pages or 500
	if tonumber(all_page) > 500 then all_page = 500 end
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local rus = tab.results[i].name or ''
	local orig = tab.results[i].original_name or ''
	local year = tab.results[i].first_air_date or ''
	local id_tv = tab.results[i].id
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local reting = tab.results[i].vote_average or 0
	local poster,background
	if tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
	end
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	background = tab.results[i].backdrop_path
	background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
	else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end
	local overview = tab.results[i].overview or ''
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].InfoPanelLogo = background
	t[i].Logo = poster
	t[i].Address = id_tv
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	t[i].Type = 1
	t[i].Reting = reting
	t[i].Rus = rus
	t[i].Orig = orig
	t[i].Year = year
	t[i].Genre = tab.results[i].genre_ids or ''
    i=i+1
	end

	m_simpleTV.User.TVPortal.stena = t
	m_simpleTV.User.TVPortal.stena.type = 'tv'
		local gnr_name = genres_name(1,tmdb_genres_id)
		if gnr_name ~= '' then gnr_name = ' ' .. gnr_name end
		local cou_name = country_name(tmdb_country)
		if cou_name ~= '' then cou_name = ' ' .. cou_name end
		local net_name = network_name(network)
		if net_name ~= '' then net_name = ' ' .. net_name end
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Сериалы (стр. ' .. page .. ' из ' .. all_page .. ')'.. gnr_name .. cou_name .. net_name
		if next_pg <= tonumber(all_page) then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.TVPortal.stena_next = {tonumber(page)+1, tmdb_genres_id, tmdb_country, network}
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.TVPortal.stena_prev = {tonumber(page)-1, tmdb_genres_id, tmdb_country, network}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_title = title
		m_simpleTV.User.TVPortal.stena_page = {all_page, page, tmdb_genres_id, tmdb_country, network}
		if stena then return stena() end
		local gnr_name = genres_name(1,tmdb_genres_id)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Сериалы (стр. ' .. page .. ' из 500) ' .. gnr_name
		if next_pg <= 500 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		end

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		media_info_tmdb(t[id].Address,1)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		tmdb_tv_page(tonumber(page)-1, tmdb_genres_id)
		else
		run_lite_qt_tmdb()
		end
		end
		if ret == 3 then
		tmdb_tv_page(tonumber(page)+1, tmdb_genres_id)
		end
		end

function tmdb_person_page(page)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltp = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24vcG9wdWxhcj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9') .. page
	local rc, answertp = m_simpleTV.Http.Request(session, {url = urltp})
	if rc~=200 then
	return ''
	end
	require('json')
	answertp = answertp:gsub('(%[%])', '"nil"')

	local tab = json.decode(answertp)
	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '' end

	local t, i, j = {}, 1, 1
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local rus = tab.results[j].name or ''
	local known_for
----------
	if tab.results[j].known_for and tab.results[j].known_for ~= 'nil' and (tab.results[j].known_for[1].title or tab.results[j].known_for[1].name)then
	known_for = tab.results[j].known_for[1].title or tab.results[j].known_for[1].name
	if tab.results[j].known_for[2] and (tab.results[j].known_for[2].title or tab.results[j].known_for[2].name) then
	known_for = known_for .. ', ' .. (tab.results[j].known_for[2].title or tab.results[j].known_for[2].name)
	end
	if tab.results[j].known_for[3] and (tab.results[j].known_for[3].title or tab.results[j].known_for[3].name) then
	known_for = known_for .. ', ' .. (tab.results[j].known_for[3].title or tab.results[j].known_for[3].name)
	end
	else
	known_for = ''
	end
----------

	local id_person = tab.results[j].id
	local poster
	if tab.results[j].profile_path and tab.results[j].profile_path ~= 'null' then
	poster = tab.results[j].profile_path
	poster = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. poster
	else
	poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
	end
	t[i].Id = i
	t[i].Address = id_person
	t[i].Name = rus
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = rus
	t[i].InfoPanelTitle = known_for
	t[i].InfoPanelShowTime = 10000
	j=j+1
    i=i+1
	end

	m_simpleTV.User.TVPortal.stena = t
	m_simpleTV.User.TVPortal.stena.type = 'persons'

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Персоны (стр. ' .. page .. ' из 500)'
		if next_pg <= 500 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.TVPortal.stena_next = {tonumber(page)+1}
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.TVPortal.stena_prev = {tonumber(page)-1}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_title = title
		m_simpleTV.User.TVPortal.stena_page = {500, page}
		if stena then return stena() end

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		personWorkById(t[id].Address)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		tmdb_person_page(tonumber(page)-1)
		else
		run_lite_qt_tmdb()
		end
		end
		if ret == 3 then
		tmdb_person_page(tonumber(page)+1)
		end
	end

function personWorkById(tmdbperid,page)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24v') .. tmdbperid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')
	local name, logo, tmdbstr, logo1

	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return ''
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)
	if tab and tab.id and tab.name
	then
	title = tab.name
	end

	local urlt1 = decode64(
	'aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24v') .. tmdbperid .. decode64('L2NvbWJpbmVkX2NyZWRpdHM/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydQ==') .. '&sort_by=vote_average.desc'

	local rc, answert1 = m_simpleTV.Http.Request(session, {url = urlt1})
	if rc~=200 then
	return ''
	end
	require('json')
	answert1 = answert1:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert1)
	if not tab
	then
	return ''
	end

	local t, i = {}, 1
	local i1, i2 = 1, 1
	while true do
	if not tab.cast[i1]
				then
				break
				end

	local id_media = tab.cast[i1].id or ''
    local rus = tab.cast[i1].title  or tab.cast[i1].name or ''
	local orig = tab.cast[i1].original_title or tab.cast[i1].original_name or ''
	local year = tab.cast[i1].release_date or tab.cast[i1].first_air_date or ''
	local type_media = tab.cast[i1].media_type or ''
	local reting = tab.cast[i1].vote_average or 0
	local tv
	if type_media == 'movie' then
		tv=0
	else
		tv=1
	end
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
---------------
	local poster,background
	if tab.cast[i1].backdrop_path or tab.cast[i1].poster_path then
	t[i]={}
	if tab.cast[i1].backdrop_path and tab.cast[i1].backdrop_path ~= 'null' then
	background = tab.cast[i1].backdrop_path
	background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
	else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end
	if tab.cast[i1].poster_path and tab.cast[i1].poster_path ~= 'null' then
	poster = tab.cast[i1].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
	end

	local overview = tab.cast[i1].overview or ''

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - ' .. type_media
	t[i].InfoPanelLogo = background
	t[i].Logo = poster
	t[i].Address = id_media
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	t[i].Reting = reting
	t[i].Type = tv
	t[i].Rus = rus
	t[i].Orig = orig
	t[i].Year = year
	t[i].Genre = tab.cast[i1].genre_ids or ''
---------------
	i=i+1
	end
	i1=i1+1
	end

	while true do
	if not tab.crew[i2]
				then
				break
				end

	local id_media = tab.crew[i2].id or ''
    local rus = tab.crew[i2].title or tab.crew[i2].name or ''
	local orig = tab.crew[i2].original_title or tab.crew[i2].original_name or ''
	local year = tab.crew[i2].release_date or tab.crew[i2].first_air_date or ''
	local type_media = tab.crew[i2].media_type or ''
	local reting = tab.crew[i2].vote_average or 0
	local tv
	if type_media == 'movie' then
		tv=0
	else
		tv=1
	end
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

	if tab.crew[i2].job and (tab.crew[i2].job == 'Director' or tab.crew[i2].job == 'Creator') then
	if tab.crew[i2].backdrop_path or tab.crew[i2].poster_path then
---------------
	t[i]={}
	local poster,background
	if tab.crew[i2].backdrop_path and tab.crew[i2].backdrop_path ~= 'null' then
	background = tab.crew[i2].backdrop_path
	background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
	else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end
	if tab.crew[i2].poster_path and tab.crew[i2].poster_path ~= 'null' then
	poster = tab.crew[i2].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
	end

	local overview = tab.crew[i2].overview or ''

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - ' .. type_media
	t[i].InfoPanelLogo = background
	t[i].Logo = poster
	t[i].Address = id_media
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	t[i].Reting = reting
	t[i].Type = tv
	t[i].Rus = rus
	t[i].Orig = orig
	t[i].Year = year
	t[i].Genre = tab.crew[i2].genre_ids or ''
	i=i+1
---------------
	end
	end
	i2=i2+1
	end

		if page then
		local all_page = math.ceil(#t/20)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Фильмография (стр. ' .. page .. ' из ' .. all_page .. ') - ' .. title
		local t1 = {}
		for i = 1,20 do
			if not t[i + (page-1)*20] then break end
			t1[i] = t[i + (page-1)*20]
		end
		m_simpleTV.User.TVPortal.stena = t1
		m_simpleTV.User.TVPortal.stena.type = 'persona'
		if next_pg <= tonumber(all_page) then
		m_simpleTV.User.TVPortal.stena_next = {tmdbperid, tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = {tmdbperid, tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_page = {tmdbperid, all_page, page}
		m_simpleTV.User.TVPortal.stena_title = title
		if stena then return stena() end
		end

		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Name:match('%- movie')
		then
		media_info_tmdb(t[id].Address,0)
		else
		media_info_tmdb(t[id].Address,1)
		end
		end
		if ret == 2 then
		run_lite_qt_tmdb()
		end
end

function collection(page)
		local rc,answer_pls
		local file = io.open(m_simpleTV.Common.GetMainPath(1) .. 'DB/collection.m3u', 'r')
		if file then
		answer_pls = file:read('*a')
		file:close()
		else
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		local url_home = decode64('aHR0cDovL20yNC5kby5hbS9DSC9raW5vL3RtZGJfY29sbGVjdGlvbnMudHh0')
		rc,answer_pls = m_simpleTV.Http.Request(session,{url=url_home})
		if rc ~= 200 then return '' end
		answer_pls = answer_pls .. '\n'
		end
		if not file then
--		debug_in_file(answer_pls,m_simpleTV.Common.GetMainPath(1) .. 'DB/collection.m3u')
		end
		local t, i = {}, 1

			for w in answer_pls:gmatch('%#EXTINF:.-\n.-\n') do
				local title = w:match(',(.-)\n')
				local adr = w:match('\n(.-)\n')
				local logo = w:match('tvg%-logo="(.-)"') or 'simpleTVImage:./luaScr/user/westSide/icons/tmdb.png'
					if not adr or not title then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = title
				t[i].Address = adr:gsub('^tmdb_collection=','')
--анатомия
				if adr == 'tmdb_collection=8412' then logo ='http://image.tmdb.org/t/p/original/vt4Ry2oQuHwQ7KOA7ZbC1vFal3W.jpg' end
--снайпер
				if adr == 'tmdb_collection=14246' then logo ='http://image.tmdb.org/t/p/original/qQksZdRMIaZwttaT0pzbyJklWQz.jpg' end
--чаки
				if adr == 'tmdb_collection=10455' then logo ='http://image.tmdb.org/t/p/original/x8rEmL5lmMKcBFcYa1FgAv25PHr.jpg' end
--дорога домой
				if adr == 'tmdb_collection=43058' then logo ='http://image.tmdb.org/t/p/original/9At1WHGh150qwlO0Z5Jhvr8Z0Ig.jpg' end
--Правосудие Стоуна
				if adr == 'tmdb_collection=59235' then logo ='http://image.tmdb.org/t/p/original/oCIgNFsaLBSLJ4qgrwMZWLFt1wx.jpg' end
--Виннету
				if adr == 'tmdb_collection=9309' then logo ='http://image.tmdb.org/t/p/original/aHiXRJsN9PYL8TSXKHMFlE0mZaU.jpg' end
--Полтергейст
				if adr == 'tmdb_collection=10453' then logo ='https://image.tmdb.org/t/p/original/i8QZZV1olny9FCPNrxAL7Kk9CJy.jpg' end

				t[i].InfoPanelLogo = logo:gsub('original','w250_and_h141_face')
				t[i].InfoPanelName = 'TMDb: ' .. title
				t[i].InfoPanelShowTime = 10000
				i = i + 1
			end

		if page then
		local all_page = math.ceil(#t/20)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Коллекции (стр. ' .. page .. ' из ' .. all_page .. ')'
		local t1 = {}
		for i = 1,20 do
			if not t[i + (page-1)*20] then break end
			t1[i] = t[i + (page-1)*20]
		end
		m_simpleTV.User.TVPortal.stena = t1
		m_simpleTV.User.TVPortal.stena.type = 'collections'
		m_simpleTV.User.TVPortal.stena_page = {all_page, page}
		if next_pg <= tonumber(all_page) then
		m_simpleTV.User.TVPortal.stena_next = {tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = {tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_title = title
		if stena then return stena() end
		end

			t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
			t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
			local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите коллекцию TMDb (' .. #t .. ')',0,t,10000,1+4+8+2)
			if ret == -1 or not id then
				return
			end
			if ret == 1 then
				collection_TMDb(t[id].Address)
			end
			if ret == 2 then
				run_lite_qt_tmdb()
			end
			end

function collection_TMDb(tmdbcolid,page)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urlt1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9jb2xsZWN0aW9uLw==') .. tmdbcolid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')
	local rc, answert1 = m_simpleTV.Http.Request(session, {url = urlt1})
	if rc~=200 then
	return ''
	end
	require('json')
	answert1 = answert1:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert1)
	if not tab or not tab.parts or not tab.parts[1] or not tab.parts[1].id or not tab.parts[1].title
	then
	return '' end

	local name_c = tab.name
	local t, i = {}, 1
	while true do
	if not tab.parts[i] or not tab.parts[i].id
				then
				break
				end
	t[i]={}
	local id_media = tab.parts[i].id
    local rus = tab.parts[i].title or ''
	local orig = tab.parts[i].original_title or ''
	local year = tab.parts[i].release_date or ''
	local type_media = tab.parts[i].media_type or ''
	local reting = tab.parts[i].vote_average or 0
	local tv
	if type_media == 'movie' then
		tv=0
	else
		tv=1
	end
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local poster,background
	if tab.parts[i].backdrop_path and tab.parts[i].backdrop_path ~= 'null' then
	background = tab.parts[i].backdrop_path
	background = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. background
	else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
	end
	if tab.parts[i].poster_path and tab.parts[i].poster_path ~= 'null' then
	poster = tab.parts[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
	end
	local overview = tab.parts[i].overview or ''
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].InfoPanelLogo = background
	t[i].Logo = poster
	t[i].Address = id_media
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	t[i].Reting = reting
	t[i].Type = 0
	t[i].Rus = rus
	t[i].Orig = orig
	t[i].Year = year
	t[i].Genre = tab.parts[i].genre_ids or ''
	i=i+1
	end
		page = page or 1
		if page then
		local all_page = math.ceil(#t/20)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title
		if all_page > 1 then
		title =  name_c .. ' - стр. ' .. page .. ' из ' .. all_page
		else
		title = name_c
		end
		local t1 = {}
		for i = 1,20 do
			if not t[i + (page-1)*20] then break end
			t1[i] = t[i + (page-1)*20]
		end
		m_simpleTV.User.TVPortal.stena = t1
		m_simpleTV.User.TVPortal.stena.type = 'collection'
		m_simpleTV.User.TVPortal.stena.playcol = tmdbcolid
		if next_pg <= tonumber(all_page) then
		m_simpleTV.User.TVPortal.stena_next = {tmdbcolid, tonumber(page)+1}
		else
		m_simpleTV.User.TVPortal.stena_next = nil
		end
		if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_prev = {tmdbcolid, tonumber(page)-1}
		else
		m_simpleTV.User.TVPortal.stena_prev = nil
		end
		m_simpleTV.User.TVPortal.stena_title = title
		if stena then return stena() end
		end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(name_c, 0, t, 30000, 1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		media_info_tmdb(t[id].Address,0)
	end
	if ret == 2 then
		run_lite_qt_tmdb()
	end
	if ret == 3 then
		retAdr = 'collection_tmdb=' .. tmdbcolid
		m_simpleTV.Control.ChangeAddress = 'No'
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.Control.CurrentAddress = retAdr
		m_simpleTV.Control.PlayAddress(retAdr)
	end
end

function media_info_tmdb(tmdbid,tv)

	if tmdb_info_for_stena then return tmdb_info_for_stena(tmdbid,tv) end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
local urltm, titul_tmdb_media, tmdb_media
if tonumber(tv) == 0 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
titul_tmdb_media = titul_tmdb_movie
tmdb_media = 'movie'
elseif tonumber(tv) == 1 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
titul_tmdb_media = titul_tmdb_tv
tmdb_media = 'tv'
end
local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answertm = answertm:gsub('(%[%])', '"nil"')
local tab, promo, genre, country, rating = json.decode(answertm), '', '', '', ''

	if tab.poster_path and tab.poster_path ~= 'null' then
	poster = tab.poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/no-img.png'
	end
	if tab.backdrop_path and tab.backdrop_path ~= 'null'
	then
	background = tab.backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/no-img.png'
	end

	overview = tab.overview
	rating = tab.vote_average
	count = tab.vote_count
	ru_name = tab.title or tab.name
	orig_name = tab.original_title or tab.original_name
	year = tab.release_date or tab.first_air_date
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

if tab and tab.production_countries then
 local j = 1
	while true do
		if not tab.production_countries[j]
		then
		break
		end
 country = country .. tab.production_countries[j].name .. ', '
 j=j+1
 end
 country = country:gsub(', $', '')
 else
 country = ''
 end

if tab and tab.tagline then
slogan = tab.tagline
else slogan = ''
end

if tab and tab.genres then
 local j = 1
	while true do
		if not tab.genres[j]
		then
		break
		end
 genre = genre .. ', ' .. tab.genres[j].name

 j=j+1
 end
 genre = genre:gsub('^%, ', '')
 else
 genre = ''
 end
 rating = tostring(rating):match('(%d%.%d)') or tostring(rating):match('(%d)') or '0'
        local imdb_id = tab.imdb_id

		if tv == 1 then imdb_id = imdbid(tmdbid) end

		videodesc= '<table width="100%"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="300"></td><td style="padding: 0px 5px 5px; color: #FFFFFF; vertical-align: middle;"><h3><font color=#00FA9A>' .. ru_name .. '</font></h3><h4><i><font color=#CCCCCC>' .. slogan .. '</font></i></h4><h4><font color=#BBBBBB>' .. orig_name .. '</font></h4><h4><font color=#E0FFFF>' .. country .. ' • ' .. year .. '</font></h4><h4><font color=#EBEBEB>' .. genre .. '</font></h4><h5><img src="simpleTVImage:./luaScr/user/show_mi/menuTM.png" height="24" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. rating .. '.png" height="24" align="top"> ' .. rating .. ' (' .. count .. ')</h5></td></tr></table><table width="100%"><tr><td style="padding: 0px 15px 5px;" color: #FFFFFF;><h4><font color=#EBEBEB>' .. overview .. '</font></h4></td></tr></table>'
		videodesc = videodesc:gsub('"', '\"')

	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = background
		t1[1].InfoPanelName = tmdb_media .. ': TMDb info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t1[1].InfoPanelTitle = overview
		t1[1].InfoPanelShowTime = 10000

		if tab and tab.belongs_to_collection and tab.belongs_to_collection.id and tab.belongs_to_collection.name then
		t1[2] = {}
		t1[2].Id = 2
		t1[2].Address = tab.belongs_to_collection.id
		t1[2].Name = 'TMDb: ' .. tab.belongs_to_collection.name
		j=3
		end

		local k = 1
		while true do
		if not tab.genres[k]
		then
		break
		end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = tab.genres[k].id
		t1[j].Name = tmdb_media .. ' - ' .. tab.genres[k].name
		k=k+1
		j=j+1
		end
--------------person
if tv == 0 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPWNyZWRpdHMmbGFuZ3VhZ2U9cnU=')
elseif tv == 1 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPWNyZWRpdHMmbGFuZ3VhZ2U9cnU=')
end

local rc4,answertm = m_simpleTV.Http.Request(session,{url=urltm})
if rc4~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answertm = answertm:gsub('(%[%])', '"nil"')
local tab = json.decode(answertm)
local desc = ''

if tab and tab.credits and tab.credits.crew and tab.credits.crew[1] and tab.credits.crew[1].id then
local j1 = 1
	while true do

		if not tab.credits.crew[j1]
		then
		break
		end
	if tab.credits.crew[j1].job and tab.credits.crew[j1].job == 'Director' then
	t1[j] = {}
	local rus1 = tab.credits.crew[j1].name or ''
	local cha1 = tab.credits.crew[j1].job or ''
	local id_person1 = tab.credits.crew[j1].id
	t1[j].Name = rus1 .. ' - ' .. cha1
	t1[j].Id = j
	local poster1
	if tab.credits.crew[j1].profile_path and tab.credits.crew[j1].profile_path ~= 'null' then
	poster1 = tab.credits.crew[j1].profile_path
	poster1 = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. poster1
	t1[j].InfoPanelLogo = poster1
	t1[j].InfoPanelName = rus1 .. ' - ' .. cha1
	t1[j].InfoPanelShowTime = 10000
	end
	t1[j].Address = id_person1
	j=j+1
	end
	j1=j1+1
	end
end

if tab and tab.credits and tab.credits.cast and tab.credits.cast[1] and tab.credits.cast[1].id then
local j2 = 1
	while true do

		if not tab.credits.cast[j2]
		then
		break
		end

	t1[j] = {}
	local rus = tab.credits.cast[j2].name or ''
	local cha = tab.credits.cast[j2].character or ''
	local id_person = tab.credits.cast[j2].id
	t1[j].Name = rus .. ' - ' .. cha
	t1[j].Id = j
	local poster
	if tab.credits.cast[j2].profile_path and tab.credits.cast[j2].profile_path ~= 'null' then
	poster = tab.credits.cast[j2].profile_path
	poster = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. poster
	t1[j].InfoPanelLogo = poster
	t1[j].InfoPanelName = rus .. ' - ' .. cha
	t1[j].InfoPanelShowTime = 10000
	end
	t1[j].Address = id_person
    j2=j2+1
	j=j+1
	end
end
--------------
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀 '}
		if imdb_id and imdb_id ~= '' and kpid(imdb_id) and kpid(imdb_id) ~= ''
		then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play'}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('TMDb: ' .. ru_name .. ' (' .. year .. ')', 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			media_info_tmdb(tmdbid,tv)
			elseif t1[id].Name:match('TMDb: ') then
			collection_TMDb(t1[id].Address)
			elseif t1[id].Name:match('movie %-') then
			tmdb_movie_page(1, t1[id].Address)
			elseif t1[id].Name:match('tv %-') then
			tmdb_tv_page(1, t1[id].Address)
			else
			personWorkById(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_tmdb()
		end
		if ret == 3 then
			retAdr = 'https://www.imdb.com/title/' .. imdb_id .. '/reference'
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
		end
end

function tmdb_info_for_stena(tmid, tv)
	local tz0 = os.clock()

			m_simpleTV.OSD.RemoveElement('GLOBUS_STENA_ID')
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement

				t = {}
				t.id = 'GLOBUS_STENA_ID'
				t.cx= 60
				t.cy= 60
				t.class="IMAGE"
				t.animation = true
				t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d1/d%0.png"'
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

				t = {}
				t.id = 'Matrix_STENA_ID'
				t.cx= 1800
				t.cy= 980
				t.class="IMAGE"
				t.animation = true
--				t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/green/m%0.png"'
				t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/blue/m%0.png"'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0403
				t.left=0
				t.top=0
				t.transparency = 192
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltm
	if tonumber(tv) == 0 then
		urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
	elseif tonumber(tv) == 1 then
		urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
	end
	local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
	if rc3~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	require('json')
	answertm = answertm:gsub('(%[%])', '"nil"')
	local tab, country, slogan = json.decode(answertm), '', ''
	local promo
	local poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/no-img.png'
	if tab.poster_path and tab.poster_path ~= 'null' then
		poster = tab.poster_path
		poster = 'http://image.tmdb.org/t/p/original' .. poster
	end

	local background = poster
	if tab.backdrop_path and tab.backdrop_path ~= 'null' then
		background = tab.backdrop_path
		background = 'http://image.tmdb.org/t/p/original' .. background
	end

	local overview = tab.overview or ''
	local rating = tab.vote_average or 0
	local orig_name = tab.original_title or tab.original_name or ''
	local ru_name = tab.title or tab.name or orig_name
	local time_all = tab.runtime or 0
	time_all = time_all .. ' мин.'
	local number_of_episodes = tab.number_of_episodes
	local number_of_seasons = tab.number_of_seasons
	if number_of_episodes and number_of_seasons then
		time_all = ' Сезонов: ' .. number_of_seasons .. ', Эпизодов: ' .. number_of_episodes
	end
	local year = tab.release_date or tab.first_air_date
	if year and year:match('%d%d%d%d') then
		year = year:match('%d%d%d%d')
	else
		year = 0
	end

	local imdb_id
	if tab.seasons then
		imdb_id = imdbid(tmid)
	else
		imdb_id = tab.imdb_id
	end
	if m_simpleTV.User.TVPortal.stena == nil then m_simpleTV.User.TVPortal.stena = {} end
	m_simpleTV.User.TVPortal.stena.time_all = ' ● ' .. time_all
	m_simpleTV.User.TVPortal.stena.logo = poster
	m_simpleTV.User.TVPortal.stena.year = year
	m_simpleTV.User.TVPortal.stena.title = ru_name:gsub("'",'´')
	m_simpleTV.User.TVPortal.stena.title_en = orig_name:gsub("'",'´')
	m_simpleTV.User.TVPortal.stena.ret_tmdb = rating
	m_simpleTV.User.TVPortal.stena.overview = overview:gsub('\\"','"'):gsub('\n',' '):gsub('  ',' ')
	m_simpleTV.User.TVPortal.stena.background = background

	if tab and tab.videos and tab.videos.results and tab.videos.results[1] and tab.videos.results[1].key then
		promo = tab.videos.results[1].key
		promo = 'https://www.youtube.com/watch?v=' .. promo
	end
	m_simpleTV.User.TVPortal.stena.youtube = promo

	m_simpleTV.User.TVPortal.stena.genres = nil
	m_simpleTV.User.TVPortal.stena.genres = {}

	if tab and tab.genres then
	    local j = 1
		while true do
			if not tab.genres[j]
			then
				break
			end
			m_simpleTV.User.TVPortal.stena.genres[j] = {}
			m_simpleTV.User.TVPortal.stena.genres[j].Name = tab.genres[j].name
			m_simpleTV.User.TVPortal.stena.genres[j].Id = tab.genres[j].id
			m_simpleTV.User.TVPortal.stena.genres[j].Type = tv
			j=j+1
		end
	end

	m_simpleTV.User.TVPortal.stena.networks = nil
	m_simpleTV.User.TVPortal.stena.networks = {}

	if tab and tab.networks then
	    local j = 1
		while true do
			if not tab.networks[j] or not tab.networks[j].logo_path or j>2
			then
				break
			end
			m_simpleTV.User.TVPortal.stena.networks[j] = {}
			m_simpleTV.User.TVPortal.stena.networks[j].Name = tab.networks[j].name
			m_simpleTV.User.TVPortal.stena.networks[j].Id = tab.networks[j].id
			m_simpleTV.User.TVPortal.stena.networks[j].logo_path = tab.networks[j].logo_path
			j=j+1
		end
	end

	if tab and tab.production_countries then
		local j = 1
		while true do
			if not tab.production_countries[j]
			then
				break
			end
			country = country .. country_name(tab.production_countries[j].iso_3166_1) .. ', '
			j=j+1
		end
		country = country:gsub(', $', '')
	end

	if tab and tab.tagline then
		slogan = tab.tagline
	end
	m_simpleTV.User.TVPortal.stena.coll = nil
	m_simpleTV.User.TVPortal.stena.coll = {}
	local back_coll
	if tab and tab.belongs_to_collection and tab.belongs_to_collection.id and tab.belongs_to_collection.name then
		m_simpleTV.User.TVPortal.stena.coll.adr = tab.belongs_to_collection.id
		m_simpleTV.User.TVPortal.stena.coll.name = tab.belongs_to_collection.name
		if tab.belongs_to_collection.backdrop_path and tab.belongs_to_collection.backdrop_path ~= 'null' then
			back_coll = tab.belongs_to_collection.backdrop_path
			m_simpleTV.User.TVPortal.stena.coll.back = ('http://image.tmdb.org/t/p/w1440_and_h320_multi_faces' .. back_coll)
		end
	end
		m_simpleTV.User.TVPortal.stena.country = country
		m_simpleTV.User.TVPortal.stena.slogan = slogan:gsub("'",'´')
		local dtz1,dtz2,dtz3,dtz4,dtz5,dtz6,dtz7,dtz8,dtz9,dtz10,dtz11 = 0,0,0,0,0,0,0,0,0,0,0
		local tz1 = os.clock()
		dtz1 = tz1 - tz0
		Get_person(tmid, tv)
		local tz2 = os.clock()
		dtz2 = tz2 - tz1
		local answ,tim
		m_simpleTV.User.TVPortal.stena.imdb = nil
		m_simpleTV.User.TVPortal.stena.kp = nil
		local tz3 = tz2
		if imdb_id and imdb_id ~= '' then
			m_simpleTV.User.TVPortal.stena.balanser2 = nil --VideoCDN
			m_simpleTV.User.TVPortal.stena.imdb = imdb_id
			Get_AL(m_simpleTV.User.TVPortal.stena.imdb)
			tz3 = os.clock()
			dtz3 = tz3 - tz2
--		костыли
			if imdb_id == 'tt15325406' then m_simpleTV.User.TVPortal.stena.kp = 1309418 end
			if imdb_id == 'tt15307130' then m_simpleTV.User.TVPortal.stena.kp = 1101239 end
		end
		local tz4,tz5,tz6,tz7,tz8,tz9,tz10,tz11,tz12 = tz3,tz3,tz3,tz3,tz3,tz3,tz3,tz3,tz3
		local is_hdvb,is_vcdn
		if m_simpleTV.User.TVPortal.stena.kp == nil and m_simpleTV.User.TVPortal.stena.imdb then
			Get_VCDN(m_simpleTV.User.TVPortal.stena.imdb) --VideoCDN
			tz4 = os.clock()
			dtz4 = tz4 - tz3
			if m_simpleTV.User.TVPortal.stena.kp then
				is_vcdn = true
			end
		end
		if m_simpleTV.User.TVPortal.stena.kp == nil then
			get_hdvb(m_simpleTV.User.TVPortal.stena.title, m_simpleTV.User.TVPortal.stena.year) --HDVB
			tz5 = os.clock()
			dtz5 = tz5 - tz4
			if m_simpleTV.User.TVPortal.stena.kp then
				is_hdvb = true
			end
		end
		if m_simpleTV.User.TVPortal.stena.kp then
			Get_ZF_new(m_simpleTV.User.TVPortal.stena.kp) --Zetflix
			tz6 = os.clock()
			dtz6 = tz6 - tz5
			if m_simpleTV.User.TVPortal.stena.balansers and m_simpleTV.User.TVPortal.stena.balansers == true then
				if not is_hdvb then
					Get_HDVB(m_simpleTV.User.TVPortal.stena.kp) --HDVB
					tz7 = os.clock()
					dtz7 = tz7 - tz6
				end
				if not is_vcdn then
					Get_VCDN(m_simpleTV.User.TVPortal.stena.imdb) --VideoCDN
					tz8 = os.clock()
					dtz8 = tz8 - tz7
				end
				Get_Collaps(m_simpleTV.User.TVPortal.stena.kp) --Collaps
				tz9 = os.clock()
				dtz9 = tz9 - tz8
				Get_Kodik(m_simpleTV.User.TVPortal.stena.kp) --Kodik
				tz10 = os.clock()
				dtz10 = tz10 - tz9
				Get_Ashdi(m_simpleTV.User.TVPortal.stena.kp) --ASHDI
				tz11 = os.clock()
				dtz11 = tz11 - tz10
			else
				m_simpleTV.User.TVPortal.stena.balanser5 = nil --HDVB
				m_simpleTV.User.TVPortal.stena.balanser6 = nil --Collaps
				m_simpleTV.User.TVPortal.stena.balanser7 = nil --Kodik
				m_simpleTV.User.TVPortal.stena.balanser8 = nil --Ashdi
			end
		else
			m_simpleTV.User.TVPortal.stena.balanser3 = nil --ZF
			m_simpleTV.User.TVPortal.stena.balanser5 = nil --HDVB
			m_simpleTV.User.TVPortal.stena.balanser6 = nil --Collaps
			m_simpleTV.User.TVPortal.stena.balanser7 = nil --Kodik
			m_simpleTV.User.TVPortal.stena.balanser8 = nil --Ashdi
		end
		if not m_simpleTV.User.TMDB then
			m_simpleTV.User.TMDB = {}
		end
		m_simpleTV.User.TMDB.Id = tmid
		m_simpleTV.User.TMDB.tv = tv
		m_simpleTV.User.TVPortal.stena.balanser0 = nil
		answ,tim = Get_pirring_from_name(ru_name, tv, year)
		tz12 = os.clock()
		dtz12 = tz12 - tz11
		if answ == false then
			Get_Reting(tmid)
			findrutor(ru_name, year)
			findrutracker(ru_name, year)
		end
		debug_in_file('-- TMDB id: ' .. tmid .. ', tv:' .. tv .. '\nTMDB info: ' .. dtz1 .. '\nTMDB person: ' .. dtz2 .. '\n-- IMDB id: ' .. (m_simpleTV.User.TVPortal.stena.imdb or 'NOT') .. '\nGet kpid ' .. dtz3 .. '\nGet VCDN: (not kpid) ' .. dtz4 .. '\nGet HDVB: (not kpid) ' .. dtz5 .. '\n-- KP id: ' .. (m_simpleTV.User.TVPortal.stena.kp or 'NOT') .. '\nGet ZF: ' .. dtz6 .. '\nGet VCDN: ' .. dtz7 .. '\nGet HDVB: ' .. dtz8 .. '\nGet Collaps: ' .. dtz9 .. '\nGet Kodik: ' .. dtz10 .. '\nGet Ashdi: ' .. dtz11 .. '\nGet pirring: ' .. dtz12 .. ' (' .. (tim or 0) .. ')' .. '\nAll Request: ' .. dtz1+dtz2+dtz3+dtz4+dtz5+dtz6+dtz7+dtz8+dtz9+dtz10+dtz11+dtz12 .. '\n-----------------\n','c://1/timing.txt')
	return tmdb_info()
end

function UpdatePersonTMDB()
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('PERSONS')
		 then
		    tvs_core.UpdateSource(SID, false)
            tvs_func.OSD_mess('', -2)
         end
    end
end
end

function search_tmdb()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)
	local year = tmdb_search:match(' %((%d%d%d%d)%)$') or ''
	local title = tmdb_search:gsub(' %(%d%d%d%d%)$',''):gsub(' %(%)$','')
	local title1 = 'Поиск TMDb: ' .. tmdb_search

	if check_cat then check_cat() end

	if m_simpleTV.User.TVPortal.search[1] and tonumber(m_simpleTV.User.TVPortal.search[1]) > 0 then
		return search_movie(1)
	elseif m_simpleTV.User.TVPortal.search[2] and tonumber(m_simpleTV.User.TVPortal.search[2]) > 0 then
		return search_tv(1)
	elseif m_simpleTV.User.TVPortal.search[3] and tonumber(m_simpleTV.User.TVPortal.search[3]) > 0 then
		return search_persons(1)
	elseif m_simpleTV.User.TVPortal.search[4] and tonumber(m_simpleTV.User.TVPortal.search[4]) > 0 then
		return search_collections(1)
	else
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'TMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return search_all()
	end

	local t1, nm1 = find_movie(title,year)
	local t2, nm2 = find_series(title,year)
	local t3, nm3 = findpersonIdByName(title)
	local t4, nm4 = find_collections(title)

	local tt = {
	{"Фильмы","","./luaScr/user/show_mi/IconVideo.png",""},
	{"Сериалы","","./luaScr/user/show_mi/IconTVShows.png",""},
	{"Персоны","","./luaScr/user/show_mi/IconActor.png",""},
	{"Коллекции","","./luaScr/user/show_mi/IconCollection.png",""},
	}

	local t, k = {}, 1
  for i=1,#tt do
    t[k] = {}
	if i == 1 and tonumber(nm1) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm1 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	elseif i == 2 and tonumber(nm2) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm2 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	elseif i == 3 and tonumber(nm3) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm3 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	elseif i == 4 and tonumber(nm4) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm4 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	end
	i = i + 1
  end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
	if k > 1 then
    local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Выберите категорию поиска: ' .. tmdb_search,0,t,10000,1+4+8+2)
	if ret == -1 or not id then
		 return
	end
	if ret == 2 then
		search_all()
	end
	if ret == 3 then
		search()
	end
	if ret == 1 then
	if t[id].Action == "Фильмы" then
	if tonumber(nm1) == 0 then search_tmdb() end
	t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 фильмы: ' .. tmdb_search, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			media_info_tmdb(t1[id].Address,0)
		end
	elseif t[id].Action == "Сериалы" then
	if tonumber(nm2) == 0 then search_tmdb() end
	t2.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t2.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 сериалы: ' .. tmdb_search, 0, t2, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			media_info_tmdb(t2[id].Address,1)
		end
	elseif t[id].Action == "Персоны" then
	if tonumber(nm3) == 0 then search_tmdb() end
	t3.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t3.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 персоны: ' .. tmdb_search, 0, t3, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
		 return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			personWorkById(t3[id].Address)
		end
	elseif t[id].Action == "Коллекции" then
	if tonumber(nm4) == 0 then search_tmdb() end
	t4.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t4.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 коллекции: ' .. tmdb_search, 0, t4, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
		 return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			collection_TMDb(t4[id].Address)
		end
	end
	end
	else
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'TMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	end
	end

function get_info_for_play(id_cur)
	m_simpleTV.OSD.RemoveElement('STENA_INFO_ITEM_IMG_ID')
	m_simpleTV.OSD.RemoveElement('STENA_RETING_ITEM_IMG_ID')
	m_simpleTV.OSD.RemoveElement('USER_LOGO_ITEM_IMG_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_1_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_2_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_3_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_4_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_ITEM_11_ID')

	local id = id_cur:match('(%d+)')
	local t, AddElement = {}, m_simpleTV.OSD.AddElement

	local t1
	if m_simpleTV.User.TVPortal.stena.type:match('search') then
	t1 = m_simpleTV.User.TVPortal.stena_search
	else
	t1 = m_simpleTV.User.TVPortal.stena
	end
		t.BackColor = 0
		t.BackColorEnd = 255
		t.PictFileName = t1[tonumber(id)].InfoPanelLogo:gsub('w250_and_h141_face','original')
		t.TypeBackColor = 0
		t.UseLogo = 3
		t.Once = 1
		t.Blur = 0
		m_simpleTV.Interface.SetBackground(t)

	if m_simpleTV.User.TVPortal.stena.type:match('persons') or m_simpleTV.User.TVPortal.stena.type:match('collections') then return end
	if m_simpleTV.User.TVPortal.cur_content_adr == nil or
		tonumber(id) ~= m_simpleTV.User.TVPortal.cur_content_adr then
		m_simpleTV.User.TVPortal.cur_content_adr = id
		local dx = 1360/4
		local dy = 1000/5
		local nx = tonumber(id) - (math.ceil(tonumber(id)/4) - 1)*4
		local ny = math.ceil(tonumber(id)/4)
		local check = check_online(t1[tonumber(id)].Address,t1[tonumber(id)].Type,id)
					if check then
						t = {}
						t.id = 'STENA_INFO_ITEM_IMG_ID'
						t.cx=60
						t.cy=60
						t.class="IMAGE"
						if check == '' then
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Unknown.png'
						else
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Play_.png'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0101
						t.left = nx*dx + 40
						t.top  = ny*dy - 25
						t.transparency = 200
						t.zorder=2
						AddElement(t,'ID_DIV_STENA_1')
					end

				if t1[tonumber(id)].Reting and Get_rating(t1[tonumber(id)].Reting,id) and m_simpleTV.User.TVPortal.stena_info ~= true and m_simpleTV.User.TVPortal.stena_genres ~= true and m_simpleTV.User.TVPortal.stena_home ~= true then

					t = {}
					t.id = 'STENA_RETING_ITEM_IMG_ID'
					t.cx= 80 / 1*1.25
					t.cy= 16 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(t1[tonumber(id)].Reting,id) .. '.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = nx*dx - 220 + 10
					t.top  = ny*dy - 25 + 10
					t.transparency = 200
					t.zorder=2
					AddElement(t,'ID_DIV_STENA_1')

					if t1[tonumber(id)].Logo then
						t = {}
						t.id = 'USER_LOGO_ITEM_IMG_ID'
						t.cx= 300 / 1*1.25
						t.cy= 450 / 1*1.25
						t.class="IMAGE"
						t.imagepath = t1[tonumber(id)].Logo
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left=40
						t.top=200
						t.transparency = 200
						t.zorder=1
						t.borderwidth = 2
						t.bordercolor = -6250336
						t.backroundcorner = 4*4
						t.borderround = 20
						AddElement(t,'ID_DIV_STENA_1')
					end

			 t={}
			 t.id = 'TEXT_ITEM_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = t1[tonumber(id)].Rus
			 t.color = -2123993
			 t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 1510
			 t.top  = 780
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_ITEM_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = t1[tonumber(id)].Orig
			 t.color = -2123993
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0x00000020
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 1510
			 t.top  = 810
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_ITEM_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = t1[tonumber(id)].Year .. ', TMDB: ' .. t1[tonumber(id)].Reting
			 t.color = -2113993
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0x00000020
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 1510
			 t.top  = 840
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_ITEM_4_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = t1[tonumber(id)].InfoPanelTitle .. '\n\n\n\n\n\n\n\n\n'
			 t.color = ARGB(255, 192, 192, 192)
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.boundWidth = 50
			 t.row_limit=9
			 t.text_elidemode = 1
			 t.textparam = 0
			 t.left = 1510
			 t.top  = 900
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

	local genre = ''
	if t1[tonumber(id)].Genre and t1[tonumber(id)].Genre[1] then
	for j = 1,#t1[tonumber(id)].Genre do
		genre = genre .. ', ' .. genres_name(t1[tonumber(id)].Type, t1[tonumber(id)].Genre[j])
--	end
--	end
	genre = genre:gsub('^%, ','')
		if m_simpleTV.User.TVPortal.stena_info == true or m_simpleTV.User.TVPortal.stena_genres == true or m_simpleTV.User.TVPortal.stena_home == true then
			genre = ''
		end
			 t={}
			 t.id = 'TEXT_ITEM_11_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = genre
			 t.color = -2113993
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0x00000020
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 1510
			 t.top  = 870
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')
		end
		end
	end
--[[
	t[i].InfoPanelTitle = overview
	t[i].Reting = reting
	t[i].Rus = rus
	t[i].Orig = orig
	t[i].Year = year
	t[i].Genre = genre
--]]
	end
end

-------------------------------------------------------------------
----[[
 local t1={}
 t1.utf8 = true
 t1.name = 'Desc меню'
 t1.luastring = 'start_page_mediaportal()'
 t1.lua_as_scr = true
 t1.submenu = 'westSide Portal'
 t1.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide/icons/portal.png'
 t1.key = string.byte('H')
 t1.ctrlkey = 0
 t1.location = 0
 t1.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/lite.png'
 m_simpleTV.Interface.AddExtMenuT(t1)
 m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
 --]]
-------------------------------------------------------------------