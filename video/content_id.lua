-- видеоскрипт формирования title, logo, background, info SimpleTV Lite по content_id (12/02/23)
-- author west_side
-- открывает подобные ссылки:
-- content_id=622e87da83dcfc38d2c69f1a&magnet:?xt=urn:btih:BB7C024231B3D9A7C90BBD7490B3B048DE46818A

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
	local content_id = inAdr:match('id=(.-)%&')
	local retAdr = inAdr:gsub('content_id=.-%&','')
	m_simpleTV.User.torrent.content = content_id
	m_simpleTV.User.torrent.address = retAdr
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.torrent.content
	local token = 'windows_2fdda421cddb69116e0768f3bff4de05_592021'
	local url = 'http://api.vokino.tv/v2/view?id='	.. content_id .. '&token=' .. token
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
	m_simpleTV.Http.Close(session)
	local title = tab.details.name
	local poster = tab.details.poster
	local background = tab.details.bg_poster.backdrop
	local released = tab.details.released or ''
	local logo
	if background then logo = background:gsub('original','w500')
		elseif poster then logo = poster:gsub('w600_and_h900','w300_and_h450')
		else logo = 'http://m24.do.am/images/logoport.png'
	end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.CurrentTitle_UTF8 = title .. ' (' .. released .. ')'
		m_simpleTV.Control.SetTitle(title .. ' (' .. released .. ')')
		m_simpleTV.Control.ChangeChannelLogo(logo , m_simpleTV.Control.ChannelID)
	end
	m_simpleTV.Control.SetNewAddress(retAdr)
-- debug_in_file(retAdr .. '\n')