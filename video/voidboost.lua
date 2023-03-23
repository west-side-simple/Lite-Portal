-- видеоскрипт для запросов потоков Rezka по ID кинопоиска и IMDB (18.03.23)
-- nexterr, west_side
-- ## открывает подобные ссылки ##
-- https://voidboost.net/embed/280179
-- https://voidboost.net/embed/tt0108778
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://voidboost%.net/.+')
		then
		 return
		end
	local userAgent = 'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
	local session = m_simpleTV.Http.New(userAgent, proxy, false)
		if not session then
			showError('1')
		 return
		end
	m_simpleTV.Http.SetTimeout(session, 30000)
	require 'playerjs'

	local function imdbid(kpid)
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
	local background, name_tmdb, year_tmdb = '', '', ''
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then background = '' else
	if tab.movie_results[1] and imdb_id ~= 'tt0078655' and imdb_id ~= 'tt2317100' then
	background = tab.movie_results[1].backdrop_path or ''
	name_tmdb = tab.movie_results[1].title or ''
	year_tmdb = tab.movie_results[1].release_date or 0
	name_tmdb = name_tmdb .. ' (' .. year_tmdb:match('(%d+)') .. ')'
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	name_tmdb = tab.tv_results[1].name or ''
	end
	end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if background == nil then background = '' end
	return background, name_tmdb
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local proxy = ''
	local background
	local inAdr = m_simpleTV.Control.CurrentAddress
	local imdb_id
	local kp_id
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Rezka then
		m_simpleTV.User.Rezka = {}
	end
	m_simpleTV.User.Rezka.title = nil
	m_simpleTV.User.Rezka.year = nil
	if inAdr:match('/embed/')
	then m_simpleTV.User.Rezka.embed = inAdr:match('/embed/(.-)$') m_simpleTV.User.Rezka.embed = m_simpleTV.User.Rezka.embed:gsub('%&.-$','')
	elseif inAdr:match('%&embed=')
	then m_simpleTV.User.Rezka.embed = inAdr:match('%&embed=(.-)$') inAdr = inAdr:gsub('%&embed=.-$','')
	end
	imdb_id = m_simpleTV.User.Rezka.embed:match('tt%d+')
	if not imdb_id then kp_id = m_simpleTV.User.Rezka.embed:match('(%d+)') end
	local title_v, year_v, title_b, year_b
	if kp_id then imdb_id, title_v, year_v = imdbid(kp_id) end
	local logo = 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png'
	if imdb_id and imdb_id~='' and bg_imdb_id(imdb_id)~='' then
	m_simpleTV.User.Rezka.background, m_simpleTV.User.Rezka.title = bg_imdb_id(imdb_id)
	m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.Rezka.background, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end
	if not m_simpleTV.User.Rezka.title and title_v and title_v~='' then
		m_simpleTV.User.Rezka.title = title_v .. ' (' .. year_v .. ')'
	elseif not m_simpleTV.User.Rezka.title then
		title_b,year_b = ukp(kp_id)
		m_simpleTV.User.Rezka.title = title_b .. ' (' .. year_b .. ')'
		m_simpleTV.User.Rezka.background = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. kp_id .. '.jpg'
	end
	if not m_simpleTV.User.Rezka.background or m_simpleTV.User.Rezka.background=='' then
		m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end
	m_simpleTV.Control.SetTitle(m_simpleTV.User.Rezka.title)
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'hdrezka ошибка: ' .. str, showTime = 5000, color = 0xffff1000, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	m_simpleTV.User.Rezka.DelayedAddress = nil
	m_simpleTV.User.Rezka.ThumbsInfo = nil
	local function rezkaGetStream(adr)
		local rc, answer = m_simpleTV.Http.Request(session, {url = adr})
			if rc ~= 200 then return end
	 return answer
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
		local subt = urls:match("subtitle\':(.-)return pub")
