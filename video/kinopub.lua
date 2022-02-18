-- видеоскрипт для воспроизведения медиа с сайта https://kino.pub (11/09/21) - автор west_side
-- необходим действующий аккаунт на сайте https://kino.pub
-- работает в связке со скриптом Lite_qt_kinopub.lua - автор west_side
-- необходимо сгенерировать cookies в браузере Mozilla, дополнение cookies.txt.
-- сохранить файл в директорию ..\work\ используемого плеера SimpleTV.

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('https?://kino%.pub')
	and not inAdr:match('^%,')
	then return end

	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	kinopub_search = inAdr:match('^%,(.-)$') or ''
	kinopub_search = m_simpleTV.Common.multiByteToUTF8(kinopub_search,1251)
	if kinopub_search ~= '' then inAdr = 'https://kino.pub/item/search?query=' .. m_simpleTV.Common.toPercentEncoding(kinopub_search) end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)

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

if inAdr == ',' then
local title2 = 'Кинопаб'
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://cdn.service-kp.com/logo.png', TypeBackColor = 0, UseLogo = 1, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo('https://cdn.service-kp.com/logo.png', m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title2, m_simpleTV.Control.ChannelID, false)
	end
	m_simpleTV.Control.SetTitle(title2)
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

  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию Кинопаба',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end

		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				m_simpleTV.Control.ExecuteAction(105, 1)
				return
			else
				show_select(t0[id].Action)
			end
		end
