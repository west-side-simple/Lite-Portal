-- видеоскрипт для сайта https://www.imdb.com/ (19/04/25) - автор west_side
-- открывает подобные ссылки:
-- https://www.imdb.com/title/tt5491994
-- title=Форсаж
-- title=Форсаж&year=2001
-- title=Форсаж, 2001
-- title=Форсаж (2001)
-- необходимы скрипты видео ZF.lua, imdb_category.lua, getaddress_tmdb.lua - автор west_side
-- дополнительные стартовые Lite_qt_tmdb.lua, desc_gt_tmdb.lua - автор west_side

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('https?://www%.imdb%.com/title/tt%d+')
	and not inAdr:match('^title=')
	then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''

	local function get_al_t_y(title, year)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local url = decode64('aHR0cHM6Ly9hcGkuYXBidWdhbGwub3JnLz90b2tlbj1kMzE3NDQxMzU5ZTUwNWMzNDNjMjA2M2VkYzk3ZTc=') .. '&name=' .. m_simpleTV.Common.toPercentEncoding(m_simpleTV.Common.multiByteToUTF8(title)) .. '&year=' .. year
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
--		debug_in_file(url .. '\n' .. m_simpleTV.Common.multiByteToUTF8(title) .. ' ' .. year .. '\n' .. (answer or 'notanswer') .. '\n','c://1/content.txt')
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return false
		end
		answer = unescape1(answer)
		local id_imdb = answer:match('"id_imdb":"(tt.-)"')
	--	debug_in_file(title .. ' ' .. year .. '\n' .. answer .. '\n','c://1/content.txt')
		if id_imdb then
	--	debug_in_file( 'id_imdb=' .. id_imdb .. '\n', 'c://1/content.txt')
		return id_imdb
		end
		return false
	end

	local function bg_imdb_id(imdb_id)
		if imdb_id=='tt27053234' then return
		'https://image.tmdb.org/t/p/original/vkwkX6x7ymz0w6ibmYdmSx38MrJ.jpg',
		'Призвание',
		'2023',
		'222216',
		'1'
		end
		if imdb_id=='tt4741312' then return
		'https://image.tmdb.org/t/p/original/nc1XwQo9Cj8F26mzUiViWx9e8eu.jpg',
		'Кремень. Освобождение',
		'2013',
		'88225',
		'1'
		end
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
		local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
		if rc1~=200 then
		m_simpleTV.Http.Close(session)
		return
		end
		require('json')
		answerd = answerd:gsub('(%[%])', '"nil"')
		local tab = json.decode(answerd)
		local background, poster, title, year, id, tv, original_title = '','','imdb_id'
		if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then
		background = ''
		else
		if tab.movie_results[1] then
		background = tab.movie_results[1].backdrop_path or ''
		poster = tab.movie_results[1].poster_path or ''
		title = tab.movie_results[1].title
		original_title = tab.movie_results[1].original_title
		id, tv = tab.movie_results[1].id, 0
		year = tab.movie_results[1].release_date or 0
		elseif tab.tv_results[1] then
		background = tab.tv_results[1].backdrop_path or ''
		poster = tab.tv_results[1].poster_path or ''
		title = tab.tv_results[1].name
		original_title = tab.tv_results[1].original_name
		id, tv = tab.tv_results[1].id, 1
		year = tab.tv_results[1].first_air_date or 0
		end
		if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
		if poster and poster ~= '' then poster = 'http://image.tmdb.org/t/p/original' .. poster end
		if poster and poster ~= '' and background == '' then background = poster end
		end
		if background == nil then background = '' end
		return background, title, year, id, tv, original_title, poster
	end

	local function kpid(imdbid)
		if imdbid == 'tt0086333' then return '77264' end
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdbid
		local rc, answer = m_simpleTV.Http.Request(session,{url=url})
		m_simpleTV.Http.Close(session)
		if rc == 200 then
			local kp_id = answer:match('"kp_id":(%d+)')
			if kp_id then
				return tostring(kp_id)
			end
		return false
		end
		return false
	end

	local function Get_Vibix(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = 'https://vibix.org/api/v1/catalog/data?draw=1&search[value]=' .. id
		local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'post', headers = m_simpleTV.User.VF.headers})
		
		
		
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return false
		end
		local url_out = answer:match('"iframe_video_id":(%d+)')
--		debug_in_file(unescape1(answer) .. '\n','c://1/VX.txt')
		if url_out then
		local embed = '/embed/'	
		if unescape1(answer):match('"type":"serial"') then embed = '/embed-serials/' end	
		url_out = 'https://videoframe1.com' .. embed .. url_out 
		rc,answer = m_simpleTV.Http.Request(session,{url = url_out})
		answer = answer:match('new Playerjs%((.-)%);')
--		debug_in_file(answer .. '\n','c://1/VX1.txt')
		m_simpleTV.Http.Close(session)
		return url_out .. '&id=' .. id
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function Get_CDNMoovie(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = decode64('aHR0cHM6Ly9jZG5tb3ZpZXMtc3RyZWFtLm9ubGluZS9pbWRiLw==') .. id .. '/iframe'
		local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'Referer: https://cdnmovies.net/'})
		m_simpleTV.Http.Close(session)
		if rc~=200 then
			return false
		end
		return url
	end

	local function Get_FCDN(title,original_title,year)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = 'https://api.manhan.one/lite/fancdn?' .. 'title=' .. title .. '&original_title=' .. original_title .. '&year=' .. year
		local rc,answer = m_simpleTV.Http.Request(session,{url = url})
		answer = unescape3(answer)
