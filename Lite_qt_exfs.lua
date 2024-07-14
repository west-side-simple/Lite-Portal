--EX-FS portal - lite version west_side 20.06.24

local function GetBalanser_new(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = decode64('aHR0cHM6Ly9id2EtY2xvdWQuYXBuLm1vbnN0ZXIvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	m_simpleTV.Http.Close(session)
--	debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
	if rc==200 and answer:match('data%-json') then
		return url
	end
	return false
end

function run_lite_qt_exfs()
	stena_clear()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/media') or ''
	local tt = {
		{"","ПОИСК"},
		{"",". . ."},
		{"https://ex-fs.net/actors/","Актёры"},
		{"",". . ."},
		{"/film/","Фильмы"},
		{"/serials/","Сериалы"},
		{"/multfilm/","Мультфильмы"},
		{"/tv-show/","Передачи и шоу"},
		{"",". . . По странам"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Россия') .. "/","Российские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Индия') .. "/","Индийские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Канада') .. "/","Канадские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Украина') .. "/","Украинские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Турция') .. "/","Турецкие"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Корея_Южная') .. "/","Корейские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('США') .. "/","Американские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Франция') .. "/","Французские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Япония') .. "/","Японские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Великобритания') .. "/","Британские"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('Германия') .. "/","Немецкие"},
		{"/country/" .. m_simpleTV.Common.toPercentEncoding('СССР') .. "/","СССР"},
		{"",". . . По жанрам"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фантастика') .. "/","Фантастика"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('аниме') .. "/","Аниме"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('биография') .. "/","Биография"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('боевик') .. "/","Боевик"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('вестерн') .. "/","Вестерн"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('военный') .. "/","Военный"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('детектив') .. "/","Детектив"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('детский') .. "/","Детский"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('для_взрослых') .. "/","Для взрослых"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('документальный') .. "/","Документальный"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('драма') .. "/","Драма"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('история') .. "/","История"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('комедия') .. "/","Комедия"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('короткометражка') .. "/","Короткометражка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('концерт') .. "/","Концерт"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('криминал') .. "/","Криминал"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('мелодрама') .. "/","Мелодрама"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('музыка') .. "/","Музыка"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('мюзикл') .. "/","Мюзикл"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('новости') .. "/","Новости"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('приключения') .. "/","Приключения"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('реальное_ТВ') .. "/","Реальное ТВ"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('семейный') .. "/","Семейный"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('спорт') .. "/","Спорт"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('ток-шоу') .. "/","Ток-шоу"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('триллер') .. "/","Триллер"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('ужасы') .. "/","Ужасы"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фильм-нуар') .. "/","Фильм-Нуар"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('игра') .. "/","Игра"},
		{"/genre/" .. m_simpleTV.Common.toPercentEncoding('фэнтези') .. "/","Фэнтези"},

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
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию EX-FS',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'Актёры' then
				page_exfs(t0[id].Action)
			elseif t0[id].Action == '' then
				run_lite_qt_exfs()
			else
				page_exfs('https://ex-fs.net' .. t0[id].Action)
			end
		end
		if ret == 2 then
		media_info(last_adr)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function page_exfs(inAdr)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name2,data2 = answer:match('ex%-fs%.net.+%s(_ym_uid)%s+(%S+)')
			local name3,data3 = answer:match('ex%-fs%.net.+%s(_ym_d)%s+(%S+)')
			local name4,data4 = answer:match('ex%-fs%.net.+%s(_ym_isad)%s+(%S+)')
			local name5,data5 = answer:match('ex%-fs%.net.+%s(PHPSESSID)%s+(%S+)')
			local name6,data6 = answer:match('ex%-fs%.net.+%s(dle_user_id)%s+(%S+)')
			local name7,data7 = answer:match('ex%-fs%.net.+%s(dle_password)%s+(%S+)')
			local name8,data8 = answer:match('ex%-fs%.net.+%s(dle_newpm)%s+(%S+)')

			if name2 and data2 and name3 and data3 and name4 and data4 and name5 and data5 and name6 and data6 and name7 and data7 and name8 and data8
			then str = name2 .. '=' .. data2 .. ';' .. name3 .. '=' .. data3 .. ';' .. name4 .. '=' .. data4 .. ';' .. name5 .. '=' .. data5 .. ';' .. name6 .. '=' .. data6 .. ';' .. name7 .. '=' .. data7 .. ';' .. name8 .. '=' .. data8
			else
			return ''
			end
			end
