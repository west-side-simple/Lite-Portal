-- видеоскрипт приветствия Mediaportal SimpleTV Team (28/04/23)
-- author - westSide
-- открывает подобные ссылки:
-- hellow_world=https://raw.githubusercontent.com/west-side-simple/playlists/main/video1.mp4

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^hello_world=')
	then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local retAdr
	if inAdr:match('%d+') and tonumber(inAdr:match('(%d+)')) == 1 then
	retAdr = 'https://raw.githubusercontent.com/west-side-simple/playlists/main/video' .. inAdr:match('(%d+)') .. '.mp4'
	else
	retAdr = 'http://m24.do.am/SimpleTVupd/news' .. inAdr:match('(%d+)') .. '.mp4'
	end
	local logo = './luaScr/user/westSide/icons/liteportal.png'
	local title = 'SimpleTV Mediaportal Team'

	m_simpleTV.Control.ChangeChannelLogo(logo , m_simpleTV.Control.ChannelID)
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.SetNewAddress(retAdr)