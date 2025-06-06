-- видеоскрипт для балансера VideoDB (17.10.24)
-- author west_side
	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if m_simpleTV.Control.CurrentAddress:match('^tmdb_id=')
	then return end
	if not m_simpleTV.Control.CurrentAddress:match('/late/videodb')
	then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.DB then
		m_simpleTV.User.DB = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	m_simpleTV.User.TMDB.Id = nil
	m_simpleTV.User.TMDB.tv = nil
	m_simpleTV.User.DB.CurAddress = inAdr
	m_simpleTV.User.DB.DelayedAddress = nil
	m_simpleTV.User.TVPortal.balanser = 'VideoDB'
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_np = getConfigVal('perevod/db') or ''
	if not getConfigVal('perevod/db') then setConfigVal('perevod/db','') end
	local function Get_ZF(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 4000)
		local url = decode64('aHR0cHM6Ly90dGx6Znh5eC5kZXBsb3kuY3gvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. id
		local rc,answer = m_simpleTV.Http.Request(session,{url = url})

	--	debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Common.Sleep(1000)
		rc,answer = m_simpleTV.Http.Request(session,{url = url})
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function get_logo_yandex(kp_id)
	if not kp_id then return end
		local url = 'https://st.kp.yandex.net/images/film_big/' .. kp_id .. '.jpg'
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then
			return false
		end
		m_simpleTV.Http.SetTimeout(session, 3000)
		m_simpleTV.Http.SetTLSProtocol(session, 'TLS1_2')
		m_simpleTV.Http.EnableLocalCache(session)
		local rc,answer = m_simpleTV.Http.Request(session,{url=url, writeinfile = true})
		m_simpleTV.Http.Close(session)
		return answer
	end

	local function get_serial(kpid,season,episode)
		if not kpid or tonumber(kpid) == 0 then return end
		local kpid_cur
		if tonumber(kpid) == 77381 or tonumber(kpid) == 94103 or tonumber(kpid) == 77388 or tonumber(kpid) == 77385 or tonumber(kpid) == 77387 or tonumber(kpid) == 77386 or tonumber(kpid) == 426306 or tonumber(kpid) == 426309 or tonumber(kpid) == 420337 or tonumber(kpid) == 426310 then kpid_cur = kpid kpid = 77381 end
		local url_al = decode64('aHR0cHM6Ly9hcGkuYXBidWdhbGwub3JnLz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEma3A9') .. kpid
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then	return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local rc,answer = m_simpleTV.Http.Request(session,{url=url_al})
--		debug_in_file(answer .. '\n')
		m_simpleTV.Http.Close(session)
		if rc~=200 then return end
		require('json')
		answer = htmlEntities.decode(answer)
		answer = answer:gsub('\\\\\\/', '/')
		answer = answer:gsub(' \\"', ' «'):gsub('\\"', '»')
		answer = unescape3(answer)
		answer = answer:gsub('\\', '')
		answer = answer:gsub('(%[%])', '"nil"')
--		debug_in_file(answer .. '\n')
		local tab = json.decode(answer)
		local t,i,current_ep = {},1,1
		for w in answer:gmatch('"season":.-%}%}%}%}') do
			local s = w:match('"season":(%d+)')
			for v in w:gmatch('"episode":.-%}%}%}') do
				local e = v:match('"episode":(%d+)')
				t[i] = {}
				t[i].Id = i
				if tonumber(kpid) == 77381 then
					local t1 =
						{
						{1,5,'Барон',77381,'tt0245602',2000},
						{2,10,'Адвокат',94103,'tt0394150',2000},
						{3,8,'Крах Антибиотика',77388,'tt0368589',2001},
						{4,7,'Арестант',77385,'tt0368588',2003},
						{5,5,'Опер',77387,'tt0368590',2003},
						{6,7,'Журналист',77386,'tt0368591',2003},
						{7,12,'Передел',426306,'tt5031866',2005},
						{8,12,'Терминал',426309,'tt4791006',2006},
						{9,12,'Голландский Пассаж',420337,'tt4810954',2006},
						{10,12,'Расплата',426310,'tt4786988',2007},
						}
					t[i].Name = t1[tonumber(s)][3] .. ' , Серия ' .. e
					t[i].Address = m_simpleTV.User.DB.CurAddress:gsub('&s=%d+',''):gsub('&e=%d+',''):gsub('&kinopoisk_id=%d+','') .. '&kinopoisk_id=' .. t1[tonumber(s)][4] .. '&s=1&e=' .. e
					if t1[tonumber(s)][4] == tonumber(kpid_cur) and tonumber(episode) == tonumber(e) then current_ep = i end
				else
					t[i].Name = 'Сезон ' .. s .. ', Эпизод ' .. e
					t[i].Address = m_simpleTV.User.DB.CurAddress:gsub('&s=%d+',''):gsub('&e=%d+','') .. '&s=' .. s .. '&sid=' .. (tonumber(s)-1) .. '&e=' .. e
					if tonumber(season) == tonumber(s) and tonumber(episode) == tonumber(e) then current_ep = i end
				end
--				debug_in_file(t[i].Name .. ' / ' .. t[i].Address .. '\n','c://1/answer_als.txt')
				i = i + 1
			end
		end
		return table_reverse (t), #t - current_ep + 1
	end

	local function imdbid(kpid)
	if not kpid then return end
	if tonumber(kpid)== 1101239 then return 'tt15307130','Реализация',2019,1 end
	local tv = 0
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJmtpbm9wb2lza19pZD0=') .. kpid
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then	return false end
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		if tonumber(kpid) == 231141 then return 'tt0435978','','',1 end
		url_vn = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEma3A9') .. kpid
		rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5==200 and answer_vn:match('"id_imdb":"(tt%d+)') then
		if answer_vn:match('"seasons":') then tv = 1 end
		return answer_vn:match('"id_imdb":"(tt%d+)'),'','',tv
		end
		return '','','',0
		end
		require('json')
		answer_vn = answer_vn:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].content_type and tab_vn.data[1].content_type == 'tv-series' then tv = 1 end
		local kostyl
		if tonumber(kpid) == 1309418 then kostyl = 'tt15325406' tv = 1 end
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id and tab_vn.data[1].imdb_id ~= 'null' and tab_vn.data[1].year then
		return kostyl or tab_vn.data[1].imdb_id or '', unescape3(tab_vn.data[1].title) or '',tab_vn.data[1].year:match('%d%d%d%d') or '', tv
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and ( not tab_vn.data[1].imdb_id or tab_vn.data[1].imdb_id == '') then
		return kostyl or '', unescape3(tab_vn.data[1].title) or '',tab_vn.data[1].year:match('%d%d%d%d') or '', tv
		else return '','','',0
		end
	end

	local function bg_imdb_id(imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then	return false end
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ=')

	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc5~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local background, name_tmdb, tmdb_id, tv, year_tmdb, overview_tmdb = '', '', '', 0, '', ''
	if imdb_id == 'tt27053234' then
	tab.tv_results = {}
	tab.tv_results[1] = {}
	tab.tv_results[1].backdrop_path = "/vkwkX6x7ymz0w6ibmYdmSx38MrJ.jpg"
	tab.tv_results[1].poster_path = "/f7gsprOjZZXuD4cXOQaAiFO4v04.jpg"
	tab.tv_results[1].name = "Призвание"
	tab.tv_results[1].first_air_date = "2021-03-13"
	tab.tv_results[1].overview = "Середина 80-х, Москва. Старшего оперуполномоченного МУРа Владимира Чеянова назначают начальником следственной группы по одному резонансному делу — об убийстве семьи Лошкарёвых. Тела отца, его пожилой матери и старшего сына нашли в собственной квартире в Москве."
	tab.tv_results[1].id = 222216
	end
	if imdb_id == 'tt15307130' then
	tab.tv_results = {}
	tab.tv_results[1] = {}
	tab.tv_results[1].backdrop_path = "/vVUNtiF2Ncnyq4DpK4iAOGrgnHS.jpg"
	tab.tv_results[1].poster_path = "/8VMftUs6jYduri1zYdUWDsV43eZ.jpg"
	tab.tv_results[1].name = "Реализация"
	tab.tv_results[1].first_air_date = "2019-03-11"
	tab.tv_results[1].overview = "Опытного розыскника из Великого Новгорода с необычной фамилией Красавéц после конфликта с криминальным бизнесменом переводят на должность простого участкового в Центральный район Петербурга. Всё, что хочет теперь Красавец — это тихо и мирно дослужить до пенсии. Но каждый раз, неожиданно для себя, оказывается в эпицентре преступных событий. То он втянут в разборки между криминальным авторитетом и коллегами из УМВД, то ищет похищенного начальника главка, то ловит неуловимого киллера."
	tab.tv_results[1].id = 120724
	end
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path and not tab.movie_results[1].poster_path
	and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path and not tab.tv_results[1].poster_path
	then return '', '', '', '', '', ''
	else
	if tab.movie_results[1] and imdb_id ~= 'tt0078655' and imdb_id ~= 'tt2317100' and imdb_id ~= 'tt0108778' then

	background = tab.movie_results[1].backdrop_path or ''
	background1 = tab.movie_results[1].poster_path or ''
	name_tmdb = tab.movie_results[1].title or ''
	year_tmdb = tab.movie_results[1].release_date or ''
	overview_tmdb = tab.movie_results[1].overview or ''
	tmdb_id = tab.movie_results[1].id
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	background1 = tab.tv_results[1].poster_path or ''
	name_tmdb = tab.tv_results[1].name or ''
	year_tmdb = tab.tv_results[1].first_air_date or ''
	overview_tmdb = tab.tv_results[1].overview or ''
	tmdb_id = tab.tv_results[1].id
	tv = 1
	end
	end
	if year_tmdb and year_tmdb ~= '' then
	year_tmdb = year_tmdb:match('%d%d%d%d')
	else year_tmdb = 0 end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background
	elseif background1 and background1 ~= nil and background1 ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background1 end
	if background == nil then background = '' end

	m_simpleTV.User.TMDB.Id = tmdb_id
	m_simpleTV.User.TMDB.tv = tv
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TMDB.Id .. ',' .. m_simpleTV.User.TMDB.tv
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	if not m_simpleTV.User.TVPortal.get then
		m_simpleTV.User.TVPortal.get = {}
	end
	if not m_simpleTV.User.TVPortal.get.TMDB then
		m_simpleTV.User.TVPortal.get.TMDB = {}
	end
	if not m_simpleTV.User.TVPortal.cor then
		m_simpleTV.User.TVPortal.cor = {}
	end
	m_simpleTV.User.filmix.CurAddress = nil
	m_simpleTV.User.rezka.CurAddress = nil
	m_simpleTV.User.TVPortal.get.TMDB.Id = tmdb_id
	m_simpleTV.User.TVPortal.get.TMDB.tv = tv
	info_fox(name_tmdb,year_tmdb,background)
	return background, name_tmdb, year_tmdb, overview_tmdb, tmdb_id, tv
	end

	local function DBIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('db_qlty') or 5000)
		local index = #t
			for i = 1, #t do
				if t[i].qlty >= lastQuality then
					index = i
				 break
				end
			end
		if index > 1 then
			if t[index].qlty > lastQuality then
				index = index - 1
			end
		end
	 return index
	end

	local function GetDBAdr(urls)

		local subt = urls:match("subtitle\':(.-)return pub")