return str
end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local cookies = cookiesFromFile() or ''

	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.fromPercentEncoding(m_simpleTV.Common.multiByteToUTF8(inAdr,1251)), headers = 'Cookie: ' .. cookies})

		if rc ~= 200 then return end
--	m_simpleTV.Http.Close(session)
	answer = answer:gsub('\n', ' ')
	local title = answer:match('<title>(.-)</title>') or 'EX-FS'

	if m_simpleTV.Common.isUTF8(title) == false then title = m_simpleTV.Common.multiByteToUTF8(title) end
	title = title:gsub('Смотреть кино ex ua, fs to фильмы онлайн бесплатно в хорошем HD качестве', 'Фильмы'):gsub(' смотреть онла.+', ''):gsub('^Сериал ', ''):gsub('%(.+', ''):gsub(' %&raquo;', ''):gsub('Смотреть ', ''):gsub(' онлайн бесплатно ', ''):gsub(' онлайн смотреть бесплатно в хорошем HD качестве', ''):gsub('Российские и Голливудские актеры%, актрисы%, знаменитости на EX%-FS%.NET', 'фильмы с актером | актрисой')
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title)
	end
	local t, i = {}, 1

			for w in answer:gmatch('<div class="MiniPostAllForm MiniPostAllFormDop.-">.-</div>  </div>') do

			local logo, adr, name = w:match('<img src="(.-)".-<a href="(.-)" title="(.-)"')
			local title1 = w:match('<img src=".-".-<a href=".-" title=".-".-title="(.-)"') or ''
			if title1 ~= '' then title1 = ' (' .. title1 .. ')' end
			local title2 = w:match('<img src=".-".-<a href=".-" title=".-".-title=".-".-title="(.-)"') or ''
			if title2 ~= '' then title2 = ', ' .. title2 end
			local group = ''
					if not adr or not name then break end
--				if m_simpleTV.Common.isUTF8(name) == false then name = m_simpleTV.Common.multiByteToUTF8(name) end
				t[i] = {}
				t[i].Id = i
--				t[i].Name = name:gsub(' /.+', '') .. title1
				t[i].Address = adr
				if not inAdr:match('/films/') and not inAdr:match('/series/') and not inAdr:match('/cartoon/') and not inAdr:match('/show/') then
				if adr:match('/film/') then group = ' - Фильм' end
				if adr:match('/serial/') then group = ' - Сериал' end
				if adr:match('/multfilm/') then group = ' - Мультфильм' end
				if adr:match('/tv%-show/') then group = ' - Передачи и шоу' end
				end
				t[i].Name = name:gsub(' /.+', '') .. title1 .. group
				t[i].InfoPanelLogo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
				t[i].InfoPanelName = name:gsub(' /.+', '') .. title1
				t[i].InfoPanelTitle = title1:gsub(' %(',''):gsub('%)','') .. title2
				t[i].InfoPanelShowTime = 10000

				i = i + 1
			end

		local prev_pg = answer:gsub('^.-<div class="navigations">',''):match('</a>   <a href="(.-)">Назад</a>')
		local next_pg = answer:gsub('^.-<div class="navigations">',''):match('</a> <a href="(.-)">Вперед</a>')
		local all_pg = answer:gsub('^.-<div class="navigations">',''):match('(%d+)</a>   ') or 1
		local current_page = inAdr:match('/page/(%d+)/') or 1
		if tonumber(current_page) > 1 and not title:match('траница') then title = title .. ' страница - ' .. current_page end
		if next_pg then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg then
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
		if inAdr:match('/actors/%d+') then
		all_pg = ' - ' .. #t
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '💾'}
		else all_pg = ' из ' .. all_pg .. ' стр.'
		end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. all_pg, 0, t, 30000, 1+4+8+2)
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
		if ret == 2 then
		if prev_pg then
		page_exfs(inAdr:gsub('/page/.-$','/') .. 'page/' .. current_page-1 .. '/')
		elseif inAdr:match('/actors/%d+') then
		page_exfs('https://ex-fs.net/actors/')
		else
		run_lite_qt_exfs()
		end
		end
		if ret == 3 then
		if inAdr:match('/actors/%d+') then
		setConfigVal('person/rezka',inAdr)
		UpdatePersonEXFS()
		return
		else
		page_exfs(inAdr:gsub('/page/.-$','/') .. 'page/' .. current_page+1 .. '/')
		end
		end
		end

