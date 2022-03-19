-- видеоскрипт для сайта https://hdi.zetflix.online/ (10/02/22)
-- west_side
-- открывает подобные ссылки:
-- https://hdi.zetflix.online/iplayer/videodb.php?kp=300
-- ##
	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if not m_simpleTV.Control.CurrentAddress:match('^https?://hdi%.zetflix%.online') then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.ZF then
		m_simpleTV.User.ZF = {}
	end
	m_simpleTV.User.ZF.CurAddress = inAdr
	m_simpleTV.User.ZF.DelayedAddress = nil
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_np = getConfigVal('perevod/zf') or ''
	local ua = 'Mozilla/5.0 (Windows NT 10.0; rv:97.0) Gecko/20100101 Firefox/97.0'
	local session = m_simpleTV.Http.New(ua)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)
	local function imdbid(kpid)
	local tv = 0
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJmtpbm9wb2lza19pZD0=') .. kpid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		return '','','',0
		end
		require('json')
		answer_vn = answer_vn:gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].type and tab_vn.data[1].type == 'serial' then tv = 1 end
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id and tab_vn.data[1].imdb_id ~= 'null' and tab_vn.data[1].year then
		return tab_vn.data[1].imdb_id or '', tab_vn.data[1].title or '',tab_vn.data[1].year:match('%d%d%d%d') or '', tv
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and ( not tab_vn.data[1].imdb_id or tab_vn.data[1].imdb_id ~= 'null') then
		return '', tab_vn.data[1].title or '',tab_vn.data[1].year:match('%d%d%d%d') or '', tv
		else return '','','',0
		end
	end
	local function bg_imdb_id(imdb_id)
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
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path and not tab.movie_results[1].poster_path
	and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path and not tab.tv_results[1].poster_path
	then return '', '', '', '', '', ''
	else
	if tab.movie_results[1] then
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
	return background, name_tmdb, year_tmdb, overview_tmdb, tmdb_id, tv
	end
	local function tmdb_tv(tmdbid,inAdr)
	local urls = 'https://api.themoviedb.org/3/tv/' .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
	local rc6,answers = m_simpleTV.Http.Request(session,{url=urls})
	if rc6~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answers = answers:gsub('(%[%])', '"nil"')
	local tab = json.decode(answers)
	if tab and tab.seasons and tab.seasons[1] and tab.seasons[1].episode_count and tab.seasons[1].season_number
	then
	local t, j, i = {}, 1, 1
	while true do
	if not tab.seasons[j]
				then
				break
				end
	for	k = 1,tab.seasons[j].episode_count do
	t[i]={}
	t[i].Id = k
	t[i].Name = tab.seasons[j].name .. ', Эпизод ' .. k
	t[i].Address = inAdr:gsub('&season=.-$','') .. '&season=' .. tab.seasons[j].season_number .. '&episode=' .. k
	i=i+1
	k=k+1
	end
	j=j+1
	end
	return t
	end
	end
	local kpid = inAdr:match('kp%=(%d+)')
	m_simpleTV.User.ZF.kpid = kpid
	local season,episode=m_simpleTV.User.ZF.CurAddress:match('season=(%d+).-episode=(%d+)')
	local logo, title, year, overview, tmdbid, tv
	local id_imdb,title_v,year_v,tv = imdbid(kpid)
	if id_imdb and id_imdb~= '' and bg_imdb_id(id_imdb)~= ''	then
	logo, title, year, overview, tmdbid, tv = bg_imdb_id(imdbid(kpid))
	if tv == 1 then
	if not season or not episode then
	if not season then season = 1 end
	if not episode then episode = 1 end
	inAdr = inAdr:gsub('%&.-$','') .. '&season=' .. season .. '&episode=' .. episode
	m_simpleTV.Control.PlayAddress(inAdr)
	return
	end
	title = title .. ' (Сезон ' .. season .. ', Серия ' .. episode .. ')'
	end
	else
	logo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. kpid .. '.jpg'
	title = title_v
	year = year_v
	end
	rc,answer = m_simpleTV.Http.Request(session,{url = inAdr, method = 'get', headers = 'User-agent: ' .. ua .. '\nReferer: https://hdi.zetflix.online/iplayer/player.php'})
		if rc ~= 200 then return end
	local function ZFIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('zf_qlty') or 5000)
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
	local function GetZFAdr(urls)
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
			for qlty, adr in urls:gmatch('%[(.-)%](http.-%.mp4)') do
			if not qlty:match('%d+') then break end
				t[i] = {}
				t[i].Address = adr
				t[i].Name = qlty
				t[i].qlty = tonumber(qlty:match('%d+'))
				i = i + 1
			end
			if i == 1 then return end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address:gsub('^https://', 'http://') .. '$OPT:NO-STIMESHIFT$OPT:demux=mp4,any' .. (subt or '')
				t[i].qlty = tonumber(t[i].Name:match('%d+'))
			end
		m_simpleTV.User.ZF.Tab = t
		local index = ZFIndex(t)
	 return t[index].Address
	end
	function perevod_ZF()
	local t = m_simpleTV.User.ZF.TabPerevod
		if not t then return end
		if #t > 0 then
		local current_p = 1
		for i = 1,#t do
		if t[i].Name == getConfigVal('perevod/zf') then current_p = i end
		i = i + 1
		end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ZF()'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(' 🔊 Перевод ', current_p - 1, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
			setConfigVal('perevod/zf', t[id].Name)
			m_simpleTV.Control.SetNewAddress(m_simpleTV.User.ZF.CurAddress, m_simpleTV.Control.GetPosition())
			end
			if ret == 3 then
				Qlty_ZF()
			end
		end
	end
	function Qlty_ZF()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.ZF.Tab
			if not t then return end
		local index = ZFIndex(t)
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Кинопоиск ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 2)
		if m_simpleTV.User.ZF.isVideo == false then
			if m_simpleTV.User.ZF.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('zf_qlty', t[id].qlty)
		end
		if ret == 2 then
			m_simpleTV.Control.SetNewAddress('**' .. m_simpleTV.User.ZF.kpid, m_simpleTV.Control.GetPosition())
		end
	end
	m_simpleTV.User.ZF.titleTab = nil
	m_simpleTV.User.ZF.isVideo = nil
	m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Control.CurrentTitle_UTF8 = title .. ', ' .. year
	m_simpleTV.Control.SetTitle(title .. ', ' .. year)
	local poster = answer:match('poster: "(.-)"')
	if poster and poster == '' then poster = logo end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster or logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	local retAdr
	retAdr = answer:match('file:"(.-)"')
	if retAdr then setConfigVal('perevod/zf', '') end
		if not retAdr then
		retAdr = answer:match('file:%[(.-)%]%}')
		if retAdr == '' then m_simpleTV.Control.ExecuteAction(102, 1) return end
		local t1,i,current_p = {},1
		for w in retAdr:gmatch('%{.-%}') do
		local name,file = w:match('"title": "(.-)".-"file":.-"(.-)"')
		if not name or not file then break end
		t1[i]={}
		t1[i].Id = i
		t1[i].Address = file
		t1[i].Name = name
		if t1[i].Name == getConfigVal('perevod/zf') then current_p = i end
		i=i+1
		end
		m_simpleTV.User.ZF.TabPerevod = t1
	if i > 2 then
	if current_p then
	retAdr = t1[current_p].Address
	title = title .. ' - ' .. t1[current_p].Name
	else
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите озвучку - ' .. title, 0, t1, 5000, 1)
		id = id or 1
		retAdr = t1[id].Address
		current_p = id
		setConfigVal('perevod/zf', t1[id].Name)
		title = title .. ' - ' .. t1[id].Name
	end
	elseif i == 2 then
		retAdr = t1[1].Address
		current_p = 1
		setConfigVal('perevod/zf', t1[1].Name)
		title = title .. ' - ' .. t1[1].Name
	else return
	end
		end
	local t = {}
	if current_np then
	m_simpleTV.Control.CurrentTitle_UTF8 = title .. ', ' .. year
	m_simpleTV.Control.SetTitle(title .. ', ' .. year)
	end
	if imdb or (not imdb and tv~=1) then
	retAdr = GetZFAdr(retAdr)
	end
	if tv == 1	then
	local current_ep = 1
	if tmdbid then
	local urls = 'https://api.themoviedb.org/3/tv/' .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
	local rc6,answers = m_simpleTV.Http.Request(session,{url=urls})
	if rc6~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answers = answers:gsub('(%[%])', '"nil"')
	local tab = json.decode(answers)
	if tab and tab.seasons and tab.seasons[1] and tab.seasons[1].episode_count and tab.seasons[1].season_number
	then
	local j, i = 1, 1
	while true do
	if not tab.seasons[j]
				then
				break
				end
	for	k = 1,tab.seasons[j].episode_count do
	if tonumber(tab.seasons[j].season_number) == tonumber(season) and k == tonumber(episode) then current_ep = i end
	t[i]={}
	t[i].Id = i
	t[i].Address = inAdr:gsub('%&season=.-$','') .. '&season=' .. tonumber(tab.seasons[j].season_number) .. '&episode=' .. k
	t[i].Name = tab.seasons[j].name .. ', Эпизод ' .. k
	i=i+1
	k=k+1
	end
	j=j+1
	end
	end
	else
	local t1,i = {},1
	local answer1 = answer:match('file:%[(.-)%,%]')
	for w in answer1:gmatch('%[%{"comment":.-%}') do
	local name,adr = w:match('"comment":"(.-)"%,"file":"(.-)"')
	if not name or not adr then break end
	t1[i]={}
	t1[i].Id = i
	t1[i].Address = GetZFAdr(adr)
	t1[i].Name = name
	i=i+1
	end

	for i = 1, #t1 do
		t[i]={}
		t[i].Address = t1[#t1-i+1].Address
		t[i].Name = t1[#t1-i+1].Name
		t[i].Id = #t1-i+1
	end
	retAdr = t[1].Address
	end
	m_simpleTV.User.ZF.titleTab = t
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ZF()'}
	if getConfigVal('perevod/zf') ~= '' then
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_ZF()'}
	end
	m_simpleTV.OSD.ShowSelect_UTF8('Сезоны: ' .. title, current_ep - 1, t, 10000, 32)
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAddress = retAdr
	return
	else
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title:gsub(' %- ' .. current_np,'')
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ZF()'}
			if getConfigVal('perevod/zf') ~= '' then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_ZF()'}
			end
			m_simpleTV.OSD.ShowSelect_UTF8('ZF: ' .. getConfigVal('perevod/zf'), 0, t, 8000, 32 + 64 + 128)
	end

	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.CurrentAddress = retAdr
-- debug_in_file(retAdr .. '\n')