--		debug_in_file(subt .. '\n')
		if subt then
			local s, j = {}, 1
			for w in subt:gmatch('https.-%.vtt') do
				s[j] = {}
				s[j] = w
				j = j + 1
			end
			subt = '$OPT:sub-track=0$OPT:input-slave=' .. table.concat(s, '#')
		end
		local t, i = {}, 1
		local qlty, adr
			for qlty, adr in urls:gmatch('"(.-)":"(.-)"') do
			if not qlty:match('%d+') then break end
				t[i] = {}
				t[i].Address = adr
				t[i].Name = qlty
				t[i].qlty = tonumber(qlty:match('%d+'))
				i = i + 1
			end
--[[			for qlty, adr in urls:gmatch('"(.-)":"(.-)"') do
			if not qlty:match('%d+') then break end
				t[i] = {}
				t[i].Address = adr
				t[i].Name = qlty
				t[i].qlty = tonumber(qlty:match('%d+'))
				i = i + 1
			end--]]
			if i == 1 then return end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address:gsub('^https://', 'http://') .. '$OPT:NO-STIMESHIFT' .. (subt or '')
				t[i].qlty = tonumber(t[i].Name:match('%d+'))
			end
		m_simpleTV.User.DB.Tab = t
		local index = DBIndex(t)
	 return t[index].Address
	end

	local function GetDBTrAdr(adr)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then	return end
		local rc,answer = m_simpleTV.Http.Request(session,{url=adr})
		if rc~=200 then return end
		local episode=adr:match('&e=(%d+)')
		if not episode then return end
		for w in answer:gmatch('%{"method":"play".-%}%}') do
