-- видеоскрипт для сайта https://filmix.ac (23/07/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Scripts
-- west_side mod for lite (05/02/23)
-- ## авторизация ##
-- логин, пароль установить в 'Password Manager', для id - filmix
-- ## необходим ##
-- модуль: /core/playerjs.lua
-- AceStream
-- ## открывает подобные ссылки ##
-- https://filmix.ac/semejnyj/103212-odin-doma-2-zateryannyy-v-nyu-yorke-1992.html
-- https://filmix.ac/play/112056
-- https://filmix.ac/fantastika/113095-puteshestvenniki-2016.html
-- https://filmix.ac/download-file/55308
-- https://filmix.ac/download/5409
-- https://filmix.ac/download/35895
-- ## зеркало ##
local zer = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or ''
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://filmix%.')
			and not m_simpleTV.Control.CurrentAddress:match('^%$filmixnet')
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
	require 'playerjs'
	require 'lfs'
	require 'json'
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	local logo = 'http://m24.do.am/images/logoport.png'

	if inAdr:match('^%$filmixnet') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 0, Once = 1})
	elseif not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 1, Once = 1})
	end
	if zer ~= '' then
		inAdr = inAdr:gsub('https?://filmix%..-/', zer .. '/')
	end

	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'filmix ошибка: ' .. str, showTime = 1000 * 5, color = 0xffff6600, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
		if inAdr:match('/download%-file/') then
			local retAdr = 'torrent://' .. inAdr:gsub('https://', 'http://')
			m_simpleTV.Control.CurrentAddress = retAdr
		 return
		end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3809.87 Safari/537.36')
		if not session then
			showError('1')
			return
		end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local host = inAdr:match('https?://.-/')
		if inAdr:match('/download/') then
			local filmix_adr = inAdr:match('&(.-)$')
			inAdr = inAdr:gsub('&.-$','')
		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
		end

			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
			local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
				if rc ~= 200 then
					showError('2')
				 return
				end
			answer = m_simpleTV.Common.multiByteToUTF8(answer)
			local title, year = answer:match('<h1>Скачать бесплатно (.-)%, (%d+)<')
			title = title:gsub('<span class="title">','')
			if not year then year = 0 end
			local videodesc, background = info_fox(title,year,'')

			if m_simpleTV.Control.MainMode == 0 then
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background or logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
				m_simpleTV.Control.ChangeChannelLogo(background, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
			end

			local t, i = {}, 1
			if answer:match('<span class="item%-content"><b>.-download%-file/%d+') then
			for w in answer:gmatch('<span class="item%-content"><b>.-download%-file/%d+') do
			qual, Adr = w:match('<span class="item%-content"><b>(.-)</b></span>.-/(download%-file/%d+)')

				t[i] = {}
				t[i].Id = i
				t[i].Name = qual
				t[i].Address = host .. Adr
				i = i + 1
				end
			elseif answer:gmatch('<div class="quality"><span>.-</span></div>.-download%-file/%d+') then
			for w in answer:gmatch('<div class="quality"><span>.-</span></div>.-download%-file/%d+') do
			qual, Adr = w:match('<div class="quality"><span>(.-)</span></div>.-/(download%-file/%d+)')

				t[i] = {}
				t[i].Id = i
				t[i].Name = qual
				t[i].Address = host .. Adr
				i = i + 1
			end
			end
				if i == 1 then
					showError('3')
				 return
				end

                local retAdr
				if filmix_adr then
					t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Filmix ', ButtonScript = 'm_simpleTV.Control.PlayAddress(\'' .. filmix_adr .. '\')'}
				end
	            t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal ', ButtonScript = 'run_lite_qt_filmix()'}
				local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите торрент', 0, t, 5000, 32+64+128)
				if not id then id = 1 end
				retAdr = t[id].Address

			retAdr = 'torrent://' .. retAdr:gsub('https://', 'http://')
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.CurrentTitle_UTF8 = title
			if m_simpleTV.Control.MainMode == 0 then
				m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
			end
			m_simpleTV.Control.SetTitle(title)
		 return
		end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.filmix then
		m_simpleTV.User.filmix = {}
	end
	m_simpleTV.User.filmix.CurAddress = inAdr
	local current_np = getConfigVal('perevod/filmix') or ''
	local title
	if m_simpleTV.User.filmix.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.filmix.title .. ' - ' .. m_simpleTV.User.filmix.Tabletitle[index].Name
		end
	end
	local function ShowInfo(s)
		local q = {}
			q.once = 1
			q.zorder = 0
			q.cx = 0
			q.cy = 0
			q.id = 'AK_INFO_TEXT'
			q.class = 'TEXT'
			q.align = 0x0202
			q.top = 0
			q.color = 0xFFFFFFF0
			q.font_italic = 0
			q.font_addheight = 6
			q.padding = 20
			q.textparam = 1 + 4
			q.text = s
			q.background = 0
			q.backcolor0 = 0x90000000
		m_simpleTV.OSD.AddElement(q)
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
	end
	local function filmixIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('filmix_qlty') or 720)
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
	local function GetQualityFromAddress(Adr)
		local t, i = {}, 1
		for qlty, adr in Adr:gmatch('%[(.-)%]([^,]*)') do
			t[i] = {}
			t[i].qlty = qlty
			t[i].Name = qlty
			t[i].Address = adr
			i = i + 1
		end
			for _, v in pairs(t) do
				v.qlty = v.qlty:gsub('2K UHD', '1440'):gsub('4K UHD', '2160'):gsub('1080p Ultra%+', '1150'):gsub('p', '')
				v.qlty = tonumber(v.qlty)
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 300 then
					v.qlty = 240
				elseif v.qlty > 300 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 500 then
					v.qlty = 480
				elseif v.qlty > 500 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1100 then
					v.qlty = 1080
				elseif v.qlty > 1100 and v.qlty <= 1200 then
					v.qlty = 1100
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1444
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				elseif v.qlty > 2800 and v.qlty <= 4500 then
					v.qlty = 4320
				end
