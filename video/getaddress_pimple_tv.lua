-- открывает подобные ссылки:
-- https://www.pimpletv.ru/football/%d+
-- https://www.pimpletv.ru
-- необходим аддон Ace
-- author west_side 29.11.24

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('https?://www%.pimpletv%.ru') then return end

	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'

	local poyas = 2
	if m_simpleTV.User.Pimple == nil then
		m_simpleTV.User.Pimple = {}
	end
	m_simpleTV.User.Pimple.current = nil
	m_simpleTV.User.Pimple.current_valid = nil

	local url = inAdr

	local function get_current_broadcasting()
		local current_item = 1
		local current_adr = m_simpleTV.User.Pimple.current_item
		local tt0 = {}
		for i = 1, #m_simpleTV.User.Pimple.current_valid do
				tt0[i] = {}
				tt0[i].Id = tonumber(m_simpleTV.User.Pimple.current_valid[i].Id_in)
				tt0[i].Name = m_simpleTV.User.Pimple.current_valid[i].Name
				tt0[i].Action = m_simpleTV.User.Pimple.current_valid[i].Action
		end

		table.sort(tt0, function(a, b) return a.Id < b.Id end)
		local tt1 = {}
		for i = 1, #tt0 do
				tt1[i] = {}
				tt1[i].Id = i
				tt1[i].Name = tt0[i].Name
				tt1[i].Action = tt0[i].Action
				if tt1[i].Action == current_adr then current_item = i end
		end
		m_simpleTV.User.Pimple.current_valid = nil
		m_simpleTV.User.Pimple.all = nil
		tt0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat, StopOnError = 1}
		if #tt1 > 0 then
			local ret1, id1 = m_simpleTV.OSD.ShowSelect_UTF8('Pimple ACE', tonumber(current_item)-1, tt1, 30000, 1 + 4 + 8)
			if ret1 == 1 then
				m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
				m_simpleTV.User.Pimple.current_item = tt1[id1].Action
				m_simpleTV.Control.PlayAddressT({address=tt1[id1].Action, title=tt1[id1].Name})
			end
			if ret1 == 0 then
				m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
				return m_simpleTV.Control.ExecuteAction('KEYSTOP')
			end
		else
			m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Контент не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		end
	end

	function luaCallback_for_check_pimple(sessionId, rc, answer, uservalue)
		if not m_simpleTV.User.Pimple.current_valid then
			m_simpleTV.User.Pimple.current_valid = {}
		end
		if not m_simpleTV.User.Pimple.current then
			m_simpleTV.User.Pimple.current = 0
		end
		m_simpleTV.User.Pimple.current = m_simpleTV.User.Pimple.current + 1
		if answer:match('href="acestream:') then