function media_info(inAdr)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then
		tooltip_body = ''
	else
		tooltip_body = 'bgcolor="#434750"'
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local function cookiesFromFile()
		local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
		local file = io.open(path, 'r')
		if not file then
			return ''
			else
			local answer = file:read('*a')
			file:close()

			local name2,data2 = answer:match('ex%-fs%.net.+%s(_ym_uid)%s+(%S+)')
			local name3,data3 = answer:match('ex%-fs%.net.+%s(_ym_d)%s+(%S+)')
			local name4,data4 = answer:match('ex%-fs%.net.+%s(_ym_isad)%s+(%S+)')
			local name5,data5 = answer:match('ex%-fs%.net.+%s(PHPSESSID)%s+(%S+)')
			local name6,data6 = answer:match('ex%-fs%.net.+%s(dle_user_id)%s+(%S+)')
			local name7,data7 = answer:match('ex%-fs%.net.+%s(dle_password)%s+(%S+)')
			local name8,data8 = answer:match('ex%-fs%.net.+%s(dle_newpm)%s+(%S+)')

			if name2 and data2 and name3 and data3 and name4 and data4 and name5 and data5 and name6 and data6 and name7 and data7 and name8 and data8 then
				str = name2 .. '=' .. data2 .. ';' .. name3 .. '=' .. data3 .. ';' .. name4 .. '=' .. data4 .. ';' .. name5 .. '=' .. data5 .. ';' .. name6 .. '=' .. data6 .. ';' .. name7 .. '=' .. data7 .. ';' .. name8 .. '=' .. data8
			else
				return ''
			end
		end
		return str
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local cookies = cookiesFromFile() or ''

	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.fromPercentEncoding(m_simpleTV.Common.multiByteToUTF8(inAdr,1251)), headers = 'Cookie: ' .. cookies})

		if rc ~= 200 then return end
