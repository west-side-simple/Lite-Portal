-- видеоскрипт для сайта https://rezka.ag (22.05.25)
-- author west_side
-- ## открывает подобные ссылки ##
-- https://hdrezka.ag/films/comedy/31810-horoshie-malchiki-2019.html
-- https://hdrezka.ag/series/fiction/34492-porogi-vremeni-1993.html
-- https://hdrezka.ag/franchises/999-vse-filmy-sagi-beskonechnosti/
-- https://hdrezka.ag/collections/741-serialy-cbs/
-- https://hdrezka.ag/person/4694-dzhinnifer-gudvin/

-- ## прокси ##
	local proxy = ''

	if m_simpleTV.Control.ChangeAddress ~= 'No' then
		return
	end
	if not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezka%.ag/.+')
		and not m_simpleTV.Control.CurrentAddress:match('^https?://%a+hdrezka%.com/.+')
		and not m_simpleTV.Control.CurrentAddress:match('^https?://rezkery%.com/.+')
		and not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezka%..+')
		and not m_simpleTV.Control.CurrentAddress:match('^http?://kinopub%.me.+')
		and not m_simpleTV.Control.CurrentAddress:match('^https?://rezka%.fi/.+')
		and not m_simpleTV.Control.CurrentAddress:match('^https?://rezka%-ua%.in/.+')
		and not m_simpleTV.Control.CurrentAddress:match('^https?://rezka%-ua%.org/.+') then
		return
	end
	if m_simpleTV.Control.CurrentAddress:match('/person/') then
		person_rezka_work(m_simpleTV.Control.CurrentAddress)
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = 'wait'
		return
	end
	if m_simpleTV.Control.CurrentAddress:match('/collections/') then
		collection_rezka_url(m_simpleTV.Control.CurrentAddress)
		m_simpleTV.Control.CurrentAddress = 'wait'
	end
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then
		tooltip_body = ''
	else
		tooltip_body = 'bgcolor="#182633"'
	end
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- ## зеркало ##
	local zerkalo = getConfigVal('zerkalo/rezka') or ''

	require 'playerjs'
	local inAdr = m_simpleTV.Control.CurrentAddress
	if zerkalo and zerkalo ~= '' then
		inAdr = inAdr:gsub('^http.-://.-/',zerkalo)
	end

	local inAdr1 = inAdr:gsub('%&.-$','')
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	local logo = 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png'
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'hdrezka ошибка: ' .. str, showTime = 5000, color = 0xffff1000, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
--	m_simpleTV.Control.CurrentAddress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
	if not session then
		showError('нет сессии')
		return
	end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.rezka then
		m_simpleTV.User.rezka = {}
	end
	if not m_simpleTV.User.YT then
		m_simpleTV.User.YT = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	if not m_simpleTV.User.TVPortal.get then
		m_simpleTV.User.TVPortal.get = {}
	end
	if not m_simpleTV.User.TVPortal.get.TMDB then
		m_simpleTV.User.TVPortal.get.TMDB = {}
	end
	m_simpleTV.User.rezka.ThumbsInfo = nil
	m_simpleTV.User.rezka.PositionThumbsHandler = nil
	m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo = nil
	m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = nil
	m_simpleTV.User.YT.ThumbsInfo = nil
	m_simpleTV.User.YT.PositionThumbsHandler = nil
	m_simpleTV.User.filmix.CurAddress = nil
	if not m_simpleTV.User.rezka.CurAddress or m_simpleTV.User.rezka.CurAddress==nil or m_simpleTV.User.rezka.CurAddress and m_simpleTV.User.rezka.CurAddress ~= inAdr1 then
		m_simpleTV.User.rezka.trTabl = nil
		m_simpleTV.User.rezka.trTabl_all = nil
		m_simpleTV.User.rezka.logo = nil
		m_simpleTV.User.rezka.title = nil
		m_simpleTV.User.rezka.AllTranslate = nil
		m_simpleTV.User.rezka.TabEpisodes = nil
	end
	m_simpleTV.User.rezka.CurAddress = inAdr1
	m_simpleTV.User.westSide.PortalTable = true
	m_simpleTV.User.TVPortal.balanser = 'HDRezka'
	m_simpleTV.User.rezka.DelayedAddress = nil
	m_simpleTV.User.rezka.tr_id = inAdr:match('%&translator_id=(%d+)')

	if zerkalo == '' then
		m_simpleTV.User.rezka.host = 'https://hdrezka.ag/'
	else
		m_simpleTV.User.rezka.host = zerkalo
	end

	local function Check_Current_Translate()
		local current_tr = m_simpleTV.User.rezka.tr_id or m_simpleTV.User.rezka.trTabl[1].Address
		for i = 1, #m_simpleTV.User.rezka.trTabl do
			if tonumber(m_simpleTV.User.rezka.trTabl[i].Address) == tonumber(current_tr) then
				m_simpleTV.User.rezka.tr_id = m_simpleTV.User.rezka.trTabl[i].Address
				m_simpleTV.User.rezka.tr = m_simpleTV.User.rezka.trTabl[i].Name
				return
			end
		end
		m_simpleTV.User.rezka.tr_id = m_simpleTV.User.rezka.trTabl[1].Address
		m_simpleTV.User.rezka.tr = m_simpleTV.User.rezka.trTabl[1].Name
	end

	local function get_trTabl_for_episode(season, episode)