--		debug_in_file(url .. '\n' .. answer .. '\n','c://1/fcdn.txt')
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			local t = {}
			for url, tr in answer:gmatch('"url":"(.-)".-"translate":"(.-)"') do
					t[#t + 1] = {}
					t[#t].Id = #t
					t[#t].Address = url
					t[#t].Name = tr
--	debug_in_file(tr .. ' ' .. url .. '\n--------------\n','c://1/content_fcdn.txt')
			end
			m_simpleTV.User.TVPortal.balanser = 'VideoDB'
			return t[#t].Address
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function Get_DB(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = decode64('aHR0cHM6Ly9hcGkubWFuaGFuLm9uZS9sYXRlL3ZpZGVvZGI/a2lub3BvaXNrX2lkPQ==') .. id
		local rc,answer = m_simpleTV.Http.Request(session,{url = url})

--		debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Common.Sleep(1000)
		rc,answer = m_simpleTV.Http.Request(session,{url = url})
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function Get_ZF_new(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = decode64('aHR0cHM6Ly9oaWR4bGdsay5kZXBsb3kuY3gvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. id
		local rc,answer = m_simpleTV.Http.Request(session,{url = url})

--		debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Common.Sleep(1000)
		rc,answer = m_simpleTV.Http.Request(session,{url = url})
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function Get_Title_Year_Poster(imdb_id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = decode64('aHR0cHM6Ly93d3cub21kYmFwaS5jb20vP2FwaWtleT02MzY0NjJiMCZpPQ==') .. imdb_id
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return false end
		local title, year, genre, country, poster = answer:match('"Title":"(.-)".-"Year":"(%d%d%d%d).-"Genre":"(.-)".-"Country":"(.-)".-"Poster":"(.-)"')
		return title, year, poster
	end

	local year_in = inAdr:match('year=(%d%d%d%d)') or inAdr:match('%((%d%d%d%d)%)') or inAdr:match('%,(%d%d%d%d)')

	local title_in = inAdr:match('title=(.-)$')

	local imdbid

	if title_in and year_in then
		title_in = title_in:gsub('&year=.-$',''):gsub(' %(%d%d%d%d%)',''):gsub(' %,%d%d%d%d',''):gsub('%s+$',''):gsub('^%s+','')
		imdbid = get_al_t_y(title_in, year_in)
		if not imdbid then
			return m_simpleTV.Control.SetNewAddressT({address = '*' .. m_simpleTV.Common.multiByteToUTF8(title_in), title=m_simpleTV.Common.multiByteToUTF8(title_in), position = 0})
		end
	elseif title_in and not year_in then
		return m_simpleTV.Control.SetNewAddressT({address = '*' .. m_simpleTV.Common.multiByteToUTF8(title_in:gsub('%s+$',''):gsub('^%s+','')), title=m_simpleTV.Common.multiByteToUTF8(title_in:gsub('%s+$',''):gsub('^%s+','')), position = 0})
	end

	imdbid = imdbid or inAdr:match('(tt%d+)')
	
	local retAdr = Get_Vibix(imdbid)
	local logo, title, year, id, tv, original_title, poster = bg_imdb_id(imdbid)

	if title == nil or year == nil or title == '' then
		title, year, logo = Get_Title_Year_Poster(imdbid)
		if not title then
			title = 'IMDb_id=' .. imdbid
		end
		if not logo then
			logo = ''
		end
		year = year and year:match('%d+') or ''
		if year ~= '' then
			title = title .. ' (' .. year .. ')'
		end
	else
		year = year:match('%d+') or ''
		if year ~= '' then
			title = title .. ' (' .. year .. ')'
		end
	end
	
	
	
	local zf = true -- or true or false
--	retAdr = Get_CDNMoovie(imdbid)
	local kp_id
	if not retAdr then
		kp_id = kpid(imdbid)
		if kp_id and zf then
			retAdr = Get_ZF_new(kp_id)
		end
--[[		if kp_id and not retAdr then
			retAdr = Get_DB(kp_id)
		end	--]]
		if not retAdr and title and original_title and year then
			retAdr = Get_FCDN(title:gsub(' %(.-$',''),original_title,year)
		end
	end

	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	if not logo or logo == '' then logo = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT89hQjoryKk0JDGGngnnV3bLpSTv61LwpYAg&s' end
	if not poster or poster == '' then poster = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT89hQjoryKk0JDGGngnnV3bLpSTv61LwpYAg&s' end
	m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	add_to_history_imdb('https://www.imdb.com/title/' .. imdbid, title, (poster or logo))
	
	if id and tv then
		if retAdr then
			m_simpleTV.Control.PlayAddressT({address = 'tmdb_id=' .. id .. '&tv=' .. tv .. '&' .. retAdr, title=title, position = 0})
		else
			m_simpleTV.Control.CurrentAdress = 'wait'
			media_info_tmdb(id, tv)
			return
		end
	else
		if retAdr then
		m_simpleTV.Control.SetNewAddressT({address = retAdr, title=title, position = 0})
		else
		m_simpleTV.Control.CurrentAdress = 'wait'
		return
		end
	end
