-- видеоскрипт для сайтов http://www.hdkinoteatr.com  https://kinogo.cc/ (18/03/21)
-- необходимы скрипты: collaps (autor - nexterr)
-- открывает подобные ссылки:
-- http://www.hdkinoteatr.com/drama/28856-vse_ispravit.html
-- https://kinogo.cc/75043-poslednee-voskresenie-last-station-kinogo-2009.html
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://www%.hdkinoteatr%.com')
		and not inAdr:match('^https?://kinogo%.cc')
		then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end
local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('hdkinoteatr ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local title = answer:match('<font color="yellow">(.-)</font>') or answer:match('<title>(.-)</title>') or 'hdkinoteatr'
	title = title:gsub('%).-$', ')')
	local poster = answer:match('<meta property="og:image" content="(.-)"')
	m_simpleTV.Control.CurrentTitle_UTF8 = title:gsub('/.+', ''):gsub('Смотреть ', '')
	local background = answer:match('"url": "(.-)"') or poster
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end	
	local retAdr
	local t,i = {},1
	for w in answer:gmatch('<iframe src=.-</iframe>') do
		adr = w:match('<iframe src=(.-) ')
		if not adr or adr:match('/trailer/') or adr:match('token=') then break end
		t[i] = {}
		t[i].Address = adr:gsub('"',''):gsub('^//', 'http://'):gsub('/iframe%?.+', '/iframe'):gsub('vb17120ayeshajenkins','vb17121coramclean'):gsub('%?host=kinogo%.cc.-$','')
		if adr:match('/embed/') then t[i].Name = 'Collaps' else t[i].Name = 'HDVB' end
		i=i+1
	end
		local hash, res = {}, {}
		for i = 1, #t do
		t[i].Address = tostring(t[i].Address)
			if not hash[t[i].Address] then
				res[#res + 1] = t[i]
				hash[t[i].Address] = true
			end
		end
		for i = 1, #res do
			res[i].Id = i
		end
	if #res and #res > 1 then	
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🎞 ' .. title, 0, res, 8000, 1 + 2)
		id = id or 1
		retAdr = res[id].Address
	else
		retAdr = res[1].Address
	end
		if not retAdr then
			m_simpleTV.OSD.ShowMessage_UTF8('hdkinoteatr ошибка[2]', 255, 5)
		 return
		end
	if inAdr:match('kinogo%.cc') then
	setConfigVal('info/kinogo',inAdr)
	end
	m_simpleTV.Control.ChangeAdress = 'No'
	if inAdr:match('kinogo%.cc') then
	m_simpleTV.Control.CurrentAdress = retAdr .. '&kinogo=' .. inAdr
	else
	m_simpleTV.Control.CurrentAdress = retAdr
	end
	dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
-- debug_in_file(retAdr .. '\n')