--			debug_in_file(uservalue.Id_in .. '. ' .. uservalue.Name .. ' - ' .. answer:match('href="(acestream:.-)"') .. '\n')
			m_simpleTV.User.Pimple.current_valid[#m_simpleTV.User.Pimple.current_valid+1] = uservalue
		end
		m_simpleTV.Http.Close(sessionId)
		if m_simpleTV.User.Pimple.all then
		m_simpleTV.OSD.ShowMessageT({text = 'Доступно трансляций ' .. #m_simpleTV.User.Pimple.current_valid .. ' из ' .. m_simpleTV.User.Pimple.all .. '\n', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		end
		if tonumber(m_simpleTV.User.Pimple.current) == tonumber(m_simpleTV.User.Pimple.all) then
--			debug_in_file('--------------------------------\n')
			m_simpleTV.User.Pimple.current = nil
			m_simpleTV.Control.ExecuteAction('KEYSTOP')
			get_current_broadcasting()
		end
	end

	local function get_ace_item(t0)
		local tt0, k = {},1
		local current_item = 1
		local current_adr = m_simpleTV.User.Pimple.current_item
		local session_for_check = {}
		for j = 1,#t0 do
			session_for_check[j] = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
			m_simpleTV.Http.SetTimeout(session_for_check[j], 10000)
			m_simpleTV.Http.RequestA(session_for_check[j], {url = t0[j].Action, method = 'GET', callback = 'luaCallback_for_check_pimple', uservalue = t0[j]})
			m_simpleTV.OSD.ShowMessageT({text = 'Контент на Ace: ' .. j .. ' из ' .. #t0, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			j = j + 1
		end
	end

	local function get_all_item()
		local session_get_all_item = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session_get_all_item then return end
		m_simpleTV.Http.SetTimeout(session_get_all_item, 12000)
		local name_ch = "Pimple on Ace"
		local url = "https://www.pimpletv.ru"
		local rc, answer = m_simpleTV.Http.Request(session_get_all_item, {url = url})
		m_simpleTV.Http.Close(session_get_all_item)

		if answer==nil then
		return
		end
		
		local t, i = {}, 1		
--		debug_in_file(answer .. '\n')
		local answer1 = answer:match('(<div class="streams%-day">.-</a>%s+</div><div)') or answer:match('(<div class="streams%-day">.-</a>%s+</div></div>)')
		if not answer1 then return
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Контент не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		end
		if answer1 then
--		debug_in_file(answer1 .. '\n')
		for w in answer1:gmatch('<a href=.-</a>') do

			local adr, title1, title2, title3 = w:match('<a href="(.-)".-<div class="match%-item__title%-tournament">(.-)<.-<span class="table%-item__home%-name">(.-)</span>.-<span class="table%-item__away%-name">(.-)</span>')
--			debug_in_file(w .. '\n')
			local start = w:match('<div class="match%-item__title%-date">.-<div>(.-)<')
			local start1 = w:match('<div class="match%-item__title%-date liveTime">(.-)</div>')
			local flag, flagg
			if start1 then
				start1 = start1:gsub('\n',''):gsub('\r',''):gsub('^%s+',''):gsub('%s+$','')
				flagg = '🟢 '
			end
			if not adr or not start and not start1 then break end
			if start then
			local h, m = start:match('(%d+):(%d+)')
			local cor
			if h and m and poyas then
			cor = h - 3 + poyas
			if cor < 0 then cor = cor + 24 end
			if cor > 24 then cor = cor - 24 end
			start = cor .. ':' .. m
			end
			local year, month, day = os.date("%Y"), os.date("%m"), os.date("%d")
			local arr = {year = year, month = month, day = day, hour = cor, min = m, sec = 0}
			flag = os.time() - os.time(arr)
			if tonumber(flag) < 0 then flagg = '🔴 ' end
			if tonumber(flag) >= 0 then flagg = '🟢 ' end
			if tonumber(flag) >= 2*60*60 then flagg = '🟡 ' end
			end
			t[i]={}
			t[i].Id_in = i
			t[i].Name = flagg .. (start or start1) .. ' ' .. title2 .. ' - ' .. title3 .. ' (' .. title1 .. ')'
			t[i].Action = 'https://www.pimpletv.ru' .. adr
--			debug_in_file(t[i].Id_in .. '/' .. t[i].Name .. ' ' .. t[i].Action .. '\n')
			i = i + 1
		end
		local hash, t0 = {}, {}
				for i = 1, #t do
					if not hash[t[i].Action]
					then
						t0[#t0 + 1] = t[i]
						hash[t[i].Action] = true
					end
				end
		m_simpleTV.User.Pimple.all = #t0
		m_simpleTV.Control.ExecuteAction('KEYSTOP')
		get_ace_item(t0)
		else return
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Контент не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})			
		end
	end

	if inAdr == "https://www.pimpletv.ru" then
		local name_ch = "Pimple on Ace"
		m_simpleTV.Control.SetTitle(name_ch)
		if m_simpleTV.Control.MainMode == 0 then
			m_simpleTV.Control.ChangeChannelName(name_ch, m_simpleTV.Control.ChannelID, false)
		end
		return get_all_item()
	else
		local session_get_stream = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session_get_stream then return end
		m_simpleTV.Http.SetTimeout(session_get_stream, 12000)
		local rc, answer = m_simpleTV.Http.Request(session_get_stream, {url = url})
		m_simpleTV.Http.Close(session_get_stream)
--		debug_in_file(answer .. '\n')
		local name_ch = m_simpleTV.Control.CurrentTitle_UTF8
		m_simpleTV.Control.SetTitle(name_ch)
		if m_simpleTV.Control.MainMode == 0 then
			m_simpleTV.Control.ChangeChannelName(name_ch, m_simpleTV.Control.ChannelID, false)
		end
		local t, i = {}, 1
		local current_item = 1
		local current_adr = m_simpleTV.User.Pimple.current_adr
		for w in answer:gmatch('title="Ace Stream".->Смотреть</a></td></tr>') do
--			debug_in_file(w .. '\n')
			local title1, title2, title3, adr = w:match('title="Ace Stream".-Читать.-<td>(.-)</td><td>(.-)</td><td>(.-)</td>.-href="(acestream:.-)">Смотреть</a></td></tr>')
			if not adr or not title1 then break end
			t[i]={}
			t[i].Id = i
			t[i].Name = title1 .. ' ' .. title2 .. ' ' .. title3 .. 'fps'
			t[i].Action = adr
			if t[i].Action == current_adr then current_item = i end
			i = i + 1
		end
		if #t > 0 then
			t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat, StopOnError = 1}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Pimple '}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(name_ch, tonumber(current_item)-1, t, 30000, 1 + 4 + 8)
			if ret == nil or ret == -1 or ret == 2 then return m_simpleTV.Control.PlayAddressT({address='https://www.pimpletv.ru', title='Pimple on Ace'}) end
			if ret == 1 then
				m_simpleTV.User.Pimple.current_adr = t[id].Action
				m_simpleTV.Control.SetNewAddressT({address=t[id].Action})
			end
			if ret == 0 then
				return m_simpleTV.Control.ExecuteAction('KEYSTOP')
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Контент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			return m_simpleTV.Control.PlayAddressT({address='https://www.pimpletv.ru', title='Pimple on Ace'})
		end
	end