--	m_simpleTV.Http.Close(session)
	answer = answer:gsub('\n', ' ')
	local kp_id = answer:match('data%-kinopoisk="(%d+)"') or answer:match('/kp/(%d+)') or answer:match('kp_id=(%d+)')
	local desc = answer:match('<meta name="description" content="(.-)"') or ''
	local poster = answer:match('<div class="FullstoryForm">.-<img src="(.-)"') or ''
	poster = 'https://ex-fs.net' .. poster:gsub('https://ex%-fs%.net','')
	local title_rus = answer:match('<h1 class="view%-caption">(.-)</h1>') or ''
	title_rus = title_rus:gsub(' смотреть онлайн','')
	local title_eng = answer:match('<h2 class="view%-caption2">(.-)</h2>') or ''
	local kpr = answer:match('<div class="in_name_kp">(.-)</div>') or ''
	local imdbr = answer:match('<div class="in_name_imdb">(.-)</div>') or ''
	local year = answer:match('<p class="FullstoryInfoin"><a href="/year/.-" title="(.-)"') or ''
	local age = answer:match('infoi_age">(.-)</p>') or '0+'
	local all_time = answer:match('Время%:</h4>.-"FullstoryInfoin">(.-)</p>') or ''
	local desc1 = answer:match('<div class="FullstorySubFormText">(.-)</div>') or desc
	desc1 = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. title_rus .. '</font></h4><h5><font color=#BBBBBB>' .. title_eng .. '</font></h5><h5><font color=#E0FFFF>' .. year .. ' • ' .. age .. ' • Кинопоиск: ' .. kpr .. ' • IMDb: ' .. imdbr .. '</font></h5><h5><font color=#E0FFFF>' .. all_time .. '</font></h5><h4><font color=#EBEBEB>' .. desc1:gsub('<br />','<p>') .. '</font></h4></td></tr></table>'
	local answer1 = answer:match('<div class="FullstoryInfo">(.-)</div>') or ''
	local answer2 = answer:match('<div class="FullstoryKadrFormImgAc">(.-)</div>') or ''
	local answer3 = answer:match('<div class="RelatedFormTitle">(.-)<script') or ''
	local title = title_rus .. ' (' .. year .. ')'
	local t1,j,balanser={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title or 'EX-FS info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. desc1 .. '</body></html>'
		t1[1].InfoPanelTitle = desc
		t1[1].InfoPanelShowTime = 10000

		if kp_id and kp_id~=0 then
			balanser = GetBalanser_new(kp_id)
			if balanser then
			t1[2] = {}
			t1[2].Id = 2
			t1[2].Address = balanser
			t1[2].Name = 'Online: ZF'
			j = 3
			end
		end

		for w1 in answer1:gmatch('<a href=".-</a>') do
		local adr,name = w1:match('<a href="(.-)" title="(.-)"')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://ex-fs.net' .. adr
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
		j=j+1
		end
		for w2 in answer2:gmatch('<a href=".-</a>') do
		local adr,logo,name = w2:match('<a href="(.-)".-<img src="(.-)".-title="(.-)"')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
		t1[j].InfoPanelLogo = 'https://ex-fs.net' .. logo
		t1[j].InfoPanelName = t1[j].Name
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end
		for w3 in answer3:gmatch('<img src=".-<a href=".-</a>') do
		local logo,adr,name = w3:match('<img src="(.-)".-href="(.-)">(.-)<')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = 'Похожий контент: ' .. name:gsub('&#039;',"'"):gsub('&amp;',"&")
		t1[j].InfoPanelLogo = 'https://ex-fs.net' .. logo:gsub('^https://ex%-fs%.net','')
		t1[j].InfoPanelName = t1[j].Name
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀 '}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Кинопоиск'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('EX-FS: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
				media_info(inAdr)
			elseif t1[id].Name:match('Похожий контент') then
				media_info(t1[id].Address)
			elseif t1[id].Name:match('ZF') then
				setConfigVal('info/media',inAdr)
				setConfigVal('info/scheme','EXFS')
				m_simpleTV.Control.PlayAddressT({address=t1[id].Address, title=title})
			else
				page_exfs(t1[id].Address .. '/')
			end
		end
		if ret == 2 then
			run_lite_qt_exfs()
		end
		if ret == 3 then
			retAdr = inAdr
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
		end
end

function UpdatePersonEXFS()
	if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
		local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
		for SID, v in pairs(tmp_sources) do
			 if v.name:find('PERSONS') then
				tvs_core.UpdateSource(SID, false)
				tvs_func.OSD_mess('', -2)
			 end
		end
	end
end

-------------------------------------------------------------------
--[[
 local t1={}
 t1.utf8 = true
 t1.name = 'EX FS меню'
 t1.luastring = 'run_lite_qt_exfs()'
 t1.lua_as_scr = true
 t1.key = string.byte('K')
 t1.ctrlkey = 3
 t1.location = 0
 t1.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/exfs_logo.ico'
 m_simpleTV.Interface.AddExtMenuT(t1)
--]]
-----------------------------------------------------------------