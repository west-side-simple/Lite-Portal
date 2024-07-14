-- видеоскрипт формирования title, logo, background, info SimpleTV Lite по hevc_id (16/11/23)
-- author west_side
-- открывает подобные ссылки:
-- hevc_id=3483&magnet:?xt=urn:btih:59EBC4250D9C5D104FDDF6CEEC7EA5CF9FFB2853&amp;tr=http://rips.club:2710/00000af98b3d84b196ec12e9a990b241/announce&amp;tr=udp://tracker.opentrackr.org:1337/announce&amp;tr=udp://tracker.openbittorrent.com:80/announce&amp;tr=udp://tracker.openbittorrent.com:1337/announce&amp;tr=udp://tracker.openbittorrent.com:6969&amp;tr=udp://opentor.net:6969&amp;tr=http://retracker.local/announce
--
	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^hevc_id=') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.hevc then
		m_simpleTV.User.hevc = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end

	m_simpleTV.User.TVPortal.balanser = 'RipsClub'	
	local hevc_id = inAdr:match('id=(.-)%&')
	local retAdr = inAdr:gsub('hevc_id=.-%&','')
	m_simpleTV.User.hevc.content = hevc_id
	m_simpleTV.User.hevc.address = retAdr
	m_simpleTV.User.westSide.PortalTable = 'https://rips.club/video-' .. m_simpleTV.User.hevc.content .. '/'

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.User.westSide.PortalTable})
	if rc ~= 200 then return end
	m_simpleTV.Http.Close(session)
	local title = answer:match('<title>(.-)</title>') or 'HEVC'
	title = title:gsub('%&quot%;','"'):gsub('%&apos%;',"'"):gsub('%).-$',')')
	local poster = answer:match('<meta property="og%:image" content="(.-)">')
	local year = title:match(' %((%d%d%d%d)%)$')
	local name = title:gsub(' %(.-$','')
	local desc, background, over, use
	if name and year then
		desc, background, over = info_fox(name, year, poster)
	end
	if background then use = 3 end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = background or poster, TypeBackColor = 0, UseLogo = use or 1, Once = 1})
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.Control.SetTitle(title)
		m_simpleTV.Control.ChangeChannelLogo(poster , m_simpleTV.Control.ChannelID)
	end
	m_simpleTV.Control.SetNewAddress(retAdr)
-- debug_in_file(retAdr .. '\n')