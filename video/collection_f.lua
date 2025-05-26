-- видеоскрипт для воспроизведения коллекций из TMDb (23/01/25)
-- открывает подобные ссылки:
-- collection_tmdb=645
-- автор west_side
	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^collection_tmdb=%d+') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)

	local function imdb_id(tmdbid)
		local urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
		local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
		if rc3~=200 then
		m_simpleTV.Http.Close(session)
		return
		end
		require('json')
		answertm = answertm:gsub('(%[%])', '"nil"')
		local tab = json.decode(answertm)
		local id = tab.imdb_id or ''
		return id
	end

	local function getadr(imdb_id)
		local url = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEmaW1kYj0=') .. imdb_id
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
		return
		end
		local kp_id = answer:match('"id_kp":(%d+)')
		if imdb_id == 'tt0145487' then kp_id = 838 end
		if not kp_id or kp_id == 0 then
			url = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZmaWVsZD1pbWRiX2lkJnF1ZXJ5PQ==') .. imdb_id
			local rc,answer = m_simpleTV.Http.Request(session,{url=url})
			if rc~=200 then
				return
			end
			kp_id = answer:match('"kinopoisk_id":(%d+)')
			if not kp_id or kp_id == 0 then
				return
			end
		end
		url = decode64('aHR0cHM6Ly9oaWR4bGdsay5kZXBsb3kuY3gvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. kp_id
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 or rc==200 and not answer:match('"method":"play"') then
		m_simpleTV.Common.Sleep(1000)
		rc,answer = m_simpleTV.Http.Request(session,{url=url})
		end
		if rc~=200 or rc==200 and not answer:match('"method":"play"') then
		return
		end
		return answer:match('"url":"(.-)"'):gsub('%-v%d+%-a%d+%.m3u8','.mp4')
	end

	local tmdbcolid = inAdr:match('^collection_tmdb=(%d+)')
----------------------
	local urlt1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9jb2xsZWN0aW9uLw==') .. tmdbcolid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')
	local rc, answert1 = m_simpleTV.Http.Request(session, {url = urlt1})
	if rc~=200 then
	return ''
	end
	require('json')
	answert1 = answert1:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert1)
	if not tab or not tab.parts or not tab.parts[1] or not tab.parts[1].id or not tab.parts[1].title then
		return ''
	end
	local title = tab.name
	local poster
	if tab.poster_path then
		poster = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. tab.poster_path
	else
		poster = 'simpleTVImage:./luaScr/user/show_mi/no-img.png'
	end

--	m_simpleTV.Control.SetTitle(title)
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end

		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})

	local t1 = {}
	t1.BackColor = 0
	t1.BackColorEnd = 255
	t1.PictFileName = poster:gsub('w250_and_h141_face','original')
	t1.TypeBackColor = 0
	t1.UseLogo = 3
	t1.Once = 1
	t1.Blur = 0
	m_simpleTV.Interface.SetBackground(t1)

	local t, i, j = {}, 1, 1
	while true do
	if not tab.parts[j] or not tab.parts[j].id
				then
				break
				end

	local id_media = tab.parts[j].id

	if imdb_id(id_media) and imdb_id(id_media) ~= '' and getadr(imdb_id(id_media))
	then
	t[i]={}
    local rus = tab.parts[j].title or ''
	local orig = tab.parts[j].original_title or ''
	local year = tab.parts[j].release_date or ''
	if year and year~= '' then
	year = year:match('%d%d%d%d')
	else year = '0' end

	local poster
	if tab.parts[j].backdrop_path and tab.parts[j].backdrop_path ~= 'null' then
	poster = tab.parts[j].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w250_and_h141_face' .. poster
	elseif tab.parts[j].poster_path and tab.parts[j].poster_path ~= 'null' then
	poster = tab.parts[j].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end
	local overview = tab.parts[j].overview or ''
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].year = year
	t[i].InfoPanelLogo = poster
	t[i].Address = getadr(imdb_id(id_media))
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	i=i+1
	end
	m_simpleTV.OSD.ShowMessageT({text = 'Загрузка коллекции ' .. j
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})
	j=j+1
	end
----------------------
	if tonumber(tmdbcolid) == 10 then
	table.sort(t, function(a, b) return a.Name < b.Name end)
	for i = 1, #t do
		t[i].Id = i
	end
	else
	table.sort(t, function(a, b) return tostring(a.year) < tostring(b.year) end)
	for i = 1, #t do
		t[i].Id = i
	end
	end
	if t[1] and t[1].Address then m_simpleTV.Control.CurrentAddress = t[1].Address end
    t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 ', ButtonScript = 'collection_TMDb(\'' .. tonumber(tmdbcolid) ..'\')'}
	m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 8000, 2 + 64)
