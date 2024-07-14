-- видеоскрипт для сайта http://www.kinopoisk.ru
-- Copyright © 2017-2023 Nexterr | https://github.com/Nexterr/simpleTV
-- mod west_side - (10.09.24)
-- ## необходимы ##
-- видеоскрипты: videocdn.lua, hdvb.lua, collaps.lua, voidboost.lua, zetflix.lua, kodik.lua, cdnmovies.lua
-- ## открывает подобные ссылки ##
-- https://www.kinopoisk.ru/film/5928
-- https://www.kinopoisk.ru/level/1/film/46225/sr/1/
-- https://www.kinopoisk.ru/level/1/film/942397/sr/1/
-- https://www.kinopoisk.ru/film/336434
-- https://www.kinopoisk.ru/film/4-mushketera-sharlo-1973-60498/sr/1/
-- https://www.kinopoisk.ru/images/film_big/946897.jpg
-- https://www.kinopoisk.ru/film/535341/watch/?from_block=Фильмы%20из%20Топ-250&
-- https://hd.kinopoisk.ru/film/456c0edc4049d31da56036a9ae1484f4
-- http://rating.kinopoisk.ru/7378.gif
-- https://www.kinopoisk.ru/series/733493/
-- ## адрес сайта (зеркала) filmix.ac ##
local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
-- 'https://filmix.life' (пример)
-- ## прокси для Seasonvar ##
local proxy = ''
-- '' - нет
-- 'https://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ## источники ##
local function getConfigVal(key)
 return m_simpleTV.Config.GetValue(key,'LiteConf.ini')
end

local function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,'LiteConf.ini')
end

local function find_in_history(kpid)
local recentAddress = getConfigVal('kp_history/adr') or ''
     local t,i={},1
	 for w in string.gmatch(recentAddress,"[^,]+") do
	   local kp_id,bal = w:match('(%d+).-%&bal=(.-)$')
--	   debug_in_file('fromRecentAddress = ' .. kp_id .. ' ' .. bal .. ' ' .. recentAddress .. '\n','c://1/kp.txt')
	   t[i] = {}
	   t[i].Address = w
       if kp_id == kpid then
	   return bal
	   end
       i=i+1
     end
return ''
end
--------------------------------------
function add_to_history(adr,title,logo)

-- wafee code for history
	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = getConfigVal('kp_history/title') or ''
    local recentAddress = getConfigVal('kp_history/adr') or ''
	local recentLogo = getConfigVal('kp_history/logo') or ''
     local t={}
     local tt={}
     local i=2
	 t[1] = {}
     t[1].Id = 1
     t[1].Name = title
	 t[1].Address = adr
	 t[1].Logo = logo
   if recentName~='' and recentLogo~='' and recentAddress~='' then

     for w in string.gmatch(recentName,"[^,]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
       i=i+1
     end
     i=2
     for w in string.gmatch(recentAddress,"[^,]+") do
       t[i].Address = w
       i=i+1
     end
	 i=2
     for w in string.gmatch(recentLogo,"[^,]+") do
       t[i].Logo = w
       i=i+1
     end

     local function isExistAdr()
       for i=2,#t do
         if adr:gsub('%&bal=.-$','')==t[i].Address:gsub('%&bal=.-$','') then
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
      recentName = recentName .. name .. ','
      recentAddress = recentAddress .. t[i].Address .. ','
	  recentLogo = recentLogo .. t[i].Logo .. ','
      t[i].Id = i
--      debug_in_file('fromOSDmenu = ' .. t[i].Id .. ' ' .. t[i].Name .. ' ' .. t[i].Address .. '\n','c://1/kp.txt')
     end

	 setConfigVal('kp_history/title',recentName)
	 setConfigVal('kp_history/logo',recentLogo)
	 setConfigVal('kp_history/adr',recentAddress)

	 else

	 setConfigVal('kp_history/title',title .. ',')
	 setConfigVal('kp_history/logo',logo .. ',')
	 setConfigVal('kp_history/adr',adr .. ',')

   end
end

--------------------------------------
local tname = {}
if not m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini') or tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 1 then
-- сокращенная база
tname = {
-- сортировать: поменять порядок строк
-- отключить: поставить в начале строки --
 'Videocdn',
-- 'ZF',
 'VB',
-- 'CDN Movies',
-- 'Hdvb',
-- 'Collaps',
-- 'Kodik',
 'Magnets',
	}
-- ##
elseif tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 2 then
-- полная база
tname = {
-- сортировать: поменять порядок строк
-- отключить: поставить в начале строки --
 'Videocdn',
-- 'ZF',
 'VB',
-- 'CDN Movies',
 'Hdvb',
 'Collaps',
 'Kodik',
 'Magnets',
	}
-- ##
end
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://[%w%.]*kinopoisk%.ru/.+') then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
		if not inAdr:match('/film')
			and not inAdr:match('//rating%.')
			and not inAdr:match('/series/')
		then
		 return
		end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 0, Once = 1})
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
-- ## убрать ThumbsInfo
		if m_simpleTV.User.Rezka and m_simpleTV.User.Rezka.ThumbsInfo then m_simpleTV.User.Rezka.ThumbsInfo = nil end
