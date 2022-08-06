-- видеоскрипт для сайта https://ex-fs.net (04/08/22) - автор west_side
-- открывает подобные ссылки:
-- https://ex-fs.net/cartoon/105216-boss-molokosos-2.html
-- необходимы скрипты poisk_kinopoisk.lua, kinopoisk.lua - автор nexterr
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://ex%-fs%.%a+') then return end
		if inAdr:match('/actors/') then page_exfs(inAdr) return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
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
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Cookie: ' .. cookies})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local retAdr = answer:match('data%-kinopoisk="(%d+)"')
	local title = answer:match('<title>(.-)</title>') or 'ex-fs'
	local logo = answer:match('<img src="(/uploads/.-)">') or '/templates/ex-fs/images/favicon.ico'
	logo = 'https://ex-fs.net' .. logo
	if m_simpleTV.Common.isUTF8(title) == false then title = m_simpleTV.Common.multiByteToUTF8(title) end
	title = title:gsub(' смотреть онла.+', ''):gsub('^Сериал ', ''):gsub('%(.+', '')
	m_simpleTV.Control.CurrentTitle_UTF8 = title
		if not retAdr then
		retAdr = '*' .. m_simpleTV.Common.UTF8ToMultiByte(title)
		else
		retAdr = '**' .. retAdr
		setConfigVal('info/media',inAdr)
		setConfigVal('info/scheme','EXFS')
		end
	m_simpleTV.Control.ChangeAdress = 'No'
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
-- debug_in_file(retAdr .. '\n')