--		debug_in_file(season .. ' / ' .. episode .. '\n---\n','c://1/isser_rezka1.txt')
		local t, j = {}, 1
		for i = 1,#m_simpleTV.User.rezka.AllTranslate do
--		debug_in_file(m_simpleTV.User.rezka.AllTranslate[i].Name1 .. ' / ' .. m_simpleTV.User.rezka.AllTranslate[i].Address2 .. '\n','c://1/isser_rezka1.txt')
			local s = m_simpleTV.User.rezka.AllTranslate[i].Address1:match('season=(%d+)')
			local e = m_simpleTV.User.rezka.AllTranslate[i].Address1:match('episode=(%d+)')
			if tonumber(season) == tonumber(s) and tonumber(episode) == tonumber(e) then
				t[j] = {}
				t[j].Id = j
				t[j].Name = m_simpleTV.User.rezka.AllTranslate[i].Name1
				t[j].Address = m_simpleTV.User.rezka.AllTranslate[i].Address2
				j = j + 1
			end
		end
		return t
	end

	function Check_Translate()
		local proxy = ''
		local session = {}
		local data_id = m_simpleTV.User.rezka.CurAddress:match('/(%d+)')
		local url = m_simpleTV.User.rezka.host .. 'ajax/get_cdn_series/?t=' .. os.time()
		local i,t = 1,{}
		for j = 1,#m_simpleTV.User.rezka.trTabl_all do
			session[j] = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
			m_simpleTV.Http.SetTimeout(session[j], 8000)
---------------
			local host
			if zerkalo ~= '' then
			host = zerkalo:gsub('/$','')
			else
			host = 'https://hdrezka.ag'
			end