-- ##
	require 'json'
	require 'lfs'
	htmlEntities = require 'htmlEntities'
	m_simpleTV.Control.ChangeAddress= 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if inAdr:match('hd%.kinopoisk%.ru') then
		local id = inAdr:match('hd%.kinopoisk%.ru/film/(%x+)')
			if not id then return end
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://api.ott.kinopoisk.ru/v7/hd/content/' .. id .. '/metadata'})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
			 return
			end
		id = answer:match('"kpId":(%d+)')
			if not id then return end
		inAdr = 'https://www.kinopoisk.ru/film/' .. id
	end
	inAdr = inAdr:gsub('/watch/.+', ''):gsub('/watch%?.+', ''):gsub('/sr/.+', '')
	local kpid = inAdr:match('.+%-(%d+)') or inAdr:match('/film//?(%d+)') or inAdr:match('%d+')
		if not kpid then return end
	local turl, svar, t, rett, Rt = {}, {}, {}, {}, {}
	local rc, answer, retAdr, title, orig_title, year, rating_kp, rating_imdb, zonaAbuse, zonaUrl, zonaSerial, zonaId, zonaDesc, logourl, eng_title, languages_imdb, current_bal

	local current_id = 1
	inAdr = inAdr:gsub('%&bal=.-$','')
	current_bal = find_in_history(kpid)

	local usvar, i, u = 1, 1, 1
	local function unescape_html(str)
	 return htmlEntities.decode(str)
	end

	local function getInfo_zona(kpid)
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL3pzb2xyLnpvbmFzZWFyY2guY29tL3NvbHIvbW92aWUvc2VsZWN0Lz93dD1qc29uJmZsPXllYXIsc2VyaWFsLHJhdGluZ19raW5vcG9pc2ssbmFtZV9ydXMscmF0aW5nX2ltZGIsZGVzY3JpcHRpb24mcT1pZDo') .. kpid})
			if rc ~= 200 then return end
			if not answer:match('^{') then return end
		answer = answer:gsub('%[%]', '""'):gsub(string.char(239, 187, 191), '')
		local tab = json.decode(answer)
			if not tab or not tab.response or not tab.response.docs or not tab.response.docs[1] then return end
		local serial = tab.response.docs[1].serial
		local year = tab.response.docs[1].year or 0
		local title = tab.response.docs[1].name_rus
		local desc = tab.response.docs[1].description or ''
		local rating_kp = tab.response.docs[1].rating_kinopoisk or 0
		local rating_imdb = tab.response.docs[1].rating_imdb or 0
		serial = tostring(serial)
		if serial == 'true' then
			serial = 1
		elseif serial == 'false' then
			serial = 0
		else
			serial = 10
		end
	 return	tonumber(serial), tonumber(year), title, desc, tonumber(rating_kp), tonumber(rating_imdb)
	end

	local function ukp(kp)
	local rc,answer = m_simpleTV.Http.Request(session,{url = decode64('aHR0cHM6Ly9raW5vcG9pc2thcGl1bm9mZmljaWFsLnRlY2gvYXBpL3YyLjIvZmlsbXMv') .. kp, method = 'get', headers = 'X-API-KEY: ' .. decode64('OTczODMxMzUtNjM0ZC00ODA4LWEzMzQtNGIwMjg3ZjZiZDBh') .. '\nContent-Type: application/json'})
	if rc ~= 200 then return '','','' end
	local title = answer:match('"nameRu"%:"(.-)"') or answer:match('"nameEn"%:"(.-)"') or answer:match('"nameOriginal"%:"(.-)"')
	local year = answer:match('"year"%:(%d%d%d%d)')
	local overview = answer:match('"description"%:"(.-)"') or ''
	return title,year,overview
	end

	local function answerdget(url)
		if url:match('PXk2QGbvEVmS') then
			rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36\nReferer: https://www.videocdn.tv/'})
				if rc ~= 200 or answer:match('video_not_found') then return end
