-- видеоскрипт для сайта https://ex-fs.net (19/07/25) - автор west_side
-- открывает подобные ссылки:
-- https://ex-fs.net/cartoon/105216-boss-molokosos-2.html

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^https?://ex%-fs%.%a+') then return end
	local inAdr1 = inAdr:match('&(.-)$')
--	debug_in_file(inAdr1..'\n')
	local scheme = ''
	if inAdr:match('/actors/') then
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAdress = 'wait'
		return page_exfs(inAdr)
	else get_media_info(inAdr:gsub('&.-$',''))
		m_simpleTV.User.EXFS.CurAddress = inAdr:gsub('&.-$','')
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.User.westSide.PortalTable = true
		if inAdr1 and inAdr1:match('yandex%.ru') then m_simpleTV.User.TVPortal.balanser = 'Trailer' end
		if inAdr1 and inAdr1:match('/lite/veoveo') then scheme = '&scheme='..m_simpleTV.User.EXFS.CurAddress end
		m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.EXFS.logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		if not inAdr1 then
			m_simpleTV.Control.CurrentAdress = 'wait'
			return info_exfs()
		elseif m_simpleTV.User.TVPortal.balanser == 'Trailer' then
			m_simpleTV.Control.SetNewAddressT({address= inAdr1, title=m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')', position = 0})
		else
			m_simpleTV.Control.SetNewAddressT({address= inAdr1..scheme
			, title=m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')', position = m_simpleTV.User.EXFS.position})
			return
		end

	end
