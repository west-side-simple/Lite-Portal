-- Плагин поиска для EX-FS portal - lite version west_side 23.11.21
-- необходимы скрипты Lite_qt_exfs.lua, ex-fs.lua - автор west_side

function search()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local search_ini = getConfigVal('search/media') or ''

	local tt = {
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
		end
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
			if t0[id].Name == 'clear'
			then
			search_ini = ''
			end
			setConfigVal('search/media',search_ini .. t0[id].Action)
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
			search_tmdb()
		end
end

function search_media()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
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
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎 Kinopub'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 '}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini) .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
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
			show_select('https://kino.pub/item/search?query=' .. search_ini)
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