--			debug_in_file(w .. '\n','c://1/ans_FX2.txt')
			local name, file = w:match('"title":".-%((.-)%)".-"quality":(.-%})')
			if not name or not file then break end
			if name:match('%d+') and name:match('%d+') == episode then return file end
		end
		return
	end

	function perevod_DB()
	local t = m_simpleTV.User.DB.TabPerevod
		if not t then return end
		if #t > 0 then
		local current_p = 1
		for i = 1,#t do
		if t[i].Name == getConfigVal('perevod/db') then current_p = i end
		i = i + 1
		end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_DB()'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(' 🔊 Перевод ', current_p - 1, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
			setConfigVal('perevod/db', t[id].Name)
			local episode = m_simpleTV.User.DB.CurAddress:match('&e=(%d+)') or ''
			if episode and episode ~= '' then
			episode = '&e=' .. episode
--			debug_in_file(m_simpleTV.User.FX.CurAddress .. '\n')
--			local adr = GetFXTrAdr(t[id].Address .. episode)
--			adr = GetFXAdr(adr)
			m_simpleTV.Control.ChangeAdress = 'Yes'
--			m_simpleTV.Control.CurrentAddress = m_simpleTV.User.DB.CurAddress:gsub('&t=%d+','') .. '&t=' .. id
			m_simpleTV.Control.SetNewAddressT({address = t[id].Address .. episode, position = m_simpleTV.Control.GetPosition()})
