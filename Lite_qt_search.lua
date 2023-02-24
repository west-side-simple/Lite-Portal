-- Плагин поиска для lite portal - west_side 24.02.23
-- необходимы скрипты Lite_qt_exfs.lua, ex-fs.lua, Lite_qt_tmdb.lua, Lite_qt_kinopub.lua, Lite_qt_filmix.lua - автор west_side

function search()

require 'lfs'

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local search_ini = getConfigVal('search/media') or ''
	local answer
	local baze = 'mediaDB.txt'
	local path = m_simpleTV.Common.GetMainPath(1) .. 'DB/'
	local file = io.open(path .. baze, 'r')
	if not file then
	m_simpleTV.OSD.ShowMessageT({text = ' необходим файл ' .. m_simpleTV.Common.GetMainPath(1) .. 'DB/' .. baze, color = ARGB(255, 127, 63, 255), showTime = 1000 * 30})
	answer = '' else
	answer = file:read('*a')
	file:close()
	end

	local t1,i={},1
	if search_ini ~= '' then
	t1[1] ={}
	t1[1].Id = 1
	t1[1].Name = "!!! clear"
	t1[1].Action = ""
	i = 2
	end
		for w in answer:gmatch('\n.-%|') do
		local name = w:match('\n(.-)%|')
		if name:match(m_simpleTV.Common.fromPercentEncoding(search_ini)) and search_ini ~= '' or search_ini == '' then
			t1[i] = {}
			t1[i].Id = i
			t1[i].Name = name:gsub(' %d$','')
			t1[i].Action = name:gsub(' %d$','')
			i=i+1
		end
		end

		local hash, t0 = {}, {}
		for i = 1, #t1 do
			if not hash[t1[i].Name]
			then
				t0[#t0 + 1] = t1[i]
				hash[t1[i].Name] = true
			end
		end
		table.sort(t0, function(a, b) return tostring(a.Action) < tostring(b.Action) end)
		for i = 1, #t0 do
			t0[i].Id = i
			t0[i].Name = t0[i].Name:gsub('%%22','"')
			t0[i].Action = t0[i].Action:gsub('%%22','"')
		end

	if search_ini == '' then
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' From Buffer'}
	else
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 '}
	end
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini),0,t0,10000,1+4+8+2)

		if ret == -1 or not id then
			return
		end

		if ret == 1 then
			if t0[id].Name == '!!! clear'
			then
			search_ini = ''
			end
			setConfigVal('search/media',m_simpleTV.Common.toPercentEncoding(t0[id].Action))
			search()
		end

		if ret == 2 then
			if search_ini == '' then
			search_ini = m_simpleTV.Interface.CopyFromClipboard()
			search_ini = escape (search_ini)
			setConfigVal('search/media',search_ini)
			search()
			else
			setConfigVal('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.Common.multiByteToUTF8(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Common.fromPercentEncoding(search_ini:gsub('^%%20%%20%%20%%20',''):gsub('^%%20%%20%%20',''):gsub('^%%20%%20',''):gsub('^%%20',''):gsub('%%20%%20%%20%%20$',''):gsub('%%20%%20%%20$',''):gsub('%%20%%20$',''):gsub('%%20$',''))):gsub('%S$',''),1251)))
			search()
			end
		end

		if ret == 3 then
			search_all()
		end
end

function search_all()
m_simpleTV.Control.ExecuteAction(37)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local search_ini = getConfigVal('search/media') or ''
	local tt1={
	{'Трекеры',''},
	{'RipsClub (HEVC)',''},
	{'TMDb',''},
	{'EX-FS',''},
	{'Rezka',''},
	{'Filmix',''},
	{'KinoGo',''},
	{'KinoKong',''},
	{'UA',''},
	{'Kinopub',''},
	{'YouTube',''},
	{'VideoCDN',''},
	}

  local t1={}
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
	t1[i].Action = tt1[i][2]
  end
  t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
  t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Search Lite Portal: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini),0,t1,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
  if t1[id].Name == 'TMDb' then search_tmdb()
  elseif t1[id].Name == 'EX-FS' then search_media()
  elseif t1[id].Name == 'Rezka' then search_rezka()
  elseif t1[id].Name == 'Filmix' then search_filmix_media()
  elseif t1[id].Name == 'Трекеры' then content_adr_page('http://api.vokino.tv/v2/list?name=' .. search_ini)
  elseif t1[id].Name == 'RipsClub (HEVC)' then search_hevc('https://rips.club/search/?part=0&year=&cat=0&standard=0&bit=0&order=1&search=' .. search_ini)
  elseif t1[id].Name == 'KinoGo' then search_kinogo()
  elseif t1[id].Name == 'KinoKong' then search_kinokong()
  elseif t1[id].Name == 'UA' then search_ua()
  elseif t1[id].Name == 'Kinopub' then show_select('https://kino.pub/item/search?query=' .. search_ini)
  elseif t1[id].Name == 'YouTube' then search_youtube()
  elseif t1[id].Name == 'VideoCDN' then m_simpleTV.Control.PlayAddress('*' .. m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Common.fromPercentEncoding(search_ini)))
  end
  end
  if ret == 3 then
   search()
  end
  if ret == 2 then
   run_westSide_portal()
  end
