-- открывает подобные ссылки:
-- https://www.imdb.com/interest/in0000188/ - подборки
-- https://www.imdb.com/event/ev0000147/2024/1/ - ивенты
-- https://www.imdb.com/name/nm0000151/ - фильмографии
-- https://www.imdb.com/chart/boxoffice/ - в топе
-- https://www.imdb.com/search/title/?title_type=feature&genres=animation - расширенный поиск
-- необходим скрипт imdb_media.lua, ZF.lua, VF.lua - автор west_side
-- 06.04.25

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress

	if not inAdr then return end

	if not inAdr:match('https?://www%.imdb%.com/interest/in%d+')
	and not inAdr:match('https?://www%.imdb%.com/chart/')
	and not inAdr:match('https?://www%.imdb%.com/name/')
	and not inAdr:match('https?://www%.imdb%.com/find/')
	and not inAdr:match('https?://www%.imdb%.com/event/')
	and not inAdr:match('https?://www%.imdb%.com/search/')
	and not inAdr:match('^*')
	then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local url = inAdr
	if inAdr:match('^*') then
		local search = inAdr:match('^*(.-)$')
		if search:match('^*(%d+)') then
			return m_simpleTV.Control.PlayAddressT({address='https://www.kinopoisk.ru/film/' .. search:match('^*(%d+)')})
		else
			search = m_simpleTV.Common.toPersentEncoding(m_simpleTV.Common.multiByteToUTF8(search))
			url = 'https://www.imdb.com/find/?s=tt&ref_=nv_sr_sm&q=' .. search:gsub('%%28.-%%29','')
		--	debug_in_file(url .. '\n','c://1/search.txt')
		end
	end
	local cookies = 'lc-main=ru_RU' 
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Cookie: ' .. cookies})
--	debug_in_file(m_simpleTV.Control.CurrentTitle_UTF8 .. ' // ' .. url .. '\n','c://1/imdb_title.txt')
	local name_ch

	if m_simpleTV.Control.CurrentTitle_UTF8 and not m_simpleTV.Control.CurrentTitle_UTF8:match('^http') then name_ch = m_simpleTV.Control.CurrentTitle_UTF8 else name_ch = answer:match('<title>(.-)</title>') end
	answer = answer:match('<script id="__NEXT_DATA__" type="application/json">(.-)</script>')
	answer = unescape3(answer)
			if not answer then return end
			answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
--			debug_in_file(answer .. '\n','c://1/imdb_int.txt')
			m_simpleTV.Control.SetTitle(name_ch)
			if m_simpleTV.Control.MainMode == 0 then
				m_simpleTV.Control.ChangeChannelName(name_ch, m_simpleTV.Control.ChannelID, false)
			end
			local t, i = {}, 1
			for w in answer:gmatch('"id":"tt.-"runtime"') do
			local address, Title, Type, originalTitle, logo, year = w:match('"id":"(tt.-)".-"text":"(.-)".-"text":"(.-)".-"text":"(.-)".-"url":"(.-)".-"year":(%d%d%d%d)')
			if not address then break end
				t[i]={}
				t[i].Id = i
				t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
				t[i].Action = 'https://www.imdb.com/title/' .. address
				t[i].InfoPanelTitle = Title .. ' / ' .. originalTitle .. ' (' .. year .. ') - ' .. Type
				t[i].InfoPanelLogo = logo
				i = i + 1
			end

			if #t == 0 then
				for w in answer:gmatch('"id":"tt.-"imageType":".-"') do
					local address, Title, year, logo, Type = w:match('"id":"(tt.-)".-"titleNameText":"(.-)".-"titleReleaseText":"(.-)".-"url":"(.-)".-"imageType":"(.-)"')
					if not address then break end
					t[i]={}
--					t[i].Id = i
					t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
					t[i].Action = 'https://www.imdb.com/title/' .. address
					t[i].InfoPanelTitle = Title .. ' (' .. year .. ') - ' .. Type
					t[i].InfoPanelLogo = logo
					i = i + 1
				end
			end

			if #t == 0 then
				for w in answer:gmatch('"id":"tt.-"titleType":%{"id":".-"') do
					local address, Title, originalTitle, logo, year, Type = w:match('"id":"(tt.-)".-"text":"(.-)".-"text":"(.-)".-"url":"(.-)".-%((%d%d%d%d)%)".-"titleType":%{"id":"(.-)"')
					if not address then break end
					t[i]={}
					t[i].Id = i
					t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
					t[i].Action = 'https://www.imdb.com/title/' .. address
					t[i].InfoPanelTitle = Title .. ' / ' .. originalTitle .. ' (' .. year .. ') - ' .. Type
					t[i].InfoPanelLogo = logo
					i = i + 1
				end
			end

			if #t == 0 then
				for w in answer:gmatch('"canRate".-"topCast"') do
					local logo, year, address, Title, Type = w:match('"url":"(.-)".-"releaseYear":(%d%d%d%d).-"titleId":"(.-)".-"titleText":"(.-)".-"id":"(.-)"')
					if not address then break end
					t[i]={}
					t[i].Id = i
					t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
					t[i].Action = 'https://www.imdb.com/title/' .. address
					t[i].InfoPanelTitle = Title .. ' (' .. year .. ') - ' .. Type
					t[i].InfoPanelLogo = logo
					i = i + 1
				end
			end

			local hash, t0 = {}, {}
				for i = 1, #t do
					if not hash[t[i].Action]
					then
						t0[#t0 + 1] = t[i]
						hash[t[i].Action] = true
					end
				end

				for i = 1, #t0 do
					t0[i].Id = i
				end

		local AutoNumberFormat, FilterType
			if #t0 > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		if #t0 > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('IMDb: ' .. name_ch:gsub('^*',''), 0, t0, 30000, 1 + 4 + 8 + 2)
			if ret == 1 then
				add_to_history_imdb(t0[id].Action, t0[id].Name, t0[id].InfoPanelLogo)
				m_simpleTV.Control.PlayAddressT({address=t0[id].Action, title=t0[id].Name})
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'IMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