--			m_simpleTV.Control.Restart()
			else
			m_simpleTV.Control.Restart()
			end
			end
			if ret == 3 then
				Qlty_DB()
			end
		end
	end

	function Qlty_DB()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.DB.Tab
			if not t then return end
		local index = DBIndex(t)
		if m_simpleTV.User.DB.zf_bal then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ZF ', ButtonScript = ''}
		end
			if getConfigVal('perevod/db') ~= '' and m_simpleTV.User.DB.TabPerevod and #m_simpleTV.User.DB.TabPerevod > 1 then
				t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_DB()'}
			end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 8 + 2)
		if m_simpleTV.User.DB.isVideo == false then
			if m_simpleTV.User.DB.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('db_qlty', t[id].qlty)
		end
		if ret == 2 then
			m_simpleTV.Control.PlayAddressT({address=m_simpleTV.User.DB.zf_bal, position=m_simpleTV.Control.GetPosition()})
		end
		if ret == 3 then
			perevod_DB()
		end
	end

	local kpid = inAdr:match('kinopoisk_id=(%d+)')
	m_simpleTV.User.DB.kpid = kpid
	local id_imdb,title_v,year_v,tv
--	id_imdb = inAdr:match('kp%=(tt%d+)')
	local season,episode=m_simpleTV.User.DB.CurAddress:match('&s=(%d+).-&e=(%d+)')

	local logo, title, year, overview, tmdbid, tv
	if kpid then
		id_imdb,title_v,year_v,tv = imdbid(kpid)
