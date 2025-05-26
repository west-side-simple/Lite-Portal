-- открывает подобные ссылки:
-- https://api.lkpma.xyz/collections//colls/samye_dobrye_filmy.json
-- https://ws.pris.cam/api/collections/view/hbo
-- необходим скрипт getaddress_tmdb.lua - автор west_side (22.01.25)

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress	
	if not inAdr then return end
	
	if not inAdr:match('/collections//colls/')
	and not inAdr:match('/collections/view/')
	then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local url = inAdr
	local name_ch = m_simpleTV.Control.CurrentTitle_UTF8			
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelName(name_ch, m_simpleTV.Control.ChannelID, false)
	end
	local t, i = {}, 1
	for k =1,10 do
		local rc, answer = m_simpleTV.Http.Request(session, {url = url .. '?page=' .. k})
		if not answer then break end		
		for w in answer:gmatch('%{.-%}') do			
			local tv
			local address = w:match('"id":.-(%d+)')
			local Title = w:match('"title":.-"(.-)"') or w:match('"name":.-"(.-)"')
			local originalTitle = w:match('"original_title":.-"(.-)"') or w:match('"original_name":.-"(.-)"')
			local overview = w:match('"overview":.-"(.-)"') or ''
			local Type = w:match('"media_type":.-"(.-)"')
			if Type and Type == 'movie' then tv = 0 else tv = 1 end
			local logo = w:match('"poster_path":.-"(.-)"') or ''
			logo = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. logo
			local year = w:match('"release_date":.-"(%d%d%d%d)') or w:match('"first_air_date":.-"(%d%d%d%d)') or 0
			if not address then break end
			t[i]={}
			t[i].Id = i
			t[i].Name = Title .. ' (' .. year .. ') - ' .. Type
			t[i].Action = 'tmdb_id=' .. address .. '&tv=' .. tv .. '&'
			t[i].InfoPanelTitle = overview
			t[i].InfoPanelName = Title .. ' / ' .. originalTitle .. ' (' .. year .. ') - ' .. Type
			t[i].InfoPanelLogo = logo
--			debug_in_file(t[i].Action .. '\n','c://1/tmdb_int.txt')
			i = i + 1
		end
		k = k + 1
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('TMDB: ' .. name_ch, 0, t0, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			m_simpleTV.Control.PlayAddressT({address=t0[id].Action, title=t0[id].Name})
		end
	else
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'IMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	end
		