--		debug_in_file( '\n' .. url .. '\n' .. answer .. '\n', 'c://1/cdn.txt', setnew )
			return url
		elseif url:match('kNKj47MkBgLS') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return url
		elseif url:match('cdnmovies') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://cdnmovies.net/'})
				if rc ~= 200 or (rc == 200 and not answer:match('#2')) then return end
			return url
		elseif url:match('kodikapi%.com') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"link":"([^"]+)')
		elseif url:match('iframe%.video') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"path":"([^"]+)')
		elseif url:match('synchroncode') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: api.synchroncode.com'})
				if rc ~= 200 then return end
				if answer:match('embedHost') then
				 return url
				end
		elseif url:match('vb17123filippaaniketos') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"iframe_url":"([^"]+)')
		elseif url:match('voidboost') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return url
		elseif url:match('zetflix') then
			rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; rv:97.0) Gecko/20100101 Firefox/97.0\nReferer: https://hdi.zetflix.online/iplayer/player.php'})
				if rc ~= 200 or answer:match('video_not_found') then return end
			return url
		elseif url:match('vokino') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url .. '&token=' .. decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')})
				if rc ~= 200 then return end
			require('json')
			answer = answer:gsub('(%[%])', '"nil"')
--			debug_in_file( '\n' .. url .. '\n' .. answer .. '\n', 'c://1/pir.txt', setnew )
			local tab = json.decode(answer)
			if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
			then
			return end
			m_simpleTV.Http.Close(session)
			local t, i = {}, 1
			while true do
			if not tab.channels[i] or not tab.channels[i].details.id
						then
						break
						end
			local id = tab.channels[i].details.id or ''
			local name = tab.channels[i].details.name or 'noname'
			local released = tab.channels[i].details.released or ''
			if name == title then return 'id=' .. id end
			i=i+1
			end
			return url
		end
	 return
	end

	local function getAdr(answer, url)
		if url:match('iframe%.video') then
			return answer
		elseif url:match('PXk2QGbvEVmS') then
			return answer
		elseif url:match('kNKj47MkBgLS') then
			return answer
		elseif url:match('cdnmovies%.net') then
			return answer
		elseif url:match('kodikapi%.com') then
			return answer
		elseif url:match('synchroncode') then
			return url
		elseif url:match('vb17123filippaaniketos') then
			return answer
		elseif url:match('voidboost') then
			return answer
		elseif url:match('zetflix') then
			return answer
		elseif url:match('vokino') then
			return answer
		end
	 return
	end

	local function getlogo()
		local session2 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:84.0) Gecko/20100101 Firefox/84.0', nil, true)
			if not session2 then return end
		m_simpleTV.Http.SetTimeout(session2, 8000)
		local url = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. kpid .. '.jpg'
		m_simpleTV.Http.SetRedirectAllow(session2, false)
		local rc, answer = m_simpleTV.Http.Request(session2, {url = url})
		local raw = m_simpleTV.Http.GetRawHeader(session2) or ''
		m_simpleTV.Http.Close(session2)
		if rc == 200
			or (rc == 302 and not raw:match('no%-poster%.gif'))
		then
			logourl = url
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = logourl, TypeBackColor = 0, UseLogo = 3, Once = 1})
		else
			url = 'https://www.iphones.ru/wp-content/uploads/2020/06/orig-1240x630.png'
			logourl = url
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = url, TypeBackColor = 0, UseLogo = 3, Once = 1})
		end
	end

	local function imdbid(kpid)
	if kpid == '77264' then return 'tt0086333','Шерлок Холмс и доктор Ватсон: Сокровища Агры','1983' end
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJmtpbm9wb2lza19pZD0=') .. kpid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		return '','',''
		end
		require('json')
		answer_vn = answer_vn:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id and tab_vn.data[1].imdb_id ~= 'null' and tab_vn.data[1].year then
		return tab_vn.data[1].imdb_id or '', unescape3(tab_vn.data[1].title) or '',tab_vn.data[1].year:match('%d%d%d%d') or ''
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and ( not tab_vn.data[1].imdb_id or tab_vn.data[1].imdb_id ~= 'null') then
		return '', unescape3(tab_vn.data[1].title) or '',tab_vn.data[1].year:match('%d%d%d%d') or ''
		else return '','',''
		end
	end

	local function bg_imdb_id(imdb_id)
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc5~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local background, name_tmdb, year_tmdb, overview_tmdb = '', '', '', ''
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then return '', '', '', '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	name_tmdb = tab.movie_results[1].title or ''
	year_tmdb = tab.movie_results[1].release_date or ''
	overview_tmdb = tab.movie_results[1].overview or ''
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	name_tmdb = tab.tv_results[1].name or ''
	year_tmdb = tab.tv_results[1].first_air_date or ''
	overview_tmdb = tab.tv_results[1].overview or ''
	end
	end
	if year_tmdb and year_tmdb ~= '' then
	year_tmdb = year_tmdb:match('%d%d%d%d')
	else year_tmdb = 0 end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if background == nil then background = '' end
	return background, name_tmdb, year_tmdb, overview_tmdb
	end

	local background, id_imdb, name_tmdb, year_tmdb, overview_tmdb, name_vcd, year_vcd, overview_kp, title_kp, year_kp

	serial, year_kp, title_kp, overview_kp, rating_kp, rating_imdb = getInfo_zona(kpid)

	if imdbid(kpid)
		then
		id_imdb, name_vcd, year_vcd = imdbid(kpid)
		if id_imdb ~= '' and bg_imdb_id(id_imdb)~= '' then
		background, name_tmdb, year_tmdb, overview_tmdb = bg_imdb_id(id_imdb)
		end
	end

	if background and background~= ''
		then
		logourl = background
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		else
		getlogo()
	end

	if not name_tmdb or (name_tmdb and name_tmdb == '') then
		title = name_vcd
		year = year_vcd
	else
		title = name_tmdb
		year = year_tmdb
	end

	if not title or (title and title == '') then
		title = title_kp
		year = year_kp
	end

	if not title or (title and title == '') then
		title_kp, year_kp, overview_kp = ukp(kpid)
		title = title_kp
		year = year_kp
	end

	if not title or title and title == '' then
		title = 'Кинопоиск'
	end
	if not year or (year and year == '') then
		year = ''
	else
		year = ' (' .. tostring(year) .. ')'
	end

	m_simpleTV.Control.CurrentTitle_UTF8 = title .. year
	m_simpleTV.Control.SetTitle(title .. year)

	local function setMenu()
		local logo_k = logourl or 'https://avatars.mds.yandex.net/get-zen-logos/200214/pub_595fb4431410c3258a91bf55_5af1c6e63dceb755566a70a2/xxh'
		m_simpleTV.Control.ChangeChannelLogo(logo_k, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		for i = 1, #tname do
			if tname[i] == 'Kodik' then
				turl[i] = {adr = decode64('aHR0cDovL2tvZGlrYXBpLmNvbS9nZXQtcGxheWVyP3Rva2VuPTQ0N2QxNzllODc1ZWZlNDQyMTdmMjBkMWVlMjE0NmJlJmtpbm9wb2lza0lEPQ') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Videocdn' then
				turl[i] = {adr = decode64('aHR0cHM6Ly84MjA5LnN2ZXRhY2RuLmluL1BYazJRR2J2RVZtUz9rcF9pZD0') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Collaps' then
				turl[i] = {adr = 'https://api' .. os.time() .. decode64('LnN5bmNocm9uY29kZS5jb20vZW1iZWQva3Av') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'CDN Movies' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9jZG5tb3ZpZXMtc3RyZWFtLm9ubGluZS9raW5vcG9pc2sv') .. kpid .. '/iframe', tTitle = 'Большая база фильмов и сериалов', tLogo = 'https://raw.githubusercontent.com/Nexterr-origin/simpleTV-Images/main/cdnmovie.png'}
			elseif tname[i] == 'Hdvb' then
				turl[i] = {adr = decode64('aHR0cHM6Ly92YjE3MTIzZmlsaXBwYWFuaWtldG9zLnB3Ly9hcGkvdmlkZW9zLmpzb24/dG9rZW49Yzk5NjZiOTQ3ZGEyZjNjMjliMzBjMGUwZGNjYTZjZjQmaWRfa3A9') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'VB' then
				turl[i] = {adr = decode64('aHR0cHM6Ly92b2lkYm9vc3QubmV0L2VtYmVkLw') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'ZF' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9oZGkuemV0ZmxpeC5vbmxpbmUvaXBsYXllci92aWRlb2RiLnBocD9rcD0=') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Magnets' then
				turl[i] = {adr = decode64('aHR0cDovL2FwaS52b2tpbm8udHYvdjIvbGlzdD9uYW1lPSUyQg==') .. kpid:gsub('77264','127608'), tTitle = 'Пиринговые ресурсы', tLogo = logo_k}
			end
		end
	end

	local function menu()
		for i = 1, #tname do
			t[i] = {}
			t[i].Name = tname[i]
			t[i].InfoPanelName = title .. year
			if not id_imdb or id_imdb ~= '' or id_imdb and id_imdb == '' and tname[i] ~= 'Videoapi' then
			t[i].answer = answerdget(turl[i].adr)
			t[i].Address = turl[i].adr
			end
			if background and name_tmdb and year_tmdb and overview_tmdb then
				t[i].InfoPanelTitle = overview_tmdb
				t[i].InfoPanelLogo = logourl or 'https://avatars.mds.yandex.net/get-zen-logos/200214/pub_595fb4431410c3258a91bf55_5af1c6e63dceb755566a70a2/xxh'
			else
				t[i].InfoPanelTitle = overview_kp or turl[i].tTitle
				t[i].InfoPanelLogo = logourl or turl[i].tLogo
			end
			t[i].InfoPanelShowTime = 30000
		end

		for _, v in pairs(t) do
			if v.answer then
			v.Id = u
			if current_bal and v.Name == current_bal then current_id = u end
			rett[u] = v
			u = u + 1
			end
		end
	end

	local function selectmenu()
		rett.ExtParams = {FilterType = 2}

			rett.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Rezka'}

		m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🎬 ' .. title .. year, current_id-1, rett, 8000, 1 + 2)
			if ret == 3 then
				m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
				search_rezka()
			end

			id = id or current_id
			add_to_history(inAdr .. '&bal=' .. rett[id].Name,title:gsub('%,','') .. year,rett[id].InfoPanelLogo)
			retAdr = getAdr(rett[id].answer, rett[id].Address)

		if retAdr == -1 then
			selectmenu()
		end
	end
	setMenu()
	menu()
	if #rett == 0 then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/westSide/icons/liteportal.png"', text = 'Kinopoisk: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	 return
	end
	selectmenu()
	if not retAdr or retAdr == 0 then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/westSide/icons/liteportal.png"', text = 'Kinopoisk: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	 return
	end
	if retAdr:match('vokino') then content_adr_page(retAdr) end
	if retAdr:match('^id=') then content(retAdr:gsub('id=','')) end
	m_simpleTV.Control.CurrentTitle_UTF8 = title .. year
	m_simpleTV.Control.SetTitle(title .. year)
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.ChangeAddress = 'No'
	retAdr = retAdr:gsub('\\/', '/')
	retAdr = retAdr:gsub('^//', 'http://')
	if retAdr:match('svetacdn%.') then retAdr = retAdr .. '&embed=' .. kpid end
	m_simpleTV.Control.CurrentAddress = retAdr

	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')
	dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\video\\hdvb.lua')
	dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\video\\collaps.lua')
	dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\video\\kodik.lua')
-- debug_in_file(retAdr .. '\n')