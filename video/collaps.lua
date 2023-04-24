-- видеоскрипт для видеобалансера "Collaps" https://collaps.org (15/06/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Scripts
-- mod west_side (23/04/23)
-- ## открывает подобные ссылки ##
-- https://api1603044906.kinogram.best/embed/movie/7059
-- https://api1603044906.kinogram.best/embed/kp/5928
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://api[%d]*[^/]+/embed/movie/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api[%d]*[^/]+/embed/kp/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api%..-/embed/kp/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api%..-/embed/movie/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^$collaps')
		then
		 return
		end
	require 'json'
	local inAdr = m_simpleTV.Control.CurrentAddress
	if inAdr:match('^$collaps') or not inAdr:match('&kinopoisk') then
		m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = 'error'
	local userAgent = 'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
	local session = m_simpleTV.Http.New(userAgent)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.collaps then
		m_simpleTV.User.collaps = {}
	end
	m_simpleTV.User.collaps.kinogo = nil
	m_simpleTV.User.collaps.ua = nil
	local title,logo,subt
	if m_simpleTV.User.collaps.episode then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.collaps.episode[index].Name
		end
	end
	local function showMsg(str, color)
		local t = {text = str, showTime = 1000 * 5, color = color, id = 'channelName'}
		m_simpleTV.OSD.ShowMessageT(t)
	end
	local function collapsIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('collaps_qlty') or 5000)
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
	local function GetcollapsAdr(url)
		url = url:gsub('^$collaps', '')
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('%$OPT.-$','')})
			if rc ~= 200 then return end
		local subt = url:match('(%$OPT.-)$')	or ''
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
		local transl
		local transl0 = m_simpleTV.User.collaps.transl or '1'
		if answer:match('index%-a' .. transl0) then
			transl = transl0
		else
			transl = answer:match('index%-a(%d+)') or '1'
		end
			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address:gsub('%.m3u8', '-a' .. transl ..'.m3u8') .. subt
			end
		m_simpleTV.User.collaps.Tab = t
		local index = collapsIndex(t)
	 return t[index].Address
	end
	function Qlty_collaps()
		local t = m_simpleTV.User.collaps.Tab
			if not t or #t == 0 then return end
		m_simpleTV.Control.ExecuteAction(37)
		local index = collapsIndex(t)
		if m_simpleTV.User.collaps.kinogo then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'kinogo_info(\'' .. m_simpleTV.User.collaps.kinogo .. '\')'}
		end
		if m_simpleTV.User.collaps.ua then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'ua_info(\'' .. m_simpleTV.User.collaps.ua .. '\')'}
		end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 10000, 1 + 4)
		if ret == 1 then
			local retAdr = t[id].Address
			m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('collaps_qlty', t[id].qlty)
		end
		if ret == 2 then
		if m_simpleTV.User.collaps.kinogo then
		kinogo_info(m_simpleTV.User.collaps.kinogo)
		end
		if m_simpleTV.User.collaps.ua then
		ua_info(m_simpleTV.User.collaps.ua)
		end		
		end
	end
	local function play(Adr, title)
		local retAdr = GetcollapsAdr(Adr) or Adr
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		showMsg(title, ARGB(255, 153, 153, 255))
		m_simpleTV.Control.CurrentAddress = retAdr:gsub('^$collaps','')