end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Cookie: ' .. cookies})
--	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	answer = answer:gsub('\n', ' ')
	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	if inAdr:match('/tv/view/') then

	local title1 = answer:match('<title>(.-)</title>') or 'Кинопаб'
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://cdn.service-kp.com/logo.png', TypeBackColor = 0, UseLogo = 1, Once = 1})
		m_simpleTV.Control.ChangeChannelName(title1:gsub('&#039;',"'"):gsub('&amp;',"&"), m_simpleTV.Control.ChannelID, false)
	end
	m_simpleTV.Control.SetTitle(title1)
	retAdr = answer:match('<source src=\'(.-)\'')

	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr

	elseif not inAdr:match('/item/view/') then
	local title1 = answer:match('<title>(.-)</title>') or 'Кинопаб'
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://cdn.service-kp.com/logo.png', TypeBackColor = 0, UseLogo = 1, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo('https://cdn.service-kp.com/logo.png', m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title1:gsub('&#039;',"'"):gsub('&amp;',"&"), m_simpleTV.Control.ChannelID, false)
	end
	m_simpleTV.Control.SetTitle(title1)
	local all,query,current = 1,kinopub_search,1
	local t,i = {},1
	if answer:match('<div class="item%-poster">') then
	current = 48
	query = ''
	all = answer:match('<h3>.->.-(%d+).-<') or 1
	for w in answer:gmatch('<div class="item%-poster">(.-)</div> </div> </div>') do
	t[i]={}
	local adr1,logo1,name1 = w:match('href="(.-)".-<img src="(.-)".-title="(.-)"')
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
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
	local adr1,logo1,name1 = w:match('href="(.-)".-<img src="(.-)".-title="(.-)"')
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
	end

	if answer:match('<div class="item%-media">') and not inAdr:match('query') and inAdr:match('/view/') then
	for w in answer:gmatch('<div class="item%-media">(.-)</div> </div>') do
	t[i]={}
	local adr1,logo1,name1 = w:match('href="(.-)".-<img src="(.-)".-<a href=".-">(.-)</a>')
					if not logo1 or not adr1 or not name1 then break end
							t[i].Id = i
							t[i].Address = 'https://kino.pub' .. adr1
							t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelLogo = logo1
							t[i].InfoPanelName = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
	current = i-1
	query = ''
	all = i-1
	end

	if answer:match('id="selection') and not inAdr:match('query') and not inAdr:match('/view/') then
	current = 48
	query = ''
	all = 524
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

	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title1, 0, t, 30000, 1 + 4 + 8 + 2)
	if ret == -1 or not id then
		 return
		end
	if ret == 1 then
		show_select(t[id].Address)
	end
	if ret == 2 then
	if prev_pg then
	show_select('https://kino.pub' .. prev_pg:gsub('&amp;','&'))
	else
	run_lite_qt_kinopub()
	end
	end
	if ret == 3 then show_select('https://kino.pub' .. next_pg:gsub('&amp;','&')) end
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
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title1, 0, t, 30000, 1 + 4 + 8 + 2)
	if ret == -1 or not id then
		 return
		end
	if ret == 1 then
	if t[id].Address:match('/view/') then
		retAdr = t[id].Address
		m_simpleTV.Control.CurrentTitle_UTF8 = t[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	else
		show_select(t[id].Address)
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
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.PlayAddress(retAdr)

else

	local function GetQlty(answer1)

	local i, t = 1, {}
	local index = 1
	local adr1 = answer1:match('<a href="(.-)"')
	for w in answer1:gmatch('<a.-</a>') do
	local adr, qlty = w:match('<a href="(.-)">(.-)</a>')

	if not qlty or not adr then break end
	t[i] = {}
	t[i].Id = i
	t[i].Name = qlty
	t[i].Address = adr
	if qlty == tostring(m_simpleTV.Config.GetValue('kinopub_qlty')) then index = i adr1 = adr end
	i=i+1
	end

	return adr1, t, index
	end

	function OnMultiAddressOk_kinopub(Object, id)
		if id == 0 then
			OnMultiAddressCancel_kinopub(Object)
		else
			m_simpleTV.User.kinopub.DelayedAddress = nil
		end
	end

	function OnMultiAddressCancel_kinopub(Object)
		if m_simpleTV.User.rezka.DelayedAddress then
			local state = m_simpleTV.Control.GetState()
			if state == 0 then
				m_simpleTV.Control.SetNewAddress(m_simpleTV.User.kinopub.DelayedAddress)
			end
			m_simpleTV.User.kinopub.DelayedAddress = nil
		end
		m_simpleTV.Control.ExecuteAction(36, 0)
	end

	function Qlty_kinopub(answer)

		local adr2, t, index = GetQlty(answer)
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index-1, t, 5000, 1 + 4 + 2)
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('kinopub_qlty', t[id].Name)
		end
		if ret == 2 then
			run_lite_qt_kinopub()
		end
	end

	function tags_kinopub(answer)

		local t1,j={},1
		for w1 in answer:gmatch('<a class="text%-success" href="/movie%?genre.-</a>') do
		local adr,name = w1:match('<a class="text%-success" href="(/movie%?genre.-)">(.-)</a>')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://kino.pub' .. adr
		t1[j].Name = m_simpleTV.Common.multiByteToUTF8(name:gsub('&#039;',"'"):gsub('&amp;',"&"),1251)
		j=j+1
		end

		for w1 in answer:gmatch('<a class="text%-success" href="/serial%?genre.-</a>') do
		local adr,name = w1:match('<a class="text%-success" href="(/serial%?genre.-)">(.-)</a>')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://kino.pub' .. adr
		t1[j].Name = m_simpleTV.Common.multiByteToUTF8(name:gsub('&#039;',"'"):gsub('&amp;',"&"),1251)
		j=j+1
		end

		for w1 in answer:gmatch('<a class="text%-success" href="/item/search.-</a>') do
		local name = w1:match('<a class="text%-success" href="/item/search.->(.-)</a>')
		if not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://kino.pub/item/search?query=' .. m_simpleTV.Common.toPercentEncoding(m_simpleTV.Common.multiByteToUTF8(name,1251))
		t1[j].Name = m_simpleTV.Common.multiByteToUTF8(name:gsub('&#039;',"'"):gsub('&amp;',"&"),1251)
		j=j+1
		end

		for w1 in answer:gmatch('<a class="text%-success" href="/selection/view.-</a>') do
		local adr,name = w1:match('<a class="text%-success" href="(/selection/view.-)">(.-)</a>')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://kino.pub' .. adr
		t1[j].Name = 'Подборка - ' .. m_simpleTV.Common.multiByteToUTF8(name:gsub('&#039;',"'"):gsub('&amp;',"&"),1251)
		j=j+1
		end

		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🧾 Теги', 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			show_select(t1[id].Address)
		end
	end

	function Season_kinopub(answer2)

		local t1,j={},1
		for w1 in answer2:gmatch('<span class="p%-r%-sm p%-t%-sm">.-</a>') do
		local types, adr, name = w1:match('<a class="(.-)".-href="(.-)".-role="button">(.-)</a>')
		if not adr then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://kino.pub' .. adr
		if not types:match('outline')
		then
		se = j
		end
		t1[j].Name = ' Сезон ' .. name
		j=j+1
		end
			t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('📺 Сезоны:', se-1, t1, 5000, 1 + 4 + 2)
		if ret == 1 then
			m_simpleTV.Control.PlayAddress(t1[id].Address)
		end
	end

	local qlty = m_simpleTV.Config.GetValue('kinopub_qlty')
	local answer1 = answer:match('<li class="dropdown%-header">Файл mp4</li>(.-)<li class="dropdown%-header">HLS плейлист</li>')
	local answer2 = answer:match('<span class="season%-title m%-l%-sm p%-r%-sm">.-</div> </div>')
	local answer3 = answer:match('<td><strong>Год.-</tbody>')
	local retAdr = GetQlty(answer1) or 'https://yandex-cdn.net/hls4/aWQ9MTc5MTE5OzMxNjQ4MDg1MzU7MTMzMjg0NjQ7MTYzMjE2ODMwMCZoPTVjM2lkeUVZOWVVM1JzSnZtVUgzMHcmZT0xNjMyMjU0NzAw/demo.m3u8?loc=nl'
	local title = answer:match('<title>(.-)</title>') or 'KinoPub'
	local year = answer:match('?years=(%d+)')
	if year then year = tonumber(year) title = title .. ' (' .. year .. ')' end
	local logo = answer:match('<hr>.-<img src="(.-)"') or 'https://cdn.service-kp.com/logo.png'
	local desc_text = answer:match('id="plot">(.-)<') or ''
	local videodesc = info_fox(title:gsub('&#039;',"'"):gsub('&amp;',"&"):gsub(' %(.-$',''):gsub(' /.-$',''),year,logo)
	local imdb_id = answer:match('href="http://www%.imdb%.com/title/(.-)"')
	if imdb_id then