--				v.Name = v.qlty .. 'p'
			end
			if i == 1 then return end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		for i = 1, #t do
			t[i].Id = i
			t[i].Address = t[i].Address .. '$OPT:NO-STIMESHIFT'
		end
		m_simpleTV.User.filmix.Tab = t
		local index = filmixIndex(t)
	 return t[index].Address
	end
	local function SavefilmixPlaylist()
		if m_simpleTV.User.filmix.Tabletitle then
			local t = m_simpleTV.User.filmix.Tabletitle
			if #t > 250 then
				m_simpleTV.OSD.ShowMessageT({text = 'Сохранение плейлиста ...', color = 0xff9bffff, showTime = 1000 * 30, id = 'channelName'})
			end
			local header = m_simpleTV.User.filmix.title
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="filmix" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Address:gsub('^%$filmixnet', '')
					adr = GetQualityFromAddress(adr)
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '", ' .. name .. '\n' .. adr:gsub('%$OPT:.+', '') .. '\n'
				end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', ''):gsub('[\\/"%*:<>%|%?]+', ' '):gsub('%s+', ' '):gsub('^%s*', ''):gsub('%s*$', '')
			local fileEnd = ' (filmix ' .. os.date('%d.%m.%y') ..').m3u'
			local folder = m_simpleTV.Common.GetMainPath(2) .. m_simpleTV.Common.UTF8ToMultiByte('сохраненные плейлисты/')
			lfs.mkdir(folder)
			local folderAk = folder .. 'filmix/'
			lfs.mkdir(folderAk)
			local filePath = folderAk .. header .. fileEnd
			local fhandle = io.open(filePath, 'w+')
			m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 1, id = 'channelName'})
			if fhandle then
				fhandle:write(m3ustr)
				fhandle:close()
				ShowInfo('плейлист сохранен в файл\n' .. m_simpleTV.Common.multiByteToUTF8(header) .. '\nв папку\n' .. m_simpleTV.Common.multiByteToUTF8(folderAk))
			else
				ShowInfo('невозможно сохранить плейлист')
			end
		end
	end
	local function play(Adr, title)
		if session then
			m_simpleTV.Http.Close(session)
		end
		if Adr:match('/download/') then
			m_simpleTV.Control.PlayAddress(Adr)
		end
		local retAdr = GetQualityFromAddress(Adr:gsub('^%$filmixnet', ''))
			if not retAdr then
				showError('4, не доступно')
				m_simpleTV.Control.CurrentAddress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		if m_simpleTV.Control.CurrentTitle_UTF8 then
			m_simpleTV.Control.CurrentTitle_UTF8 = title
		end
		m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.CurrentAddress = retAdr