--		debug_in_file(tv .. ' / ' .. id_imdb .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer_al.txt')
	end
	if id_imdb and id_imdb~= '' and bg_imdb_id(id_imdb) and bg_imdb_id(id_imdb)~= '' then
		logo, title, year, overview, tmdbid, tv = bg_imdb_id(id_imdb)
		if tonumber(kpid) == 77381 or tonumber(kpid) == 94103 or tonumber(kpid) == 77388 or tonumber(kpid) == 77385 or tonumber(kpid) == 77387 or tonumber(kpid) == 77386 or tonumber(kpid) == 426306 or tonumber(kpid) == 426309 or tonumber(kpid) == 420337 or tonumber(kpid) == 426310 or tonumber(kpid) == 77261 or tonumber(kpid) == 45789 or tonumber(kpid) == 77263 then tv = 1 end

	else
	if tonumber(kpid) == 77381 or tonumber(kpid) == 94103 or tonumber(kpid) == 77388 or tonumber(kpid) == 77385 or tonumber(kpid) == 77387 or tonumber(kpid) == 77386 or tonumber(kpid) == 426306 or tonumber(kpid) == 426309 or tonumber(kpid) == 420337 or tonumber(kpid) == 426310 then tv = 1 end
		logo = get_logo_yandex(kpid)
--		id_imdb,title_v,year_v,tv = imdbid(kpid)
		title = title_v
		year = year_v
	end
	if tonumber(tv) == 1 then
		if not season or not episode then
			if not season then season = 1 end
			if not episode then episode = 1 end
			inAdr = inAdr:gsub('&s=%d+',''):gsub('&e=%d+','') .. '&s=' .. season .. '&sid=' .. (tonumber(season)-1) .. '&e=' .. episode
--			m_simpleTV.Control.PlayAddressT({address=inAdr, title=title .. ', ' .. (year or '')})
--			return
		end
		if tonumber(kpid) == 77381 or tonumber(kpid) == 94103 or tonumber(kpid) == 77388 or tonumber(kpid) == 77385 or tonumber(kpid) == 77387 or tonumber(kpid) == 77386 or tonumber(kpid) == 426306 or tonumber(kpid) == 426309 or tonumber(kpid) == 420337 or tonumber(kpid) == 426310 then
			local t3 =
				{
				{1,5,'Барон',77381,'tt0245602',2000},
				{2,10,'Адвокат',94103,'tt0394150',2000},
				{3,8,'Крах Антибиотика',77388,'tt0368589',2001},
				{4,7,'Арестант',77385,'tt0368588',2003},
				{5,5,'Опер',77387,'tt0368590',2003},
				{6,7,'Журналист',77386,'tt0368591',2003},
				{7,12,'Передел',426306,'tt5031866',2005},
				{8,12,'Терминал',426309,'tt4791006',2006},
				{9,12,'Голландский Пассаж',420337,'tt4810954',2006},
				{10,12,'Расплата',426310,'tt4786988',2007},
				}

			for i=1,#t3 do
				if t3[tonumber(i)][4] == tonumber(kpid) then
					title = 'Бандитский Петербург. ' .. t3[tonumber(i)][3] .. ' (Серия ' .. episode .. ')'
					year = t3[tonumber(i)][6]
					break end
				end

			m_simpleTV.User.TMDB.Id = 64281
			m_simpleTV.User.TMDB.tv = 1
			m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TMDB.Id .. ',' .. m_simpleTV.User.TMDB.tv
			if not m_simpleTV.User.TVPortal then
				m_simpleTV.User.TVPortal = {}
			end
			if not m_simpleTV.User.TVPortal.get then
				m_simpleTV.User.TVPortal.get = {}
			end
			if not m_simpleTV.User.TVPortal.get.TMDB then
				m_simpleTV.User.TVPortal.get.TMDB = {}
			end
			if not m_simpleTV.User.TVPortal.cor then
				m_simpleTV.User.TVPortal.cor = {}
			end
			m_simpleTV.User.filmix.CurAddress = nil
			m_simpleTV.User.rezka.CurAddress = nil
			m_simpleTV.User.TVPortal.get.TMDB.Id = 64281
			m_simpleTV.User.TVPortal.get.TMDB.tv = 1
			info_fox('Бандитский Петербург',2000,'')
		else
			title = title .. ' (Сезон ' .. season .. ', Эпизод ' .. episode .. ')'
		end
	end
-------------------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc,answer = m_simpleTV.Http.Request(session,{url = inAdr})
-------------------------

	m_simpleTV.User.DB.titleTab = nil
	m_simpleTV.User.DB.isVideo = nil
	m_simpleTV.User.DB.zf_bal = nil
	m_simpleTV.Control.ChangeChannelLogo(logo or '', m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Control.CurrentTitle_UTF8 = (title or '') .. ', ' .. (year or '')
	m_simpleTV.Control.SetTitle((title or '') .. ', ' .. (year or ''))

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	local zf_b
	if kpid then
		zf_b = Get_ZF(kpid)
		if zf_b then
		if season then zf_b = zf_b .. '&s=' .. season end
		if episode then zf_b = zf_b .. '&e=' .. episode end
		m_simpleTV.User.DB.zf_bal = zf_b
		end
	end
	local retAdr,retAdr1
--	debug_in_file(answer .. '\n','c://1/ans_DB.txt')
	retAdr = answer
--	debug_in_file(inAdr .. '\n' .. tv .. '\n' .. retAdr .. '\n','c://1/FXX.txt')
		if not retAdr then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'DB: Медиаконтент не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			m_simpleTV.Control.ExecuteAction(11)
			return
		end
		if retAdr == '' then
			m_simpleTV.Control.ExecuteAction(102, 1)
			return
		end
		local t1,i,current_p = {},1,1
		local t2,j,current_ep = {},1,1
		local name, file, get_tr
		local is_perevod = false
		if not retAdr:match('%{"method":"play".-%}%}') and retAdr:match('"method":"link".-</div>') then
			local newAdr = retAdr:match('"url":"(.-)"')
			if season and not newAdr:match('&s=%d+') then newAdr = newAdr .. '&s=' .. season end
			rc,retAdr = m_simpleTV.Http.Request(session,{url = newAdr})
		end
--		debug_in_file(inAdr .. '\n' .. tv .. '\n' .. retAdr .. '\n','c://1/FXX.txt')
		if not retAdr:match('%{"method":"play".-%}%}') and retAdr:match('"method":"link".-</div>') then
			local newAdr = retAdr:match('"url":"(.-)"')
			if season and not newAdr:match('&s=%d+') then newAdr = newAdr .. '&s=' .. season end
			rc,retAdr = m_simpleTV.Http.Request(session,{url = newAdr})
		end
--		debug_in_file(inAdr .. '\n' .. tv .. '\n' .. retAdr .. '\n','c://1/FXX.txt')
		if retAdr:match('серия') or retAdr:match('эпизод') then
		tv = 1
		if not season or not episode then
			if not season then season = 1 end
			if not episode then episode = 1 end
			inAdr = inAdr:gsub('&s=%d+',''):gsub('&e=%d+',''):gsub('&sid=%d+','') .. '&s=' .. season .. '&sid=' .. tonumber(season)-1 .. '&e=' .. episode
		end
		else
		tv = 0
		end
		if tonumber(tv)==1 then
			for w in retAdr:gmatch('"method":"link".-</div>') do
--				debug_in_file(w .. '\n','c://1/ans_FX1.txt')
				file, name = w:match('"url":"(.-)".->(.-)</div>')
				if not name or not file then break end
--				debug_in_file(file .. '/' .. name .. '\n','c://1/ans_FX1.txt')
				t1[i]={}
				t1[i].Id = i
				t1[i].Address = file
				t1[i].Name = name
				if i == 1 and getConfigVal('perevod/db') and getConfigVal('perevod/db') == '' then 
				current_p = 1
				is_perevod = true
				setConfigVal('perevod/db',t1[1].Name)
				end
				if t1[i].Name and getConfigVal('perevod/db') and t1[i].Name:gsub('%-','') == getConfigVal('perevod/db'):gsub('%-','') then
				current_p = i
				is_perevod = true
				end
				i=i+1
			end
--			debug_in_file(t1[tonumber(current_p)].Address .. '\n','c://1/ans_FX3.txt')
			get_tr = retAdr:match('<div class="videos__button selector active".->(.-)</div>')
			if get_tr:gsub('%-','') ~= getConfigVal('perevod/db'):gsub('%-','') and is_perevod then
				m_simpleTV.Control.SetNewAddressT({address=t1[tonumber(current_p)].Address:gsub('&kinopoisk_id=%d+','') .. '&kinopoisk_id=' .. kpid .. '&e=' .. episode or 1, position = m_simpleTV.Control.GetPosition()})
				return
			end
			for w in retAdr:gmatch('%{"method":"play".-%}%}') do
--				debug_in_file(w .. '\n','c://1/ans_FX2.txt')
				name, file = w:match('"title":".-%((.-)%)".-"quality":(.-%})')
				if not name or not file then break end
--				debug_in_file(file .. '/' .. name .. '\n','c://1/ans_FX2.txt')
				t2[j]={}
				t2[j].Id = j
				t2[j].Address = file
				t2[j].Name = name:match('%d+')
				if tonumber(t2[j].Name) == tonumber(episode) then retAdr1 = t2[j].Address:gsub('&kinopoisk_id=%d+','') .. '&kinopoisk_id=' .. kpid end
				j=j+1
			end
		else
			for w in retAdr:gmatch('%{"method":"play".-%}%}') do
--				debug_in_file(w .. '\n','c://1/ans_DB1.txt')
				name, file = w:match('"title":".-%((.-)%)".-"quality":(.-%})')
				if not name or not file then break end
				t1[i]={}
				t1[i].Id = i
				t1[i].Address = file
				t1[i].Name = name
				if i == 1 and getConfigVal('perevod/db') and getConfigVal('perevod/db') == '' then 
				current_p = 1
				setConfigVal('perevod/db',t1[1].Name)
				end
				if getConfigVal('perevod/db') and t1[i].Name:gsub('%-','') == getConfigVal('perevod/db'):gsub('%-','') then current_p = i end
				i=i+1
			end
		end
		m_simpleTV.User.DB.TabPerevod = t1
	if i > 2 then
		if current_p then
		retAdr = t1[tonumber(current_p)].Address
		title = (title or '') .. ' - ' .. t1[tonumber(current_p)].Name

		else
	--		local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите озвучку - ' .. (title or ''), 0, t1, 5000, 1)
	--		id = id or 1
			retAdr = t1[1].Address:gsub('&kinopoisk_id=%d+','') .. '&kinopoisk_id=' .. kpid
			current_p = 1
			setConfigVal('perevod/db', t1[1].Name)
			title = (title or '') .. ' - ' .. t1[1].Name
		end
	elseif i == 2 then
		retAdr = t1[1].Address:gsub('&kinopoisk_id=%d+','') .. '&kinopoisk_id=' .. kpid
		current_p = 1
		setConfigVal('perevod/db', t1[1].Name)
		title = (title or '') .. ' - ' .. t1[1].Name
	else
		return
	end

	local t = {}
	if current_np then
		m_simpleTV.Control.CurrentTitle_UTF8 = (title or '') .. ', ' .. (year or '')
		m_simpleTV.Control.SetTitle((title or '') .. ', ' .. (year or ''))
	end

	if  tonumber(tv) == 0 then
		retAdr = GetDBAdr(retAdr)
	end
	if tonumber(tv) == 1	then

		t,current_ep = get_serial(kpid,season,episode)
--		debug_in_file(kpid .. ' ' .. season .. '/' .. episode .. ' - ' .. #t .. '/' .. current_ep .. '\n' .. retAdr1 .. '\n','c://1/ans_FX4.txt')
		if #t and #t==0 then
			for i = 1,#t2 do
				t[i] = {}
				t[i].Id = i
				t[i].Name = 'Сезон ' .. 1 .. ', Эпизод ' .. i
				t[i].Address = inAdr:gsub('&e=%s+','') .. '&e=' .. i
				if tonumber(episode) == i then current_ep = i end
				i=i+1
			end
		end
		m_simpleTV.User.DB.titleTab = t

		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_DB()'}
		if getConfigVal('perevod/db') ~= '' and m_simpleTV.User.DB.TabPerevod and #m_simpleTV.User.DB.TabPerevod > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_DB()'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8((title or ''), current_ep - 1, t, 10000, 32)
		
			if not retAdr1 then
				setConfigVal('perevod/db', '')
				m_simpleTV.Control.Restart()		
			end
			
		retAdr = retAdr1
		retAdr = GetDBAdr(retAdr)

		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = retAdr

	else
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title:gsub(' %- $','')
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_DB()'}
		if getConfigVal('perevod/db') ~= '' and m_simpleTV.User.DB.TabPerevod and #m_simpleTV.User.DB.TabPerevod > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_DB()'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8('DB: ' .. (title:gsub('^.- %- ','') or ''), 0, t, 8000, 32 + 64 + 128)
	end

	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.CurrentAddress = retAdr
--  debug_in_file(retAdr .. '\n')