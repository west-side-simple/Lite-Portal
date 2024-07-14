-- menu Youtube desc for mediaportal
-- author: west_side 17.01.24
-- #!based on nexterr code (./luaScr/user/video/YT.lua)
-- необходим
-- видеоскрипт для сайта https://www.youtube.com
-- Copyright © 2017-2024 Nexterr | https://github.com/Nexterr-origin/simpleTV-YouTube
--------------------------------------------------

	if m_simpleTV.User == nil then
		m_simpleTV.User = {}
	end
	if m_simpleTV.User.YT == nil then
		m_simpleTV.User.YT = {}
	end

	--nexterr code---
	local function checkApiKey(key)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://www.googleapis.com/youtube/v3/i18nLanguages?part=snippet&fields=kind&key=' .. key})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
	 return true
	end
	--nexterr code---
	local function webApiKey()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = decode64('aHR0cHM6Ly93d3cueW91dHViZS5jb20vcy9fL2thYnVraS9fL2pzL2s9a2FidWtpLmJhc2Vfc3MuZW5fVVMuUDE3NWtKdlZFa1EuZXM1Lk8vYW09UkFBQlJBQVEvZD0xL3JzPUFOalJoVm51QU1SUTVQS2FzSUJ1MVQ3X0NlZkVtZnc3M2cvbT1iYXNl')
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		local key = answer:match('ze%("INNERTUBE_API_KEY","([^"]+)')
			if key and not checkApiKey(key) then return end
	 return key
	end
	--nexterr code---
	local function getApiKey()
		local key = m_simpleTV.User.YT.apiKey
		if key then
			if not checkApiKey(key) then
				key = webApiKey()
			end
		else
			key = webApiKey()
		end
			if not key then
--				ShowMsg(m_simpleTV.User.YT.Lng.error .. '\nAPI Key not found')				
				m_simpleTV.Common.Sleep(2000)
			 return getApiKey()
			end
		m_simpleTV.User.YT.apiKey = key
	 return true
	end
	--nexterr code---