--[[			local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rezka') end, err)
			if not login or not password or login == '' or password == '' then
				m_simpleTV.User.rezka.cookies = ''
			else
				local rc1, answer1 = m_simpleTV.Http.Request(session[j], {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0', url = host .. '/ajax/login/', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host .. '/'})
				if answer1 and answer1:match('"success":true') then
					m_simpleTV.User.rezka.cookies = m_simpleTV.Http.GetCookies(session[j],host)
				else
					m_simpleTV.User.rezka.cookies = ''
				end
			end--]]
---------------
			local tr = m_simpleTV.User.rezka.trTabl_all[j].Address
			local tr_name = m_simpleTV.User.rezka.trTabl_all[j].Name
			local body = 'id=' .. data_id .. '&translator_id=' .. tr .. '&action=get_episodes'
			local headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies
			local rc, answer0 = m_simpleTV.Http.Request(session[j], {url = url, method = 'post', body = body, headers = headers})
			answer0 = unescape3(answer0)
			answer0 = answer0:gsub('\\/', '/')
			answer0 = answer0:gsub('\\', '')
--			debug_in_file(answer0 .. '\n','c://1/ser_rezka.txt')
			local season_id, episode_id
			for w in answer0:gmatch('<li class="b%-simple_episode__item.-</li>') do
				season_id = w:match('season_id="(%d+)')
				episode_id = w:match('episode_id="(%d+)')
				if season_id and episode_id then
					t[i] = {}
					t[i].Name1 = tr_name
					t[i].Address2 = tr
					t[i].Address1 = m_simpleTV.User.rezka.CurAddress .. string.format('&season=%s&episode=%s',season_id,episode_id)
--					debug_in_file(t[i].Name1 .. ' / ' .. t[i].Address2 .. '\n' .. t[i].Address1 .. '\n','c://1/ser_rezka.txt')
					i = i + 1
				end
			end
			m_simpleTV.Http.Close(session[j])
			m_simpleTV.Common.Sleep(200)
			j = j + 1
		end
		m_simpleTV.User.rezka.AllTranslate = t

		local hash, t0 = {}, {}
		for k = 1, #t do
			if not hash[t[k].Address1]
			then
				t0[#t0 + 1] = t[k]
				hash[t[k].Address1] = true
			end
		end
		table.sort(t0, function(a, b) return a.Address1:gsub('(%d)$','0%1'):gsub('(%d)&episode','0%1') < b.Address1:gsub('(%d)$','0%1'):gsub('(%d)&episode','0%1') end)
		for k = 1, #t0 do
			t0[k].Id = k
			t0[k].Address = t0[k].Address1
			t0[k].Name = ' Сезон ' .. t0[k].Address1:match('season=(%d+)') .. ', Эпизод ' .. t0[k].Address1:match('episode=(%d+)')
--			debug_in_file(t0[k].Name .. '\n' .. t0[k].Address .. '\n','c://1/isser_rezka.txt')
		end
		m_simpleTV.User.rezka.TabEpisodes = t0
	end

	local function rezkaDeSex(url)
		url = url:match('#[^"]+')
		if not url then
			 return url
		end
		local player = playerjs.decode(url, m_simpleTV.User.rezka.playerjs_url)
--	 	debug_in_file(player .. '\n============================\n','c://1/rezka_tr.txt')
		return player
	end

	local function rezkaIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('rezka_qlty') or 5000)
		local index = #t
		for i = 1, #t do
			if t[i].qlty >= lastQuality then
				index = i
				break
			end
		end
		if index > 1 then
			if t[index].qlty > lastQuality then
				index = index - 1
			end
		end
		return index
	end

	local function GetRezkaAdr(urls)
		urls = urls:gsub('\\/', '/')
		local t1, i = {}, 1
		local url = urls:match('"url":"[^"]+') or urls
		local qlty, adr
		for qlty, adr in url:gmatch('%[(.-)](http.-//[^%s]+)') do
			t1[i] = {}
			t1[i].Address = adr
			t1[i].Name = qlty
			i = i + 1
		end
		if i == 1 then return end

		local hash, t = {}, {}
		for i = 1, #t1 do
		if not hash[t1[i].Address]
		then
			t[#t + 1] = t1[i]
			hash[t1[i].Address] = true
		end
		end

		local z = {
				{'1080p Ultra', '1080p'},
				{'1080p', '720p'},
				{'720p', '480p'},
				{'480p', '360p'},
				{'360p', '240p'},
				{'2K', '1440p'},
				{'4K', '2160p'},
			}
		local h = {}
		for i = 1, #t do
			t[i].Id = i
			t[i].Address = t[i].Address:gsub('^https://', 'http://'):gsub(':hls:manifest%.m3u8', '') .. '$OPT:NO-STIMESHIFT$OPT:demux=mp4,any$OPT:http-referrer=https://hdrezka.ag/' .. (subt or '')
--			t[i].Address = t[i].Address:gsub('^https://', 'http://'):gsub(':hls:manifest%.m3u8', '') .. '$OPT:NO-STIMESHIFT' .. (subt or '')
--			t[i].Address = t[i].Address .. (subt or '')
			for j = 1, #z do
				if t[i].Name == z[j][1] and not h[i] then
					t[i].Name = z[j][2]
					h[i] = true
				 break
				end
			end
			t[i].qlty = tonumber(t[i].Name:match('%d+'))
		end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		m_simpleTV.User.rezka.Tab = t
		local index = rezkaIndex(t)
		return t[index].Address
	end

	local function rezkaISubt(url)
		local subt = url:match('"subtitle":"[^"]+')
		if subt then
			subt = subt:gsub('\\/', '/')
			local s = {}
			for w in subt:gmatch('http.-%.vtt') do
				s[#s + 1] = w:gsub('://', '/webvtt://')
			end
			subt = '$OPT:sub-track=0$OPT:input-slave=' .. table.concat(s, '#')
		end
		return subt
	end

	local function time_ms(str)
		if str == nil then return end
		local h,m,s,ms = str:match('(%d+)%:(%d+)%:(%d+)%.(%d+)')
		ms = (tonumber(h)*60*60 + tonumber(m)*60 + tonumber(s))*1000
		return ms
	end

	local function pars_thumb(thumb_url)
		local session1 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session1 then return end
		m_simpleTV.Http.SetTimeout(session1, 2000)
		local rc, answer = m_simpleTV.Http.Request(session1, {url = thumb_url:gsub('\\/','/')})
		if rc ~= 200 then
		 m_simpleTV.Http.Close(session1)
		 m_simpleTV.User.rezka.ThumbsInfo = nil
		 return
		end
			local samplingFrequency, thumbWidth, thumbHeight = answer:match('%-%-%> (%d+%:%d+%:%d+.%d+)\n.-0%,0%,(%d+)%,(%d+)\n')
			if not samplingFrequency then
			 m_simpleTV.Http.Close(session1)
			 m_simpleTV.User.rezka.ThumbsInfo = nil
			 return
			end
			samplingFrequency = time_ms(samplingFrequency)
		local t,i,k,j = {},1,1,1
		for str in answer:gmatch('http.-\n') do
			local adr = str:match('(http.-%.jpg)#')

			if not adr then break end
			t[j] = {}
			if k == 26 then k = 1 end
			if k == 1 then
			t[j].url = adr
--			debug_in_file(adr .. '\n')
			j=j+1
			end
			k=k+1
			i=i+1
		end
		if m_simpleTV.Control.MainMode ~= 0 then m_simpleTV.Http.Close(session1) return end
		m_simpleTV.User.rezka.ThumbsInfo = nil
		m_simpleTV.User.rezka.ThumbsInfo = {}
		m_simpleTV.User.rezka.ThumbsInfo.samplingFrequency = samplingFrequency
		m_simpleTV.User.rezka.ThumbsInfo.thumbsPerImage = 25
		m_simpleTV.User.rezka.ThumbsInfo.thumbWidth = thumbWidth
		m_simpleTV.User.rezka.ThumbsInfo.thumbHeight = thumbHeight
		m_simpleTV.User.rezka.ThumbsInfo.urlPattern = t

		if not m_simpleTV.User.rezka.PositionThumbsHandler then
			local handlerInfo = {}
			handlerInfo.luaFunction = 'PositionThumbs_Rezka'
			handlerInfo.regexString = 'rezka\.ag|kinopub\.me|rezka\.fi|hdrezka|rezkery\.com|rezka\-ua\.in|rezka\-ua\.org'
			handlerInfo.sizeFactor = 0.15
			handlerInfo.backColor = ARGB(127, 30, 33, 61)
			handlerInfo.textColor = ARGB(255, 255, 215, 0)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			handlerInfo.marginBottom = 5
			handlerInfo.showPreviewWhileSeek = false
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = thumbWidth
			handlerInfo.minImageHeight = thumbHeight
			m_simpleTV.User.rezka.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
		m_simpleTV.Http.Close(session1)
	end

	function Qlty_rezka()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.rezka.Tab
			if not t then return end
		local index = rezkaIndex(t)
			if m_simpleTV.User.rezka.trTabl and #m_simpleTV.User.rezka.trTabl and #m_simpleTV.User.rezka.trTabl > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'GetTranslate()'}
			else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			end
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⓘ '}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ HDrezka - качество', index - 1, t, 5000, 1 + 4 + 2)

		if ret == 1 then
			m_simpleTV.Config.SetValue('rezka_qlty', t[id].qlty)
			m_simpleTV.Control.PlayAddressT({address=m_simpleTV.Control.CurrentAddress, position=m_simpleTV.Control.GetPosition()})
		end
		if ret == 2 then
			media_info_rezka(m_simpleTV.User.rezka.CurAddress)
		end
		if ret == 3 and m_simpleTV.User.rezka.trTabl then
			GetTranslate()
		end
	end

	function GetTranslate()
		local t = m_simpleTV.User.rezka.trTabl
		if not t then return end
		local current_tr_id
		for i = 1,#t do
			if m_simpleTV.User.rezka.tr_id and t[i].Address == m_simpleTV.User.rezka.tr_id then
				current_tr_id = i - 1
			end
			i = i + 1
		end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_rezka()'}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⓘ '}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 HDrezka - озвучка', (current_tr_id or 0), t, 5000, 1 + 4 + 2)
		if ret == 1 then
			m_simpleTV.User.rezka.tr = t[id].Name
			m_simpleTV.Control.CurrentAddress = m_simpleTV.Control.CurrentAddress:gsub('%&translator_id=%d+','') ..'&translator_id=' .. t[id].Address
			m_simpleTV.Control.PlayAddressT({address=m_simpleTV.Control.CurrentAddress:gsub('%&translator_id=%d+','') ..'&translator_id=' .. t[id].Address, position=m_simpleTV.Control.GetPosition()})
		end
		if ret == 2 then
			media_info_rezka(m_simpleTV.User.rezka.CurAddress)
		end
		if ret == 3 then
			Qlty_rezka()
		end
	end

	function PositionThumbs_Rezka(queryType, address, forTime)
		if queryType == 'testAddress' then
		 return false
		end
		if queryType == 'getThumbs' then
			if not m_simpleTV.User.rezka.ThumbsInfo or m_simpleTV.User.rezka.ThumbsInfo == nil then
				return true
			end
			local imgLen = m_simpleTV.User.rezka.ThumbsInfo.samplingFrequency * m_simpleTV.User.rezka.ThumbsInfo.thumbsPerImage
			local index = math.floor(forTime / imgLen)
			local t = {}
			t.playAddress = address
			t.url = m_simpleTV.User.rezka.ThumbsInfo.urlPattern[index+1].url
			t.httpParams = {}
			t.httpParams.extHeader = 'referer:' .. address
			t.elementWidth = m_simpleTV.User.rezka.ThumbsInfo.thumbWidth
			t.elementHeight = m_simpleTV.User.rezka.ThumbsInfo.thumbHeight
			t.startTime = index * imgLen
			t.length = imgLen
			t.elementsPerImage = m_simpleTV.User.rezka.ThumbsInfo.thumbsPerImage
			t.marginLeft = 0
			t.marginRight = 0
			t.marginTop = 0
			t.marginBottom = 0
			m_simpleTV.PositionThumbs.AppendThumb(t)
		 return true
		end
	end

	local function bg_imdb_id(imdb_id)
		local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
		local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
		if rc1~=200 then
			m_simpleTV.Http.Close(session)
			return
		end
		require('json')
		answerd = answerd:gsub('(%[%])', '"nil"')
		local tab = json.decode(answerd)
		local background = ''
		if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then
			background = ''
		else
			if tab.movie_results[1] then
				background = tab.movie_results[1].backdrop_path or ''
				poster = tab.movie_results[1].poster_path or ''
			elseif tab.tv_results[1] then
				background = tab.tv_results[1].backdrop_path or ''
				poster = tab.tv_results[1].poster_path or ''
			end
			if background and background ~= nil and background ~= '' then
				background = 'http://image.tmdb.org/t/p/original' .. background
			end
			if poster and poster ~= '' then
				poster = 'http://image.tmdb.org/t/p/original' .. poster
			end
			if poster and poster ~= '' and background == '' then
				background = poster
			end
		end
		if background == nil then
			background = ''
		end
		return background
	end

	local function get_best_stream(url)
		local host
		if zerkalo ~= '' then
		host = zerkalo:gsub('/$','')
		else
		host = 'https://hdrezka.ag'
		end
		local session1 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
		if not session1 then
			showError('нет сессии')
			return
		end
		m_simpleTV.Http.SetTimeout(session1, 8000)
--[[		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rezka') end, err)
		if not login or not password or login == '' or password == '' then
			m_simpleTV.User.rezka.cookies = ''
		else
			local rc1, answer1 = m_simpleTV.Http.Request(session1, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0', url = host .. '/ajax/login/', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host .. '/'})
			if answer1 and answer1:match('"success":true') then
				m_simpleTV.User.rezka.cookies = m_simpleTV.Http.GetCookies(session,host)
			else
				m_simpleTV.User.rezka.cookies = ''
			end
		end--]]
		local rc, answer = m_simpleTV.Http.Request(session1, {url = url, headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc ~= 200 then
			showError('недоступен сайт')
			m_simpleTV.Http.Close(session1)
			return
		end
		local tooltip_body
		if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then
			tooltip_body = ''
		else
			tooltip_body = 'bgcolor="#434750"'
		end
		answer = answer:gsub('\\/', '/')
		answer = answer:gsub('\\"', '"')
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
--		debug_in_file(answer .. '\n', 'c://1/fr.txt')
		local playerjs_url = answer:match('src="([^"]+/js/playerjs[^"]+)')
			if not playerjs_url then return end
		m_simpleTV.User.rezka.playerjs_url = url:match('^http.-//[^/]+') .. playerjs_url
		local adr = answer:match('"streams":"[^"]+')
		if adr then
			adr = rezkaDeSex(adr)
	--		debug_in_file(adr .. '\n', 'c://1/fr.txt')
			adr = adr:match('%[2160p%](http.-%.m3u8)') or adr:match('%[1440p%](http.-%.m3u8)') or adr:match('%[1080p Ultra%](http.-%.m3u8)') or adr:match('%[1080p%](http.-%.m3u8)') or adr:match('%[720p%](http.-%.m3u8)') or adr:match('%[480p%](http.-%.m3u8)') or adr:match('%[360p%](http.-%.m3u8)') or adr:match('%[240p%](http.-%.m3u8)') or ''
		else
			adr = ''
		end
		local title = answer:match('<h1 itemprop="name">([^<]+)') or 'HDrezka'
		local year = answer:match('/year/.-">(%d%d%d%d)') or 0
		local videodesc = info_fox(title:gsub(' /.-$',''), year, '')
		title = title:gsub(' /.-$','') .. ' (' .. year .. ')'
		local poster = answer:match('"og:image" content="([^"]+)')
		local desc = answer:match('"og:description" content="(.-)"%s*/>')
		local desc_text = answer:match('<div class="b%-post__description_text">([^<]+)')
		local imdb_id,tmdb_background,kp_id
		if answer:match('<span class="b%-post__info_rates imdb"><a href="/help/.-" target="_blank" rel="nofollow">IMDb</a>') then
			imdb_id = answer:match('<span class="b%-post__info_rates imdb"><a href="/help/(.-)/"')
			imdb_id = decode64(imdb_id)
			if imdb_id then
				imdb_id = imdb_id:gsub('%%3A', ':'):gsub('%%2F', '/')
				imdb_id = imdb_id:match('imdb%.com/title/(tt.-)/.-$')
				tmdb_background = bg_imdb_id(imdb_id)
				if tmdb_background and tmdb_background~='' then
					poster = tmdb_background
				end
			end
		else
			tmdb_background = ''
			imdb_id = ''
		end
		if answer:match('<span class="b%-post__info_rates kp"><a href="/help/.-" target="_blank" rel="nofollow">Кинопоиск</a>') then
			kp_id = answer:match('<span class="b%-post__info_rates kp"><a href="/help/(.-)"')
			kp_id = decode64(kp_id)
			kp_id = kp_id:gsub('%%3A', ':'):gsub('%%2F', '/')
			kp_id = kp_id:match('kinopoisk%.ru/.-/(%d+)/.-$')
		else
			kp_id = ''
		end
		m_simpleTV.Http.Close(session1)
		return adr,poster,title,desc_text,'<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
	end

	local function play(retAdr, title, id_rezka)

		local subt = rezkaISubt(retAdr)
		local thumb_url = retAdr:match('"thumbnails":"(.-)"')
		if thumb_url and thumb_url ~= ''
		then
		thumb_url = m_simpleTV.User.rezka.host .. thumb_url:gsub('\\','')
		pars_thumb(thumb_url)
		end
		retAdr = rezkaDeSex(retAdr)
--		debug_in_file( '\n' .. retAdr .. '\n', 'c://1/hdrezka.txt', setnew )
			if not retAdr or retAdr == '' then
				showError('недоступно')
			 return
			end
		retAdr = GetRezkaAdr(retAdr)
			if not retAdr then
				showError('недоступно')
			 return
			end
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
		retAdr = retAdr .. (subt or '')
		m_simpleTV.Control.CurrentAddress = retAdr
-- debug_in_file(retAdr .. '\n')
	end

	local function GetNameTr(answer)
		local transl = answer:match('<ul id="translators%-list".-</ul>')
		if transl == nil then
			return answer:match('<h2>В переводе</h2>:</td> <td>(.-)</td>') or 'Оригинал'
		end
		for w in transl:gmatch('<li.-</li>') do
				local name = w:match('title="([^"]+)') or 'NN'
				local Adr = w:match('data%-translator_id="([^"]+)')
					if not name or not Adr then break end
				if Adr == '376' then name = name .. '(ukr)' end
				if Adr == m_simpleTV.User.rezka.tr_id then return name end
		end
		return false
	end

----------------------------- franchises
	if inAdr:match('/franchises/') then
-- ## убрать ThumbsInfo
		if m_simpleTV.User.rezka and m_simpleTV.User.rezka.ThumbsInfo then m_simpleTV.User.rezka.ThumbsInfo = nil end
-- ##
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr .. '?app_rules=1', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc ~= 200 then
			showError('недоступен сайт')
			m_simpleTV.Http.Close(session)
			return
		end
		local title = answer:match('<h1>Смотреть все(.-)</h1></div>') or 'Rezka franchises'
		local poster = answer:match('"image_src" href="(.-)"') or ''
		if m_simpleTV.Control.MainMode == 0 then
			if poster ~= '' then
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster, TypeBackColor = 0, UseLogo = 1, Once = 1})
			else
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 1, Once = 1})
			end
		end
		m_simpleTV.Control.SetTitle(title:gsub(' в HD онлайн',''))
		if m_simpleTV.Control.MainMode == 0 then
			m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
			m_simpleTV.Control.ChangeChannelName(title:gsub(' в HD онлайн',''), m_simpleTV.Control.ChannelID, true)
		end
		local t,i = {},1
		for w in answer:gmatch('<div class="b%-post__partcontent_item".-</div></div>') do
			local adr,name,year = w:match('url="(.-)".-href=".-">(.-)<.-year">(.-)<')
			if not adr or not name then break end
				t[i] = {}
				t[i].Name = name .. ' (' .. year .. ')'
				t[i].Address,t[i].InfoPanelLogo,t[i].InfoPanelName,t[i].InfoPanelTitle,t[i].InfoPanelDesc = get_best_stream(adr)
				t[i].InfoPanelShowTime = 10000
				m_simpleTV.OSD.ShowMessageT({text = 'Загрузка коллекции ' .. i
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})
			i=i+1
		end
		local t1,j = {},1
		t1 = table_reverse(t)
		for i = 1, #t1 do
		if t1[i].Address ~= '' then
			t1[i].Id = i
			j = j + 1
		end
		end
		if t1[1] and t1[1].Address then
			m_simpleTV.Control.CurrentAddress = t1[1].Address
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 ', ButtonScript = 'franchises_rezka_url(\'' .. inAdr .. '\')'}
		m_simpleTV.OSD.ShowSelect_UTF8(title:gsub(' в HD онлайн','') .. ' (' .. j - 1 .. ')', 0, t1, 8000, 2 + 64)

		m_simpleTV.Control.CurrentTitle_UTF8 = title:gsub(' в HD онлайн','')
		m_simpleTV.OSD.ShowMessageT({text = title:gsub(' в HD онлайн',''), color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
--		m_simpleTV.Control.ExecuteAction(37)
		return
	end
-----------------------------

	local title, year, videodesc, poster, desc, desc_text, imdb_id, kp_id, tmdb_background
	local logo = 'https://hdrezka.ag/templates/hdrezka/images/dwnapp_logo.png'
	local host
	if zerkalo ~= '' then
	host = zerkalo:gsub('/$','')
	else
	host = 'https://hdrezka.ag'
	end
	local id_rezka = inAdr:match('/(%d+)')
	if tonumber(id_rezka) == 74605 then m_simpleTV.User.rezka.CurAddress = m_simpleTV.User.rezka.CurAddress:gsub('%-latest%.html','.html'):gsub('%.html','-latest.html') end
--[[	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rezka') end, err)
	if not login or not password or login == '' or password == '' then
		m_simpleTV.User.rezka.cookies = ''
	else
		local rc1, answer1 = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0', url = host .. '/ajax/login/', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host .. '/'})
		if answer1 and answer1:match('"success":true') then
			m_simpleTV.User.rezka.cookies = m_simpleTV.Http.GetCookies(session,host)
		else
			m_simpleTV.User.rezka.cookies = ''
		end
	end--]]
	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.User.rezka.CurAddress .. '?app_rules=1', headers = 'X-Requested-With: XMLHttpRequest\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36\nCookie: ' .. m_simpleTV.User.rezka.cookies})
--	debug_in_file(m_simpleTV.User.rezka.CurAddress .. '?app_rules=1' .. '\n' .. rc .. '\n' .. answer .. '\n','c://1/inforezka.txt')
		if rc ~= 200 and rc ~= 301 then
			m_simpleTV.Common.Sleep(200)
			rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.User.rezka.CurAddress .. '?app_rules=1', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
			if rc ~= 200 and rc ~= 301 then
				showError('недоступен сайт rc: ' .. rc)
				m_simpleTV.Http.Close(session)
				return
			end
		end

	answer = answer:gsub('\\/', '/')
	answer = answer:gsub('\\"', '"')
	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local playerjs_url = answer:match('src="([^"]+/js/playerjs[^"]+)')
	if not playerjs_url then
		return
	end
	m_simpleTV.User.rezka.playerjs_url = inAdr:match('^http.-//[^/]+') .. playerjs_url

	if not m_simpleTV.User.rezka.title or m_simpleTV.User.rezka.title == nil then
		title = title or answer:match('<h1 itemprop="name">([^<]+)') or 'HDrezka'
		year = answer:match('/year/.-">(%d%d%d%d)') or 0
		title = title:gsub(' /.-$',''):gsub(' %(.-$','') .. ' (' .. year .. ')'
		poster = answer:match('"og:image" content="([^"]+)') or logo
		desc = answer:match('"og:description" content="(.-)"%s*/>')
		desc_text = answer:match('<div class="b%-post__description_text">([^<]+)')
		add_to_history_rezka(inAdr1, title, poster)
		if answer:match('<span class="b%-post__info_rates imdb"><a href="/help/.-" target="_blank" rel="nofollow">IMDb</a>') then
			imdb_id = answer:match('<span class="b%-post__info_rates imdb"><a href="/help/(.-)/"')
			imdb_id = decode64(imdb_id)
			if imdb_id then
				imdb_id = imdb_id:gsub('%%3A', ':'):gsub('%%2F', '/')
				imdb_id = imdb_id:match('imdb%.com/title/(tt.-)/.-$')
				tmdb_background = bg_imdb_id(imdb_id)
				if tmdb_background and tmdb_background~='' then
					poster = tmdb_background
				end
			end
		else
			tmdb_background = ''
			imdb_id = ''
		end
		if answer:match('<span class="b%-post__info_rates kp"><a href="/help/.-" target="_blank" rel="nofollow">Кинопоиск</a>') then
			kp_id = answer:match('<span class="b%-post__info_rates kp"><a href="/help/(.-)"')
			kp_id = decode64(kp_id)
			kp_id = kp_id:gsub('%%3A', ':'):gsub('%%2F', '/')
			kp_id = kp_id:match('kinopoisk%.ru/.-/(%d+)/.-$')
		else
			kp_id = ''
		end
		m_simpleTV.User.rezka.logo = poster
		m_simpleTV.User.rezka.title = title
	end

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = m_simpleTV.User.rezka.logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.rezka.logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(m_simpleTV.User.rezka.title, m_simpleTV.Control.ChannelID, false)
	end
	m_simpleTV.Control.SetTitle(m_simpleTV.User.rezka.title)
	videodesc = info_fox(m_simpleTV.User.rezka.title:gsub(' %(.-$',''), m_simpleTV.User.rezka.title:match('%(%d%d%d%d') or 0, m_simpleTV.User.rezka.logo)
------------------------------------------------------------------------------
	local tr = answer:match('<ul id="translators%-list".-</ul>') or ''
	debug_in_file(tr .. '\n')
	local tr0 = answer:match('initCDNSeriesEvents%(' .. id_rezka .. ',%s*(%d+)') or answer:match('initCDNMoviesEvents%(' .. id_rezka .. ',%s*(%d+)') or 0

	if not id_rezka then
		showError('нет id_rezka')
		return
	end

	m_simpleTV.Http.Close(session)

	local rc
	local serial, movie
	local season, episode = inAdr:match('season=(%d+).-episode=(%d+)')
	local current_ep = 1

	if answer:match('initCDNSeriesEvents%(' .. id_rezka .. ',%s*(%d+)') then
		serial = true
	elseif answer:match('initCDNMoviesEvents%(' .. id_rezka .. ',%s*(%d+)') then
		movie = true
	else
		showError('видео недоступно')
		media_info_rezka(m_simpleTV.User.rezka.CurAddress)
		return
	end

	if (serial or movie) and not m_simpleTV.User.rezka.trTabl_all then
		local t, i = {}, 1
		for w in tr:gmatch('<li.-</li>') do	
			local name = w:match('title="([^"]+)') or 'NN'
			local Adr = w:match('data%-translator_id="([^"]+)')
			if not name or not Adr then
				break
			end
			if w:match('data%-translator_id="(.-)"') == '376' then
				name = name .. '(ukr)'
			end
			t[i] = {}
			t[i].Id = i
			t[i].Name = name
			t[i].Address = Adr			
			i = i + 1
		end
		if #t == 0 then
			for w in tr:gmatch('<a.-</a>') do
			local name = w:match('title="([^"]+)') or 'NN'
			local Adr = w:match('data%-translator_id="([^"]+)')
			if not name or not Adr then
				break
			end
			if w:match('data%-translator_id="(.-)"') == '376' then
				name = name .. '(ukr)'
			end
			t[i] = {}
			t[i].Id = i
			t[i].Name = name
			t[i].Address = Adr			
			i = i + 1
		end
		end
		if #t == 0 then
			t[1] = {}
			t[1].Id = 1
			t[1].Name = answer:match('<h2>В переводе</h2>:</td> <td>(.-)</td>') or 'Оригинал'
			t[1].Address = tr0
		end
		m_simpleTV.User.rezka.trTabl_all = t
	end

	if serial and not m_simpleTV.User.rezka.TabEpisodes and m_simpleTV.User.rezka.trTabl_all then
		Check_Translate()
		m_simpleTV.Common.Sleep(2000)
	end

	if movie and not m_simpleTV.User.rezka.trTabl and m_simpleTV.User.rezka.trTabl_all then
		m_simpleTV.User.rezka.trTabl = m_simpleTV.User.rezka.trTabl_all
	end

	if serial and m_simpleTV.User.rezka.TabEpisodes and m_simpleTV.User.rezka.trTabl_all then
		if not season or not episode then
			season = m_simpleTV.User.rezka.TabEpisodes[1].Address:match('season=(%d+)')
			episode = m_simpleTV.User.rezka.TabEpisodes[1].Address:match('episode=(%d+)')
		end
		m_simpleTV.User.rezka.trTabl = get_trTabl_for_episode(season, episode)
		Check_Current_Translate()

		for i = 1, #m_simpleTV.User.rezka.TabEpisodes do
			local s = m_simpleTV.User.rezka.TabEpisodes[i].Address:match('season=(%d+)')
			local e = m_simpleTV.User.rezka.TabEpisodes[i].Address:match('episode=(%d+)')
			if tonumber(season) == tonumber(s) and tonumber(episode) == tonumber(e) then
				current_ep = i
			end
		end
		local t = {}
		for i = 1,#m_simpleTV.User.rezka.TabEpisodes do
			t[i]={}
			t[i].Id = m_simpleTV.User.rezka.TabEpisodes[i].Id
			t[i].Name = m_simpleTV.User.rezka.TabEpisodes[i].Name
			t[i].Address = m_simpleTV.User.rezka.TabEpisodes[i].Address .. '&translator_id=' .. m_simpleTV.User.rezka.tr_id
		end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_rezka()'}
		if m_simpleTV.User.rezka.trTabl and #m_simpleTV.User.rezka.trTabl > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'GetTranslate()'}
		else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.rezka.title, current_ep - 1, t, 10000, 32)
		title = m_simpleTV.User.rezka.title .. m_simpleTV.User.rezka.TabEpisodes[current_ep].Name
		local session_tv = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
		if not session_tv then
			showError('нет сессии')
			return
		end
		m_simpleTV.Http.SetTimeout(session_tv, 8000)
		---------------
		local host
		if zerkalo ~= '' then
		host = zerkalo:gsub('/$','')
		else
		host = 'https://hdrezka.ag'
		end
