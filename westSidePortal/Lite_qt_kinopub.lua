--Kinopub portal - lite version west_side 16.08.25
function run_lite_qt_kinopub()
	stena_clear()
	local tt = {
	{"https://kino.pub/popular","Популярные новинки"},
	{"https://kino.pub/new","Новинки кинопаба"},
	{"https://kino.pub/hot","Горячие новинки"},
	{"https://kino.pub/movie?order=views&period=month","Лидеры просмотра"},
	{"https://kino.pub/movie?order=added&period=all","Новые фильмы"},
	{"https://kino.pub/serial?order=watchers&period=all","Популярные сериалы"},
	{"https://kino.pub/serial?order=added&period=all","Новые сериалы"},
	{"https://kino.pub/concert?order=added&period=all","Новые концерты"},
	{"https://kino.pub/documovie?order=added&period=all","Новые ДокуФильмы"},
	{"https://kino.pub/docuserial?order=added&period=all","Новые Докусериалы"},
	{"https://kino.pub/tvshow?order=added&period=all","Новые ТВ шоу"},
	{"https://kino.pub/movie?genre=23","Мультфильмы"},
	{"https://kino.pub/serial?country=2","Русские сериалы"},
	{"https://kino.pub/selection","Подборки"},
	{"","ПОИСК"},
	}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию Кинопаба',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search_all()
			elseif t0[id].Name == 'Подборки' then
				show_selection(t0[id].Action)
			else
				show_select(t0[id].Action)
			end
		end
		if ret == 2 then
		run_westSide_portal()
		end
end

function show_select(inAdr)
local proxy = ''
-- '' - нет
-- 'http://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ##
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0', proxy, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 35000)

	local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name1,data1 = answer:match('kino%.pub.+%s(_csrf)%s+(%S+)')
			local name2,data2 = answer:match('kino%.pub.+%s(token)%s+(%S+)')
			local name3,data3 = answer:match('kino%.pub.+%s(_identity)%s+(%S+)')

			if
				name1 and data1 and
				name2 and data2 and
				name3 and data3
			then
				str =
				name1 .. '=' .. data1 .. ';' ..
				name2 .. '=' .. data2 .. ';' ..
				name3 .. '=' .. data3
			else
				return ''
			end
		end
		return str
	end

	local cookies = cookiesFromFile()

	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Cookie: ' .. cookies .. '\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0\nAlt-Used: kino.pub'})

	if rc ~= 200 then m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://cdn.service-kp.com/logo.png"', text = 'Kinopub: Сервис недоступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
	run_lite_qt_kinopub() return end
	answer = answer:gsub('\n', ' ')
--	debug_in_file(answer .. '\n','c://1/testpub.txt')
	local days = answer:match('title="Купить pro аккаунт">(.-)<') or '0 дн.'
	local user_icon, user_name  = answer:match('<a data%-toggle="dropdown">.-<img src="(.-)".-alt="(.-)"')
	local title1 = answer:match('<title>(.-)</title>') or 'Кинопаб'
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local all,query,current = 1,'',1
	local t,i = {},1
	if answer:match('<div class="item%-poster">') then
	current = 48
	query = ''
	all = answer:match('<h3>.->.-(%d+).-<') or 1
	for w in answer:gmatch('<div class="item%-poster">(.-)</div> </div> </div>') do
	t[i]={}
	local adr1,logo1,name1,name2 = w:match('href="(.-)".-<img src="(.-)".-title="(.-)".-title="(.-)"')
	local hd = w:match('glyphicon glyphicon%-hd%-video')
	if hd then hd = ' HD,' else hd = '' end
	local uhd = w:match('>4k<')
	if uhd then uhd = ' 4K,' else uhd = '' end
	local cc = w:match('glyphicon glyphicon%-subtitles')
	if cc then cc = ' CC,' else cc = '' end
	local dd = w:match('glyphicon glyphicon%-sound%-dolby')
	if dd then dd = ' DD' else dd = '' end
	local add = uhd .. hd .. cc .. dd
	if add ~= '' then add = ' -' .. add:gsub('%,$','') end
	local kpr = w:match('class="img%-responsive kinopoisk">(.-)<') or ' 0 '
	local imdbr = w:match('class="fab fa%-imdb"></i>(.-)<') or ' 0'
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&") .. add
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = (name1:gsub('&#039;',"'"):gsub('&amp;',"&") .. ' / ' .. name2:gsub('&#039;',"'"):gsub('&amp;',"&")):gsub(' / $','')
							t[i].InfoPanelTitle = 'KP:' .. kpr .. '/ IMDB:' .. imdbr
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
	end

	if answer:match('<div class="item%-media">') and inAdr:match('query') then
	current = 20
	query = answer:match('name="query" value="(.-)"') or ''
	all = answer:match('<h5>.-(%d+).-</h5>') or 1
	for w in answer:gmatch('<div class="item%-media">(.-)</div> </div>') do
	t[i]={}
	local adr1,logo1,lable1,name1,info1 = w:match('href="(.-)".-<img src="(.-)".-"label">(.-)<.-title="(.-)".-(<a href=.-)</li>')
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&") .. ' - ' .. lable1
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelTitle = info1:gsub('<i class="fa fa%-thumbs%-up">','👍'):gsub('<.->',''):gsub('&nbsp;',''):gsub('^   ',''):gsub('    ',' '):gsub('   ',' / ')
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
	end

	if answer:match('<div class="item%-media">') and not inAdr:match('query') and inAdr:match('/view') then

	for w in answer:gmatch('<div class="item%-media">(.-)</div> </div>') do
	t[i]={}
	local adr1,logo1,name1 = w:match('href="(.-)".-<img src="(.-)".-<a href=".-">(.-)</a>')
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelTitle = ''
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
	current = i-1
	query = ''
	all = i-1
	end

	local activ = answer:match('<li class="active"><.->(%d+)<') or 1
	if all and activ then all_pg = math.ceil(tonumber(all)/tonumber(current)) end
	local prev_pg = answer:match('<li class="prev"><a href="(.-)"')
	local next_pg = answer:match('<li class="next"><a href="(.-)"')
	title1 = title1 .. ': ' .. query .. ' (' .. all .. ') ' .. activ .. ' из ' .. all_pg
	if next_pg then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	if prev_pg then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
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
	if title1:match('Авторизоваться') then
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://cdn.service-kp.com/logo.png"', text = 'Kinopub: Вы не авторизованы', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
	run_lite_qt_kinopub() return end

	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. user_icon .. '"', text = user_name .. ': Вы авторизованы 💲 - ' .. days, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})

	if #t > 0 then
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title1, 0, t, 30000, 1 + 4 + 8 + 2)
	if ret == -1 or not id then
		 return
		end
	if ret == 1 then
	if t[id].Address:match('/view/') then
		retAdr = t[id].Address
		m_simpleTV.Control.ChangeAddress = 'No'
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.Control.CurrentAddress = retAdr
		m_simpleTV.Control.PlayAddress(retAdr)
	else
		return
	end
	end
	if ret == 2 then
	if prev_pg then
	show_select('https://kino.pub' .. prev_pg:gsub('&amp;','&'))
	else
	run_lite_qt_kinopub()
	end
	end
	if ret == 3 then show_select('https://kino.pub' .. next_pg:gsub('&amp;','&')) end
	else
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Kinopub: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	end
end

