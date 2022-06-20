
	module('baskino_top_pls', package.seeall)
	local my_src_name = 'BASKINO'

	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'http://baskino.me/templates/Baskino/images/logo.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function imdbid(kpid)
	local url_vn = decode64('aHR0cHM6Ly9jZG5tb3ZpZXMubmV0L2FwaT90b2tlbj0wNTU5ZjA3MmYxZTA5ODJlYmZhMzRjZTIwN2Y5ZTJiOCZraW5vcG9pc2tfaWQ9') .. kpid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		return ''
		end
		require('json')
		answer_vn = answer_vn:gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id and tab_vn.data[1].imdb_id ~= 'null' then
		return tab_vn.data[1].imdb_id
		else
		return ''
		end
	end

local function bg_imdb_id(imdb_id)
local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answerd = answerd:gsub('(%[%])', '"nil"')
local tab = json.decode(answerd)
local background = ''
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then background = '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	poster = tab.movie_results[1].poster_path or ''
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	poster = tab.tv_results[1].poster_path or ''
	end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if poster and poster ~= '' then poster = 'http://image.tmdb.org/t/p/original' .. poster end
	if poster and poster ~= '' and background == '' then background = poster end
    end
	if background == nil then background = '' end
	return background
end

	local function getadr1(url)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
	require 'playerjs'
	local playerjs_url = answer:match('src="([^"]+/playerjsdev[^"]+)')
	answer = answer:match("file\'(:.-)return pub")
	answer = answer:gsub(": ",''):gsub("'#",'#'):gsub("'\n.-$",'')
	answer = playerjs.decode(answer, playerjs_url)
	adr = answer:match('%[1080p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[720p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[480p%](https://stream%.voidboost%..-%.m3u8)') or answer:match('%[360p%](https://stream%.voidboost%..-%.m3u8)') or url
	return adr
	end

	local function getadr(url)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
	adr = answer:match('data%-sign="vb" data%-url="(.-)"') or url
	name = answer:gsub('\n',''):match('<h1>(.-)</h1>') or ''
	logo = adr:match('embed/(tt%d+)%,')
	if logo then logo = bg_imdb_id(logo)
	elseif adr:match('embed/(%d+)') then
	if imdbid(adr:match('embed/(%d+)')) ~= '' then
	logo = bg_imdb_id(imdbid(adr:match('embed/(%d+)'))) else logo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. adr:match('embed/(%d+)') .. '.jpg' or '' end
--	logo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. adr:match('embed/(%d+)%,') .. '.jpg'
	else
	logo = '' end
	adr = getadr1(adr)

	return adr, name, logo
	end

	local function LoadFromSite()

		local url = 'http://baskino.me/top'

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36')
			if not session then return end

		m_simpleTV.Http.SetTimeout(session, 30000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end

		answer = answer:match('<ul class="content_list_top">(.-)</ul>')
		local t, i = {}, 1
			for w in answer:gmatch('<li>.-</li>') do
			local adr, name, year = w:match('<a href="(.-)".-<s>(.-)</s>.-<em>(.-)</em>')
					if not adr or not name then break end
				t[i] = {}
if adr:match('/films/boevie%-iskustva/') then t[i].group = 'Боевые искусства' end
if adr:match('/films/biograficheskie/') then t[i].group = 'Биографические' end
if adr:match('/films/boeviki/') then t[i].group = 'Боевики' end
if adr:match('/films/vesterny/') then t[i].group = 'Вестерны' end
if adr:match('/films/voennye/') then t[i].group = 'Военные' end
if adr:match('/films/detektivy/') then t[i].group = 'Детективы' end
if adr:match('/films/dramy/') then t[i].group = 'Драмы' end
if adr:match('/films/istoricheskie/') then t[i].group = 'Исторические' end
if adr:match('/films/komedii/') then t[i].group = 'Комедии' end
if adr:match('/films/kriminalnye/') then t[i].group = 'Криминальные' end
if adr:match('/films/melodramy/') then t[i].group = 'Мелодрамы' end
if adr:match('/films/multfilmy/') then t[i].group = 'Мультфильмы' end
if adr:match('/films/myuzikly/') then t[i].group = 'Мюзиклы' end
if adr:match('/films/priklyuchencheskie/') then t[i].group = 'Приключенческие' end
if adr:match('/films/russkie/') then t[i].group = 'Русские' end
if adr:match('/films/semeynye/') then t[i].group = 'Семейные' end
if adr:match('/films/sportivnye/') then t[i].group = 'Спортивные' end
if adr:match('/films/trillery/') then t[i].group = 'Триллеры' end
if adr:match('/films/uzhasy/') then t[i].group = 'Ужасы' end
if adr:match('/films/fantasticheskie/') then t[i].group = 'Фантастические' end

				t[i].address, t[i].name, t[i].logo =  getadr(adr)

				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.0" src="' .. t[i].logo .. '"', text = i .. '. ' .. t[i].name
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 50
									, id = 'channelName'})
				i = i + 1
			end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end

		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')'
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})

		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')