--		debug_in_file(subt .. '\n')
		if subt then
			local s, j = {}, 1
			for w in subt:gmatch('https.-%.vtt') do
				s[j] = {}
				s[j] = w
				j = j + 1
			end
			subt = '$OPT:sub-track=0$OPT:input-slave=' .. table.concat(s, '#')
		end
		local t, i = {}, 1
		local url = urls:match("file\'(:.-)return pub")
		url = url:gsub(": ",''):gsub("'#",'#'):gsub("'\n.-$",'')
		url = playerjs.decode(url, m_simpleTV.User.Rezka.playerjs_url)
		debug_in_file(url, 'c://1/bas.txt')
		local qlty, adr
			for qlty, adr in url:gmatch('%[(.-)%](http.-) ') do
			if not qlty:match('%d+') then break end
				t[i] = {}
				t[i].Address = adr
				t[i].Name = qlty
				t[i].qlty = tonumber(qlty:match('%d+'))
				i = i + 1
			end
			if i == 1 then return end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address:gsub('^https://', 'http://'):gsub(':hls:manifest%.m3u8', '') .. '$OPT:NO-STIMESHIFT$OPT:demux=mp4,any$OPT:http-referrer=https://rezka.ag/' .. (subt or '')
				t[i].qlty = tonumber(t[i].Name:match('%d+'))
			end
		m_simpleTV.User.Rezka.Tab = t
		local index = rezkaIndex(t)
	 return t[index].Address
	end
	local function time_ms(str)
	local h,m,s,ms = str:match('(%d+)%:(%d+)%:(%d+).(%d+)')
	ms = (tonumber(h)*60*60 + tonumber(m)*60 + tonumber(s))*1000
	return ms
	end
	local function pars_thumb(thumb_url)
	local rc, answer = m_simpleTV.Http.Request(session, {url = thumb_url})
		if rc ~= 200 then
			showError('4')
			m_simpleTV.Http.Close(session)
		 return
		end
			local samplingFrequency, thumbWidth, thumbHeight = answer:match('%-%-%> (%d+%:%d+%:%d+.%d+)\n.-0%,0%,(%d+)%,(%d+)\n')
			samplingFrequency = time_ms(samplingFrequency)
		local t,i,k,j = {},1,1,1
		for str in answer:gmatch('http.-\n') do
			local adr = str:match('(https.-%.jpg)#')

			if not adr then break end
			t[j] = {}
			if k == 26 then k = 1 end
			if k == 1 then
			t[j].url = adr
			j=j+1
			end
			k=k+1
			i=i+1
		end
		if m_simpleTV.Control.MainMode ~= 0 then return end
		m_simpleTV.User.Rezka.ThumbsInfo = {}
		m_simpleTV.User.Rezka.ThumbsInfo.samplingFrequency = samplingFrequency
		m_simpleTV.User.Rezka.ThumbsInfo.thumbsPerImage = 25
		m_simpleTV.User.Rezka.ThumbsInfo.thumbWidth = thumbWidth
		m_simpleTV.User.Rezka.ThumbsInfo.thumbHeight = thumbHeight
		m_simpleTV.User.Rezka.ThumbsInfo.urlPattern = t
		if not m_simpleTV.User.Rezka.PositionThumbsHandler then
			local handlerInfo = {}
			handlerInfo.luaFunction = 'PositionThumbs_Rezka'
			handlerInfo.regexString = ''
			handlerInfo.sizeFactor = 0.20
			handlerInfo.backColor = ARGB(255, 0, 0, 0)
			handlerInfo.textColor = ARGB(240, 127, 255, 0)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			handlerInfo.marginBottom = 0
			handlerInfo.showPreviewWhileSeek = true
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = 80
			handlerInfo.minImageHeight = 45
			m_simpleTV.User.Rezka.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
	end
	local function tmdb_id(imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
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
	function Perevod_rezka(translate, media, adr)
		m_simpleTV.Control.ExecuteAction(36, 0)
		local selected_tr = 0
		local tr, k, istr = {}, 1, false
		for w1 in translate:gmatch('<option.-</option>') do
		tr[k]={}
		local token, val, name = w1:match('<option data%-token="(.-)".-value="(.-)">(.-)</option>')
		if w1:match('selected') then selected_tr = k-1 end
		tr[k].Id = k
		tr[k].Address = 'https://voidboost.net/' .. media .. '/' .. token .. '/iframe?h=voidboost.net'
		if name == '-' then tr[k].Name = 'Оригинал' else tr[k].Name = name end
		if media == 'movie' or media == 'serial' and name == 'Перевод' then istr = true end
		k = k + 1
		end
		if istr == false then
		tr[#tr+1] = {}
		tr[#tr].Id = #tr
		tr[#tr].Address = 'https://voidboost.net/embed/' ..  m_simpleTV.User.Rezka.embed .. '?h=voidboost.net'
		tr[#tr].Name = 'Перевод всех сезонов'
		end
		tr.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_rezka()'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Перевод', selected_tr, tr, 5000, 1 + 4 + 2)
		if m_simpleTV.User.Rezka.isVideo == false then
			if m_simpleTV.User.Rezka.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
		if media == 'movie' then
			m_simpleTV.Control.SetNewAddress(tr[id].Address:gsub('h=voidboost%.net.-$','h=voidboost.net&embed=' .. m_simpleTV.User.Rezka.embed), m_simpleTV.Control.GetPosition())
		elseif media == 'serial' then
		local cur_season, cur_e
		if adr then
		cur_season, cur_e = adr:match('s=(%d+).-e=(%d+)')
		local rc, test = m_simpleTV.Http.Request(session, {url = tr[id].Address:gsub('h=voidboost%.net.-$','s=' .. cur_season .. '&e=' .. cur_e .. '&h=voidboost.net')})
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessageT({text = tr[id].Name .. ': озвучка эпизода отсутствует', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
			Perevod_rezka(translate, media, adr)
		else
			m_simpleTV.Control.SetNewAddress(tr[id].Address:gsub('h=voidboost%.net.-$','s=' .. cur_season .. '&e=' .. cur_e .. '&h=voidboost.net&embed=' .. m_simpleTV.User.Rezka.embed), m_simpleTV.Control.GetPosition())
		end
		else
			m_simpleTV.Control.SetNewAddress(tr[id].Address)
		end
		end
		end
		if ret == 2 then Qlty_rezka() end
	end
	function Season_rezka(season, episodes, Adr, translate)
		m_simpleTV.Control.ExecuteAction(36, 0)
		local s, k = {}, 1
		for w1 in episodes:gmatch('"%d+":%[.-%]') do
		s[k]={}
		local ses, ep = w1:match('"(%d+)":%[.-(%d+)')
		s[k].Id = k
		s[k].Address = Adr:gsub('%?h=.-$',''):gsub('%?s=.-$','') .. '?s=' .. ses .. '&e=' .. ep .. '&h=voidboost.net&embed=' .. m_simpleTV.User.Rezka.embed
		s[k].Name = 'Сезон ' .. ses
		if tonumber(ses) == tonumber(season) then selected_season = k-1 end
		k = k + 1
		end
		s.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_rezka()'}
		s.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'Perevod_rezka(\'' .. m_simpleTV.Common.multiByteToUTF8(translate) .. '\', \'' .. 'serial' .. '\')'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Сезон', selected_season, s, 5000, 1 + 4 + 2)
		if m_simpleTV.User.Rezka.isVideo == false then
			if m_simpleTV.User.Rezka.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
		m_simpleTV.Control.SetNewAddress(s[id].Address)
		end
		if ret == 2 then Qlty_rezka() end
		if ret == 3 then Perevod_rezka(m_simpleTV.Common.multiByteToUTF8(translate), 'serial') end
	end
	function OnMultiAddressOk_rezka(Object, id)
		if id == 0 then
			OnMultiAddressCancel_rezka(Object)
		else
			m_simpleTV.User.rezka.DelayedAddress = nil
		end
	end
	function OnMultiAddressCancel_rezka(Object)
		if m_simpleTV.User.Rezka.DelayedAddress then
			local state = m_simpleTV.Control.GetState()
			if state == 0 then
				m_simpleTV.Control.SetNewAddress(m_simpleTV.User.Rezka.DelayedAddress)
			end
			m_simpleTV.User.Rezka.DelayedAddress = nil
		end
		m_simpleTV.Control.ExecuteAction(36, 0)
	end
	function Qlty_rezka()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.Rezka.Tab
			if not t then return end
		local index = rezkaIndex(t)
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			if getConfigVal('info/scheme') then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = ''}
			end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 2)
		if m_simpleTV.User.Rezka.isVideo == false then
			if m_simpleTV.User.Rezka.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('rezka_qlty', t[id].qlty)
		end
		if ret == 2 then
		if getConfigVal('info/scheme') == 'EXFS' then media_info(getConfigVal('info/media')) end
		if getConfigVal('info/scheme') == 'TMDB' then media_info_tmdb(tmdb_id(getConfigVal('info/imdb'))) end
		if getConfigVal('info/scheme') == 'Rezka' then media_info_rezka(getConfigVal('info/Rezka')) end
		end
	end
	function PositionThumbs_Rezka(queryType, address, forTime)
		if queryType == 'testAddress' and m_simpleTV.User.Rezka and m_simpleTV.User.Rezka.ThumbsInfo and m_simpleTV.User.Rezka.ThumbsInfo ~= nil then
		 if string.match(address, "voidboost%.net")
		 or string.match(address, "kinopoisk%.")
		 or string.match(address, "^*")
		 or string.match(address, "imdb%.")
		 then return true end
		 return false
		end
		if queryType == 'getThumbs' then
				if not m_simpleTV.User.Rezka.ThumbsInfo or m_simpleTV.User.Rezka.ThumbsInfo == nil then
				 return false
				end
			local imgLen = m_simpleTV.User.Rezka.ThumbsInfo.samplingFrequency * m_simpleTV.User.Rezka.ThumbsInfo.thumbsPerImage
			local index = math.floor(forTime / imgLen)
			local t = {}
			t.playAddress = address
			t.url = m_simpleTV.User.Rezka.ThumbsInfo.urlPattern[index+1].url
			t.httpParams = {}
			t.httpParams.extHeader = 'referer:' .. address
			t.elementWidth = m_simpleTV.User.Rezka.ThumbsInfo.thumbWidth
			t.elementHeight = m_simpleTV.User.Rezka.ThumbsInfo.thumbHeight
			t.startTime = index * imgLen
			t.length = imgLen
			t.elementsPerImage = m_simpleTV.User.Rezka.ThumbsInfo.thumbsPerImage
			t.marginLeft = 0
			t.marginRight = 3
			t.marginTop = 0
			t.marginBottom = 0
			m_simpleTV.PositionThumbs.AppendThumb(t)
		 return true
		end
	end
	local function play(adr, title)
	local retAdr = rezkaGetStream(adr)
		retAdr = GetRezkaAdr(retAdr)
			if not retAdr then
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
				showError('3')
			 return
			end
		m_simpleTV.Control.CurrentAddress = retAdr
-- debug_in_file(retAdr .. '\n')
	end
	m_simpleTV.User.Rezka.isVideo = nil
	m_simpleTV.User.Rezka.titleTab = nil
	local title
	if m_simpleTV.User.Rezka.title then
	title = m_simpleTV.User.Rezka.title:gsub(' %(Сезон.-$','')
	else
		title = m_simpleTV.Control.CurrentTitle_UTF8:gsub(' %(Сезон.-$','')
	end
	if title == '' then title = title_v .. ', ' .. year_v end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
		if rc ~= 200 then
			showError('4')
			m_simpleTV.Http.Close(session)
		 return
		end
	if answer:match('<select name="season".-</select>') and not inAdr:match('%?s=') then
		local episodes = answer:match('var seasons_episodes = %{(.-)%}')
		local first_season, first_episodes
		if episodes then
		first_season, first_episodes = episodes:match('"(%d+)":%[.-(%d+)')
		else
		first_season, first_episodes = 0,1
		end
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.SetNewAddress(inAdr:gsub('%?h=.-$','') .. '?s=' .. first_season .. '&e=' .. first_episodes .. '&h=voidboost.net&embed=' .. m_simpleTV.User.Rezka.embed)
		return
	end
	if m_simpleTV.Control.MainMode == 0 and m_simpleTV.User.Rezka.background then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = m_simpleTV.User.Rezka.background, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	if m_simpleTV.Control.MainMode == 0 and not m_simpleTV.User.Rezka.background then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 1, Once = 1})
	end
	m_simpleTV.Control.SetTitle(title)
	local playerjs_url = answer:match('src="([^"]+/playerjsdev[^"]+)')
		if not playerjs_url then return end
	m_simpleTV.User.Rezka.playerjs_url = playerjs_url
	local translate = answer:match('<select name="translator".-</select>')
	local thumb_url = answer:match("thumbnails\': \'(.-)\'")
	if thumb_url and thumb_url ~= ''
	then
	thumb_url = 'https://voidboost.net' .. thumb_url
	pars_thumb(thumb_url)
	end
	local cur_translate = translate:match('selected=.->(.-)<') or 'Перевод'
	if cur_translate == '-' then cur_translate = 'Оригинал' end
		if not answer:match('<select name="season".-</select>') then
		local retAdr = inAdr
		local t = {}
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_rezka()'}
		if translate then
			title = title .. ' - ' .. cur_translate
			m_simpleTV.Control.CurrentTitle_UTF8 = title
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'Perevod_rezka(\'' .. m_simpleTV.Common.multiByteToUTF8(translate) .. '\', \'' .. 'movie' .. '\', \'' .. retAdr .. '\')'}
		end
			m_simpleTV.OSD.ShowSelect_UTF8('HDrezka' .. ' (' .. cur_translate .. ')', 0, t, 8000, 32 + 64 + 128)
		else
			local retAdr = inAdr
			local season = answer:match('<select name="season".-</select>') or ''
			local episodes = answer:match('var seasons_episodes = %{(.-)%}') or ''
			local ep_in_season = answer:match('<select name="episode".-</select>') or ''
			if not inAdr:match('%?s=') then
			cur_season, cur_episodes = episodes:match('"(%d+)":%[.-(%d+)')
			else
			cur_season = season:match('<option value="(%d+)" selected') or 1
			cur_episodes = ep_in_season:match('<option value="(%d+)" selected') or 1
			end
			local t,i = {},1
			for w in ep_in_season:gmatch('<option.-</option>') do
			local ep, ep_name = w:match('<option value="(%d+)".->(.-)</option>')
		t[i] = {}
		t[i].Id = i
		t[i].Name = ep_name
		if tonumber(ep) == tonumber(cur_episodes) then play_ep = i - 1 end
		t[i].Address = inAdr:gsub('%?h=.-$',''):gsub('%?s=.-$','') .. '?s=' .. cur_season .. '&e=' .. ep .. '&h=voidboost.net&embed=' .. m_simpleTV.User.Rezka.embed
		i = i + 1
		end
		m_simpleTV.User.Rezka.titleTab = t
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'Perevod_rezka(\'' .. m_simpleTV.Common.multiByteToUTF8(translate) .. '\', \'' .. 'serial' .. '\', \'' .. retAdr .. '\')'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Сезоны ', ButtonScript = 'Season_rezka(\'' .. cur_season .. '\', \'' .. episodes .. '\', \'' .. retAdr .. '\', \'' .. translate .. '\')'}
		m_simpleTV.OSD.ShowSelect_UTF8('Сезон ' .. cur_season .. ', ' .. cur_translate, play_ep, t, 8000, 32 + 64)
		retAdr = inAdr:gsub('%?h=.-$',''):gsub('%?s=.-$','') .. '?s=' .. cur_season .. '&e=' .. cur_episodes .. '&h=voidboost.net&embed=' .. m_simpleTV.User.Rezka.embed
		retAdr = rezkaGetStream(retAdr)
		retAdr = GetRezkaAdr(retAdr)
		title = title .. ' (Сезон ' .. cur_season .. ', Серия ' .. cur_episodes .. ') - ' .. cur_translate
		inAdr = retAdr
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = inAdr
		return
		end
	play(inAdr, title)