-- debug_in_file(retAdr .. '\n')
	end
		if inAdr:match('^$collaps') then
			play(inAdr, title)
		 return
		end
	m_simpleTV.User.collaps.kinogo = inAdr:match('%&kinogo=(.-)$')
	m_simpleTV.User.collaps.ua = inAdr:match('%&kino4ua=(.-)$')
	if m_simpleTV.User.collaps.kinogo then
		m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.collaps.kinogo
	end
	if m_simpleTV.User.collaps.ua then
		m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.collaps.ua
	end
	inAdr = inAdr:gsub('&kinopoisk', ''):gsub('%&kinogo=.-$', ''):gsub('%&kino4ua=.-$', '')
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
		if rc ~= 200 then
			showMsg('collaps ошибка: 1', ARGB(255, 255, 102, 0))
		 return
		end
	local season_title = ''
	local seson = ''
	title = m_simpleTV.Control.CurrentTitle_UTF8 or 'Collaps'
	m_simpleTV.User.collaps.episode = nil
	m_simpleTV.User.collaps.transl = nil
	local serials = answer:match('seasons:(%[.-}%]}%])')
	if serials then
		m_simpleTV.Control.SetTitle(title)
		serials = serials:gsub('%[%]', '""')
		local tab = json.decode(serials)
			if not tab then return end
		local t0, i = {}, 1
			while true do
					if not tab[i] then break end
				t0[i] = {}
				t0[i].Name = tab[i].season .. ' сезон'
				t0[i].Address = i
				i = i + 1
			end
			if i == 1 then return end
		if i > 2 then
			table.sort(t0, function(a, b) return a.Name < b.Name end)
			for i = 1, #t0 do
				t0[i].Id = i
			end
			t0.ExtParams = {FilterType = 2}
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите сезон - ' .. title, 0, t0, 10000, 1)
			id = id or 1
		 	seson = t0[id].Address
			season_title = ' ' .. t0[id].Name
		else
			seson = t0[1].Address
			local ses = t0[1].Name:match('%d+') or '0'
			if tonumber(ses) > 1 then
				season_title = ' ' .. t0[1].Name
			end
		end
		m_simpleTV.User.collaps.season = t0
		local i = 1
		local tr = {}
			while tab[seson].episodes[1].audio.names[i] do
				tr[i] = {}
				tr[i].Id = i
				tr[i].Name = tab[seson].episodes[1].audio.names[i]
				i = i + 1
			end
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите перевод - ' .. title, 0, tr, 10000, 1)
			m_simpleTV.User.collaps.transl = id
		end
		local t, i = {}, 1
		local episode = {}
			while tab[seson].episodes[i] do
				t[i] = {}
				episode[i] = {}
				t[i].Id = i
				t[i].Name = tab[seson].episodes[i].episode .. ' серия'
				episode[i].Name = title .. season_title .. ' - ' .. t[i].Name
				t[i].Address = '$collaps' .. tab[seson].episodes[i].hls
				i = i + 1
			end
			if i == 1 then return end
		m_simpleTV.User.collaps.episode = episode
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_collaps()'}
		local p = 0
		if i == 2 then
			p = 32 + 128
		end
		t.ExtParams = {FilterType = 2}
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. season_title, 0, t, 15000, p + 64)
		id = id or 1
		inAdr = t[id].Address
		title = title .. season_title .. ' - ' .. t[id].Name
	else
		inAdr = answer:match('hls:%s*"([^"]+)')
			if not inAdr then
				m_simpleTV.Http.Close(session)
				showMsg('collaps ошибка: 2', ARGB(255, 255, 102, 0))
			 return
			end
		title = answer:match('title:%s*"(.-)",') or 'Collaps'
		logo = answer:match('poster:%s*"(.-)",')
		subt = answer:match('cc:%s*%[(.-)%]')
		if subt then
			local s = {}
			for w in subt:gmatch('http.-%.vtt') do
				s[#s + 1] = w:gsub('://', '/webvtt://')
			end
			subt = '$OPT:sub-track=0$OPT:input-slave=' .. table.concat(s, '#')
		end
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		title = title:gsub('\\u0026', '&')
		m_simpleTV.Control.SetTitle(title)
		local transl = answer:match('audio:%s*({[^}]+})')
		if transl then
			transl = transl:gsub('%[%]', '""')
			local err, a = pcall(json.decode, transl)
			if err == true and a then
				local i = 1
				local tr = {}
					while a.names[i] do
						tr[i] = {}
						tr[i].Id = i
						tr[i].Name = a.names[i]
						i = i + 1
					end
				if i > 2 then
					local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите перевод - ' .. title, 0, tr, 10000, 1)
					m_simpleTV.User.collaps.transl = id
				end
			end
		end
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Address = inAdr
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_collaps()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		m_simpleTV.OSD.ShowSelect_UTF8('Collaps', 0, t1, 10000, 64 + 32 + 128)
	end
--	debug_in_file(inAdr .. '\n')
	inAdr = inAdr .. (subt or '')
	play(inAdr, title)