-- debug_in_file(retAdr .. '\n')
	end
	function Quality_filmix()
		local t = m_simpleTV.User.filmix.Tab
			if not t then return end
		local index = filmixIndex(t)
		if not m_simpleTV.User.filmix.isVideo then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 💾 Выгрузка ', ButtonScript = 'SavefilmixPlaylist()'}
		else
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Filmix ', ButtonScript = 'run_lite_qt_filmix()'}
		end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🧾 Теги ', ButtonScript = 'similar_filmix()'}
		if #t > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 2)
			if ret == 1 then
				m_simpleTV.Control.SetNewAddressT({address = t[id].Address, position = m_simpleTV.Control.GetPosition()})
				m_simpleTV.Config.SetValue('filmix_qlty', t[id].qlty)
				if m_simpleTV.Control.GetState() == 0 then
					m_simpleTV.Control.Restart()
				end
			end
			if ret == 2 then
			if not m_simpleTV.User.filmix.isVideo then
				SavefilmixPlaylist()
			else
				run_lite_qt_filmix()
			end
			end
			if ret == 3 then
				similar_filmix()
			end
		end
	end
	function similar_filmix()
	local t = m_simpleTV.User.filmix.TabSimilar
		if not t then return end
		if #t > 0 then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_filmix()'}
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Quality_filmix()'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🧾 Теги', 0, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
				if t[id].Name:match('Жанр: ') then
				ganres_content_filmix(t[id].Address)
				elseif t[id].Name:match('В ролях: ') or t[id].Name:match('Режиссер: ') then
				person_content_filmix(t[id].Address)
				elseif t[id].Name:match('Подборка: ') then
				collection_filmix_url(t[id].Address)
				else
				m_simpleTV.Control.PlayAddress(t[id].Address)
				end
			end
			if ret == 2 then
				perevod_filmix()
			end
			if ret == 3 then
				Quality_filmix()
			end
		end
	end
	function perevod_filmix()
	local t = m_simpleTV.User.filmix.TabPerevod
		if not t then return end
		if #t > 0 then
		local current_p = 1
		for i = 1,#t do
		if t[i].Name == getConfigVal('perevod/filmix') then current_p = i end
		i = i + 1
		end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Quality_filmix()'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(' 🔊 Перевод ', current_p - 1, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
			setConfigVal('perevod/filmix', t[id].Name)
			m_simpleTV.Control.SetNewAddress(m_simpleTV.User.filmix.CurAddress, m_simpleTV.Control.GetPosition())
			end
			if ret == 3 then
				Quality_filmix()
			end
		end
	end
	m_simpleTV.User.filmix.isVideo = false
		if inAdr:match('^%$filmixnet') then
			play(inAdr, title)
		 return
		end
	inAdr = inAdr:gsub('&kinopoisk', '')

	m_simpleTV.User.filmix.Tabletitle = nil
	local id = inAdr:match('/(%d+)')
		if not id then
			showError('6')
			m_simpleTV.Http.Close(session)
		 return
		end
	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if not login or not password or login == '' or password == '' then
			login = decode64('bWV2YWxpbA')
			password = decode64('bTEyMzQ1Ng')
		end

			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = host, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})

---------------
		rc,answer = m_simpleTV.Http.Request(session,{url=inAdr})
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
		rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login=submit', url = url1, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
		rc,answer = m_simpleTV.Http.Request(session,{url=inAdr})
		end

	answer = m_simpleTV.Common.multiByteToUTF8(answer)
	answer = answer:gsub('\n', ' ')

	title = answer:match('<title>(.-)</title>') or 'Filmix'
	title = title:gsub('[%s]?/.+', ''):gsub('[%s]?%(.+', ''):gsub('смотреть онлай.+', ''):gsub('[%s]$', ''):gsub('%&nbsp%;',' ')
	local overview = answer:match('<div class="full%-story">(.-)</div>') or ''
	overview = overview:gsub('<.->','')
	local year = answer:match('<a itemprop="copyrightYear".->(.-)</a>') or 0
	local poster = answer:match('"og:image" content="([^"]+)') or logo
	local videodesc = info_fox(title, year, poster)
	local background = answer:match('<ul class="frames%-list">(.-)</ul>')
	if background then background = background:match('"(.-)"') end
	if background then background = host .. background:gsub('^/','') end
	if poster then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background or poster:gsub('thumbs/w220','orig'), TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	title = title .. ' (' .. year .. ')'
	m_simpleTV.User.filmix.title = title
	m_simpleTV.Control.SetTitle(title)
