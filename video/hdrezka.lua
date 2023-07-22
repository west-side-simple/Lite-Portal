-- видеоскрипт для сайта https://rezka.ag (22/07/23)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Scripts
-- mod west_side for lite version
-- ## открывает подобные ссылки ##
-- https://rezka.ag/films/comedy/31810-horoshie-malchiki-2019.html
-- https://rezka.ag/series/fiction/34492-porogi-vremeni-1993.html
-- https://rezka.ag/series/comedy/34512-kosmicheskie-voyska-2020.html
-- http://nexthdrezka.com/series/fiction/34385-skvoz-sneg-2020.html
-- http://betahdrezka.com/cartoons/adventures/7717-priklyucheniya-kota-v-sapogah-2015.html
-- ## прокси ##
local proxy = ''
-- '' - нет
-- например 'http://proxy-nossl.antizapret.prostovpn.org:29976'
-- ##
--local zerkalo = ''
--local zerkalo = 'https://rezkery.com/'
--local zerkalo = 'http://upivi.com/'
--local zerkalo = 'http://kinopub.me/'
-- '' - нет
-- например 'https://rezkery.com/'
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://rezka%.ag/.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://%a+hdrezka%.com/.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezka%-ag%.com/.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://rezkery%.com/.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezka%-router%.com/.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezka%..+')
			and not m_simpleTV.Control.CurrentAddress:match('^http?://kinopub%.me.+')
			and not m_simpleTV.Control.CurrentAddress:match('^http?://upivi%.com.+')
			and not m_simpleTV.Control.CurrentAddress:match('^http?://metaivi%.com.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezka19139%.org.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://rd8j1em1zxge%.org.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://m85rnv8njgwv%.org.+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://hdrezkah42yfy%.org/.+')
			and not m_simpleTV.Control.CurrentAddress:match('^%$rezka')
		then
		 return
		end
local tooltip_body
if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
else tooltip_body = 'bgcolor="#182633"'
end
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
local zerkalo = getConfigVal('zerkalo/rezka') or ''
	require 'playerjs'
	local inAdr = m_simpleTV.Control.CurrentAddress
	if zerkalo and zerkalo ~= '' then
	inAdr = inAdr:gsub('^http.-://.-/',zerkalo)
	end
	local inAdr1 = inAdr:gsub('%$rezka.-$','')
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	local logo = 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png'
	if m_simpleTV.Control.MainMode == 0 then
		if not inAdr:match('^%$rezka') and not inAdr:match('/franchises/') then
			m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 1, Once = 1})
		else
			m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 1, Once = 1})
		end
	end
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'hdrezka ошибка: ' .. str, showTime = 5000, color = 0xffff1000, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
		if not session then
			showError('1')
		 return
		end
	m_simpleTV.Http.SetTimeout(session, 30000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.rezka then
		m_simpleTV.User.rezka = {}
	end
	m_simpleTV.User.rezka.DelayedAddress = nil
	if zerkalo == '' then
		m_simpleTV.User.rezka.host = 'https://hdrezka.ag/'
	else
		m_simpleTV.User.rezka.host = zerkalo
	end
	local title
	if m_simpleTV.User.rezka.titleTab then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.rezka.title .. ' - ' .. m_simpleTV.User.rezka.titleTab[index].Name
		end
	end
	local function get_voidboost(kp_id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local url = decode64('aHR0cHM6Ly92b2lkYm9vc3QubmV0L2VtYmVkLw') .. kp_id
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return false
		end
		return url
	end
	local function rezkaDeSex(url)
		url = url:match('#[^"]+')
			if not url then
			 return url
			end
	 return playerjs.decode(url, m_simpleTV.User.rezka.playerjs_url)
	end
	local function rezkaGetStream(adr)
		local url = m_simpleTV.User.rezka.host .. '/ajax/get_cdn_series/?t=' .. os.time()
		local body = adr:gsub('^.-$rezka', '') .. '&action=get_stream'
		local headers = 'X-Requested-With: XMLHttpRequest'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url, method = 'post', body = body, headers = headers})
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
		urls = urls:gsub('\\/', '/')
		local t, i = {}, 1
		local url = urls:match('"url":"[^"]+') or urls
		local qlty, adr
			for qlty, adr in url:gmatch('%[(.-)](http.-//[^%s]+)') do
				t[i] = {}
				t[i].Address = adr
				t[i].Name = qlty
