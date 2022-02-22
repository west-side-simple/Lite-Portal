-- Плагин поиска для lite portal - west_side 18.02.22
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

--[[	local tt = {
		{'',"clear"},
		{m_simpleTV.Common.toPercentEncoding('а'),"а"},
		{m_simpleTV.Common.toPercentEncoding('б'),"б"},
		{m_simpleTV.Common.toPercentEncoding('в'),"в"},
		{m_simpleTV.Common.toPercentEncoding('г'),"г"},
		{m_simpleTV.Common.toPercentEncoding('д'),"д"},
		{m_simpleTV.Common.toPercentEncoding('е'),"е"},
		{m_simpleTV.Common.toPercentEncoding('ё'),"ё"},
		{m_simpleTV.Common.toPercentEncoding('ж'),"ж"},
		{m_simpleTV.Common.toPercentEncoding('з'),"з"},
		{m_simpleTV.Common.toPercentEncoding('и'),"и"},
		{m_simpleTV.Common.toPercentEncoding('й'),"й"},
		{m_simpleTV.Common.toPercentEncoding('к'),"к"},
		{m_simpleTV.Common.toPercentEncoding('л'),"л"},
		{m_simpleTV.Common.toPercentEncoding('м'),"м"},
		{m_simpleTV.Common.toPercentEncoding('н'),"н"},
		{m_simpleTV.Common.toPercentEncoding('о'),"о"},
		{m_simpleTV.Common.toPercentEncoding('п'),"п"},
		{m_simpleTV.Common.toPercentEncoding('р'),"р"},
		{m_simpleTV.Common.toPercentEncoding('с'),"с"},
		{m_simpleTV.Common.toPercentEncoding('т'),"т"},
		{m_simpleTV.Common.toPercentEncoding('у'),"у"},
		{m_simpleTV.Common.toPercentEncoding('ф'),"ф"},
		{m_simpleTV.Common.toPercentEncoding('х'),"х"},
		{m_simpleTV.Common.toPercentEncoding('ц'),"ц"},
		{m_simpleTV.Common.toPercentEncoding('ч'),"ч"},
		{m_simpleTV.Common.toPercentEncoding('ш'),"ш"},
		{m_simpleTV.Common.toPercentEncoding('щ'),"щ"},
		{m_simpleTV.Common.toPercentEncoding('ъ'),"ъ"},
		{m_simpleTV.Common.toPercentEncoding('ы'),"ы"},
		{m_simpleTV.Common.toPercentEncoding('ь'),"ь"},
		{m_simpleTV.Common.toPercentEncoding('э'),"э"},
		{m_simpleTV.Common.toPercentEncoding('ю'),"ю"},
		{m_simpleTV.Common.toPercentEncoding('я'),"я"},
		{m_simpleTV.Common.toPercentEncoding('  '),"_"},
		}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end--]]
-----------------------------

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

	local t1={}
	t1[1] ={}
	t1[1].Id = 1
	t1[1].Name = "!!! clear"
	t1[1].Action = ""
	local i=2
		for w in answer:gmatch('\n.-%|') do
		local name = w:match('\n(.-)%|')
			t1[i] = {}
			t1[i].Id = i
			t1[i].Name = name
			t1[i].Action = name
			i=i+1
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
-----------------------------
	if search_ini == '' then
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' From Buffer'}
	else
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back'}
	end
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 '}

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini),0,t0,10000,1+4+8+2)

		if ret == -1 or not id then
			return
		end

		if ret == 1 then
			if t0[id].Name == '!!! clear'
			then
			search_ini = ''
			end
			setConfigVal('search/media',search_ini .. m_simpleTV.Common.toPercentEncoding(t0[id].Action))
			search()
		end

		if ret == 2 then
			if search_ini == '' then
			search_ini = m_simpleTV.Interface.CopyFromClipboard()
			search_ini = escape (search_ini)
			setConfigVal('search/media',search_ini)
			search()
			else
			setConfigVal('search/media',search_ini:gsub('%S%S%S%S%S%S$',''))
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
	{'TMDb',''},
	{'EX-FS',''},
	{'Rezka',''},
	{'Filmix',''},
	{'Kinopub',''},
	{'YouTube',''},
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
  elseif t1[id].Name == 'Kinopub' then show_select('https://kino.pub/item/search?query=' .. search_ini)
  elseif t1[id].Name == 'YouTube' then search_youtube()
  end
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
	local function infodesc_rezka(adr1)
		local rc3,answeradr = m_simpleTV.Http.Request(session,{url=adr1})
		if rc3~=200 then
			m_simpleTV.Http.Close(session)
		return
		end
		overview = answeradr:match('"og:description" content="(.-)"%s*/>') or ''
		return overview
	end

	local urld2 = 'https://rezkery.com/search?do=search&subaction=search&q=' .. m_simpleTV.Common.toPercentEncoding(search_ini:gsub('%-',' '))
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
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
			search_all()
		end
	end

function search_youtube()
-- west_side code
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local search_ini = getConfigVal('search/media') or ''
	local title1 = 'Поиск медиа: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini)
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
	local types, urlyoutube, header = 'video','watch?v=','видео'
	local eventType = ''
	local url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=' .. search_ini .. '&type=' .. types .. '&fields=items/id,items/snippet/title&maxResults=50' .. eventType .. '&key='
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
			t[i].Name = tab.items[i].snippet.title:gsub('%&quot%;','"')
			t[i].Adress = 'https://www.youtube.com/' .. urlyoutube .. (tab.items[i].id.videoId or tab.items[i].id.playlistId or tab.items[i].id.channelId)
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
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
		if #t > 0 then
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено Youtube: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.PlayAddress(t[id].Adress)
		end
		if ret == 3 then
			search()
		end
		if ret == 2 then
			search_all()
		end
		else
			search_all()
		end
end
-------------------------------------------------------------------
 local t2={}
 t2.utf8 = true
 t2.name = 'Search menu'
 t2.luastring = 'search()'
 t2.lua_as_scr = true
 t2.key = string.byte('S')
 t2.ctrlkey = 3
 t2.location = 0
 t2.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Search.png'
 m_simpleTV.Interface.AddExtMenuT(t2)
-------------------------------------------------------------------