--------------
	local j,ts = 1,{}
--------------TabGanres
	local answer_g = answer:match('<span class="label">Жанр:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href="(.-)">(.-)</a>')
	if not adr or not name then break end
	ts[j] = {}
	ts[j].Id = j
	ts[j].Name = 'Жанр: ' .. name
	ts[j].Address = adr
	j=j+1
	end
--------------TabPerson
	local answer_g = answer:match('<span class="label">Режиссер:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href ="(.-)".-"name">(.-)<')
	if not adr or not name then break end
	ts[j] = {}
	ts[j].Id = j
	ts[j].Name = 'Режиссер: ' .. name:gsub('^.+%s%s','')
	ts[j].Address = adr
	j=j+1
	end
	local answer_g = answer:match('<span class="label">В ролях:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href ="(.-)".-"name">(.-)<')
	if not adr or not name then break end
	ts[j] = {}
	ts[j].Id = j
	ts[j].Name = 'В ролях: ' .. name
	ts[j].Address = adr
	j=j+1
	end
--------------TabCollection
	local answer_g = answer:match('<span class="label">В подборках:.-</div>') or ''
	for ws in answer_g:gmatch('<a.-</a>') do
	local adr,name = ws:match('href="(.-)".-title="(.-)"')
	if not adr or not name then break end
	ts[j] = {}
	ts[j].Id = j
	ts[j].Name = 'Подборка: ' .. name
	ts[j].Address = adr
	j=j+1
	end
-------------TabSimilar
	for ws in answer:gmatch('<li class="slider%-item">.-</li>') do
	local adr,logo,name = ws:match('href="(.-)".-src="(.-)".-title="(.-)"')
	if not adr or not name then break end
	local year = adr:match('(%d%d%d%d)%.html$')
	if year then year = ', ' .. year else year = '' end
	ts[j] = {}
	ts[j].Id = j
	ts[j].Name = 'Похожий контент: ' .. name:gsub('%&nbsp%;',' ') .. year
	ts[j].Address = adr
	ts[j].InfoPanelLogo = logo
	ts[j].InfoPanelName = 'Filmix медиаконтент: ' .. name:gsub('%&nbsp%;',' ') .. year
	j=j+1
	end
