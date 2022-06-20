-- скрапер TVS для загрузки плейлистов "CatCast" https://catcast.tv/ (15/02/2022)
-- необходим видоскрипт: catcast.lua


module('catcast_all_pls', package.seeall)
local my_src_name = 'CatCast all'

function GetSettings()
 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://catcast.tv/assets/no-logo.svg', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 1, show_progress = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 1}, STV = {add = 1, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoNumber = 1, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 0, TypeFind = 1, TypeMedia = 1}}
end

function GetVersion()
	return 2, 'UTF-8'
end

local function LoadFromSite(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0')
	if not session then return end
--[[	local t = {}
	t.url = 'https://api.catcast.tv/api/channels?online=true&sort_by=viewers&type=tv&page=all&count=480'
	t.method = 'get'
	t.headers = 'X-Timezone-Offset: -180\nReferer: https://catcast.tv/tv/online'
	local rc, answer = m_simpleTV.Http.Request(session, t)
	m_simpleTV.Http.SetTimeout(session, 300000)
	if rc ~= 200 then--]]
	local search = 'channels.json'
	local path = m_simpleTV.MainScriptDir .. 'user/TVSources/core/' .. search
	local file = io.open(path, 'r')
	if not file then
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="https://catcast.tv/assets/no-logo.svg"', text = ' необходимо скачать файл ' .. m_simpleTV.MainScriptDir .. 'user/TVSources/core/channels.json', color = ARGB(255, 127, 63, 255), showTime = 1000 * 30})
	answer = '' else
	answer = file:read('*a')
	file:close()
	end
	m_simpleTV.OSD.ShowMessageT({text = 'Базовый контент загружен'
								, color = ARGB(255, 127, 63, 255)
								, showTime = 1000 * 5
								, id = 'channelName'})
--	end
	m_simpleTV.Http.SetTimeout(session, 300000)
--	m_simpleTV.Http.Close(session)
	for j = 1,50 do 
	local t1 = {}
	t1.url = 'https://api.catcast.tv/api/channels?page=' .. j
	t1.method = 'get'
	t1.headers = 'X-Timezone-Offset: -180\nReferer: https://catcast.tv/tv/online'
	local rc, answer1 = m_simpleTV.Http.Request(session, t1)	
	if rc ~= 200 then
	answer1 = ''
	end
	answer = answer .. answer1
	m_simpleTV.OSD.ShowMessageT({text = 'Загрузка динамичного контента: ' .. j
								, color = ARGB(255, 127, 63, 255)
								, showTime = 1000 * 5
								, id = 'channelName'})	
	end
	answer = answer:gsub('%],"first_page_url":".-"data":%[', ',')
		-- debug_in_file(answer .. '\n')
	answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
	require 'json'
	local tab = json.decode(answer)
	if not tab.data.list.data then return end
	local t, i = {}, 1
	while tab.data.list.data[i] do
		t[i] = {}
		t[i].name = (unescape3(tab.data.list.data[i].name:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' '):gsub('u2605', '')
		t[i].id = tab.data.list.data[i].id
		t[i].video_desc = (unescape3(tab.data.list.data[i].description_text:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' ') .. ' id=' .. t[i].id
		t[i].address = 'https://catcast.tv/' .. unescape3(tab.data.list.data[i].shortname)
		t[i].logo = tab.data.list.data[i].background or tab.data.list.data[i].logo
		if tab.data.list.data[i].tags and tab.data.list.data[i].tags[1] then
		t[i].group = 'CastTV - other'
--		t[i].group = (unescape3(tab.data.list.data[i].tags[1]:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' ')
		local j, tags = 1, ''
		while true do
		if not (tab.data.list.data[i].tags and tab.data.list.data[i].tags[j]) then break end
		tags = tags .. ', ' .. (unescape3(tab.data.list.data[i].tags[j]:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' ')
		j=j+1
		end
		t[i].video_title = tags:gsub('^, ', ''):gsub(' , ', ', ')
		if t[i].video_title:match('СССР') or t[i].video_title:match('USSR') or t[i].video_title:match('ussr') or t[i].video_title:match('ссср')
		then t[i].group = 'CastTV - USSR' t[i].group_logo = '../Channel/Logo/CatCast/СССР.png'
		elseif t[i].video_title:match('мульт') or t[i].video_title:match('дети') or t[i].video_title:match('детям') or t[i].video_title:match('детское')
		then t[i].group = 'CastTV - cartoons' t[i].group_logo = '../Channel/Logo/CatCast/Мульты.png'
		elseif t[i].video_title:match('юмор') or t[i].video_title:match('прикол')
		then t[i].group = 'CastTV - humor't[i].group_logo = '../Channel/Logo/CatCast/Юмор.png'
		elseif t[i].video_title:match('музыка') or t[i].video_title:match('Музыка') or t[i].video_title:match('песня') or t[i].video_title:match('Песня') or t[i].video_title:match('шансон') or t[i].video_title:match('music') or t[i].video_title:match('MUSIC') or t[i].video_title:match('pop') or t[i].video_title:match('POP') or t[i].video_title:match('hit') or t[i].video_title:match('HIT') or t[i].video_title:match('Hit')
		then t[i].group = 'CastTV - music' t[i].group_logo = '../Channel/Logo/CatCast/Музыка.png'
		elseif t[i].video_title:match('сериал') or t[i].video_title:match('СЕРИАЛ') or t[i].video_title:match('Сериал')
		then t[i].group = 'CastTV - series' t[i].group_logo = '../Channel/Logo/CatCast/Сериал.png'
		elseif t[i].video_title:match('кино') or t[i].video_title:match('FILM') or t[i].video_title:match('film') or t[i].video_title:match('КИНО') or t[i].video_title:match('Фильм') or t[i].video_title:match('фильм') or t[i].video_title:match('ФИЛЬМ')
		then t[i].group = 'CastTV - films' t[i].group_logo = '../Channel/Logo/CatCast/Фильмы.png'
		elseif t[i].video_title:match('игры')
		then t[i].group = 'CastTV - games' t[i].group_logo = '../Channel/Logo/CatCast/Игры.png'
		elseif t[i].video_title:match('тв') or t[i].video_title:match('ТВ') or t[i].video_title:match('Телеканал')
		then t[i].group = 'CastTV - channels' t[i].group_logo = '../Channel/Logo/CatCast/Каналы.png'
		else t[i].group = 'CastTV - other' t[i].group_logo = '../Channel/Logo/CatCast/Другие.png' end
		else t[i].group = 'CastTV' t[i].group_logo = '../Channel/Logo/CatCast/Несортированные.png' t[i].video_title = 'CastTV'
		end
		i = i + 1
	end

	if i == 1 then return end
		local hash, t0 = {}, {}
		for i = 1, #t do
			if not hash[t[i].address]
			then
				t0[#t0 + 1] = t[i]
				hash[t[i].address] = true
			end
		end
	return t0
end

function GetList(UpdateID, m3u_file)
	if not UpdateID then return end
	if not m3u_file then return end
	if not TVSources_var.tmp.source[UpdateID] then return end
	local Source = TVSources_var.tmp.source[UpdateID]
	local t_pls = LoadFromSite()
	if not t_pls then
	m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста'
								, color = ARGB(255, 255, 100, 0)
								, showTime = 1000 * 5
								, id = 'channelName'})
		return
	end

	local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
	local handle = io.open(m3u_file, 'w+')
	if not handle then return end
	handle:write(m3ustr)
	handle:close()
	return 'ok'
end
-- debug_in_file(#t_pls .. '\n')