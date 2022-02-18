
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^m24_') then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, TypeBackColor = 0, PictFileName = '', UseLogo = 0, Once = 1})
		if m_simpleTV.Control.ChannelID == 268435455 then
			m_simpleTV.Control.ChangeChannelLogo(' ', m_simpleTV.Control.ChannelID)
		end
	end
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'imtv ошибка: ' .. str, showTime = 5000, color = ARGB(255, 255, 0, 0), id = 'channelName'})
	end
	function removeDuplicates(tbl)
		local timestamps, newTable = {}, {}
			for index, record in ipairs(tbl) do
				if not timestamps[record.Address] then
					timestamps[record.Address] = 1
					table.insert(newTable, record)
				end
			end
	 return newTable
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = 'error'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36')
		if not session then
			showError('0')
		 return
		end
	local pls, header
	if inAdr:match('m24_oldtv') then
		pls = 'http://m24.do.am/_fr/0/old.txt'
		header = 'Old'
	elseif inAdr:match('m24_slowtv') then
		pls = 'http://m24.do.am/_fr/0/slow.txt'
		header = 'Asian '
	elseif inAdr:match('m24_blacktv') then
		pls = 'http://m24.do.am/_fr/0/black.txt'
		header = 'Black '
	elseif inAdr:match('m24_trancetv') then
		pls = 'http://m24.do.am/_fr/0/trance.txt'
		header = 'Trance '
	elseif inAdr:match('m24_djlivetv') then
		pls = 'http://m24.do.am/_fr/0/livetrance.txt'
		header = 'DJ Live '
	elseif inAdr:match('m24_dancetv') then
		pls = 'http://m24.do.am/_fr/0/dance.txt'
		header = 'Pop  '
	elseif inAdr:match('m24_rocktv') then
		pls = 'http://m24.do.am/_fr/0/rock.txt'
		header = 'Rosk  '
	elseif inAdr:match('m24_hardtv') then
		pls = 'http://m24.do.am/_fr/0/hard.txt'
		header = 'Hard  '
	elseif inAdr:match('m24_hottv') then
		pls = 'http://m24.do.am/_fr/0/hot.txt'
		header = 'Hot  '
	elseif inAdr:match('m24_m24tv') then
		pls = 'http://m24.do.am/_fr/0/m24.txt'
		header = 'Music 24 '
        elseif inAdr:match('m24_radio') then
		pls = 'http://m24.do.am/_fr/0/radio2.txt'
		header = 'No videoclip '
        elseif inAdr:match('m24_fps') then
		pls = 'http://m24.do.am/CH/kino/hd.txt'
		header = ' '
        elseif inAdr:match('m24_1') then
		pls = 'http://m24.do.am/CH/kino/hd1.txt'
		header = ' '
        elseif inAdr:match('m24_2') then
		pls = 'http://m24.do.am/CH/kino/hd2.txt'
		header = ' '
        elseif inAdr:match('m24_3') then
		pls = 'http://m24.do.am/CH/kino/hd3.txt'
		header = ' '
        elseif inAdr:match('m24_4') then
		pls = 'http://m24.do.am/CH/kino/hd4.txt'
		header = ' '



	end

pls = pls .. '?rand=' .. math.random()
	local rc, answer = m_simpleTV.Http.Request(session, {url = pls})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			showError('1')
		 return
		end
	answer = answer:gsub('^.-"', '{"')
	require 'json'
	local t = json.decode(answer)
		if not t or not t.playlist then
			showError('2')
		 return
		end
	local tab, i = {}, 1
		while t.playlist[i] do
			tab[i] = {}
			tab[i].Id = i
			tab[i].Address = t.playlist[i].file .. '?&isPlst=true$OPT:INT-SCRIPT-PARAMS=psevdotv'
			i = i + 1
		end
		if i == 1 then
			showError('3')
		 return
		end
	tab = removeDuplicates(tab)
	tab.ExtParams = {}
	tab.ExtParams.Random = 1
	tab.ExtParams.PlayMode = 1
	tab.ExtParams.StopOnError = 0
	local plstIndex = math.random(#tab)
	m_simpleTV.OSD.ShowSelect_UTF8(header, plstIndex - 1, tab, 0, 64 + 256)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = tab[plstIndex].Address
	dofile(m_simpleTV.MainScriptDir .. 'user\\video\\video.lua')
-- debug_in_file(tab[plstIndex].Address .. '\n')