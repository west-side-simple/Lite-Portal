-- ##
-- автор west_side 08/03/2022
-- мультипоиск для сайта https://filmix.ac
-- открывает ссылки типа ?паркер
-- ##
if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
local inAdr =  m_simpleTV.Control.CurrentAddress
if not string.match( inAdr, '^?.-$' ) then return end

local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'

m_simpleTV.Control.ChangeAddress='Yes'
m_simpleTV.Control.CurrentAddress = 'error'
local InfoPanelTitle, InfoPanelDesc = '', ''
local userAgent = "Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0"
local session =  m_simpleTV.Http.New(userAgent)
if not session then return end
m_simpleTV.Http.SetTimeout(session, 60000)

local search = m_simpleTV.Common.multiByteToUTF8(inAdr:gsub('^?', ''), 1251)
local logo = 'https://filmix.ac/templates/Filmix/media/img/favicon.ico'

 if m_simpleTV.Control.MainMode == 0 then
  m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'https://filmix.ac/templates/Filmix/media/img/favorites-bg.png', TypeBackColor = 0, UseLogo = 3, Once = 1})
  m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
  m_simpleTV.Control.ChangeChannelName('Search Filmix: ' .. search, m_simpleTV.Control.ChannelID, false)
 end

 m_simpleTV.Control.SetTitle('Search Filmix: ' .. search)

	local function findmedia(search)

			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl
			local body = 'scf=fx&story=' .. m_simpleTV.Common.toPercentEncoding(search) .. '&search_start=0&do=search&subaction=search&years_ot=&years_do=&kpi_ot=&kpi_do=&imdb_ot=&imdb_do=&sort_name=asc&undefined=asc&sort_date=&sort_favorite='
			local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})
			m_simpleTV.Http.Close(session)
					local otvet = answer:match('<article.-<script>') or ''
					local i, t = 1, {}
					for w in otvet:gmatch('<article.-</article>') do
					t[i] = {}
					local logo, name, adr = w:match('<a class="fancybox" href="(.-)".-alt="(.-)".-<a class="watch icon%-play" itemprop="url" href="(.-)"')
					if not logo or not adr or not name then break end
							t[i].Id = i
							t[i].Address = adr
							t[i].Name = name
							t[i].InfoPanelLogo = logo:gsub('/orig/','/thumbs/w220/')
							t[i].InfoPanelName = name
							t[i].InfoPanelShowTime = 30000
					i = i + 1
					end
		return t, i-1
	end

	local function findperson(search)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
				if not session then
				 return
				end
		m_simpleTV.Http.SetTimeout(session, 600000)
		local url_search = filmixsite .. '/persons/search/' .. search
		local rc, answer = m_simpleTV.Http.Request(session, {url = url_search})

					if rc ~= 200 then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/0.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/1.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/2.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/3.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/4.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/5.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
		m_simpleTV.Common.Sleep(5000)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/time/6.png"', text = ' ... one moment please', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
					rc, answer = m_simpleTV.Http.Request(session, {url = url_search})
					if rc ~= 200
					then
					m_simpleTV.Control.ExecuteAction(63)
					end
					end

			answer = m_simpleTV.Common.multiByteToUTF8(answer)
			answer = answer:gsub('\n', ' ')
	local i, sim = 1, {}
	for w in answer:gmatch('<div class="short">.-</a></h2>') do
	sim[i] = {}
	sim_adr, sim_img, sim_name = w:match('href="(.-)".-img src="(.-)".-<h2 class="name" itemprop="name"><a href=".-">(.-)</a></h2>')
	if not sim_adr or not sim_name then break end
							sim[i].Id = i
							sim[i].Address = sim_adr
							sim[i].Name = sim_name
							sim[i].InfoPanelLogo = sim_img:gsub('/thumbs%.filmix%.ac/','/filmix.co/uploads/'):gsub('/w220/','/thumbs/w220/')
							sim[i].InfoPanelName = sim_name
							sim[i].InfoPanelShowTime = 30000

	i = i + 1
	end
	m_simpleTV.Http.Close(session)
	return sim, i-1
	end

	local function findpersonwork(url_person)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
				if not session then
				 return
				end
					m_simpleTV.Http.SetTimeout(session, 60000)
					local rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					local k = 0

					if rc ~= 200 then
					k = k + 1
					m_simpleTV.OSD.ShowMessageT({text = ' ... one moment please ' .. k, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
					m_simpleTV.Http.Close(session)
					m_simpleTV.Common.Sleep(120000)
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
					if not session then
						return
					end
					m_simpleTV.Http.SetTimeout(session, 60000)
					rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					if rc ~= 200
					then
					k = k + 1
					m_simpleTV.OSD.ShowMessageT({text = ' ... one moment please ' .. k, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
					m_simpleTV.Http.Close(session)
					m_simpleTV.Common.Sleep(120000)
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
					if not session then
						return
					end
					m_simpleTV.Http.SetTimeout(session, 60000)
					rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					if rc ~= 200
					then
					k = k + 1
					m_simpleTV.OSD.ShowMessageT({text = ' ... one moment please ' .. k, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
					m_simpleTV.Http.Close(session)
					m_simpleTV.Common.Sleep(120000)
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
					if not session then
						return
					end
					m_simpleTV.Http.SetTimeout(session, 60000)
					rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					if rc ~= 200
					then
					k = k + 1
					m_simpleTV.OSD.ShowMessageT({text = ' ... one moment please ' .. k, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
					m_simpleTV.Http.Close(session)
					m_simpleTV.Common.Sleep(120000)
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
					if not session then
						return
					end
					m_simpleTV.Http.SetTimeout(session, 60000)
					rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					if rc ~= 200
					then
					k = k + 1
					m_simpleTV.OSD.ShowMessageT({text = ' ... one moment please ' .. k, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
					m_simpleTV.Http.Close(session)
					m_simpleTV.Common.Sleep(120000)
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
					if not session then
						return
					end
					m_simpleTV.Http.SetTimeout(session, 60000)
					rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					if rc ~= 200
					then
					k = k + 1
					m_simpleTV.OSD.ShowMessageT({text = ' ... one moment please ' .. k, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
					m_simpleTV.Http.Close(session)
					m_simpleTV.Common.Sleep(120000)
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
					if not session then
						return
					end
					m_simpleTV.Http.SetTimeout(session, 60000)
					rc, answer = m_simpleTV.Http.Request(session, {url = url_person})
					if rc ~= 200
					then
					m_simpleTV.Control.ExecuteAction(63)
					end
					end
					end
					end
					end
					end
					end

			answer = m_simpleTV.Common.multiByteToUTF8(answer)
			answer = answer:gsub('\n', ' ')

	local i, sim = 1, {}


	for w in answer:gmatch('"slider%-item">(.-)</a>') do
	sim[i] = {}
	sim_adr, sim_img, sim_name = w:match('href="(.-)">.-<img src="(.-)".-title="(.-)"')
	if not sim_adr or not sim_name then break end
							sim[i].Id = i
							sim[i].Address = sim_adr
							sim[i].Name = sim_name
							sim[i].InfoPanelLogo = sim_img
							sim[i].InfoPanelName = sim_name
							sim[i].InfoPanelShowTime = 30000
	i = i + 1
	end
	m_simpleTV.Http.Close(session)
		return sim, i-1
	end

m_simpleTV.Control.CurrentTitle_UTF8 = 'Search Filmix: ' .. search

	local t2, tn2 = findmedia(search)
	local t1, tn1 = findperson(search)

function menu1()

	t2.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎 TMDb'}
	t2.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Filmix person'}
	t2.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Filmix media: ' .. search .. ' (' .. tn2 .. ')', 0, t2, 30000, 1 + 4 + 8 + 2)
		if ret == -1 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
--		 return
		end
	if ret == 3 then

	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎 TMDb'}
	t1.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Filmix media'}
	t1.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Filmix person: ' .. search .. ' (' .. tn1 .. ')', 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == -1 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
--		 return
		end
		if ret == 2 then
			search = '=' .. m_simpleTV.Common.UTF8ToMultiByte(search)
			m_simpleTV.Control.PlayAddress(search)
		end
		if ret == 3 then
			menu1()
		end
------------------------------
		if ret == 1 then

		m_simpleTV.Control.CurrentTitle_UTF8 = t1[id].Name

		t4, tn4 = findpersonwork(t1[id].Address)
		if t4 ~= '' then
		local hash, res = {}, {}
		for i = 1, #t4 do
			t4[i].Address = tostring(t4[i].Address)
			if not hash[t4[i].Address] then
				res[#res + 1] = t4[i]
				hash[t4[i].Address] = true
			end
		end
			local AutoNumberFormat, FilterType
			if #res > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		res.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		res.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
		res.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. t1[id].Name, 0, res, 30000, 1 + 4 + 8 + 2)
	if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		menu1()
		end
	if ret == 1 then
		search = res[id].Address
		m_simpleTV.Control.CurrentTitle_UTF8 = res[id].Name
		m_simpleTV.Control.ChangeChannelLogo(res[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		search = res[id].Address
	end
	end
	end
------------------------------
	end

		if ret == 2 then
		search = '=' .. m_simpleTV.Common.UTF8ToMultiByte(search)
		m_simpleTV.Control.PlayAddress(search)
		end

	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t2[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t2[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		search = t2[id].Address
	end
end
	menu1()

	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = search
	dofile(m_simpleTV.MainScriptDir .. 'user/video/video.lua')
-- debug_in_file(search .. '\n')