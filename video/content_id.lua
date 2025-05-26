-- видеоскрипт воспроизведения контента по content_id (08/01/24)
-- author west_side
-- открывает подобные ссылки:
-- content_id=622e87da83dcfc38d2c69f1a&magnet:?xt=urn:btih:BB7C024231B3D9A7C90BBD7490B3B048DE46818A
-- content_id=622e5c0583dcfc38d2b9bb00_1_1&balanser=seriahd&https://hye1eaipby4w.takedwn.ws/05_05_21/05/05/08/4GM4MCXW/EI27ZPOP.mp4/master.m3u8

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^content_id=') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''

	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.torrent then
		m_simpleTV.User.torrent = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	if not m_simpleTV.User.hdua then
		m_simpleTV.User.hdua = {}
	end
	if not m_simpleTV.User.westSide then
		m_simpleTV.User.westSide = {}
	end
	m_simpleTV.User.westSide.PortalTable,m_simpleTV.User.TMDB.tv,m_simpleTV.User.TMDB.Id,m_simpleTV.User.hdua.serial=nil,nil,nil,nil
	m_simpleTV.User.torrent.balanser = nil
	m_simpleTV.User.torrent.seria_title = nil
	m_simpleTV.User.torrent.seria_id = nil
--	m_simpleTV.User.torrent.audio_id = nil
	m_simpleTV.User.torrent.tr = nil
	m_simpleTV.User.torrent.Tab1 = nil
--	m_simpleTV.User.torrent.audio_ind = nil
	m_simpleTV.User.torrent.audio_name = nil
--	m_simpleTV.User.torrent.seria_title = nil
	m_simpleTV.User.torrent.content = nil
	m_simpleTV.User.torrent.audio_epi_id = nil

	local content_id = inAdr:match('id=(.-)%&')
	local content_id_episode
	if content_id:match('_') then
		content_id_episode = content_id
		m_simpleTV.User.torrent.seria_id = content_id_episode
	end
	content_id = content_id:gsub('_.-$','')
	local tr = inAdr:match('%&tr=(%d+)') or ''
--	local res = inAdr:match('%&res=(%d+p)') or ''
	local balanser = inAdr:match('balanser=(.-)%&')
	m_simpleTV.User.torrent.balanser = balanser
	local retAdr = inAdr:gsub('content_id=.-%&',''):gsub('balanser=.-%&',''):gsub('tr=.-$','')
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local url = 'http://api.vokino.tv/v2/view/'	.. content_id .. '?token=' .. token
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.details or not tab.details.id or not tab.details.name
	then
	return end
	local title = tab.details.name
	local poster = tab.details.poster or ''
	local background = tab.details.bg_poster.backdrop
	local released = tab.details.released or ''
	local desc = tab.details.about
	local logo
	if background then logo = background:gsub('original','w500')
		elseif poster then logo = poster:gsub('w600_and_h900','w300_and_h450')
		else logo = 'http://m24.do.am/images/logoport.png'
	end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	m_simpleTV.User.torrent.title = title
	m_simpleTV.User.torrent.year = released
	m_simpleTV.User.torrent.poster = poster
	title = title .. ' (' .. released .. ')'
	add_to_history_tracker(inAdr,title,poster)
	m_simpleTV.Control.ChangeChannelLogo(logo , m_simpleTV.Control.ChannelID)
	if m_simpleTV.User.torrent.content ~= content_id then m_simpleTV.User.torrent.audio_id = nil end
	m_simpleTV.User.torrent.content = content_id
	m_simpleTV.Config.SetValue('info/torrent',content_id,'LiteConf.ini')
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.torrent.content
	if balanser == 'seriahd' or balanser == 'videocdn' or balanser == 'collaps' then
		m_simpleTV.User.torrent.tr = 'http://api.vokino.tv/v2/online/' .. m_simpleTV.User.torrent.balanser .. '?id=' .. m_simpleTV.User.torrent.content .. '&tr=' .. tr
	end
--	m_simpleTV.User.torrent.res = res
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAddress = 'error'

--	debug_in_file(content_id .. ' - ' .. retAdr .. '\n' .. (m_simpleTV.User.torrent.content or 'not') .. '\n' .. (m_simpleTV.User.westSide.PortalTable or 'not') .. '\n','c://1/content.txt')

	local function GetSerial()
		local tr
		if m_simpleTV.User.torrent.tr then
			tr = m_simpleTV.User.torrent.tr:match('%d+$')
		end
		local res
		if m_simpleTV.User.torrent.res then
			res = m_simpleTV.User.torrent.res
		end
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		local url = 'http://api.vokino.tv/v2/online/' .. balanser .. '?id=' .. content_id .. '&token=' .. token
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
--		debug_in_file( '\n' .. url .. '\n' .. answer .. '\n', 'c://1/cdn.txt', setnew )
		local tab = json.decode(answer)
		if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].submenu or not tab.channels[1].submenu[1]
		then
		return end
		local t, i, n, id_seria = {}, 1, 1, 1
		while true do
			if not tab.channels[i] or not tab.channels[i].submenu
				then
				break
				end
			local j = 1
			while true do
				if not tab.channels[i].submenu[j] or not tab.channels[i].submenu[j].ident