end

function search_media()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local t, i, j, pages, answerd3 = {}, 1, 1, 1, ''
	while j <= tonumber(pages) do
	local urld2 = 'https://ex-fs.net/index.php?do=search&subaction=search&search_start=' .. j .. '&full_search=0&result_from=1&story=' .. search_ini
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', ''):gsub('\n', '')
	if j==1 then pages = answerd2:match('найдено (%d+)') or 18 pages = math.ceil(tonumber(pages)/18) end
	answerd3 = answerd3 .. answerd2
	j=j+1
	end

	for w in answerd3:gmatch('<div class="SeaRchresultPost">.-<div class="clear"></div>') do
	local group
	local logo, adr, name, title, infodesc_exfs = w:match('<img src="(.-)".-href="(.-)" >(.-)</a>.-<div class="SeaRchresultPostInfo">(.-)</div>.-<div class="SeaRchresultPostOpisanie">(.-)</div>')
	logo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
	infodesc_exfs = infodesc_exfs:gsub('<div.->',''):gsub('&nbsp;',' ')
	title = title:gsub('</a>',''):gsub('<a.->','')
	title = ' (' .. title .. ')'
	if not logo or not adr or not name then break end

	if adr:match('/films/') then group = ' - Фильм' end
	if adr:match('/series/') then group = ' - Сериал' end
	if adr:match('/cartoon/') then group = ' - Мультфильм' end
	if adr:match('/show/') then group = ' - Передачи и шоу' end
	if adr:match('/actors/') then group = ' - Актёр' title = '' end
	t[i] = {}
	t[i].Id = i
	t[i].Name = name .. title .. group
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'EX-FS info: ' .. name .. title
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = infodesc_exfs

	i = i + 1
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
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено EX-FS: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Address:match('/actors/') then
		page_exfs(t[id].Address)
		else
		media_info(t[id].Address)
		end
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'EX-FS: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function search_rezka()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local zerkalo = m_simpleTV.Config.GetValue('zerkalo/rezka',"LiteConf.ini") or ''
	if zerkalo == '' then
	zerkalo = 'https://rezka.ag/'
	end
		local function infodesc_rezka(adr1)
		local rc3,answeradr = m_simpleTV.Http.Request(session,{url=adr1})
		if rc3~=200 then
			m_simpleTV.Http.Close(session)
		return
		end
		overview = answeradr:match('"og:description" content="(.-)"%s*/>') or ''
		return overview
		end

	local urld2 = zerkalo .. 'search?do=search&subaction=search&q=' .. m_simpleTV.Common.toPercentEncoding(search_ini:gsub('%-',' '))
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	if not answerd2:match('<div class="b%-content__inline_item".-</div> </div></div>')then
	rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local t, i = {}, 1
	for w in answerd2:gmatch('<div class="b%-content__inline_item".-</div> </div></div>') do

	local logo, group, adr, name, title = w:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a> <div>(.-)<')

	if not adr or not name then break end

	t[i] = {}
	t[i].Id = i
	t[i].Name = name .. ' (' .. title .. ') ' .. group
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'Rezka info: ' .. name .. ' (' .. title .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = infodesc_rezka(t[i].Address)

	i = i + 1

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
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено Rezka: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.PlayAddress(t[id].Address)
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Rezka: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
	end

function search_youtube()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск YouTube: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local tt = {
	{'video','watch?v=','','видео'},
	{'playlist','playlist?list=','','плейлист'},
	{'channel','channel/','','канал'},
	{'video','watch?v=','&eventType=live','прямой эфир'},
	{'video&videoDimension=2d','watch?v=','','2D видео'},
	}
	local t = {}
	for i = 1,#tt do
	t[i] = {}
    t[i].Id = i
    t[i].Name = tt[i][4]
	t[i].types = tt[i][1]
	t[i].urlyoutube = tt[i][2]
	t[i].eventType = tt[i][3]
	t[i].Action = ''
  end
  t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
  t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Поиск YouTube: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini),0,t,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
	search_youtube_item(t[id].types, t[id].urlyoutube, t[id].eventType, t[id].Name)
  end
  if ret==2 then
	search_all()
  end
  if ret==3 then
	run_westSide_portal()
  end
