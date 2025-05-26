-- видеоскрипт для балансера ashdi (15.12.24)
-- author west_side
	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if m_simpleTV.Control.CurrentAddress:match('^tmdb_id=')
	then return end
	if not m_simpleTV.Control.CurrentAddress:match('/lite/ashdi')
	then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.ashdi then
		m_simpleTV.User.ashdi = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	m_simpleTV.User.TMDB.Id = nil
	m_simpleTV.User.TMDB.tv = nil
	m_simpleTV.User.ashdi.CurAddress = inAdr
	m_simpleTV.User.ashdi.DelayedAddress = nil
	m_simpleTV.User.TVPortal.balanser = 'ASHDI'
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_np = getConfigVal('perevod/ashdi') or ''

	local function get_logo_yandex(kp_id)
	if not kpid then return end
		local url = 'https://st.kp.yandex.net/images/film_big/' .. kp_id .. '.jpg'
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then
			return false
		end
		m_simpleTV.Http.SetTimeout(session, 3000)
		m_simpleTV.Http.SetTLSProtocol(session, 'TLS1_1')
		m_simpleTV.Http.EnableLocalCache(session)
		local rc,answer = m_simpleTV.Http.Request(session,{url=url, writeinfile = true})
		m_simpleTV.Http.Close(session)
		return answer
	end

	local function get_serial(kpid,season,episode)
		if not kpid or tonumber(kpid) == 0 then return end
		local url_al = decode64('aHR0cHM6Ly9hcGkuYXBidWdhbGwub3JnLz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEma3A9') .. kpid
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then	return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local rc,answer = m_simpleTV.Http.Request(session,{url=url_al})
		m_simpleTV.Http.Close(session)
		if rc~=200 then return end
		require('json')
		answer = htmlEntities.decode(answer)
		answer = answer:gsub('\\\\\\/', '/')
		answer = answer:gsub('\\"', '"')
		answer = unescape3(answer)
		answer = answer:gsub('\\', '')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		local t,i,current_ep = {},1,1
		for w in answer:gmatch('"season":.-%}%}%}%}') do
			local s = w:match('"season":(%d+)')
			for v in w:gmatch('"episode":.-%}%}%}') do
				local e = v:match('"episode":(%d+)')
				t[i] = {}
				t[i].Id = i
				t[i].Name = 'Сезон ' .. s .. ', Эпизод ' .. e
				t[i].Address = decode64('aHR0cHM6Ly9hcGkubWFuaGFuLm9uZS9sYXRlL2FzaGRpP2tpbm9wb2lza19pZD0=') .. kpid .. '&s=' .. s .. '&e=' .. e
				if season == s and episode == e then current_ep = i end
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

	local function ashdiIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('ashdi_qlty') or 5000)
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

	local function GetAshdiAdr(session,url,sub)
		local subt = ''
		if sub and sub:match('http') then
			local s, j = {}, 1
			for w in sub:gmatch('http.-%.vtt') do
				s[j] = {}
				s[j] = w
				j = j + 1
			end
			subt = '$OPT:sub-track=0$OPT:input-slave=' .. table.concat(s, '#')
		end
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		local t = {}
			for w, adr in answer:gmatch('EXT%-X%-STREAM%-INF(.-)\n(.-)\n') do
				local qlty = w:match('RESOLUTION=%d+x(%d+)')
				if adr and qlty then
					t[#t + 1] = {}
					t[#t].Address = adr
					t[#t].qlty = tonumber(qlty)
				end
			end
			if #t == 0 then return end
			for _, v in pairs(t) do
				v.qlty = tonumber(v.qlty)
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 240 then
					v.qlty = 240
				elseif v.qlty > 240 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 480 then
					v.qlty = 480
				elseif v.qlty > 480 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1200 then
					v.qlty = 1080
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1444
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				else
					v.qlty = 4320
				end
				v.Name = v.qlty .. 'p'
			end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)

			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address .. '$OPT:NO-STIMESHIFT$OPT:demux=mp4,any' .. subt
			end
		m_simpleTV.User.ashdi.Tab = t
		local index = ashdiIndex(t)
	 return t[index].Address
	end

	function perevod_ashdi()
	local t = m_simpleTV.User.ashdi.TabPerevod
		if not t then return end
		if #t > 0 then
		local current_p = 1
		for i = 1,#t do
		if t[i].Name == getConfigVal('perevod/ashdi') then current_p = i end
		i = i + 1
		end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ashdi()'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(' 🔊 Перевод ', current_p - 1, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
			setConfigVal('perevod/ashdi', t[id].Name)
			local episode = m_simpleTV.User.ashdi.CurAddress:match('&e=(%d+)')
			if episode then episode = '&e=' .. episode else episode = '' end
			m_simpleTV.Control.SetNewAddress(t[id].Address .. episode, m_simpleTV.Control.GetPosition())
			end
			if ret == 3 then
				Qlty_ashdi()
			end
		end
	end

	function Qlty_ashdi()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.ashdi.Tab
			if not t then return end
		local index = ashdiIndex(t)
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Кинопоиск ', ButtonScript = ''}
			if getConfigVal('perevod/ashdi') ~= '' and m_simpleTV.User.ashdi.TabPerevod and #m_simpleTV.User.ashdi.TabPerevod>1 then
				t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_ashdi()'}
			end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 8 + 2)
		if m_simpleTV.User.ashdi.isVideo == false then
			if m_simpleTV.User.ashdi.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('ashdi_qlty', t[id].qlty)
		end
		if ret == 2 then
			setConfigVal('search/media',m_simpleTV.User.ashdi.kpid)
			add_to_history_of_search()
			search_media()
--			m_simpleTV.Control.SetNewAddress('**' .. m_simpleTV.User.ashdi.kpid, m_simpleTV.Control.GetPosition())
		end
		if ret == 3 then
			perevod_ashdi()
		end
	end

	local kpid = inAdr:match('kinopoisk_id=(%d+)')
	m_simpleTV.User.ashdi.kpid = kpid
	local id_imdb,title_v,year_v,tv
--	id_imdb = inAdr:match('kp%=(tt%d+)')
	local season,episode=m_simpleTV.User.ashdi.CurAddress:match('&s=(%d+).-&e=(%d+)')

	local logo, title, year, overview, tmdbid, tv
	if kpid then
		id_imdb,title_v,year_v,tv = imdbid(kpid)
--		debug_in_file(tv .. ' / ' .. id_imdb .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer_al.txt')
	end
	if id_imdb and id_imdb~= '' and bg_imdb_id(id_imdb)~= '' then
		logo, title, year, overview, tmdbid, tv = bg_imdb_id(id_imdb)
		if tv == 1 then
			if not season or not episode then
				if not season then season = 1 end
				if not episode then episode = 1 end
				inAdr = inAdr:gsub('&s=%d+',''):gsub('&e=%d+','') .. '&s=' .. season .. '&e=' .. episode
				m_simpleTV.Control.PlayAddressT({address=inAdr})
				return
			end
			title = title .. ' (Сезон ' .. season .. ', Эпизод ' .. episode .. ')'
		end
	else
		logo = get_logo_yandex(kpid)
--		id_imdb,title_v,year_v,tv = imdbid(kpid)
		title = title_v
		year = year_v
	end

-------------------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc,answer = m_simpleTV.Http.Request(session,{url = inAdr})
--	debug_in_file(answer .. '\n','c://1/ans_ashdi1.txt')

-------------------------

	m_simpleTV.User.ashdi.titleTab = nil
	m_simpleTV.User.ashdi.isVideo = nil
	m_simpleTV.Control.ChangeChannelLogo(logo or '', m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Control.CurrentTitle_UTF8 = (title or '') .. ', ' .. (year or '')
	m_simpleTV.Control.SetTitle((title or '') .. ', ' .. (year or ''))

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	local retAdr,retAdr1,retAdr2
	
	retAdr = unescape3(answer)
--	debug_in_file(retAdr .. '\n','c://1/ans_ashdi.txt')
		if not retAdr then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'ashdi: Медиаконтент не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			m_simpleTV.Control.ExecuteAction(11)
			return
		end
		if retAdr == '' then
			m_simpleTV.Control.ExecuteAction(102, 1)
			return
		end
		local t1,i,current_p = {},1,1
		local t2,j,current_ep = {},1,1
--		local name, file, sub, get_tr
		local is_perevod = false
		if tv==1 then
			for w in retAdr:gmatch('"method":"link".-</div>') do
--				debug_in_file(w .. '\n','c://1/ans_ashdi1.txt')
				local file, name = w:match('"url":"(.-)".->(.-)</div>')
				if not name or not file then break end
				t1[i]={}
				t1[i].Id = i
				t1[i].Address = file
				t1[i].Name = name
				if t1[i].Name == getConfigVal('perevod/ashdi') then
				current_p = i
				is_perevod = true
				end
				i=i+1
			end
			local get_tr = retAdr:match('<div class="videos__button selector active".->(.-)</div>')
			if get_tr ~= getConfigVal('perevod/ashdi') and is_perevod then
				m_simpleTV.Control.SetNewAddressT({address=t1[tonumber(current_p)].Address .. '&e=' .. episode, position = m_simpleTV.Control.GetPosition()})
				return
			end
			for w in retAdr:gmatch('\'%{"method":"play".-%}\'') do
--				debug_in_file(w .. '\n','c://1/ans_ashdi1.txt')
				local file, name, sub = w:match('\'%{"method":"play".-"url":"(.-)".-"title":" %((.-)%)"')
				if not name or not file then break end
				sub = w:match('"subtitles": %[(.-)%]')
				t2[j]={}
				t2[j].Id = j
				t2[j].Address = file
				t2[j].Name = name:match('%d+')
				t2[j].Sub = sub or ''
				if t2[j].Name == episode then
					retAdr1 = t2[j].Address
					retAdr2 = t2[j].Sub
				end
				j=j+1
			end
		else
			for w in retAdr:gmatch('\'%{"method":"play".-%}\'') do
--				debug_in_file(w .. '\n','c://1/ans_ashdi1.txt')
				local file, name, sub = w:match('\'%{"method":"play".-"url":"(.-)".-"title":" %((.-)%)"')
				if not name or not file then break end
				sub = w:match('"subtitles": %[(.-)%]')
				t1[i]={}
				t1[i].Id = i
				t1[i].Address = file
				t1[i].Name = name
				t1[i].Sub = sub or ''
				if t1[i].Name == getConfigVal('perevod/ashdi') then current_p = i end
--				debug_in_file(i .. ' ' .. name .. ' ' .. file .. ' ' .. sub .. '\n','c://1/ans_ashdi1.txt')
				i=i+1
			end
		end
		m_simpleTV.User.ashdi.TabPerevod = t1
	if i > 2 then
		if current_p then
		retAdr = t1[current_p].Address
		retAdr2 = t1[current_p].Sub
		title = (title or '') .. ' - ' .. t1[current_p].Name

		else
	--		local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите озвучку - ' .. (title or ''), 0, t1, 5000, 1)
	--		id = id or 1
			retAdr = t1[1].Address
			retAdr2 = t1[1].Sub
			current_p = 1
			setConfigVal('perevod/ashdi', t1[1].Name)
			title = (title or '') .. ' - ' .. t1[1].Name
		end
	elseif i == 2 then
		retAdr = t1[1].Address
		retAdr2 = t1[1].Sub
		current_p = 1
		setConfigVal('perevod/ashdi', t1[1].Name)
		title = (title or '') .. ' - ' .. t1[1].Name
	else
		return
	end

	local t = {}
	if current_np then
		m_simpleTV.Control.CurrentTitle_UTF8 = (title or '') .. ', ' .. (year or '')
		m_simpleTV.Control.SetTitle((title or '') .. ', ' .. (year or ''))
	end

	if  tv == 0 then
		retAdr = GetAshdiAdr(session,retAdr,retAdr2)
	end
	if tv == 1	then

		t,current_ep = get_serial(kpid,season,episode)
		m_simpleTV.User.ashdi.titleTab = t

		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ashdi()'}
		if getConfigVal('perevod/ashdi') ~= '' and m_simpleTV.User.ashdi.TabPerevod and #m_simpleTV.User.ashdi.TabPerevod>1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_ashdi()'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8((title or ''), current_ep - 1, t, 10000, 32)
		retAdr = retAdr1
		retAdr = GetAshdiAdr(session,retAdr,retAdr2)
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = retAdr
		return
	else
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title:gsub(' %- ' .. current_np,'')
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ashdi()'}
		if getConfigVal('perevod/ashdi') ~= '' and m_simpleTV.User.ashdi.TabPerevod and #m_simpleTV.User.ashdi.TabPerevod>1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_ashdi()'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8('ASHDI: ' .. getConfigVal('perevod/ashdi'), 0, t, 8000, 32 + 64 + 128)
	end

	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.CurrentAddress = retAdr
-- debug_in_file(retAdr .. '\n')