--				or not tab.channels[i].submenu[j].stream_url
					then
					break
					end
				t[n]={}
				t[n].Id = n
--[[				local k, subtitle = 1,''
				while true do
					if not tab.channels[i].submenu[j].subtitles or not tab.channels[i].submenu[j].subtitles[k] or not tab.channels[i].submenu[j].subtitles[k][2]
						then
						break
						end
					subtitle = subtitle .. '#' .. tab.channels[i].submenu[j].subtitles[k][2]
					k=k+1
				end
				if subtitle ~= '' then
					subtitle = '$OPT:sub-track=0$OPT:input-slave=' .. subtitle:gsub('^#',''):gsub('://', '/webvtt://')
				end--]]
--				t[n].Address1 = tab.channels[i].submenu[j].stream_url:gsub('%.mp4.-$','.mp4') .. subtitle
				t[n].Address2 = tab.channels[i].submenu[j].ident
--				t[n].Address = 'content_id=' .. t[n].Address .. '&balanser=' .. balanser .. '&' .. t[n].Address1
				t[n].Address = 'content_id=' .. t[n].Address2 .. '&balanser=' .. balanser .. '&tr=' .. (tr or '')
				t[n].Name = tab.channels[i].title .. ', ' .. tab.channels[i].submenu[j].title
	--			debug_in_file( '\n' .. t[n].Name .. '\n' .. t[n].Address .. '\n', 'c://1/cdn.txt', setnew )
				if content_id_episode == tab.channels[i].submenu[j].ident then
					id_seria = n
					m_simpleTV.User.torrent.seria_title = t[n].Name
					m_simpleTV.User.torrent.id_seria = n
				end
				t[n].InfoPanelName = title .. ' ' .. t[n].Name
				t[n].InfoPanelTitle = desc
				t[n].InfoPanelLogo = logo
				j=j+1
				n=n+1
			end
			i=i+1
		end
		m_simpleTV.User.torrent.serial = t -- таблица всех эпизодов балансера
		local t1, j = {}, 1
		while true do
			if not tab.menu or not tab.menu[1] or not tab.menu[1].submenu or not tab.menu[1].submenu[j] or not tab.menu[1].submenu[j].playlist_url
				then
				break
				end
			t1[j]={}
			t1[j].Id = j
			t1[j].Name = tab.menu[1].submenu[j].title:gsub('%) %(',', '):gsub('%)',''):gsub('%(',''):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub(' закадровый',''):gsub('Неизвестно','выбор CDN')
			t1[j].Address1 = tab.menu[1].submenu[j].playlist_url:match('%&tr=(%d+)')
			t1[j].Address = tab.menu[1].submenu[j].playlist_url
			j=j+1
		end
		if #t1 ~= 0 then
			m_simpleTV.User.torrent.audio_ind = t1 -- таблица всех озвучек балансера
		end
		return true
	end

	local function GetCurVoiceEpisode()
		local adr
		local str = '✅ '
		for i = 1,#m_simpleTV.User.torrent.audio_epi do
			if m_simpleTV.User.torrent.tr and m_simpleTV.User.torrent.tr == m_simpleTV.User.torrent.audio_epi[i].Address then
				str = str .. '✅ ' .. m_simpleTV.User.torrent.audio_epi[i].Name .. '\n'
				adr = m_simpleTV.User.torrent.audio_epi[i].Address_str:gsub('%.mp4.-$','.mp4') .. m_simpleTV.User.torrent.audio_epi[i].Address_sub
				m_simpleTV.User.torrent.audio_name = m_simpleTV.User.torrent.audio_epi[i].Name
				m_simpleTV.User.torrent.audio_epi_id = i
			else
				str = str .. m_simpleTV.User.torrent.audio_epi[i].Name .. '\n'
			end
			i=i+1
		end
		if adr == nil then
			adr = m_simpleTV.User.torrent.audio_epi[1].Address_str:gsub('%.mp4.-$','.mp4') .. m_simpleTV.User.torrent.audio_epi[1].Address_sub
			m_simpleTV.User.torrent.audio_name = m_simpleTV.User.torrent.audio_epi[1].Name
		else
			str = str:gsub('^✅ ','')
		end
		m_simpleTV.OSD.ShowMessageT({text = str, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		title = title:gsub('%).-$', ')') .. ' ' .. m_simpleTV.User.torrent.seria_title .. ' - ' .. m_simpleTV.User.torrent.audio_name
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.Control.SetTitle(title)
		return adr
	end

	local function GetSeriaAdr()
		for i = 1,#m_simpleTV.User.torrent.serial do
		if m_simpleTV.User.torrent.seria_id and m_simpleTV.User.torrent.seria_id == m_simpleTV.User.torrent.serial[i].Address2 then
		return m_simpleTV.User.torrent.serial[i].Address1
		end
		i=i+1
		end
		return m_simpleTV.User.torrent.serial[1].Address1
	end

---------------------------------------блок COLLAPS

	local function StreamIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('Stream_qlty') or 5000)
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

	local function GetStreamAdr(url)
		local transl = m_simpleTV.User.torrent.tr or '&tr=0'
		transl = transl:match('%d+')
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('%$OPT.-$','')})
			if rc ~= 200 then return end
		local subt = url:match('(%$OPT.-)$') or ''
		local t1 = {}
			for w1 in answer:gmatch('GROUP%-ID="audio0".-%.m3u8') do
				local name = w1:match('NAME="(.-)"')
				local lang = w1:match('LANGUAGE="(.-)"')
				local audio_ind = w1:match('index%-a(%d+)')
				if lang and audio_ind then
					t1[#t1 + 1] = {}
					t1[#t1].Number = tonumber(audio_ind)
					t1[#t1].Name = t1[#t1].Number .. '. ' .. lang
				end
			end
			for i = 1, #t1 do
				t1[i].Id = i
				t1[i].Name = t1[i].Name
				t1[i].Number = t1[i].Number
				if transl == t1[i].Number then
				m_simpleTV.User.torrent.tr = '&tr=' .. i - 1
				m_simpleTV.User.torrent.audio_name = t1[i].Name
				end
				i = i + 1
			end
			if #t1 == 0 then
			t1 = nil
			end
		m_simpleTV.User.torrent.audio_ind = t1
		local t = {}
			for w, adr in answer:gmatch('EXT%-X%-STREAM%-INF(.-)\n(.-)\n') do
				local qlty = w:match('RESOLUTION=%d+x(%d+)')
				if adr and adr:match('x%-bc') and qlty then
					t[#t + 1] = {}
					t[#t].Address = adr
					t[#t].qlty = tonumber(qlty)
				end
			end
			if #t == 0 then return end
			for _, v in pairs(t) do
				v.qlty = tonumber(v.qlty)
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 240 then
					v.qlty = 240
				elseif v.qlty > 240 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 480 then
					v.qlty = 480
				elseif v.qlty > 480 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1200 then
					v.qlty = 1080
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1444
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				else
					v.qlty = 4320
				end
				v.Name = v.qlty .. 'p'
			end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address:gsub('%.m3u8', '-a' .. (transl + 1) ..'.m3u8') .. subt
			end
		m_simpleTV.User.torrent.Tab = t
		local index = StreamIndex(t)
	 return t[index].Address
	end

	function Qlty_Stream()
		local t = m_simpleTV.User.torrent.Tab
			if not t or #t == 0 then return end
		m_simpleTV.Control.ExecuteAction(37)
		local index = StreamIndex(t)
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'content(\'' .. m_simpleTV.User.torrent.content .. '\')'}
		if m_simpleTV.User.torrent.audio_ind then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка', ButtonScript = 'Audio_Stream()'}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 10000, 1 + 4)
		if ret == 1 then
			local retAdr = t[id].Address
			m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('Stream_qlty', t[id].qlty)
		end
		if ret == 2 then
		content(m_simpleTV.User.torrent.content)
		end
		if ret == 3 then
		Audio_Stream()
		end
	end

	function Audio_Stream()
		local t = m_simpleTV.User.torrent.audio_ind
			if not t or #t == 0 then return end
		m_simpleTV.Control.ExecuteAction(37)
		local index = m_simpleTV.User.torrent.tr or '&tr=0'
		index = index:match('%d+')
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'content(\'' .. m_simpleTV.User.torrent.content .. '\')'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ Качество', ButtonScript = 'Qlty_Stream()'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', index, t, 10000, 1 + 4)
		if ret == 1 then
--			m_simpleTV.User.torrent.tr = id
			m_simpleTV.User.torrent.audio_name = t[id].Name
			m_simpleTV.User.torrent.tr = '&tr=' .. (id - 1)
--			GetSerial()
--			local retAdr = GetSeriaAdr()
			local retAdr = m_simpleTV.Control.CurrentAdress:gsub('%-a.-%.m3u8', '-a' .. t[id].Number .. '.m3u8')
--			retAdr = GetStreamAdr(retAdr)
			m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())

		end
		if ret == 2 then
		content(m_simpleTV.User.torrent.content)
		end
		if ret == 3 then
		Qlty_Stream()
		end
	end
---------------------------------------конец блока COLLAPS

---------------------------------------блок CDN

	local function check_address(adr)--проверка отклика потока
		local rc, answer = m_simpleTV.Http.Request(session, {url = adr, method = 'get'})
		if rc == 200 and answer:match('^%#EXTM3U') then
			return true
		end
		return false
	end

	local function CDNIndex(t)--вывод индекса качества потока
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('CDN_qlty') or 5000)
		local index = 1
			for i = 1, #t do
				if tonumber(t[i].qlty) == lastQuality then
					index = i
				end
			end
			if tonumber(t[#t].qlty) > lastQuality then
				index = #t
			end
	 return index
	end

	local function voiceover_check(url)--проверка озвучек откликом потока
		local name,address,res
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		local rc, answer = m_simpleTV.Http.Request(session, {url = url .. '&token=' .. token})
			if rc ~= 200 then return end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		local t1, j = {}, 1
		while true do
			if not tab.menu or not tab.menu[1] or not tab.menu[1].submenu or not tab.menu[1].submenu[j] or not tab.menu[1].submenu[j].playlist_url
				then
				break
				end
			t1[j]={}
			t1[j].Id = j
			t1[j].Name = tab.menu[1].submenu[j].title
			t1[j].Address = tab.menu[1].submenu[j].playlist_url
			if t1[j].Address == url then
			name, address = t1[j].Name, t1[j].Address
			end
			j=j+1
			end
		if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].stream_url then
			res = false
		else
			res = check_address(tab.channels[1].stream_url)
		end
		return name:gsub('%) %(',', '):gsub('%)',''):gsub('%(',''):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub(' закадровый',''):gsub('Неизвестно','Выбор CDN'), address:match('%tr=(%d+)'), res
	end

	local function GetVoiceCDN()--создание таблицы озвучек за счет проверки озвучек
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		local url = 'http://api.vokino.tv/v2/online/videocdn?id=' .. content_id .. '&token=' .. token
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then return end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		local t,t1,i,j = {},{},1,1
		while true do
			if not tab.menu or not tab.menu[1] or not tab.menu[1].submenu or not tab.menu[1].submenu[j] or not tab.menu[1].submenu[j].playlist_url
				then
				break
				end
			t1[j]={}
			t1[j].Address = tab.menu[1].submenu[j].playlist_url
			j=j+1
		end

		local tt, k = {}, 1
		for j=1,#t1 do
			local name,address,res = voiceover_check(t1[j].Address)
			if res==true then
				tt[k]={}
				tt[k].Id=k
				tt[k].Name=name
				tt[k].Address=address
				k=k+1
			end
			j=j+1
		end
		m_simpleTV.User.torrent.audio_ind = tt--таблица озвучек
		if #m_simpleTV.User.torrent.audio_ind == 0 then
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/westSide/icons/liteportal.png"', text = ' Медиаконтент недоступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
			content(m_simpleTV.User.torrent.content)
		else
		m_simpleTV.User.torrent.tr = m_simpleTV.User.torrent.audio_ind[1].Address
--[[			local str = '\nОзвучки:'
			for i=1,#m_simpleTV.User.torrent.audio_ind do
			str = str .. '\n' .. m_simpleTV.User.torrent.audio_ind[i].Name .. ' ' .. m_simpleTV.User.torrent.audio_ind[i].Address
			i=i+1
			end--]]
--		debug_in_file(str .. '\n', 'c://1/cdn.txt', setnew )
		end
--debug_in_file( '\n' .. str .. '\n' .. retAdr .. '\n', 'c://1/cdn.txt', setnew )
		return true
	end

	local function GetQltCDN()--создание таблицы качества видео по указанным в потоках разрешениях видео
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		local transl = ''
		if m_simpleTV.User.torrent.tr then
			transl = '&tr=' .. m_simpleTV.User.torrent.tr
		end
		local url = 'http://api.vokino.tv/v2/online/videocdn?id=' .. content_id .. '&token=' .. token .. transl
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then return end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		local t, i, j = {}, 1, 1
		while true do
			if not tab.channels or not tab.channels[i] or not tab.channels[i].stream_url
			then
			break
			end
			local address = tab.channels[i].stream_url:gsub('%.mp4.-$','.mp4'):gsub('^https','http')
			if check_address(tab.channels[i].stream_url) == true then
				t[j]={}
				t[j].Id = j
				t[j].qlty = address:match('/(%d+)%.mp4') or ''
				t[j].Name = t[j].qlty .. 'p'
				t[j].Address = address
				j = j + 1
			end
			i = i + 1
		end

		local hash, t0 = {}, {}
		for i = 1, #t do
			if not hash[t[i].Address] then
				t0[#t0 + 1] = t[i]
				hash[t[i].Address] = true
			end
		end

		for i = 1, #t0 do
			t0[i].Id = i
			t0[i].qlty = t0[i].Address:match('/(%d+)%.mp4')
			t0[i].Name = t0[i].qlty .. 'p'
		end
		table.sort(t0, function(a, b) return tonumber(a.qlty) > tonumber(b.qlty) end)
		m_simpleTV.User.torrent.Tab1 = t0--таблица качества видео
		return true
	end

	function Qlty_CDN(t)--создание окна выбора качества потока
		local t = m_simpleTV.User.torrent.Tab1
			if not t or #t == 0 then return end
		m_simpleTV.Control.ExecuteAction(37)
		local index = CDNIndex(t)
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'content(\'' .. m_simpleTV.User.torrent.content .. '\')'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка', ButtonScript = 'Audio_CDN()'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 10000, 1 + 4)
		if ret == 1 then
			local retAdr = t[id].Address
			m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('CDN_qlty', t[id].qlty)
		end
		if ret == 2 then
		content(m_simpleTV.User.torrent.content)
		end
		if ret == 3 then
		Audio_CDN()
		end
	end

	local function GetCDNforResolution(res)
		local transl = ''
		if m_simpleTV.User.torrent.tr then
			transl = '&tr=' .. m_simpleTV.User.torrent.tr:match('%d+$')
		end
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		local url = 'http://api.vokino.tv/v2/online/videocdn?id=' .. content_id .. '&token=' .. token .. '&quality=' .. res .. 'p' .. transl
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then return end
--	debug_in_file( '\n' .. url .. '\n' .. answer .. '\n', 'c://1/cdn.txt', setnew )
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].submenu or not tab.channels[1].submenu[1]
	then
	return end
	local address
	local i = 1
		while true do
		if not tab.channels[i] or not tab.channels[i].submenu
			then
			break
			end
			local j = 1
			while true do
			if not tab.channels[i].submenu[j] or not tab.channels[i].submenu[j].ident or not tab.channels[i].submenu[j].stream_url
				then
				break
				end
				local k, subtitle = 1,''
				while true do
					if not tab.channels[i].submenu[j].subtitles or not tab.channels[i].submenu[j].subtitles[k] or not tab.channels[i].submenu[j].subtitles[k][2]
						then
						break
						end
					subtitle = '#' .. tab.channels[i].submenu[j].subtitles[k][2]
					k=k+1
				end
			if subtitle ~= '' then
				subtitle = '$OPT:sub-track=0$OPT:input-slave=' .. subtitle:gsub('^#',''):gsub('://', '/webvtt://')
			end
			address = tab.channels[i].submenu[j].stream_url:gsub('%.mp4.-$','.mp4'):gsub('^https','http') .. subtitle
			if m_simpleTV.User.torrent.seria_id == tab.channels[i].submenu[j].ident then
--	debug_in_file( '\n' .. res .. 'p: ' .. address .. '\n', 'c://1/cdn.txt', setnew )
				return address
			end
			j=j+1
			end
			i=i+1
			end
		return false
	end

	local function GetEpisodes()--создание таблицы эпизодов для озвучки
		local transl = ''
		local id_seria = 1
		local solution
		local url = 'http://api.vokino.tv/v2/online/videocdn?id=' .. m_simpleTV.User.torrent.content
		if m_simpleTV.User.torrent.tr then
			transl = '&tr=' .. m_simpleTV.User.torrent.tr
		end
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		url = url .. '&token=' .. token .. transl
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then return end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local t1, t2, j = {}, {}, 1
		while true do
			if not tab.menu or not tab.menu[1] or not tab.menu[1].submenu or not tab.menu[1].submenu[j] or not tab.menu[1].submenu[j].playlist_url
				then
				break
				end
			t1[j]={}
			t1[j].Id = j
			t1[j].Name = tab.menu[1].submenu[j].title:gsub('%) %(',', '):gsub('%)',''):gsub('%(',''):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub(' закадровый',''):gsub('Неизвестно','выбор CDN')
			t1[j].Address = tab.menu[1].submenu[j].playlist_url:match('%&tr=(%d+)')
			--if m_simpleTV.User.torrent.tr and tonumber(m_simpleTV.User.torrent.tr) == tonumber(t1[j].Address) then
			if tab.menu[1].submenu[j].selected == true then
				m_simpleTV.User.torrent.audio_id = j
				m_simpleTV.User.torrent.audio_name = t1[j].Name
			end
			j=j+1
		end
	m_simpleTV.User.torrent.audio_ind = t1
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].submenu or not tab.channels[1].submenu[1]
	then
	return end
	local t, i, n = {}, 1, 1
		while true do
		if not tab.channels[i] or not tab.channels[i].submenu
			then
			break
			end
		local j = 1
			while true do
			if not tab.channels[i].submenu[j] or not tab.channels[i].submenu[j].ident or not tab.channels[i].submenu[j].stream_url
				then
				break
				end
			t[n]={}
			t[n].Id = n
			local k, subtitle = 1,''
			while true do
			if not tab.channels[i].submenu[j].subtitles or not tab.channels[i].submenu[j].subtitles[k] or not tab.channels[i].submenu[j].subtitles[k][2]
				then
				break
				end
			subtitle = '#' .. tab.channels[i].submenu[j].subtitles[k][2]
			k=k+1
			end
			if subtitle ~= '' then
			subtitle = '$OPT:sub-track=0$OPT:input-slave=' .. subtitle:gsub('^#',''):gsub('://', '/webvtt://')
			end
			t[n].Resolution = tab.channels[i].submenu[j].quality_full
			t[n].Address1 = tab.channels[i].submenu[j].stream_url:gsub('%.mp4.-$','.mp4'):gsub('^https','http') .. subtitle
			t[n].Address2 = tab.channels[i].submenu[j].ident
			t[n].Address = 'content_id=' .. t[n].Address2 .. '&balanser=' .. balanser .. '&' .. t[n].Address1 .. transl
			t[n].Name = tab.channels[i].title .. ', ' .. tab.channels[i].submenu[j].title
			if m_simpleTV.User.torrent.seria_id == tab.channels[i].submenu[j].ident then
				id_seria = n
				m_simpleTV.User.torrent.seria_title = t[n].Name .. ' - ' .. m_simpleTV.User.torrent.audio_name
			end
			t[n].InfoPanelName = title .. ' ' .. t[n].Name
			t[n].InfoPanelTitle = desc
			t[n].InfoPanelLogo = logo
			j=j+1
			n=n+1
			end
			i=i+1
			end
		m_simpleTV.User.torrent.serial_tmp = t
		if id_seria ~= nil then
			solution = check_address(m_simpleTV.User.torrent.serial_tmp[id_seria].Address1)
		end
		if id_seria == nil or solution ~= true then
			m_simpleTV.OSD.ShowMessageT({text = m_simpleTV.User.torrent.audio_name .. ': озвучка эпизода отсутствует', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
			Audio_CDN()
		end

			local resolution, i = {720,480,360,240}, 2
			t2[1]={}
			t2[1].Id = 1
			t2[1].Name = m_simpleTV.User.torrent.serial_tmp[id_seria].Resolution
			t2[1].qlty = t2[1].Name:match('%d+')
			t2[1].Address = m_simpleTV.User.torrent.serial_tmp[id_seria].Address1
			for k = 1, 4 do
				if tonumber(resolution[k]) < tonumber(t2[1].qlty) then
					local address = GetCDNforResolution(resolution[k])
					if address then
					t2[i]={}
					t2[i].Id = i
					t2[i].qlty = address:match('/(%d+)%.mp4') or ''
					t2[i].Name = t2[i].qlty .. 'p'
					t2[i].Address = address
					i=i+1
					end
				end
				k=k+1
			end
			local hash, t0 = {}, {}
			for i = 1, #t2 do
				if not hash[t2[i].Address]
				then
					t0[#t0 + 1] = t2[i]
					hash[t2[i].Address] = true
				end
			end

			for i = 1, #t0 do
			t0[i].Id = i
			t0[i].qlty = t0[i].Address:match('/(%d+)%.mp4')
			t0[i].Name = t0[i].qlty .. 'p'
			end
			table.sort(t0, function(a, b) return tonumber(a.qlty) > tonumber(b.qlty) end)
			m_simpleTV.User.torrent.Tab1 = t0
		return true
	end

	local function GetVoiceEpisode(content_id_episode) -- создание таблицы озвучек для текущего эпизода
		local tt = m_simpleTV.User.torrent.audio_ind
		local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
		local t, n = {}, 1
		for voice = 1,#tt do
			local rc, answer = m_simpleTV.Http.Request(session, {url = tt[voice].Address .. '&token=' .. token})
			if rc ~= 200 then return false end
			require('json')
			answer = answer:gsub('(%[%])', '"nil"')
			local tab = json.decode(answer)
			if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].submenu or not tab.channels[1].submenu[1]
			then
			return false end
			local i = 1
			while true do
				if not tab.channels[i] or not tab.channels[i].submenu
					then
					break
					end
				local j = 1
				while true do
					if not tab.channels[i].submenu[j] or not tab.channels[i].submenu[j].ident or not tab.channels[i].submenu[j].stream_url
						then
						break
						end
					if content_id_episode == tab.channels[i].submenu[j].ident -- фильтр конкретного эпизода
--					and tostring(check_address(tab.channels[i].submenu[j].stream_url)) == 'true' -- фильтр воспроизводимости верхнего потока (проверка других не производится)
					then
						local res, cc = ' / ', ''
						t[n]={}
						t[n].Id = n
						local k, subtitle = 1,''
						while true do
							if not tab.channels[i].submenu[j].subtitles or not tab.channels[i].submenu[j].subtitles[k] or not tab.channels[i].submenu[j].subtitles[k][2]
								then
								break
								end
							subtitle = subtitle .. '#' .. tab.channels[i].submenu[j].subtitles[k][2]
							k=k+1
						end
						if subtitle ~= '' then
							subtitle = '$OPT:sub-track=0$OPT:input-slave=' .. subtitle:gsub('^#',''):gsub('://', '/webvtt://')
							cc = ' / cc (' .. k .. ')'
						end
						t[n].Address_sub = subtitle
						t[n].Address_str = tab.channels[i].submenu[j].stream_url
						t[n].Address_voi = tt[voice].Address1
						res = res .. t[n].Address_str:match('(%d+)%.mp4') .. 'p'
						t[n].Name = tt[voice].Name:gsub('%) %(',', '):gsub('%)',''):gsub('%(',''):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub(' закадровый',''):gsub('Неизвестно','выбор CDN') .. res .. cc
						t[n].Address = tt[voice].Address
						if m_simpleTV.User.torrent.tr == tt[voice].Address1 then
--						m_simpleTV.User.torrent.audio_name = t[n].Name
--						t[n].Name = '✅ ' .. t[n].Name
						m_simpleTV.User.torrent.audio_epi_id = n
--						m_simpleTV.User.torrent.tr = tr
						end--]]
--						str = str .. t[n].Name .. '\n'
--						t[n].Name = t[n].Name:gsub('✅ ','')
						n=n+1
					end
					j=j+1 -- проход по эпизодам сезона
				end
				i=i+1 -- проход по сезонам
			end
			voice = voice + 1 -- проход по озвучкам
		end
		if #t > 0 then
--[[			if not str:match('✅ ') then
				str = '✅ ' .. str
				m_simpleTV.User.torrent.audio_epi_id = 1
			end -- ставит галку возле первой доступной озвучки, если нет выбранной на предыдущем эпизоде--]]
--			m_simpleTV.OSD.ShowMessageT({text = str, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			m_simpleTV.User.torrent.audio_epi = t
			return true
		end
		return false
	end

	function Audio_CDN()--создание окна выбора озвучки
		local t = m_simpleTV.User.torrent.audio_epi
			if not t or #t == 0 then return end
		m_simpleTV.Control.ExecuteAction(37)
		local index = m_simpleTV.User.torrent.audio_epi_id or 1
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'content(\'' .. m_simpleTV.User.torrent.content .. '\')'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ Качество', ButtonScript = 'Qlty_CDN()'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', index - 1, t, 10000, 1 + 4)
		if ret == 1 then
			m_simpleTV.User.torrent.audio_epi_id = id
			m_simpleTV.User.torrent.audio_name = t[id].Name
			m_simpleTV.User.torrent.tr = t[id].Address
			local retAdr = GetCurVoiceEpisode(t[id].Address)
--			m_simpleTV.User.torrent.audio_epi_id = nil
			m_simpleTV.Control.ChangeAdress = 'Yes'
			m_simpleTV.Control.CurrentAddress = retAdr
--[[			local index = CDNIndex(m_simpleTV.User.torrent.Tab1)
			local retAdr = m_simpleTV.User.torrent.Tab1[index].Address
			m_simpleTV.User.torrent.audio_id = t[id].Id--]]
--			m_simpleTV.User.torrent.is_set_position = true

			m_simpleTV.Control.SetNewAddress('content_id=' .. m_simpleTV.User.torrent.seria_id .. '&balanser=' .. m_simpleTV.User.torrent.balanser .. '&tr=' .. m_simpleTV.User.torrent.tr:match('%d+$'), m_simpleTV.Control.GetPosition())
		end
		if ret == 2 then
		content(m_simpleTV.User.torrent.content)
		end
		if ret == 3 then
		Qlty_CDN()
		end
	end
---------------------------------------комментарии
-- для сериала:
-- content_id=...&balanser=...&tr=...
-- m_simpleTV.User.torrent.content, m_simpleTV.User.westSide.PortalTable,
-- m_simpleTV.User.torrent.seria_id (возможно nil), m_simpleTV.User.torrent.balanser (возможно nil), m_simpleTV.User.torrent.tr (возможно nil)
-- title, poster, background, released, desc, logo - если поменялся m_simpleTV.User.torrent.content
-- формирование мультиадреса вывода сериала:
-- GetSerial() - m_simpleTV.User.torrent.serial -- таблица всех эпизодов балансера и m_simpleTV.User.torrent.audio_ind -- таблица всех озвучек балансера
-- m_simpleTV.User.torrent.seria_title -- название серии (Сезон 1, Серия 1)
-- m_simpleTV.User.torrent.id_seria -- id серии в плейлисте мультиадреса -- если эпизода нет, то замена адреса на первый
-- формирование таблицы доступных переводов для воспроизводимого эпизода
-- GetVoiceEpisode() - m_simpleTV.User.torrent.audio_epi -- включает реальный адрес потока для выбранной озвучки m_simpleTV.User.torrent.tr (если нет потока, то меняет адрес на доступный)
---------------------------------------конец блока CDN

	if (balanser == 'seriahd' or balanser == 'videocdn') and m_simpleTV.User.torrent.seria_id then
		GetSerial()
		local t = m_simpleTV.User.torrent.serial
			if balanser == 'seriahd' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка', ButtonScript = 'Audio_Stream()'}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙ Качество ', ButtonScript = 'Qlty_Stream()'}
			end
			if balanser == 'videocdn' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка', ButtonScript = 'Audio_CDN()'}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙ Качество ', ButtonScript = 'Qlty_CDN()'}
			end
			t.ExtParams = {FilterType = 2, StopOnError = 1, StopAfterPlay = 0, PlayMode = 1}
			local __,id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' - ' .. balanser, m_simpleTV.User.torrent.id_seria-1, t, 10000, 2 + 64 + 32)
			id = id or 1