function show_selection(inAdr)
local proxy = ''
-- '' - нет
-- 'http://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ##
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0', proxy, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)

	local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name1,data1 = answer:match('kino%.pub.+%s(_csrf)%s+(%S+)')
			local name2,data2 = answer:match('kino%.pub.+%s(token)%s+(%S+)')
			local name3,data3 = answer:match('kino%.pub.+%s(_identity)%s+(%S+)')

			if
				name1 and data1 and
				name2 and data2 and
				name3 and data3
			then
				str =
				name1 .. '=' .. data1 .. ';' ..
				name2 .. '=' .. data2 .. ';' ..
				name3 .. '=' .. data3
			else
				return ''
			end
		end
		return str
	end

	local cookies = cookiesFromFile()

	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Cookie: ' .. cookies .. '\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0\nAlt-Used: kino.pub'})

		if rc ~= 200 then return end
	answer = answer:gsub('\n', ' ')

	local title1 = answer:match('<title>(.-)</title>') or 'Кинопаб'
	if not m_simpleTV.Control.CurrentAdress then
		m_simpleTV.Control.SetTitle(title1)
	end
	local t,i = {},1

	local current = 48
	local query = ''
	local all = 524
	for w in answer:gmatch('id="selection(.-)</div> </div>') do

	t[i]={}
	local adr1,logo1,name1 = w:match('href="(.-)"><img src="(.-)".-<a href=".-">(.-)</a>')
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
	local activ = answer:match('<li class="active"><.->(%d+)<') or 1
	if all and activ then all_pg = math.ceil(tonumber(all)/tonumber(current)) end
	local prev_pg = answer:match('<li class="prev"><a href="(.-)"')
	local next_pg = answer:match('<li class="next"><a href="(.-)"')
	title1 = title1 .. ': ' .. query .. ' (' .. all .. ') ' .. activ .. ' из ' .. all_pg
	if next_pg then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
	end
	if prev_pg then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
	else
	t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	end
	if title1:match('Авторизоваться') then
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://cdn.service-kp.com/logo.png"', text = 'Kinopub: Вы не авторизованы', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
	run_lite_qt_kinopub() end
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title1, 0, t, 30000, 1 + 4 + 8 + 2)
	if ret == -1 or not id then
		 return
		end
	if ret == 1 then
		show_select(t[id].Address)
	end
	if ret == 2 then
	if prev_pg then
	show_selection('https://kino.pub' .. prev_pg:gsub('&amp;','&'))
	else
	run_lite_qt_kinopub()
	end
	end
	if ret == 3 then show_selection('https://kino.pub' .. next_pg:gsub('&amp;','&')) end
	end

-------------------------------------------------------------------
----[[
 local t={}
 t.utf8 = true
 t.name = 'Кинопаб меню'
 t.luastring = 'run_lite_qt_kinopub()'
 t.lua_as_scr = true
 t.key = string.byte('J')
 t.ctrlkey = 3
 t.location = 0
 t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/kinopub_logo.png'
 m_simpleTV.Interface.AddExtMenuT(t)
 --]]
-------------------------------------------------------------------