--ошибки базы
	imdb_id=imdb_id:gsub('tt0596345','tt1596345')
--
	logo = bg_imdb_id(imdb_id)
	end

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title:gsub('&#039;',"'"):gsub('&amp;',"&"), m_simpleTV.Control.ChannelID, false)
	end
--------------serial
	if answer:match('<div class="row m%-b">') then
		local t, t1, i, j = {}, {}, 1, 1
		local e = 1
		local se, se_name = 1, title:gsub(' %(.-$',''):gsub(' %/.-$',''):gsub('&#039;',"'"):gsub('&amp;',"&")
		if answer:match('<span class="season%-title m%-l%-sm p%-r%-sm">.-</span>') then
		for w1 in answer:gmatch('<span class="p%-r%-sm p%-t%-sm">.-</a>') do
		local types, adr, name = w1:match('<a class="(.-)".-href="(.-)".-role="button">(.-)</a>')
		if not adr then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = 'https://kino.pub' .. adr
		if not types:match('outline')
		then
		se = j
		se_name = title:gsub(' %(.-$',''):gsub(' %/.-$',''):gsub('&#039;',"'"):gsub('&amp;',"&") .. ' (Сезон ' .. name .. ')'
		end
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
		j=j+1
		end
		end
		if answer:match('<div class="item episode%-thumbnail".-</a> </div>.-<li class="dropdown%-header">Файл mp4</li>') then
		local answer3 = answer:match('<div class="item episode%-thumbnail".-</div> </div> </div> </div>')
		for w in answer3:gmatch('<div class="item episode%-thumbnail".-</a> </div>') do
		local adr, logo, name1 = w:match('<a href="(.-)".-<img src="(.-)".-<span class="label label%-primary episode%-number">(.-)</span>')
		local name2 = w:match('<a href=".-".-<img src=".-".-<span class="label label%-primary episode%-number">.-</span>.-<a href=".-">(.-)<') or ''
		if name2 ~= '' then name2 = ' - ' .. name2 end
		if not adr then break end
		t[i] = {}
		t[i].Id = i
		t[i].Address = 'https://kino.pub' .. adr
		if inAdr == t[i].Address then e = i end
		t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&") .. name2:gsub('&#039;',"'"):gsub('&amp;',"&")
		t[i].InfoPanelTitle = desc_text
		if not se_name:match('Сезон') then se_name = '' end
		t[i].InfoPanelName = title:gsub(' %(.-$',''):gsub(' %/.-$',''):gsub('&#039;',"'"):gsub('&amp;',"&") .. ' (' .. (se_name:gsub('%)',''):gsub('^.-%(','') .. ', '  .. name1:gsub('&#039;',"'"):gsub('&amp;',"&") .. name2:gsub('&#039;',"'"):gsub('&amp;',"&") .. ')'):gsub('^%, ','')
		t[i].InfoPanelShowTime = 8000
		t[i].InfoPanelLogo = logo
		t[i].InfoPanelDesc = '<html><body' .. videodesc .. '</body></html>'
		i=i+1
		end
	else
		for w in answer:gmatch('<div class="item episode%-thumbnail".-</div> </div> </div>') do
		local adr, logo, name1 = w:match('<a href="(.-)".-<img src="(.-)".-<span class="label label%-primary episode%-number">(.-)</span>')

		if not adr then break end
		t[i] = {}
		t[i].Id = i
		t[i].Address = 'https://kino.pub' .. adr
		if inAdr == t[i].Address then e = i end
		t[i].Name = name1:gsub('&#039;',"'"):gsub('&amp;',"&")
		t[i].InfoPanelTitle = desc_text
		if not se_name:match('Сезон') then se_name = '' end
		t[i].InfoPanelName = title:gsub(' %(.-$',''):gsub(' %/.-$',''):gsub('&#039;',"'"):gsub('&amp;',"&") .. ' (' .. (se_name:gsub('%)',''):gsub('^.-%(','') .. ', ' .. name1:gsub('&#039;',"'"):gsub('&amp;',"&") .. ')'):gsub('^%, ','')
		t[i].InfoPanelShowTime = 8000
		t[i].InfoPanelLogo = logo
		t[i].InfoPanelDesc = '<html><body' .. videodesc .. '</body></html>'
		i=i+1
		end
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_kinopub(\'' .. answer1 .. '\')'}
		if se_name ~= '' and answer2 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '📺', ButtonScript = 'Season_kinopub(\'' .. answer2 .. '\')'}
		else
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '🧾', ButtonScript = 'tags_kinopub(\'' .. answer3 .. '\')'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8(se_name, e-1, t, 8000, 32 + 64 + 128)

	else
--------------not serial

		local t = {}
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title:gsub('&#039;',"'"):gsub('&amp;',"&")
		t[1].InfoPanelTitle = desc_text
		t[1].InfoPanelName = title:gsub('&#039;',"'"):gsub('&amp;',"&")
		t[1].InfoPanelShowTime = 8000
		t[1].InfoPanelLogo = logo
		t[1].InfoPanelDesc = '<html><body' .. videodesc .. '</body></html>'
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_kinopub(\'' .. answer1 .. '\')'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '🧾', ButtonScript = 'tags_kinopub(\'' .. answer3 .. '\')'}

		m_simpleTV.OSD.ShowSelect_UTF8('Kinopub', 0, t, 8000, 32 + 64 + 128)
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = retAdr
	end
-- debug_in_file(retAdr .. '\n')