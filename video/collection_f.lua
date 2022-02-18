-- видеоскрипт для воспроизведения коллекций из TMDb (23/11/21)
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
	return ''
	end
	require('json')
	answertm = answertm:gsub('(%[%])', '"nil"')
	local tab = json.decode(answertm)
	local id = tab.imdb_id or ''
	return id
	end

	local function getadr1(url)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return '' end
	require 'playerjs'
	local playerjs_url = answer:match('src="([^"]+/playerjsdev[^"]+)')
	answer = answer:match("file\'(:.-)return pub")
	answer = answer:gsub(": ",''):gsub("'#",'#'):gsub("'\n.-$",'')
	answer = playerjs.decode(answer, playerjs_url)
	local adr = answer:match('%[1080p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[720p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[480p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[360p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[240p%](https://stream%.voidboost%..-%.m3u8)') or ''
	return adr
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
	if not tab or not tab.parts or not tab.parts[1] or not tab.parts[1].id or not tab.parts[1].title
	then
	return '' end
	local title = tab.name
	local poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. tab.poster_path
	local t, i, j = {}, 1, 1
	while true do
	if not tab.parts[j] or not tab.parts[j].id
				then
				break
				end
	t[i]={}
	local id_media = tab.parts[j].id

	if imdb_id(id_media) and imdb_id(id_media) ~= '' and getadr1('https://voidboost.net/embed/' .. imdb_id(id_media)) and getadr1('https://voidboost.net/embed/' .. imdb_id(id_media)) ~= '' then

    local rus = tab.parts[j].title or ''
	local orig = tab.parts[j].original_title or ''
	local year = tab.parts[j].release_date or ''
	if year and year~= '' then
	year = year:match('%d%d%d%d')
	else year = '0' end

	local poster
	if tab.parts[j].backdrop_path and tab.parts[j].backdrop_path ~= 'null' then
	poster = tab.parts[j].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
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
	t[i].Address = getadr1('https://voidboost.net/embed/' .. imdb_id(id_media))
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

	m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 8000, 2 + 64)

	m_simpleTV.Control.SetTitle(title)
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, true)
	end

		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})

----------------------

-- debug_in_file(retAdr .. '\n')