local function cookiesFromFile()
	local tab = m_simpleTV.Common.DirectoryEntryList(m_simpleTV.Common.GetMainPath(1), '*cookies.txt', 'Files')
		if #tab == 0 then return end
	local prioTab = {'youtube%.com', '^cookies'}
	local f
		for i = 1, #prioTab do
			for j = 1, #tab do
				if tab[j].completeBaseName:match(prioTab[i]) then
					f = tab[j].absoluteFilePath
				 break
				end
			end
			if f then break end
		end
		if not f then return end
	local fhandle = io.open(f, 'r')
		if not fhandle then return end
	local t = {}
	local cookie_SAPISID
		for line in fhandle:lines() do
			local name, val = line:match('%.youtube%.com[^%d+]+%d+%s+(%S+)%s+(%S+)')
			if name
				and not name:match('^ST%-')
				and not name:match('^__Secure.-C$')
				and not name:match('^__Secure.-D$')
				and val
			then
				t[#t + 1] = string.format('%s=%s', name, val)
				if not cookie_SAPISID
					and name == 'SAPISID'
				then
					cookie_SAPISID = val
				end
			end
		end
	fhandle:close()
		if #t < 7 or not cookie_SAPISID then return end
	m_simpleTV.User.YT.isAuth = cookie_SAPISID
 return table.concat(t, ';')
end
	--nexterr code---
	if not m_simpleTV.User.YT.Lng then
		m_simpleTV.User.YT.Lng = {}
		local stvLang, _ = m_simpleTV.Interface.GetLanguage()
		local _, osLang_country = m_simpleTV.Interface.GetLanguageCountry()
		local country = osLang_country:gsub('[^_]+_', '')
		m_simpleTV.User.YT.Lng.lang = stvLang
		m_simpleTV.User.YT.Lng.country = country
		if stvLang == 'ru' then
			m_simpleTV.User.YT.Lng.adaptiv = 'адаптивное'
			m_simpleTV.User.YT.Lng.desc = 'описание'
			m_simpleTV.User.YT.Lng.qlty = 'качество'
			m_simpleTV.User.YT.Lng.savePlstFolder = 'сохраненые плейлисты'
			m_simpleTV.User.YT.Lng.savePlst_1 = 'плейлист сохранен в файл'
			m_simpleTV.User.YT.Lng.savePlst_2 = 'в папку'
			m_simpleTV.User.YT.Lng.savePlst_3 = 'невозможно сохранить плейлист'
			m_simpleTV.User.YT.Lng.sub = 'субтитры'
			m_simpleTV.User.YT.Lng.subTr = 'перевод'
			m_simpleTV.User.YT.Lng.preview = 'предосмотр'
			m_simpleTV.User.YT.Lng.audio = 'аудио'
			m_simpleTV.User.YT.Lng.noAudio = 'нет аудио'
			m_simpleTV.User.YT.Lng.plst = 'плейлист'
			m_simpleTV.User.YT.Lng.error = 'ошибка'
			m_simpleTV.User.YT.Lng.live = 'прямая трансляция'
			m_simpleTV.User.YT.Lng.upLoadOnCh = 'загружено на канал'
			m_simpleTV.User.YT.Lng.loading = 'загрузка'
			m_simpleTV.User.YT.Lng.videoNotAvail = 'видео не доступно'
			m_simpleTV.User.YT.Lng.videoNotExst = 'видео не существует'
			m_simpleTV.User.YT.Lng.page = 'стр.'
			m_simpleTV.User.YT.Lng.camera = 'вид с видеокамеры'
			m_simpleTV.User.YT.Lng.camera_plst_title = 'список видеокамер'
			m_simpleTV.User.YT.Lng.channel = 'канал'
			m_simpleTV.User.YT.Lng.video = 'видео'
			m_simpleTV.User.YT.Lng.search = 'поиск'
			m_simpleTV.User.YT.Lng.notFound = 'не найдено'
			m_simpleTV.User.YT.Lng.started = 'начало в'
			m_simpleTV.User.YT.Lng.published = 'опубликовано'
			m_simpleTV.User.YT.Lng.duration = 'продолжительность'
			m_simpleTV.User.YT.Lng.link = 'открыть в браузере'
			m_simpleTV.User.YT.Lng.noCookies = 'ТРЕБУЕТСЯ ВХОД: используйте "cookies файл" для авторизации'
			m_simpleTV.User.YT.Lng.chapter = 'главы'
		else
			m_simpleTV.User.YT.Lng.adaptiv = 'adaptive'
			m_simpleTV.User.YT.Lng.desc = 'description'
			m_simpleTV.User.YT.Lng.qlty = 'quality'
			m_simpleTV.User.YT.Lng.savePlstFolder = 'saved playlists'
			m_simpleTV.User.YT.Lng.savePlst_1 = 'playlist saved to file'
			m_simpleTV.User.YT.Lng.savePlst_2 = 'to folder'
			m_simpleTV.User.YT.Lng.savePlst_3 = 'unable to save playlist'
			m_simpleTV.User.YT.Lng.sub = 'subtitles'
			m_simpleTV.User.YT.Lng.subTr = 'translated'
			m_simpleTV.User.YT.Lng.preview = 'preview'
			m_simpleTV.User.YT.Lng.audio = 'audio'
			m_simpleTV.User.YT.Lng.noAudio = 'no audio'
			m_simpleTV.User.YT.Lng.plst = 'playlist'
			m_simpleTV.User.YT.Lng.error = 'error'
			m_simpleTV.User.YT.Lng.live = 'live'
			m_simpleTV.User.YT.Lng.upLoadOnCh = 'uploads from channel'
			m_simpleTV.User.YT.Lng.loading = 'loading'
			m_simpleTV.User.YT.Lng.videoNotAvail = 'video not available'
			m_simpleTV.User.YT.Lng.videoNotExst = 'video does not exist'
			m_simpleTV.User.YT.Lng.page = 'page'
			m_simpleTV.User.YT.Lng.camera = 'camera view'
			m_simpleTV.User.YT.Lng.camera_plst_title = 'switch camera'
			m_simpleTV.User.YT.Lng.channel = 'channel'
			m_simpleTV.User.YT.Lng.video = 'video'
			m_simpleTV.User.YT.Lng.search = 'search'
			m_simpleTV.User.YT.Lng.notFound = 'not found'
			m_simpleTV.User.YT.Lng.started = 'started'
			m_simpleTV.User.YT.Lng.published = 'published'
			m_simpleTV.User.YT.Lng.duration = 'duration'
			m_simpleTV.User.YT.Lng.link = 'open in browser'
			m_simpleTV.User.YT.Lng.noCookies = 'LOGIN REQUIRED: use "cookies file" for authorization'
			m_simpleTV.User.YT.Lng.chapter = 'chapters'
		end
	end
	--nexterr code---
	if not m_simpleTV.User.YT.cookies then
		local cookies = cookiesFromFile() or 'VISITOR_INFO1_LIVE=;SOCS=CAI;PREF=&hl=' .. m_simpleTV.User.YT.Lng.lang
		cookies = cookies:gsub('&amp;', '&')
		m_simpleTV.User.YT.cookies = cookies
		m_simpleTV.User.YT.Lng.lang = cookies:match('hl=([^&;]+)') or m_simpleTV.User.YT.Lng.lang
		m_simpleTV.User.YT.Lng.country = cookies:match('gl=([^&;]+)') or m_simpleTV.User.YT.Lng.country
	end

	-----------------
	getApiKey()
	-----------------

function get_answer_history(page)
	page = tonumber(page) or 1
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local url = 'https://www.youtube.com/feed/history'

	m_simpleTV.Http.SetCookies(session, url, m_simpleTV.User.YT.cookies, '')
--	local start = os.clock() --debug
	local ss, sss = m_simpleTV.Http.Request(session, {url = url, method = 'get'})
	sss = sss:gsub('\\n',' '):gsub('\\','')
--	debug_in_file(os.clock() - start .. '\n' .. ss .. '\n' .. sss .. '\n','c://1/testyoutube_answer.txt')
--	local finish = os.clock() - start --debug
	local t,i,j={},0,0
	for w in sss:gmatch('"videoRenderer":%{"videoId":.-"watchEndpoint"') do
		local id,logo,title,ch,all_time,count = w:match('"videoId":"(.-)".-"thumbnail".-"url":"(.-)".-"text":"(.-)".-"longBylineText".-"text":"(.-)".-"label":"(.-)".-"viewCountText":%{"simpleText":"(.-)"')
		if id and title and logo and ch and all_time and count then
			j = j + 1
			if j > (tonumber(page) - 1) * 28 and j <= tonumber(page) * 28 then
			i = i + 1
			t[i] = {}
			t[i].Name = title
			t[i].Address = 'https://www.youtube.com/watch?v=' .. id
			t[i].InfoPanelLogo = 'https:' .. logo:gsub('/hqdefault','/mqdefault'):gsub('/default','/mqdefault'):gsub('%?.-$',''):gsub('^https:','')
			t[i].InfoPanelName = ch .. ' | ' .. title
			t[i].InfoPanelTitle = all_time .. '\n' .. count
--			debug_in_file(id .. ' | ' .. title .. ' | ' .. logo .. ' | ' .. ch .. ' | ' .. all_time .. ' | ' .. count .. '\n','c://1/test_answer.txt')
			elseif j > tonumber(page) * 28 then break
			end
		end
	end
--[[
	local t1 = {}
	for i = 1,28 do
		if not t[i + (page-1)*28] then break end
		t1[i] = t[i + (page-1)*28]
		i=i+1
	end--]]

	m_simpleTV.User.TVPortal.stena_search_youtube = t
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'youtube_history'

--	local all = math.ceil(j/28)
	local all = 2 -- debug
	if all == 0 then all = 1 end
	local prev_pg = tonumber(page) - 1
	local next_pg = tonumber(page) + 1
	local title = 'Youtube история просмотра (стр. ' .. page .. ' из ' .. all .. ')'
		m_simpleTV.User.TVPortal.stena_search_youtube_title = title
	if next_pg <= tonumber(all) then
		m_simpleTV.User.TVPortal.stena_youtube_next = {tonumber(page)+1}
	else
		m_simpleTV.User.TVPortal.stena_youtube_next = nil
	end
	if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_youtube_prev = {tonumber(page)-1}
	else
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil
	end
	m_simpleTV.Http.Close(session)
--	debug_in_file(finish .. '\n' .. os.clock() - start - finish .. '\n','c://1/testyoutube_answer.txt')
	stena_search_youtube_content()--]]