--				t[i].qlty = tonumber(qlty:match('%d+'))
				i = i + 1
			end
			if i == 1 then return end
--		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		local z = {
				{'1080p Ultra', '1080p'},
				{'1080p', '720p'},
				{'720p', '480p'},
				{'480p', '360p'},
				{'360p', '240p'},
			}
		local h = {}
			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address:gsub('^https://', 'http://'):gsub(':hls:manifest%.m3u8', '')
						.. '$OPT:NO-STIMESHIFT$OPT:demux=mp4,any$OPT:http-referrer=https://rezka.ag/' .. (subt or '')
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
			local adr = str:match('(http.-%.jpg)#')

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

		m_simpleTV.User.rezka.ThumbsInfo = {}
		m_simpleTV.User.rezka.ThumbsInfo.samplingFrequency = samplingFrequency
		m_simpleTV.User.rezka.ThumbsInfo.thumbsPerImage = 25
		m_simpleTV.User.rezka.ThumbsInfo.thumbWidth = thumbWidth
		m_simpleTV.User.rezka.ThumbsInfo.thumbHeight = thumbHeight
		m_simpleTV.User.rezka.ThumbsInfo.urlPattern = t

		if not m_simpleTV.User.rezka.PositionThumbsHandler then
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
			m_simpleTV.User.rezka.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
	end
	function OnMultiAddressOk_rezka(Object, id)
		if id == 0 then
			OnMultiAddressCancel_rezka(Object)
		else
			m_simpleTV.User.rezka.DelayedAddress = nil
		end
	end
	function OnMultiAddressCancel_rezka(Object)
		if m_simpleTV.User.rezka.DelayedAddress then
			local state = m_simpleTV.Control.GetState()
			if state == 0 then
				m_simpleTV.Control.SetNewAddress(m_simpleTV.User.rezka.DelayedAddress)
			end
			m_simpleTV.User.rezka.DelayedAddress = nil
		end
		m_simpleTV.Control.ExecuteAction(36, 0)
	end
	function Qlty_rezka()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.rezka.Tab
			if not t then return end
		local index = rezkaIndex(t)
		if m_simpleTV.User.paramScriptForSkin_buttonOk then
			t.OkButton = {ButtonImageCx = 30, ButtonImageCy= 30, ButtonImage = m_simpleTV.User.paramScriptForSkin_buttonOk}
		end
		if m_simpleTV.User.paramScriptForSkin_buttonClose then
			t.ExtButton1 = {ButtonEnable = true, ButtonImageCx = 30, ButtonImageCy= 30, ButtonImage = m_simpleTV.User.paramScriptForSkin_buttonClose}
		else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 2)
		if m_simpleTV.User.rezka.isVideo == false then
			if m_simpleTV.User.rezka.DelayedAddress then
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
			media_info_rezka(inAdr1)
		end
	end
	function GetTranslate(inAdr1)
		m_simpleTV.Control.SetNewAddress(inAdr1, m_simpleTV.Control.GetPosition())
	end
	function PositionThumbs_Rezka(queryType, address, forTime)
		if queryType == 'testAddress' then
		 if string.match(address, "rezka%.ag")
		 or string.match(address, "rezkery%.com")
		 or string.match(address, "hdrezka")
		 or string.match(address, "upivi%.com")
		 or string.match(address, "kinopub%.me")
		 or string.match(address, "^#")
		 then return true end
		 return false
		end
		if queryType == 'getThumbs' then
				if not m_simpleTV.User.rezka.ThumbsInfo  or m_simpleTV.User.rezka.ThumbsInfo == nil then
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
			t.marginRight = 3
			t.marginTop = 0
			t.marginBottom = 0
			m_simpleTV.PositionThumbs.AppendThumb(t)
		 return true
		end
	end
	local function bg_imdb_id(imdb_id)
	--#!!nexterr code!!#--
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
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then background = '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	poster = tab.movie_results[1].poster_path or ''
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	poster = tab.tv_results[1].poster_path or ''
	end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if poster and poster ~= '' then poster = 'http://image.tmdb.org/t/p/original' .. poster end
	if poster and poster ~= '' and background == '' then background = poster end
    end
	if background == nil then background = '' end
	return background
	end
	local function get_best_stream(url)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then
			showError('4')
			m_simpleTV.Http.Close(session)
		 return
		end
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#434750"'
	end
	answer = answer:gsub('\\/', '/')
	answer = answer:gsub('\\"', '"')
	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local playerjs_url = answer:match('src="([^"]+/js/playerjs[^"]+)')
		if not playerjs_url then return end
	m_simpleTV.User.rezka.playerjs_url = url:match('^http.-//[^/]+') .. playerjs_url
	local adr = answer:match('"streams":"[^"]+')
	if adr then
	adr = rezkaDeSex(adr)
	adr = adr:match('%[1080p Ultra%](http.-://stream%.voidboost%..-%.m3u8)') or adr:match('%[1080p%](http.-://stream%.voidboost%..-%.m3u8)') or adr:match('%[720p%](http.-://stream%.voidboost%..-%.m3u8)') or adr:match('%[480p%](http.-://stream%.voidboost%..-%.m3u8)') or adr:match('%[360p%](http.-://stream%.voidboost%..-%.m3u8)') or adr:match('%[240p%](http.-://stream%.voidboost%..-%.m3u8)') or ''
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
	if answer:match('<span class="b%-post__info_rates imdb"><a href="/help/.-" target="_blank" rel="nofollow">IMDb</a>') then
	imdb_id = answer:match('<span class="b%-post__info_rates imdb"><a href="/help/(.-)/"')
	imdb_id = decode64(imdb_id)
	if imdb_id then
	imdb_id = imdb_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	imdb_id = imdb_id:match('imdb%.com/title/(tt.-)/.-$')
	tmdb_background = bg_imdb_id(imdb_id)
	if tmdb_background and tmdb_background~='' then poster = tmdb_background end
	end
	else tmdb_background = '' imdb_id = '' poisk_tmdb = '' end
	if answer:match('<span class="b%-post__info_rates kp"><a href="/help/.-" target="_blank" rel="nofollow">Кинопоиск</a>') then
	kp_id = answer:match('<span class="b%-post__info_rates kp"><a href="/help/(.-)"')
	kp_id = decode64(kp_id)
	kp_id = kp_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	kp_id = kp_id:match('kinopoisk%.ru/.-/(%d+)/.-$')
	else kp_id = '' end
		return adr,poster,title,desc_text,'<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
	end
	local function play(retAdr, title, id)
		if retAdr:match('%$rezkaid') then
			retAdr = rezkaGetStream(retAdr)
				if not retAdr then
					m_simpleTV.Http.Close(session)
					showError('2')
					m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
				 return
				end
		end
		local subt = rezkaISubt(retAdr)
		retAdr = rezkaDeSex(retAdr)
