-- видеоскрипт для сайтов http://www.hdkinoteatr.com  https://kinogo.cc/ (02/08/21)
-- необходимы скрипты: collaps (autor - nexterr)
-- открывает подобные ссылки:
-- http://www.hdkinoteatr.com/drama/28856-vse_ispravit.html
-- https://kinogo.cc/75043-poslednee-voskresenie-last-station-kinogo-2009.html
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://www%.hdkinoteatr%.com') 
		and not inAdr:match('https?://kinogo%.cc') 
		then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('hdkinoteatr ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local retAdr = answer:match('<iframe src="(.-)"')
		if not retAdr then
			m_simpleTV.OSD.ShowMessage_UTF8('hdkinoteatr ошибка[2]', 255, 5)
		 return
		end
	local title = answer:match('<font color="yellow">(.-)</font>') or answer:match('<title>(.-)</title>') or 'hdkinoteatr'
	local poster = answer:match('<meta property="og:image" content="(.-)"')
	m_simpleTV.Control.CurrentTitle_UTF8 = title:gsub('/.+', ''):gsub('Смотреть ', '')
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end
	
	retAdr = retAdr:gsub('^//', 'http://'):gsub('/iframe%?.+', '/iframe'):gsub('vb17120ayeshajenkins','vb17121coramclean')
	m_simpleTV.Control.ChangeAdress = 'No'
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
-- debug_in_file(retAdr .. '\n')