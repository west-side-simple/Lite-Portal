-- видеоскрипт приветствия Mediaportal SimpleTV Team (23/04/23)
-- author - westSide
-- открывает подобные ссылки:
-- hellow_world=https://raw.githubusercontent.com/west-side-simple/playlists/main/video1.mp4

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^hello_world=%d+')
	then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local retAdr = 'https://raw.githubusercontent.com/west-side-simple/playlists/main/video' .. inAdr:match('(%d+)') .. '.mp4'
	local logo = './luaScr/user/westSide/icons/liteportal.png'
	local title = 'SimpleTV Mediaportal Team'

	m_simpleTV.Control.ChangeChannelLogo(logo , m_simpleTV.Control.ChannelID)
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.SetNewAddress(retAdr)