--		debug_in_file( '\n' .. retAdr .. '\n', 'c://1/hdrezka.txt', setnew )
			if not retAdr or retAdr == '' then
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
				showError('2.01')
			 return
			end
		retAdr = GetRezkaAdr(retAdr)
			if not retAdr then
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
				showError('3')
			 return
			end
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
		retAdr = retAdr .. (subt or '')
		m_simpleTV.Control.CurrentAddress = retAdr
-- debug_in_file(retAdr .. '\n')
	end
----------------------------- franchises
	if inAdr:match('/franchises/') then
-- ## убрать ThumbsInfo
		if m_simpleTV.User.rezka and m_simpleTV.User.rezka.ThumbsInfo then m_simpleTV.User.rezka.ThumbsInfo = nil end
-- ##
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr .. '?app_rules=1'})
		if rc ~= 200 then
			showError('4')
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
	if t1[1] and t1[1].Address then m_simpleTV.Control.CurrentAddress = t1[1].Address end
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 ', ButtonScript = 'franchises_rezka_url(\'' .. inAdr .. '\')'}
	m_simpleTV.OSD.ShowSelect_UTF8(title:gsub(' в HD онлайн','') .. ' (' .. j - 1 .. ')', 0, t1, 8000, 2 + 64)

		m_simpleTV.Control.CurrentTitle_UTF8 = title:gsub(' в HD онлайн','')
		m_simpleTV.OSD.ShowMessageT({text = title:gsub(' в HD онлайн',''), color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
--		m_simpleTV.Control.ExecuteAction(37)
	return
	end
-----------------------------
	m_simpleTV.User.rezka.isVideo = nil
	m_simpleTV.User.rezka.titleTab = nil
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('$rezka.-$','') .. '?app_rules=1'})
		if rc ~= 200 then
			showError('4')
			m_simpleTV.Http.Close(session)
		 return
		end

	answer = answer:gsub('\\/', '/')
	answer = answer:gsub('\\"', '"')
	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local playerjs_url = answer:match('src="([^"]+/js/playerjs[^"]+)')
		if not playerjs_url then return end
	m_simpleTV.User.rezka.playerjs_url = inAdr:match('^http.-//[^/]+') .. playerjs_url
	local thumb_url = answer:match('"thumbnails":"(.-)"')
	if thumb_url and thumb_url ~= '' and not answer:match('<li class="b%-simple_episode__item')
	then
	thumb_url = m_simpleTV.User.rezka.host .. thumb_url
	pars_thumb(thumb_url)
	end
	local title = answer:match('<h1 itemprop="name">([^<]+)') or 'HDrezka'
	local year = answer:match('/year/.-">(%d%d%d%d)') or 0
	local videodesc = info_fox(title:gsub(' /.-$',''), year, '')
	title = title:gsub(' /.-$','') .. ' (' .. year .. ')'
	local poster = answer:match('"og:image" content="([^"]+)') or logo
	local desc = answer:match('"og:description" content="(.-)"%s*/>')
	local desc_text = answer:match('<div class="b%-post__description_text">([^<]+)')
	local imdb_id, kp_id, voidboost, embed
	if answer:match('<span class="b%-post__info_rates imdb"><a href="/help/.-" target="_blank" rel="nofollow">IMDb</a>') then
	imdb_id = answer:match('<span class="b%-post__info_rates imdb"><a href="/help/(.-)/"')
	imdb_id = decode64(imdb_id)
	if imdb_id then
	imdb_id = imdb_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	imdb_id = imdb_id:match('imdb%.com/title/(tt.-)/.-$')
	tmdb_background = bg_imdb_id(imdb_id)
	if tmdb_background and tmdb_background~='' then poster = tmdb_background end
	end
	else tmdb_background = '' imdb_id = '' poisk_tmdb = '' end

	if answer:match('<span class="b%-post__info_rates kp"><a href="/help/.-" target="_blank" rel="nofollow">Кинопоиск</a>') then
	kp_id = answer:match('<span class="b%-post__info_rates kp"><a href="/help/(.-)"')
	kp_id = decode64(kp_id)
	kp_id = kp_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	kp_id = kp_id:match('kinopoisk%.ru/.-/(%d+)/.-$')
	else kp_id = '' end

	if kp_id and kp_id ~= '' then
		voidboost =	get_voidboost(kp_id)
	end
	if voidboost then
		return
		m_simpleTV.Control.SetNewAddress(voidboost)
	end

	if m_simpleTV.Control.MainMode == 0 then
	if tmdb_background == '' then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster, TypeBackColor = 0, UseLogo = 3, Once = 1})
	else
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = tmdb_background, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	end

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end
	if inAdr:match('%$rezka') then
		local season, episode = inAdr:match('%&season=(%d+)%&episode=(%d+)')
		title = title .. ' Сезон ' .. season .. ', Серия ' .. episode
		play(inAdr, title, id)
		return
	end
	m_simpleTV.Control.SetTitle(title)
	local tr = answer:match('<ul id="translators%-list".-</ul>')
	local is_translate = 'No'
	if tr then
		local t, i = {}, 1
			for w in tr:gmatch('<li.-</li>') do
				local name = w:match('title="([^"]+)') or 'NN'
				local Adr = w:match('data%-translator_id="([^"]+)')
					if not name or not Adr then break end
				if w:match('data%-translator_id="(.-)"') == '376' then name = name .. ' (ukr)' end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name
				t[i].Address = Adr
				i = i + 1
			end
			if i == 1 then return end
		if i > 2 then
			is_translate = 'Yes'
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
			if kp_id and kp_id ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Кинопоиск '}
			elseif imdb_id and imdb_id ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 IMDB '}
			end
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите перевод - ' .. title, 0, t, 5000, 1)
			if ret == 3 then
			if kp_id and kp_id ~= '' then
				setConfigVal('info/rezka',inAdr)
				setConfigVal('info/scheme','Rezka')
				m_simpleTV.Control.PlayAddress('**' .. kp_id)
			elseif imdb_id and imdb_id ~= '' then
				setConfigVal('info/rezka',inAdr)
				setConfigVal('info/scheme','Rezka')
				m_simpleTV.Control.PlayAddress('https://www.imdb.com/title/' .. imdb_id .. '/reference')
			end
			end
			if ret == 2 then
				media_info_rezka(inAdr1)
			end
			id = id or 1
			tr = t[id].Address
			m_simpleTV.User.rezka.tr = t[id].Name
		else
			tr = t[1].Address
			m_simpleTV.User.rezka.tr = t[1].Name
		end
	end
	local id = inAdr:match('/(%d+)')
		if not id then
			showError('5')
		 return
		end
	if not tr then
		tr = answer:match('initCDNSeriesEvents%(' .. id .. ',%s*(%d+)') or 0
	end
	local url = m_simpleTV.User.rezka.host .. '/ajax/get_cdn_series/?t=' .. os.time()
	local body = 'id=' .. id .. '&translator_id=' .. tr .. '&action=get_episodes'
	local headers = 'X-Requested-With: XMLHttpRequest'
	local rc, answer0 = m_simpleTV.Http.Request(session, {url = url, method = 'post', body = body, headers = headers})
		if rc ~= 200 then
			showError('6')
			m_simpleTV.Http.Close(session)
		 return
		end
	local serial
	if answer0:match('"success":true') then
		serial = true
	else
		serial = answer:match('<li class="b%-simple_episode__item')
		if serial then
			answer0 = answer
		end
	end
	if serial then
		answer0 = unescape3(answer0)
		answer0 = answer0:gsub('\\/', '/')
		answer0 = answer0:gsub('\\', '')
		local t, i = {}, 1
		local data_id, season_id, episode_id
			for w in answer0:gmatch('<li class="b%-simple_episode__item.-</li>') do
				data_id = w:match('data%-id="(%d+)')
				season_id = w:match('season_id="(%d+)')
				episode_id = w:match('episode_id="(%d+)')
				if data_id and season_id and episode_id then
					t[i] = {}
					t[i].Id = i
					t[i].Name = season_id .. ' Сезон, ' .. episode_id .. ' Серия'
					t[i].Address = string.format(inAdr .. '$rezkaid=%s&translator_id=%s&season=%s&episode=%s'
								, data_id
								, tr
								, season_id
								, episode_id)
					t[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
					t[i].InfoPanelTitle = desc_text
					t[i].InfoPanelName = title
					t[i].InfoPanelShowTime = 8000
					t[i].InfoPanelLogo = poster
					i = i + 1
				end
			end
			if i == 1 then
				showError('7')
			 return
			end
		if #t > 10 then
			t.ExtParams = {FilterType = 1}
		else
			t.ExtParams = {FilterType = 2}
		end
		if #t > 1 then
			m_simpleTV.User.rezka.video = true
		end
		table.sort(t, function(a, b) return a.Id < b.Id end)
		m_simpleTV.User.rezka.titleTab = t

			t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_rezka()'}
			if is_translate == 'Yes' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔊', ButtonScript = 'GetTranslate(\'' .. inAdr1 .. '\')'}
			end
			if is_translate == 'No' then
			if kp_id and kp_id ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Кинопоиск ', ButtonScript = 'm_simpleTV.Control.PlayAddress(\'**' .. kp_id .. '\')'}
			elseif imdb_id and imdb_id ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 IMDB ', ButtonScript = 'm_simpleTV.Control.PlayAddress(\'https://www.imdb.com/title/' .. imdb_id .. '/reference\')'}
			else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			end
			end

		t.ExtParams = {}
		t.ExtParams.LuaOnCancelFunName = 'OnMultiAddressCancel_rezka'
		t.ExtParams.LuaOnOkFunName = 'OnMultiAddressOk_rezka'
		t.ExtParams.LuaOnTimeoutFunName = 'OnMultiAddressCancel_rezka'
		local pl
		if #t > 1 then
			pl = 0
		else
			pl = 32
		end
		m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 10000, 2 + 64 + pl)
		local retAdr = rezkaGetStream(t[1].Address)
			if not retAdr then
				m_simpleTV.Http.Close(session)
				showError('7.1')
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		local subt = rezkaISubt(retAdr)
		retAdr = rezkaDeSex(retAdr)
			if not retAdr or retAdr == '' then
				m_simpleTV.Http.Close(session)
				showError('7.01')
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		retAdr = GetRezkaAdr(retAdr)
			if not retAdr then
				m_simpleTV.Http.Close(session)
				showError('7.2')
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		m_simpleTV.User.rezka.DelayedAddress = retAdr .. (subt or '')
		m_simpleTV.User.rezka.title = title
		title = title .. ' - ' .. m_simpleTV.User.rezka.titleTab[1].Name
		if #t > 1 then
			inAdr = 'wait'
			m_simpleTV.User.rezka.isVideo = false
		else
			inAdr = retAdr
		end
		m_simpleTV.Control.CurrentTitle_UTF8 = title .. ' - ' .. (m_simpleTV.User.rezka.tr or 'выбор HDRezka')
		m_simpleTV.OSD.ShowMessageT({text = title .. ' - ' .. (m_simpleTV.User.rezka.tr or 'выбор HDRezka'), color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.CurrentAddress = inAdr
	 return
	else
		body = 'id=' .. id .. '&translator_id=' .. tr .. '&action=get_movie'
		rc, inAdr = m_simpleTV.Http.Request(session, {url = url, method = 'post', body = body, headers = headers})
			if rc ~= 200 then
				showError('8')
				m_simpleTV.Http.Close(session)
			return
			end
		if not inAdr:match('"success":true') then
			inAdr = answer:match('data%-translator_id="' .. tr .. '"%s+data%-cdn_url="([^"]+)') or answer:match('"streams":"([^"]+)')
				if not inAdr then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Видео недоступно', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				media_info_rezka(inAdr1)
--[[				 if kp_id and kp_id ~= ''
				  then
				   m_simpleTV.Control.PlayAddress('**' .. kp_id)
				  else
				   m_simpleTV.Control.PlayAddress('*' .. m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Control.CurrentTitle_UTF8:gsub(' %(.-$',''),1251))
				 end--]]
				 return
				end
			inAdr = inAdr .. (answer:match('"subtitle":"[^"]+') or '')
		end
		local t = {}
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title
		t[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t[1].InfoPanelTitle = desc_text
		t[1].InfoPanelName = title
		t[1].InfoPanelShowTime = 8000
		t[1].InfoPanelLogo = poster

			t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_rezka()'}
			if is_translate == 'Yes' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔊', ButtonScript = 'GetTranslate(\'' .. inAdr1 .. '\')'}
			end
			if is_translate == 'No' then
			if kp_id and kp_id ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Кинопоиск ', ButtonScript = 'm_simpleTV.Control.PlayAddress(\'**' .. kp_id .. '\')'}
			elseif imdb_id and imdb_id ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 IMDB ', ButtonScript = 'm_simpleTV.Control.PlayAddress(\'https://www.imdb.com/title/' .. imdb_id .. '/reference\')'}
			else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			end
			end
			m_simpleTV.OSD.ShowSelect_UTF8('HDrezka', 0, t, 8000, 32 + 64 + 128)
	end
	play(inAdr, title .. ' - ' .. (m_simpleTV.User.rezka.tr or 'выбор HDRezka'), id)