end

function search_youtube_item(types, urlyoutube, eventType, header)
-- west_side code
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск ' .. header .. ': ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
-- nexterr code
	require 'json'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Ytube then
		m_simpleTV.User.Ytube = {}
	end
	if not m_simpleTV.User.Ytube.Cookies then
		m_simpleTV.User.Ytube.Cookies = ''
		local error_text, pm = pcall(require, 'pm')
		if package.loaded.pm then
			local ret, login, pass = pm.GetTestPassword('youtube', 'YouTube', true)
			if pass and pass ~= '' then
				pass = pass .. ';'
				m_simpleTV.User.Ytube.Cookies = pass:gsub('PREF=.-;', '')
			end
		end
	end
	if not m_simpleTV.User.Ytube.ApiKey then
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://www.youtube.com/s/tv/html5/loader/live.js', headers = 'Cookie: ' .. m_simpleTV.User.Ytube.Cookies})
		local labels = answer:match('labels={\'default\':\'(.-)\'') or ''
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://www.youtube.com/s/tv/html5/' .. labels .. '/app-prod.js', headers = 'Cookie: ' .. m_simpleTV.User.Ytube.Cookies})
		local ApiKey = answer:match('%?.%.getApiKey%(%):.-"(.-)"')
		if ApiKey and ApiKey ~= '' then
			m_simpleTV.User.Ytube.ApiKey = ApiKey
			m_simpleTV.User.Ytube.ApiKeyHeader = 'Referer:https://www.youtube.com/tv'
		else
			m_simpleTV.User.Ytube.ApiKey = decode64('QUl6YVN5Q05DZVgwbUpYWHZDSVNuaHBCS3pkc1hKSWVVc19KQmxJ')
			m_simpleTV.User.Ytube.ApiKeyHeader = decode64('UmVmZXJlcjpodHRwczovL25leHRlcnItc2ltcGxldHYucnU=')
		end
	end
	local url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=' .. search_ini .. '&type=' .. types .. '&fields=items/id,items/snippet/title,items/snippet/thumbnails/default/url,items/snippet/description,items/snippet/liveBroadcastContent,items/snippet/channelTitle&maxResults=50' .. eventType .. '&key='
	local rc, answer = m_simpleTV.Http.Request(session, {url = url .. m_simpleTV.User.Ytube.ApiKey, headers = m_simpleTV.User.Ytube.ApiKeyHeader})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub(string.char(239, 187, 191), ''))
		if not tab then return end
	local t, i = {}, 1
		while true do
				if not tab.items[i] then break end
			t[i] = {}
			t[i].Id = i
			t[i].Name = tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&')
			t[i].Adress = 'https://www.youtube.com/' .. urlyoutube .. (tab.items[i].id.videoId or tab.items[i].id.playlistId or tab.items[i].id.channelId)
			t[i].InfoPanelLogo = tab.items[i].snippet.thumbnails.default.url:gsub('/default','/hqdefault')
			t[i].InfoPanelName = tab.items[i].snippet.channelTitle .. ' | ' .. tab.items[i].snippet.title:gsub('%&quot%;','"')
			t[i].InfoPanelTitle = tab.items[i].snippet.description
			t[i].InfoPanelShowTime = 10000
			i = i + 1
		end
-- west_side code
	local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Youtube '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Youtube' .. header .. ': ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.PlayAddress(t[id].Adress)
		end
		if ret == 3 then
			search_youtube()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Youtube ' .. header .. ': Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_youtube()
		end
end

function search_filmix_media()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end

			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl
			local body = 'scf=fx&story=' .. search_ini .. '&search_start=0&do=search&subaction=search&years_ot=&years_do=&kpi_ot=&kpi_do=&imdb_ot=&imdb_do=&sort_name=asc&undefined=asc&sort_date=&sort_favorite='
			local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})
