
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('m24kino') then return end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, TypeBackColor = 0, PictFileName = '', UseLogo = 0, Once = 1})
		if m_simpleTV.Control.ChannelID == 268435455 then
			m_simpleTV.Control.ChangeChannelLogo('http://m24.do.am/m24logobig.png', m_simpleTV.Control.ChannelID)
		end
	end
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = ' ошибка: ' .. str, showTime = 5000, color = ARGB(255, 255, 0, 0), id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = 'error'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36')
		if not session then
			showError('0')
		 return
		end
	local pls = 'http://m24.do.am/CH/kino/m24kino.txt'
	local rc, answer = m_simpleTV.Http.Request(session, {url = pls})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			showError('1')
		 return
		end
	local tab, i = {}, 1
		for extinf in answer:gmatch('(#EXTINF:.-\n.-%c)') do
			tab[i] = {}
			tab[i].Id = i
			tab[i].Name = extinf:match('#EXTINF:.-,(.-)\n')
			tab[i].Address = extinf:match('#EXTINF:.-\n(.-)%c')
			i = i + 1
		end
		if i == 1 then
			showError('2')
		 return
		end
tab.ExtParams = {}
tab.ExtParams.Random = 1
	tab.ExtParams.PlayMode = 1
	tab.ExtParams.StopOnError = 0
	local plstIndex = math.random(#tab)
	m_simpleTV.OSD.ShowSelect_UTF8('M24 Кино 🎞️', plstIndex - 1, tab, 0, 64 + 256)
	m_simpleTV.Control.ChangeAddress = 'No'
	local title = tab[plstIndex].Name
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.OSD.ShowMessageT({text = title, showTime = 1000 * 5, id = 'channelName'})
	m_simpleTV.Control.CurrentAddress = tab[plstIndex].Address

  local title_rus = title:gsub(' %(.-$', '')
  local year = title:gsub('^.-%(', ''):gsub('%)', '')
  local videodesc, background = info_fox(title_rus, year, '')

    if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end





