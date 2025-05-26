-- видеоскрипт для сайта https://ex-fs.net (09/05/25) - автор west_side
-- открывает подобные ссылки:
-- https://ex-fs.net/cartoon/105216-boss-molokosos-2.html

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('https?://ex%-fs%.%a+') then return end
	local inAdr1 = inAdr:match('&(.-)$')
	if inAdr:match('/actors/') then
		m_simpleTV.Control.ChangeAdress = 'Yes'	
		m_simpleTV.Control.CurrentAdress = 'wait'
		return page_exfs(inAdr) 
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
--	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end
local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
local function cookiesFromFile()
	local path = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
	local file = io.open(path, 'r')
		if not file then
			return ''
			else
		local answer = file:read('*a')
		file:close()

			local name2,data2 = answer:match('ex%-fs%.net.+%s(_ym_uid)%s+(%S+)')
			local name3,data3 = answer:match('ex%-fs%.net.+%s(_ym_d)%s+(%S+)')
			local name4,data4 = answer:match('ex%-fs%.net.+%s(_ym_isad)%s+(%S+)')
			local name5,data5 = answer:match('ex%-fs%.net.+%s(PHPSESSID)%s+(%S+)')
			local name6,data6 = answer:match('ex%-fs%.net.+%s(dle_user_id)%s+(%S+)')
			local name7,data7 = answer:match('ex%-fs%.net.+%s(dle_password)%s+(%S+)')
			local name8,data8 = answer:match('ex%-fs%.net.+%s(dle_newpm)%s+(%S+)')

			if name2 and data2 and name3 and data3 and name4 and data4 and name5 and data5 and name6 and data6 and name7 and data7 and name8 and data8
			then str = name2 .. '=' .. data2 .. ';' .. name3 .. '=' .. data3 .. ';' .. name4 .. '=' .. data4 .. ';' .. name5 .. '=' .. data5 .. ';' .. name6 .. '=' .. data6 .. ';' .. name7 .. '=' .. data7 .. ';' .. name8 .. '=' .. data8
			else
			return ''
			end
			end
return str
end
	local cookies = cookiesFromFile() or ''
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('&.-$',''), headers = 'Cookie: ' .. cookies})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end

	local kp_id = answer:match('data%-kinopoisk="(%d+)"') or answer:match('/kp/(%d+)') or answer:match('kp_id=(%d+)')
--	local 
	local poster = answer:match('<div class="FullstoryForm">.-<img src="(.-)"') or ''
	poster = 'https://ex-fs.net' .. poster:gsub('https://ex%-fs%.net','')
	local title_rus = answer:match('<h1 class="view%-caption">(.-)</h1>') or ''
	title_rus = title_rus:gsub(' смотреть онлайн','')
	local year = answer:match('<p class="FullstoryInfoin"><a href="/year/.-" title="(.-)"') or ''

	if m_simpleTV.Common.isUTF8(title_rus) == false then title_rus = m_simpleTV.Common.multiByteToUTF8(title_rus) end
	local retAdr
	m_simpleTV.Control.CurrentTitle_UTF8 = title_rus .. ' (' .. year .. ')'
	m_simpleTV.Control.SetTitle( (title_rus .. ' (' .. year .. ')') )

	m_simpleTV.Control.ChangeChannelLogo(poster , m_simpleTV.Control.ChannelID)
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = poster, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
		if not kp_id then
			retAdr = '*' .. m_simpleTV.Common.UTF8ToMultiByte(title_rus)
			m_simpleTV.Control.ChangeAdress = 'No'
			m_simpleTV.Control.CurrentAdress = retAdr
		else
			setConfigVal('info/media',inAdr)
			setConfigVal('info/scheme','EXFS')
			m_simpleTV.Control.ChangeAdress = 'Yes'
			Get_Kinopoisk(title_rus, year, kp_id, inAdr, poster)
		end

-- debug_in_file(retAdr .. '\n')