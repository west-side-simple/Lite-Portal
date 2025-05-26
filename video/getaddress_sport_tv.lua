-- открывает подобные ссылки:
-- https://myfootball.top/%d+.-.html
-- https://myfootball.top/
-- необходим аддон Ace
-- author west_side 29.11.24

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('https?://myfootball%.top') then return end

	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	
	local poyas = 3
	if m_simpleTV.User.MyFootball == nil then
		m_simpleTV.User.MyFootball = {}
	end
	m_simpleTV.User.MyFootball.current = nil
	m_simpleTV.User.MyFootball.current_valid = nil

	local url = inAdr

	local function get_current_broadcasting()
		local current_item = 1
		local current_adr = m_simpleTV.User.MyFootball.current_item
		local tt0 = {}
		for i = 1, #m_simpleTV.User.MyFootball.current_valid do
				tt0[i] = {}
				tt0[i].Id = tonumber(m_simpleTV.User.MyFootball.current_valid[i].Id_in)
				tt0[i].Name = m_simpleTV.User.MyFootball.current_valid[i].Name
				tt0[i].Action = m_simpleTV.User.MyFootball.current_valid[i].Action
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
		m_simpleTV.User.MyFootball.current_valid = nil
		m_simpleTV.User.MyFootball.all = nil
		tt0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat, StopOnError = 1}
		if #tt1 > 0 then
			local ret1, id1 = m_simpleTV.OSD.ShowSelect_UTF8('MF.TOP ACE', tonumber(current_item)-1, tt1, 30000, 1 + 4 + 8)
			if ret1 == 1 then
				m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
				m_simpleTV.User.MyFootball.current_item = tt1[id1].Action
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

	function luaCallback_for_check(sessionId, rc, answer, uservalue)
		if not m_simpleTV.User.MyFootball.current_valid then
			m_simpleTV.User.MyFootball.current_valid = {}
		end
		if not m_simpleTV.User.MyFootball.current then
			m_simpleTV.User.MyFootball.current = 0
		end
		m_simpleTV.User.MyFootball.current = m_simpleTV.User.MyFootball.current + 1
		if answer:match('<a href="acestream:.-Смотреть.-<') then
--			debug_in_file(uservalue.Id_in .. '. ' .. uservalue.Name .. ' - ' .. answer:match('<a href="(acestream:.-)".-Смотреть.-<') .. '\n')
			m_simpleTV.User.MyFootball.current_valid[#m_simpleTV.User.MyFootball.current_valid+1] = uservalue
		end
		m_simpleTV.Http.Close(sessionId)
		if m_simpleTV.User.MyFootball.all then
		m_simpleTV.OSD.ShowMessageT({text = 'Доступно трансляций ' .. #m_simpleTV.User.MyFootball.current_valid .. ' из ' .. m_simpleTV.User.MyFootball.all .. '\n', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		end
		if tonumber(m_simpleTV.User.MyFootball.current) == tonumber(m_simpleTV.User.MyFootball.all) then
--			debug_in_file('--------------------------------\n')
			m_simpleTV.User.MyFootball.current = nil
			m_simpleTV.Control.ExecuteAction('KEYSTOP')
			get_current_broadcasting()
		end
	end

	local function get_ace_item(t0)
		local tt0, k = {},1
		local current_item = 1
		local current_adr = m_simpleTV.User.MyFootball.current_item
		local session_for_check = {}
		for j = 1,#t0 do
			session_for_check[j] = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
			m_simpleTV.Http.SetTimeout(session_for_check[j], 10000)
			local rc_for_check, answer_for_check = m_simpleTV.Http.RequestA(session_for_check[j], {url = t0[j].Action, method = 'GET', callback = 'luaCallback_for_check', uservalue = t0[j]})
			m_simpleTV.OSD.ShowMessageT({text = 'Контент на Ace: ' .. j .. ' из ' .. #t0, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			j = j + 1
		end
	end

	local function get_all_item()
		local session_get_all_item = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session_get_all_item then return end
		m_simpleTV.Http.SetTimeout(session_get_all_item, 12000)
		local name_ch = "MF.TOP on Ace"
		local url = "https://myfootball.top/"
		local rc, answer = m_simpleTV.Http.Request(session_get_all_item, {url = url})
		m_simpleTV.Http.Close(session_get_all_item)
		if answer==nil then
		return
		end
--		debug_in_file(answer .. '\n')
		local t, i = {}, 1
		for w in answer:gmatch('<div class="rewievs_tab1">.-</tbody>') do
--			debug_in_file(w .. '\n')
			local adr, title1, title2, start = w:match('<a href="(.-)".-<img alt="(.-)".-<td style.->(.-)<.-data%-time.->(.-)<')
			if not adr or not start then break end
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
			local flag = os.time() - os.time(arr)
			local flagg
			if tonumber(flag) < 0 then flagg = '🔴 ' end
			if tonumber(flag) >= 0 then flagg = '🟢 ' end
			if tonumber(flag) >= 2*60*60 then flagg = '🟡 ' end
			t[i]={}
			t[i].Id_in = i
			t[i].Name = flagg .. start .. ' ' .. title2 .. ' (' .. title1 .. ')'
			t[i].Action = adr
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
		m_simpleTV.User.MyFootball.all = #t0
		m_simpleTV.Control.ExecuteAction('KEYSTOP')
		get_ace_item(t0)
	end

	if inAdr == "https://myfootball.top/" then
		local name_ch = "MF.TOP on Ace"
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
		local current_adr = m_simpleTV.User.MyFootball.current_adr
		for w in answer:gmatch('<a href="acestream:.-Смотреть.-<') do
--			debug_in_file(w .. '\n')
			local adr, title1, title2 = w:match('<a href="(.-)".-title="(.-)".-Смотреть(.-)<')
			if not adr or not title2 then break end
			t[i]={}
			t[i].Id = i
			t[i].Name = title1 .. title2
			t[i].Action = adr
			if t[i].Action == current_adr then current_item = i end
			i = i + 1
		end
		if #t > 0 then
			t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat, StopOnError = 1}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' MF.TOP '}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(name_ch, tonumber(current_item)-1, t, 30000, 1 + 4 + 8)
			if ret == nil or ret == -1 or ret == 2 then return m_simpleTV.Control.PlayAddressT({address='https://myfootball.top/', title='MF.TOP on Ace'}) end
			if ret == 1 then
				m_simpleTV.User.MyFootball.current_adr = t[id].Action
				m_simpleTV.Control.SetNewAddressT({address=t[id].Action})
			end
			if ret == 0 then
				return m_simpleTV.Control.ExecuteAction('KEYSTOP')
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Контент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			return m_simpleTV.Control.PlayAddressT({address='https://myfootball.top/', title='MF.TOP on Ace'})
		end
	end
