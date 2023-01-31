-- видеоскрипт для воспроизведения плейлиста шаблона для EDEM/ILOOK (29/01/23)
-- author west_side
-- ## открывает подобные ссылки ##
-- http://he11o.akadatel.com/iptv/XXXXXXXXXXXXXX/2402/index.m3u8
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('/XXXXXXXXXXXXXX/')
		then
		 return
		end
		local answer

		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('edem ws') end, err)
		if not login or not password or login == '' or password == '' then return
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/extFiltersLogo/edem.png"', text = ' Внесите данные в менеджере паролей для ID edem ws', color = ARGB(255, 127, 63, 255), showTime = 1000 * 60})
		end
----------privat section
		local file = io.open(m_simpleTV.MainScriptDir .. 'user/TVSources/core/keys.txt', 'r')
		if file then
		answer = file:read('*a')
		file:close()
		local t, i = {}, 1
			for w in answer:gmatch('\n.-\n') do
				local key = w:match('\n(.-)\n')
				if not key then break end
				t[i] = {}
				t[i].key = key
				i = i + 1
			end
		local index = math.random(i)
		password = t[index].key
		end
-----------------------		
		local inAdr = m_simpleTV.Control.CurrentAddress
		m_simpleTV.Control.SetNewAddress(inAdr:gsub('XXXXXXXXXXXXXX',password))