-- видеоскрипт для сайта http://baskino.me (21/03/24)
-- открывает подобные ссылки:
-- http://baskino.me/films/boeviki/7767-sokrovischa-serra-madre.html
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://baskino%.%a+') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end	
	local retAdr = answer:match('"vb" data%-url="(.-)"')
		if not retAdr then return end
	local title = answer:match('<title>(.-)</title>') or 'baskino'
	local logo = answer:match('as="image" href="(.-)"') or 'http://baskino.me/templates/Baskino/images/logo.png'
	if m_simpleTV.Common.isUTF8(title) == false then title = m_simpleTV.Common.multiByteToUTF8(title) end
	title = title:gsub(' смотреть онла.+', ''):gsub('^Сериал ', ''):gsub('%(.+', '')
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Control.ChangeAdress = 'No'
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. "user\\westSidePortal\\video\\baskino.lua")
-- debug_in_file(retAdr .. '\n')