--			retAdr = GetSeriaAdr(t[id].Address .. (m_simpleTV.User.torrent.tr or '&tr=0'))
			if balanser == 'seriahd' then
			retAdr = GetStreamAdr(retAdr) or retAdr
			end
			if balanser == 'videocdn' then
--			retAdr = GetSeriaAdr()
			GetVoiceEpisode(m_simpleTV.User.torrent.seria_id)
			retAdr = GetCurVoiceEpisode(m_simpleTV.User.torrent.tr)
--			retAdr = 'domen_name/iptv/XXXXXXXXXXXXXX/516/index.m3u8'
--[[			local str = 'Доступно качество:'
			for i=1,#m_simpleTV.User.torrent.Tab1 do
			str = str .. '\n' .. m_simpleTV.User.torrent.Tab1[i].Name .. ' - ' .. m_simpleTV.User.torrent.Tab1[i].Address
			i=i+1
			end
			str = str .. '\n' .. 'Озвучки:'
			for i=1,#m_simpleTV.User.torrent.audio_ind do
			str = str .. '\n' .. m_simpleTV.User.torrent.audio_ind[i].Name
			i=i+1
			end--]]

--		debug_in_file( '\n' .. str .. '\n' .. index .. ' ' .. m_simpleTV.User.torrent.Tab1[index].Address .. '\n', 'c://1/cdn.txt', setnew )
--debug_in_file( '\n' .. str .. '\n' .. retAdr .. '\n', 'c://1/cdn.txt', setnew )
--		local index = CDNIndex(m_simpleTV.User.torrent.Tab1)
--		retAdr = m_simpleTV.User.torrent.Tab1[index].Address
			end