end

function get_answer_channels(page)
	page = tonumber(page) or 1

	if not m_simpleTV.User.TVPortal.stena_channels_youtube then

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local url = 'https://www.youtube.com/feed/channels'

		m_simpleTV.Http.SetCookies(session, url, m_simpleTV.User.YT.cookies, '')
		local ss, sss = m_simpleTV.Http.Request(session, {url = url, method = 'get'})
		sss = sss:gsub('\\n',' '):gsub('\\','')
--		debug_in_file(url .. '\n' .. ss .. '\n' .. sss .. '\n','c://1/testyoutube_answer.txt')
		local t,i={},1
		for w in sss:gmatch('"channelRenderer":%{"channelId":.-"subscribeButton"') do
			local id,title,logo,desc,count = w:match('"channelId":"(.-)".-"simpleText":"(.-)".-"thumbnail".-"url":"(.-)".-"text":"(.-)".-"label":"(.-)"')

			if id and title and logo and desc and count then
				t[i] = {}
				t[i].Name = title
				t[i].Address = 'https://www.youtube.com/channel/' .. id
				t[i].InfoPanelLogo = 'https:' .. logo:gsub('s88','s176'):gsub('^https:','')
				t[i].InfoPanelName = title
				t[i].InfoPanelTitle = count .. '\n' .. desc:gsub('%-%-',''):gsub('%=%=','')
				i = i + 1
	--			debug_in_file(id .. ' | ' .. title .. ' | ' .. logo .. ' | ' .. desc .. ' | ' .. count .. '\n','c://1/test_answer.txt')
			end
		end
		m_simpleTV.User.TVPortal.stena_channels_youtube = t
	end

	local t1 = {}
	for i = 1,28 do
		if not m_simpleTV.User.TVPortal.stena_channels_youtube[i + (page-1)*28] then break end
		t1[i] = m_simpleTV.User.TVPortal.stena_channels_youtube[i + (page-1)*28]
		i=i+1
	end

	m_simpleTV.User.TVPortal.stena_search_youtube = t1
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'youtube_channels'

	local all = math.ceil(#m_simpleTV.User.TVPortal.stena_channels_youtube/28)
	if all == 0 then all = 1 end
	local prev_pg = tonumber(page) - 1
	local next_pg = tonumber(page) + 1
	local title = 'Youtube подписки (стр. ' .. page .. ' из ' .. all .. ')'
		m_simpleTV.User.TVPortal.stena_search_youtube_title = title
	if next_pg <= tonumber(all) then
		m_simpleTV.User.TVPortal.stena_youtube_next = {tonumber(page)+1}
	else
		m_simpleTV.User.TVPortal.stena_youtube_next = nil
	end
	if prev_pg > 0 then
		m_simpleTV.User.TVPortal.stena_youtube_prev = {tonumber(page)-1}
	else
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil
	end
	if stena_search_youtube_content then return stena_search_youtube_content() end

end

function getstart(vid_cat_id, pageToken)

	local t_vid_cat_id = {
	{"25", "Новости и политика"},
	{"17", "Спорт"},
	{"10", "Музыка"},
	{"1", "Фильмы и анимация"},
	{"0", "Прямой эфир"},
	}
	local vid_cat_name = ''

		for j = 1,5 do
			if tonumber(vid_cat_id) == tonumber(t_vid_cat_id[j][1]) then vid_cat_name = t_vid_cat_id[j][2] break end
		end

	m_simpleTV.User.TVPortal.stena_search_youtube_title = 'Youtube ' .. m_simpleTV.User.YT.Lng.country .. ': ' .. vid_cat_name
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'youtube_start' .. vid_cat_id

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local url = 'https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&chart=mostPopular&hl=' .. m_simpleTV.User.YT.Lng.lang .. '&maxResults=28&regionCode=' .. m_simpleTV.User.YT.Lng.country .. '&videoCategoryId=' .. vid_cat_id .. '&key=' .. m_simpleTV.User.YT.apiKey .. '&pageToken=' .. pageToken

	if tonumber(vid_cat_id) == 0 then
		url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&eventType=live&hl=' .. m_simpleTV.User.YT.Lng.lang .. '&maxResults=28&regionCode=' .. m_simpleTV.User.YT.Lng.country .. '&type=video&key=' .. m_simpleTV.User.YT.apiKey .. '&pageToken=' .. pageToken
	end

	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	local t, i = {}, 1
	local prev_pg = tab.prevPageToken
	local next_pg = tab.nextPageToken
	while true do
		if not tab.items[i] then break end
		t[i] = {}
--		t[i].Id = i
		t[i].Name = tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&')
		if tonumber(vid_cat_id) == 0 then
			t[i].Address = 'https://www.youtube.com/watch?v=' .. tab.items[i].id.videoId
		else
			t[i].Address = 'https://www.youtube.com/watch?v=' .. tab.items[i].id
		end
		t[i].InfoPanelLogo = tab.items[i].snippet.thumbnails.medium.url
		t[i].InfoPanelName = tab.items[i].snippet.channelTitle .. ' | ' .. tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&')
		t[i].InfoPanelTitle = tab.items[i].snippet.description:gsub('%-%-',''):gsub('%=%=',''):gsub('__','')
--		t[i].InfoPanelShowTime = 10000
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_search_youtube = t

		if next_pg then
		m_simpleTV.User.TVPortal.stena_youtube_next = {vid_cat_id, next_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_next = nil
		end
		if prev_pg then
		m_simpleTV.User.TVPortal.stena_youtube_prev = {vid_cat_id, prev_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil
		end

	if stena_search_youtube_content then return stena_search_youtube_content() end
 end

function run_youtube_portal()

--m_simpleTV.Control.ExecuteAction(37)

local tt = {
			{"YouTube главная страница","https://www.youtube.com","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube список подписок >>","https://www.youtube.com/feed/channels","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube список подписок (ленты каналов - RSS feed) >>","https://www.youtube.com/feed/rss_channels","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube подписки >>","https://www.youtube.com/feed/subscriptions","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube в тренде","https://www.youtube.com/feed/trending","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube история просмотра","https://www.youtube.com/feed/history","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube понравившиеся","https://www.youtube.com/playlist?list=LL","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube понравившиеся (музыка)","https://www.youtube.com/playlist?list=LM","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"YouTube отложенный просмотр","https://www.youtube.com/playlist?list=WL","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
			{"Поиск","","./luaScr/user/show_mi/menuYT.png",' - автор westSide'},
		   }

  local t={}
  for i=1,#tt do
    t[i] = {}
    t[i].Id = i
    t[i].Name = tt[i][1]
    t[i].Action = tt[i][2]
	t[i].InfoPanelLogo = tt[i][3]
	t[i].InfoPanelTitle = 'Guide (необходимо использовать cookies)'
	t[i].InfoPanelDesc = 'Guide (необходимо использовать cookies)' .. tt[i][4]
	t[i].InfoPanelShowTime = 9000
  end

  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Youtube menu',0,t,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
	if t[id].Name == 'Поиск' then
	 return search_youtube()
	elseif t[id].Name == 'YouTube список подписок >>' then
	 get_answer_channels(1)
	elseif t[id].Name == 'YouTube история просмотра' then
	 get_answer_history(1)
	else
     m_simpleTV.Control.PlayAddressT({address = t[id].Action})
	end
  end

  end

function highlight()
m_simpleTV.Control.ExecuteAction(37)
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
local tt2={
{'Youtube канал SimpleTV M24WS','https://youtube.com/playlist?list=PL0OszcisBIjOax3iduZNSGfvuMj8NAyMj'},


}

  local t2={}
  for i=1,#tt2 do
    t2[i] = {}
    t2[i].Id = i
    t2[i].Name = tt2[i][1]
	t2[i].Address = tt2[i][2]
  end
  local cur_id = 0
  if getConfigVal('highlight') then cur_id = tonumber(getConfigVal('highlight'))-1 end
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Highlight',cur_id or 0,t2,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
	setConfigVal('highlight',id)
	m_simpleTV.Control.PlayAddressT({address = t2[id].Address})
  end
end

--[[
 local t={}
 t.utf8 = true
 t.name = 'Youtube меню'
 t.luastring = 'run_youtube_portal()'
 t.lua_as_scr = true
 t.submenu = 'Youtube by Nexterr'
 t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuYT.png'
 t.key = string.byte('I')
 t.ctrlkey = 4
 t.location = 0
 t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuYT.png'
 m_simpleTV.Interface.AddExtMenuT(t)--]]