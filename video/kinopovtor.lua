-- видеоскрипт для сайтов https://kinopovtor.cc (03/08/21)
-- автор westSide
-- открывает подобные ссылки:
-- https://kinopovtor.cc/27398-spirit-nepokornyy.html

		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://kinopovtor%.cc')
		then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('kinopovtor ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local retAdr0 = answer:match('file: %[(.-)%]')
		if not retAdr0 then
			m_simpleTV.OSD.ShowMessage_UTF8('kinopovtor ошибка[2]', 255, 5)
		 return
		end
	local title = answer:match('<title>(.-)</title>') or 'kinopovtor'
	title = m_simpleTV.Common.multiByteToUTF8(title, 1251):gsub(' смотреть онлайн.-$','')
	local poster = answer:match('<meta property="og:image" content="(.-)"')
		m_simpleTV.Control.CurrentTitle_UTF8 = title
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end

	local i = 1
	local t = {}
	for w in retAdr0:gmatch('%{.-%}') do
	t[i] = {}
	t[i].Id = i
	t[i].Name, t[i].Action = w:match('"comment":"(.-)","file":"(.-)"')
	t[i].Name = m_simpleTV.Common.multiByteToUTF8(t[i].Name, 1251)
	i = i + 1
	end
	if i > 2 then
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите перевод - ' .. title, 0, t, 8000, 1)
	if ret==1 then
	retAdr = t[id].Action
	end
	else
	retAdr = t[1].Action
	end

	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
-- debug_in_file(retAdr .. '\n')