--			title = title:gsub(' %).-$', ')') .. ' ' .. m_simpleTV.User.torrent.seria_title .. ' - ' .. (m_simpleTV.User.torrent.audio_name or '')

elseif balanser == 'collaps' or balanser == 'videocdn' then
	if balanser == 'collaps' then
		retAdr = GetStreamAdr(retAdr) or retAdr
	end
	if balanser == 'videocdn' then
		GetVoiceCDN()
		GetQltCDN()
		local index = CDNIndex(m_simpleTV.User.torrent.Tab1)
		retAdr = m_simpleTV.User.torrent.Tab1[index].Address
--		debug_in_file( '\n' .. index .. ': ' .. retAdr .. '\n', 'c://1/cdn.txt', setnew )
--[[		if check_address(retAdr) == false then
		m_simpleTV.OSD.ShowMessageT({text = (m_simpleTV.User.torrent.audio_name or '') .. ': озвучка отсутствует', color = ARGB(255, 255, 255, 255), showTime = 1000 * 5})
			Audio_CDN()
		end--]]
	end
	local t1 = {}
	t1[1] = {}
	t1[1].Id = 1
	t1[1].Name = title
	t1[1].Address = retAdr
	t1[1].InfoPanelName = title
	t1[1].InfoPanelTitle = desc
	t1[1].InfoPanelLogo = logo
	if balanser == 'collaps' then
	if m_simpleTV.User.torrent.audio_ind then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка', ButtonScript = 'Audio_Stream()'}
	end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙ Качество ', ButtonScript = 'Qlty_Stream()'}
	end
	if balanser == 'videocdn' then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка', ButtonScript = 'Audio_CDN()'}
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙ Качество ', ButtonScript = 'Qlty_CDN()'}
	end
	m_simpleTV.OSD.ShowSelect_UTF8(balanser, 0, t1, 5000, 32 + 64 + 128)
	if m_simpleTV.User.torrent.is_set_position and m_simpleTV.User.torrent.is_set_position == true then
		m_simpleTV.User.torrent.is_set_position = false
		m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())
	else
		m_simpleTV.Control.SetNewAddress(retAdr)
	end
end
------------------------------------------------
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.Control.SetTitle(title)
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = retAdr
--		m_simpleTV.Http.Close(session)
		m_simpleTV.User.torrent.address = retAdr
		if retAdr:match('^magnet:') then
			if not m_simpleTV.User.TVPortal then
				m_simpleTV.User.TVPortal = {}
			end
			info_fox(m_simpleTV.User.torrent.title,m_simpleTV.User.torrent.year,m_simpleTV.User.torrent.poster)
			m_simpleTV.User.TVPortal.balanser = 'Trackers'
		end
		if m_simpleTV.User.torrent.balanser == nil and m_simpleTV.User.torrent.is_set_position and m_simpleTV.User.torrent.is_set_position == true then
			m_simpleTV.User.torrent.is_set_position = false
			m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())
		elseif m_simpleTV.User.torrent.balanser == nil then
			m_simpleTV.Control.SetNewAddress(retAdr)
		end
-- debug_in_file(retAdr .. '\n')