-------------TabTorrent
	local tor = answer:match('href="(' .. host .. 'download/%d+)">')
	if tor then
	ts[j] = {}
	ts[j].Id = j
	ts[j].Name = 'Filmix torrent'
	ts[j].Address = tor .. '&' .. inAdr
	end
	m_simpleTV.User.filmix.TabSimilar = ts
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.filmix.TabSimilar
--------------

	local playerjs_url = answer:match('(modules/playerjs/[^\'"]+)')
		if not playerjs_url then
			showError('playerjs not found')
		 return
		end
	playerjs_url = host .. playerjs_url
	local url = host .. 'api/movies/player-data?t=' .. os.time()
	local rc, answer0 = m_simpleTV.Http.Request(session, {url = url, method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. inAdr, body = 'post_id=' .. id .. '&showfull=true' })
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			showError('9 - ' .. rc)
		 return
		end
	m_simpleTV.Http.Request(session, {url = host .. 'api/notifications/get',
	method = 'post', headers = 'X-Requested-With: XMLHttpRequest\nReferer: ' .. inAdr, body = 'page=1'})
	local tr
	if answer0:match('"video":%[%]')
	then tr = answer0:match('"trailers"(.-)}')
	else tr	= answer0:match('"video"(.-)}')
	end
		if not tr then
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Address = inAdr
		t1[1].InfoPanelName = title
		t1[1].InfoPanelShowTime = 20000
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelTitle = overview
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc:gsub('<a.-trailer%.png.->','') .. '</body></html>'
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Видео недоступно', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		similar_filmix()
		else
	local t, i, current_p = {}, 1
	local name, Adr, current_p
		for name, Adr in tr:gmatch('"(.-)":"(.-)"') do
			t[i] = {}
			t[i].Id = i
			name = unescape3(name)
			t[i].Name = name:gsub('\\/', '/')
			if t[i].Name == getConfigVal('perevod/filmix') then current_p = i end
			t[i].Address = Adr
			i = i + 1
		end

		m_simpleTV.User.filmix.TabPerevod = t

		if i == 1 then
			showError('11')
		 return
		end
	if i > 2 then
	if current_p then
	answer = t[current_p].Address
	title = title .. ' - ' .. current_np
	else
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите перевод - ' .. title, 0, t, 5000, 1)
		id = id or 1
		answer = t[id].Address
		current_p = id
		setConfigVal('perevod/filmix', t[id].Name)
		title = title .. ' - ' .. t[id].Name
	end
	else
		answer = t[1].Address
		current_p = 1
		setConfigVal('perevod/filmix', t[1].Name)
	end

	if answer0:match('"pl":"yes"') then
		local season_title = ''
		if not answer:match('^https?:') then
			inAdr = playerjs.decode(answer, playerjs_url)
		else
			inAdr = answer
		end
			if not inAdr or inAdr == '' then
				showError('12')
			 return
			end
		inAdr = inAdr:gsub('\\/', '/')
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				showError('13 - ' .. rc)
			 return
			end
		answer = answer or ''
		if answer:match('^#') then
			answer = playerjs.decode(answer, playerjs_url)
				if not answer or answer == '' then
					showError('14')
				 return
				end
			answer = m_simpleTV.Common.multiByteToUTF8(answer)
		end
		local tab = json.decode(answer:gsub('%[%]', '""'))
			if not tab then
				showError('15')
			 return
			end
		local t, i = {}, 1
		if tab[1].folder then
			local s, j, sesnom = {}, 1
				while true do
						if not tab[j] then break end
					s[j] = {}
					s[j].Id = j
					s[j].Name = tab[j].title
					s[j].Address = j
					j = j + 1
				end
				if j == 1 then
					showError('16')
				 return
				end
			if j > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, s, 5000, 1)
				if not id then
					id = 1
				end
				sesnom = s[id].Address
				season_title = ' (' .. s[id].Name .. ')'
			else
				sesnom = s[1].Address
				local ses = s[1].Name:match('%d+') or '0'
				if tonumber(ses) > 1 then
					season_title = ' (' .. s[1].Name .. ')'
				end
			end
			season_title = season_title:gsub('%(%s+', '(')
				while true do
						if not tab[sesnom].folder[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab[sesnom].folder[i].title:gsub('%(Сезон.-%)', '')
					if t[i].Name == ' ' then
						t[i].Name = '0 серия'
					end
					t[i].Address = '$filmixnet' .. tab[sesnom].folder[i].file
					t[i].InfoPanelName = title
					t[i].InfoPanelShowTime = 20000
					t[i].InfoPanelLogo = poster
					t[i].InfoPanelTitle = overview
					if videodesc ~= '' then
					t[i].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc:gsub('<a.-trailer%.png.->','') .. '</body></html>'
					end
					i = i + 1
				end
				if i == 1 then
					showError('17')
				 return
				end
		else
				while true do
						if not tab[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab[i].title
					t[i].Address = '$filmixnet' .. tab[i].file
					t[i].InfoPanelName = title
					t[i].InfoPanelShowTime = 20000
					t[i].InfoPanelLogo = poster
					t[i].InfoPanelTitle = overview
					if videodesc ~= '' then
					t[i].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc:gsub('<a.-trailer%.png.->','') .. '</body></html>'
					end
					i = i + 1
				end
				if i == 1 then
					showError('18')
				 return
				end
		end
		m_simpleTV.User.filmix.Tabletitle = t
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_filmix()'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		local pl = 0
		if i == 2 then
			pl = 32
			m_simpleTV.User.filmix.isVideo = true
		end
		title = title .. season_title
		m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 5000, pl + 64)
		m_simpleTV.User.filmix.title = title
		inAdr = t[1].Address
		title = title .. ' - ' .. m_simpleTV.User.filmix.Tabletitle[1].Name
	else
		if answer:match('^#') then
			inAdr = playerjs.decode(answer, playerjs_url)
		else
			inAdr = answer
		end
			if not inAdr or inAdr == '' then
				showError('19, не доступно')
			 return
			end
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Address = inAdr
		t1[1].InfoPanelName = title
		t1[1].InfoPanelShowTime = 20000
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelTitle = overview
		if videodesc ~= '' then
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc:gsub('<a.-trailer%.png.->','') .. '</body></html>'
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Quality_filmix()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🧾 Теги ', ButtonScript = 'similar_filmix()'}
		m_simpleTV.OSD.ShowSelect_UTF8('Filmix', 0, t1, 5000, 32 + 64 + 128)
		m_simpleTV.User.filmix.isVideo = true
	end
	end
	play(inAdr, title)
