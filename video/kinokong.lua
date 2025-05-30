-- видеоскрипт для сайта https://kinokong.sk (13/07/2022) author - nexterr
-- fix west_side 01/04/2025
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr/simpleTV
-- ## необходимы ##
-- видеоскрипты: hdvb.lua, browser_collaps.lua
-- ## открывает подобные ссылки ##
-- https://kinokong.sk/42330-films-russkiy-reyd-2020.html
-- https://kinokong.sk/45234-serial-ptica-dobrogo-gospoda-1-sezon.html
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://kinokong%.') then return end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	local inAdr = m_simpleTV.Control.CurrentAddress
	local host = inAdr:match('https?://[^/]+')
	local logo = host .. '/templates/smartphone/img/logo.svg'
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, TypeBackColor = 0, PictFileName = logo, UseLogo = 1, Once = 1})
	end
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'kinokong ошибка: ' .. str, showTime = 5000, color = 0xffff1000, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:81.0) Gecko/20100101 Firefox/81.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
		if rc ~= 200 then
			showError('1')
			m_simpleTV.Http.Close(session)
		 return
		end
	answer = m_simpleTV.Common.multiByteToUTF8(answer)
	answer = answer:gsub('<!%-%-.-%-%->', '')
	local title = answer:match('property="og:title" content="([^"]+)') or 'kinokong'
	local poster = answer:match('<div class="full%-poster">.-src="(.-)"') or logo
	local desc = answer:match('"description" content="([^"]+)') or ''
	local retAdr
	local i, t = 1, {}
		for w in answer:gmatch('<li data%-iframe=".-</li>') do
			local adr,name = w:match('<li data%-iframe="(.-)">(.-)</li>')
				if not adr or not name then break end
			if (name == 'HDVB' or name == 'Collaps') and adr~='' then
				t[i] = {}
				t[i].Id = i
				t[i].Name = name
				t[i].Address = adr
				t[i].InfoPanelName = title
				t[i].InfoPanelLogo = 'https://kinokong.sk' .. poster
				t[i].InfoPanelTitle = desc or name
				t[i].InfoPanelShowTime = 8000
				i = i + 1
			end
		end
		if i == 1 then
			showError('2')
		 return
		end
	if i > 2 then
		m_simpleTV.Control.SetTitle(title)
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 8000, 1)
		id = id or 1
		retAdr = t[id].Address
		m_simpleTV.Control.ExecuteAction(37)
	else
		retAdr = t[1].Address
	end
		if retAdr:match('trailer%-cdn') then
			rc, answer = m_simpleTV.Http.Request(session, {url = host .. retAdr, headers = 'Referer: ' .. inAdr})
			m_simpleTV.Http.Close(session)
				if rc ~= 200 then
					showError('3')
				 return
				end
			retAdr = answer:match('file:"([^"]+)')
				if not retAdr then
					showError('4')
				 return
				end
			retAdr = retAdr:gsub('^/', host .. '/')
			title = title .. ' - ' .. (answer:match('title:"([^"]+)') or 'Трейлер')
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.CurrentTitle_UTF8 = title
				if retAdr:match('https?://[%a%.]*youtu[%.combe]') then
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = retAdr .. '&isLogo=false'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\video.lua')
				 return
				end
			m_simpleTV.Control.CurrentAddress = retAdr
		 return
		end
	m_simpleTV.Http.Close(session)
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo('https://kinokong.sk' .. poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	retAdr = retAdr:gsub('^//', 'http://'):gsub('amp;', '')
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = retAdr
	dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\video\\hdvb.lua')
	dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\video\\browser_collaps.lua')
-- debug_in_file(retAdr .. '\n')