--[[		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rezka') end, err)
		if not login or not password or login == '' or password == '' then
			m_simpleTV.User.rezka.cookies = ''
		else
			local rc1, answer1 = m_simpleTV.Http.Request(session_tv, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0', url = host .. '/ajax/login/', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host .. '/'})
			if answer1 and answer1:match('"success":true') then
				m_simpleTV.User.rezka.cookies = m_simpleTV.Http.GetCookies(session_tv,host)
			else
				m_simpleTV.User.rezka.cookies = ''
			end
		end--]]
		---------------
		local url = m_simpleTV.User.rezka.host .. 'ajax/get_cdn_series/?t=' .. os.time()
		local body = 'id=' .. id_rezka .. '&' .. m_simpleTV.User.rezka.TabEpisodes[current_ep].Address .. '&translator_id=' .. m_simpleTV.User.rezka.tr_id .. '&action=get_stream'
		local headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies
		rc, inAdr = m_simpleTV.Http.Request(session_tv, {url = url, method = 'post', body = body, headers = headers})
		if rc ~= 200 then
			rc, inAdr = m_simpleTV.Http.Request(session_tv, {url = url, method = 'post', body = body, headers = headers})
			if rc ~= 200 then
				showError('неудовлетворительный ответ')
				m_simpleTV.Http.Close(session_tv)
				return
			end
		end
		if not inAdr:match('"success":true') then
			inAdr = answer:match('data%-translator_id="' .. m_simpleTV.User.rezka.tr_id .. '"%s+data%-cdn_url="([^"]+)') or answer:match('"streams":"([^"]+)')
			if not inAdr then
				showError('видео недоступно')
				m_simpleTV.Http.Close(session_tv)
				media_info_rezka(m_simpleTV.User.rezka.CurAddress)
				return
			end
			inAdr = inAdr .. (answer:match('"subtitle":"[^"]+') or '')
		end
	end

	if movie and m_simpleTV.User.rezka.trTabl then
		local session_movie = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
		if not session_movie then
			showError('нет сессии')
			return
		end
		m_simpleTV.Http.SetTimeout(session_movie, 2000)
		---------------
		local host
		if zerkalo ~= '' then
		host = zerkalo:gsub('/$','')
		else
		host = 'https://hdrezka.ag'
		end
--[[		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rezka') end, err)
		if not login or not password or login == '' or password == '' then
			m_simpleTV.User.rezka.cookies = ''
		else
			local rc1, answer1 = m_simpleTV.Http.Request(session_movie, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0', url = host .. '/ajax/login/', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host .. '/'})
			if answer1 and answer1:match('"success":true') then
				m_simpleTV.User.rezka.cookies = m_simpleTV.Http.GetCookies(session_movie,host)
			else
				m_simpleTV.User.rezka.cookies = ''
			end
		end--]]
		---------------
		local current_tr = m_simpleTV.User.rezka.tr_id or m_simpleTV.User.rezka.trTabl[1].Address
		m_simpleTV.User.rezka.tr = GetNameTr(answer) or m_simpleTV.User.rezka.trTabl[1].Name
		local url = host .. '/ajax/get_cdn_series/?t=' .. os.time()
		local body = 'id=' .. id_rezka .. '&translator_id=' .. current_tr .. '&action=get_movie'
		local headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies
		rc, inAdr = m_simpleTV.Http.Request(session_movie, {url = url, method = 'post', body = body, headers = headers})
		if rc ~= 200 then
			showError('неудовлетворительный ответ')
			m_simpleTV.Http.Close(session_movie)
			return
		end
		if not inAdr:match('"success":true') then
			inAdr = answer:match('data%-translator_id="' .. current_tr .. '"%s+data%-cdn_url="([^"]+)') or answer:match('"streams":"([^"]+)')
			if not inAdr then
				showError('видео недоступно')
				media_info_rezka(m_simpleTV.User.rezka.CurAddress)
				return
			end
			inAdr = inAdr .. (answer:match('"subtitle":"[^"]+') or '')
		end
		local t = {}
		t[1] = {}
		t[1].Id = 1
		t[1].Name = '🎬 HDrezka - опции'

		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_rezka()'}
		if m_simpleTV.User.rezka.trTabl and #m_simpleTV.User.rezka.trTabl > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'GetTranslate()'}
		else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.rezka.title, 0, t, 8000, 32 + 64 + 128)
		m_simpleTV.Http.Close(session_movie)
		title = m_simpleTV.User.rezka.title
	end

	play(inAdr, title .. ' - ' .. (m_simpleTV.User.rezka.tr or 'выбор HDRezka'), id_rezka)