--			m_simpleTV.Http.Close(session)

					local otvet = answer:match('<article.-<script>') or ''
					local i, t = 1, {}
					for w in otvet:gmatch('<article.-</article>') do
					local logo, name, adr = w:match('<a class="fancybox" href="(.-)".-alt="(.-)".-<a class="watch icon%-play" itemprop="url" href="(.-)"')
					if not logo or not adr or not name then break end
							t[i] = {}
							t[i].Id = i
							t[i].Address = adr
							if adr:match('filmi/') then name = name .. ' - Кино'
							elseif adr:match('seria/') then name = name .. ' - Сериал'
							elseif adr:match('multserialy/') then name = name .. ' - Мультсериал'
							elseif adr:match('mults/') then name = name .. ' - Мультфильм'
							end
							t[i].Name = name:gsub('%&nbsp%;',' ')
							t[i].InfoPanelLogo = logo:gsub('/orig/','/thumbs/w220/')
							t[i].InfoPanelName = name:gsub('%&nbsp%;',' ')
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
------------------------
			rc, answer = m_simpleTV.Http.Request(session, {url = filmixsite .. '/persons/search/' .. search_ini})
					answer = m_simpleTV.Common.multiByteToUTF8(answer)
					answer = answer:gsub('\n', ' ')

					for w in answer:gmatch('<div class="short">.-</a></h2>') do
					local sim_adr, sim_img, sim_name = w:match('href="(.-)".-img src="(.-)".-<h2 class="name" itemprop="name"><a href=".-">(.-)</a></h2>')
					if not sim_adr or not sim_name then break end
							t[i] = {}
							t[i].Id = i
							t[i].Address = sim_adr
							t[i].Name = sim_name .. ' - Персона'
							t[i].InfoPanelLogo = sim_img
							t[i].InfoPanelName = sim_name
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
------------------------
	local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено Filmix: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t[id].Name:match(' %- Персона') then
				person_content_filmix(t[id].Address)
			else
				m_simpleTV.Control.ExecuteAction(37)
				m_simpleTV.Control.PlayAddress(t[id].Address)
			end
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Filmix: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function search_kinogo()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local urld2 = 'https://kinogo.cc/index.php?do=search&story=' .. m_simpleTV.Common.toPercentEncoding(search_ini:gsub('%-',' '))
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local t, i = {}, 1
	for w in answerd2:gmatch('<div class="hikinogo_lenta">.-<b>') do
	local adr, logo, title, desc = w:match('<a href="(.-)">.-<img data%-src="(.-)".-title="(.-)".-<br>(.-)<br>')
	if not adr or not title then break end
	t[i] = {}
	t[i].Id = i
	t[i].Name = title
	t[i].Address = adr
	t[i].InfoPanelLogo = 'https://kinogo.cc' .. logo
	t[i].InfoPanelName = 'KinoGo info: ' .. title
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = desc:gsub('^\n     ','')
	i = i + 1
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
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено KinoGo: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.PlayAddress(t[id].Address)
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'KinoGo: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function search_kinokong()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local urld2 = 'https://kinokong.pro/index.php?do=search&subaction=search&story=' .. escape(m_simpleTV.Common.string_fromUTF8(m_simpleTV.Common.fromPercentEncoding(search_ini)))

	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd2 = m_simpleTV.Common.multiByteToUTF8(answerd2)
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local t, i = {}, 1
	for w in answerd2:gmatch('<span class="main%-sliders%-bg">.-<div class="main%-sliders%-title">') do
	local adr, logo, title = w:match('<a href="(.-)".-src="(.-)".-alt="(.-)"')
	if not adr or not title then break end
	t[i] = {}
	t[i].Id = i
	t[i].Name = title
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = title
	t[i].InfoPanelShowTime = 30000
	i = i + 1
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
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено KinoKong: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			kinokong_info(t[id].Address)
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'KinoKong: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end

function search_ua()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local urld2 = 'https://kino4ua.com/index.php?do=search&story=' .. m_simpleTV.Common.toPercentEncoding(search_ini:gsub('%-',' '))
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local t, i = {}, 1
	for w in answerd2:gmatch('<div class="movie%-img img%-box">.-<div class="movie%-rate">') do
	local logo, adr, title, desc = w:match('src="(.-)".-data%-link="(.-)".-title="(.-)".-<div class="movie%-text">(.-)</div>')
	if not adr or not title then break end
	t[i] = {}
	t[i].Id = i
	t[i].Name = title
	t[i].Address = adr
	t[i].InfoPanelLogo = 'https://kino4ua.com' .. logo
	t[i].InfoPanelName = 'UA info: ' .. title
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = desc:gsub('<.->','')
	i = i + 1
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
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено UA: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.PlayAddress(t[id].Address)
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'UA: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
end
-------------------------------------------------------------------
--[[ local t2={}
 t2.utf8 = true
 t2.name = 'Search menu'
 t2.luastring = 'search()'
 t2.lua_as_scr = true
 t2.key = string.byte('S')
 t2.ctrlkey = 3
 t2.location = 0
 t2.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Search.png'
 m_simpleTV.Interface.AddExtMenuT(t2)--]]
-------------------------------------------------------------------