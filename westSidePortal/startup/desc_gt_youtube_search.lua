-- Youtube desc for mediaportal
-- author: west_side 15.05.25
-- необходим
-- видеоскрипт для сайта https://www.youtube.com
-- Copyright © 2017-2024 Nexterr | https://github.com/Nexterr-origin/simpleTV-YouTube
--------------------------------------------------

local function ARGB(A,R,G,B)
   local a = A*256*256*256+R*256*256+G*256+B
   if A<128 then return a end
   return a - 4294967296
end

local function Get_rating(rating)
	if rating == nil or rating == '' then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end
htmlEntities = require 'htmlEntities'
	--nexterr code---
local function unescape_html(str)
 return htmlEntities.decode(str)
end
	--nexterr code---
local function title_clean(s)
	s = s:gsub('%c', ' ')
	s = s:gsub('%%22', '"')
	s = s:gsub('\\t', ' ')
	s = s:gsub('\\\\u', '\\u')
	s = s:gsub('\\u0026', '&')
	s = s:gsub('\\u2060', '')
	s = s:gsub('\\u200%a', '')
	s = s:gsub('\\u0027', '`')
	s = unescape_html(s)
	s = s:gsub('%s+', ' ')
	s = s:gsub('\\', '\\')
 return s
end
	--nexterr code---
local function desc_clean(d)
	d = d:gsub('%%22', '"')
	d = d:gsub('\\u200%a', '')
	d = d:gsub('\\u202%a', '')
	d = d:gsub('\\u00ad', '')
	d = d:gsub('\\r', '')
	d = d:gsub('\r', '')
	d = d:gsub('\\n', '\n')
	d = d:gsub('\n\n[\n]+', '\n\n')
	d = unescape3(d)
	d = unescape_html(d)
	d = d:gsub('\\', '\\')
 return d
end

local function get_info_for_channel(ch_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&type=channel&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	local name,desc,logo = answer:match('"title": "(.-)".-"description": "(.-)".-"medium".-"url": "(.-)"')
	return name,desc,logo
end

local function get_info_for_online_channel(ch_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&eventType=live&maxResults=28&type=video&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_youtube_online_count = tab.pageInfo.totalResults
end

local function get_info_for_playlist_channel(ch_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=' .. ch_id .. '&maxResults=28&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_youtube_playlist_count = tab.pageInfo.totalResults
end

local function get_info_for_video_channel(ch_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&order=date&maxResults=28&type=video&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_youtube_video_count = tab.pageInfo.totalResults
end

function get_online_for_channel(ch_id)
	if ch_id:match('BANNER2') then ch_id = m_simpleTV.User.TVPortal.stena_youtube_get_channelID
	elseif ch_id:match('YOUTUBE_STENA_') then ch_id = m_simpleTV.User.TVPortal.stena_youtube_channelID end
	if pageToken == '' then
		m_simpleTV.User.TVPortal.stena_youtube_channel_name, m_simpleTV.User.TVPortal.stena_youtube_channel_desc, m_simpleTV.User.TVPortal.stena_youtube_channel_logo = get_info_for_channel(ch_id)
		get_info_for_playlist_channel(ch_id)
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&eventType=live&maxResults=28&type=video&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_youtube_online_count = tab.pageInfo.totalResults
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'online'
	m_simpleTV.User.TVPortal.stena_youtube_channelID = ch_id
	local t, i = {}, 1

	while true do
		if not tab.items[i] then break end
		t[i] = {}
		t[i].Name = title_clean(tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&'))
		t[i].Address = 'https://www.youtube.com/watch?v=' .. tab.items[i].id.videoId
		t[i].InfoPanelLogo = tab.items[i].snippet.thumbnails.medium.url
		t[i].InfoPanelName = tab.items[i].snippet.channelTitle .. ' | ' .. title_clean(tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&'))
		t[i].InfoPanelTitle = tab.items[i].snippet.description:gsub('%-%-',''):gsub('%=%=',''):gsub('__','')
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_search_youtube = t

		m_simpleTV.User.TVPortal.stena_search_youtube_title = 'Youtube online'

		m_simpleTV.User.TVPortal.stena_youtube_next = nil
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil


	if stena_search_youtube_content then return stena_search_youtube_content() end
end

function get_video_for_channel(ch_id, pageToken)
	if ch_id:match('BANNER2') then ch_id = m_simpleTV.User.TVPortal.stena_youtube_get_channelID pageToken = ''
	elseif ch_id:match('YOUTUBE_STENA_') then ch_id = m_simpleTV.User.TVPortal.stena_youtube_channelID pageToken = '' end
	if pageToken == '' then
		m_simpleTV.User.TVPortal.stena_youtube_channel_name, m_simpleTV.User.TVPortal.stena_youtube_channel_desc, m_simpleTV.User.TVPortal.stena_youtube_channel_logo = get_info_for_channel(ch_id)
		get_info_for_playlist_channel(ch_id)
		get_info_for_online_channel(ch_id)
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&order=date&maxResults=28&type=video&key=' .. m_simpleTV.User.YT.apiKey .. '&pageToken=' .. pageToken
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'video'
	m_simpleTV.User.TVPortal.stena_youtube_channelID = ch_id
	local t, i = {}, 1
	local prev_pg = tab.prevPageToken
	local next_pg = tab.nextPageToken
	local all = tab.pageInfo.totalResults
	local all_pg = math.ceil(tonumber(all)/28)
	m_simpleTV.User.TVPortal.stena_youtube_video_count = tab.pageInfo.totalResults
	if tonumber(all_pg) == 0 then all_pg = 1 end
	while true do
		if not tab.items[i] then break end
		t[i] = {}
		t[i].Name = title_clean(tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&'))
		t[i].Address = 'https://www.youtube.com/watch?v=' .. tab.items[i].id.videoId
		t[i].InfoPanelLogo = tab.items[i].snippet.thumbnails.medium.url
		t[i].InfoPanelName = tab.items[i].snippet.channelTitle .. ' | ' .. title_clean(tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&'))
		t[i].InfoPanelTitle = tab.items[i].snippet.description:gsub('%-%-',''):gsub('%=%=',''):gsub('__','')
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_search_youtube = t

		if prev_pg == nil then m_simpleTV.User.TVPortal.stena_search_youtube_page = 1 end
		m_simpleTV.User.TVPortal.stena_search_youtube_title = 'Youtube video: стр. ' .. m_simpleTV.User.TVPortal.stena_search_youtube_page .. ' из ' .. all_pg
		if next_pg then
		m_simpleTV.User.TVPortal.stena_youtube_next = {ch_id, next_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_next = nil
		end
		if prev_pg then
		m_simpleTV.User.TVPortal.stena_youtube_prev = {ch_id, prev_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil
		end

	if stena_search_youtube_content then return stena_search_youtube_content() end
end

function get_video_jam(id_cur)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	if id_cur and id_cur ~= '' and id_cur:match('^RD') then
		id_cur = id_cur:match('RD(.-)$')
	else
		id_cur = (m_simpleTV.User.TVPortal.stena_search_youtube_current .. '&'):match('/watch%?v=(.-)%&')
	end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://www.youtube.com/watch?v=' .. id_cur .. '&list=RD' .. id_cur

	m_simpleTV.Http.SetCookies(session, url, m_simpleTV.User.YT.cookies, '')
	local ss, sss = m_simpleTV.Http.Request(session, {url = url, method = 'get'})
	m_simpleTV.Http.Close(session)
	if ss ~= 200 then return end
	sss = sss:gsub('\\n',' ')
	local t,i={},0
	for w in sss:gmatch('"playlistPanelVideoRenderer".-"shortBylineText"') do
		local title, ch_name, ch_id, logo, all_time, video_id = w:match('"simpleText":"(.-)".-"text":"(.-)".-"browseId":"(.-)".-"url":"(.-)".-"label":"(.-)".-"videoId":"(.-)"')
		logo = logo:gsub('/hqdefault%.jpg.-$','/mqdefault.jpg')
		if title and ch_name and ch_id and logo and all_time and video_id then
			i = i + 1
			t[i] = {}
			t[i].Name = title_clean(title)
			t[i].Address = 'https://www.youtube.com/watch?v=' .. video_id .. '&list=RD' .. id_cur
			t[i].InfoPanelLogo = logo
			t[i].InfoPanelName = ch_name .. ' | ' .. title_clean(title)
			t[i].InfoPanelTitle = all_time
		end
	end
	m_simpleTV.User.TVPortal.stena_search_youtube = t
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'video_jam'
	m_simpleTV.User.TVPortal.stena_search_youtube_title = 'Джем - ' .. t[1].Name
	m_simpleTV.User.TVPortal.stena_youtube_next = nil
	m_simpleTV.User.TVPortal.stena_youtube_prev = nil
	if stena_search_youtube_content then return stena_search_youtube_content() end
end

function get_video_for_playlist(pll_id, pageToken)
	if pll_id:match('BANNER3') then return get_video_jam('') end
	if pll_id:match('YOUTUBE_STENA_') then
	pll_id = m_simpleTV.User.TVPortal.stena_youtube_playlistID
	pageToken = ''
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&maxResults=28&playlistId=' .. pll_id .. '&key=' .. m_simpleTV.User.YT.apiKey .. '&pageToken=' .. pageToken
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
--	debug_in_file(answer .. '\n','c://1/testyoutube_pl.txt')
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'video_playlist'
	m_simpleTV.User.TVPortal.stena_youtube_playlistID = pll_id

	local t, i, j = {}, 1, 1
	local prev_pg = tab.prevPageToken
	local next_pg = tab.nextPageToken
	local all = tab.pageInfo.totalResults
	local all_pg = math.ceil(tonumber(all)/28)
	m_simpleTV.User.TVPortal.stena_youtube_video_playlist_count = tab.pageInfo.totalResults
	if tonumber(all_pg) == 0 then all_pg = 1 end
	while true do
		if not tab.items[i] then break end
		if tab.items[i].snippet.thumbnails and tab.items[i].snippet.thumbnails.medium and tab.items[i].snippet.thumbnails.medium.url and tab.items[i].status and tab.items[i].status.privacyStatus ~= 'unlisted' then
		t[j] = {}
		t[j].Name = title_clean(tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&'))
		t[j].Address = 'https://www.youtube.com/watch?v=' .. tab.items[i].snippet.resourceId.videoId .. '&list=' .. pll_id
		t[j].InfoPanelLogo = tab.items[i].snippet.thumbnails.medium.url
		t[j].InfoPanelName = tab.items[i].snippet.channelTitle .. ' | ' .. title_clean(tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&'))
		t[j].InfoPanelTitle = tab.items[i].snippet.description:gsub('%-%-',''):gsub('%=%=',''):gsub('__','')
		if j == 1 then
			m_simpleTV.User.TVPortal.stena_youtube_channelID = tab.items[i].snippet.channelId
			m_simpleTV.User.TVPortal.stena_youtube_channel_name, m_simpleTV.User.TVPortal.stena_youtube_channel_desc, m_simpleTV.User.TVPortal.stena_youtube_channel_logo = get_info_for_channel(m_simpleTV.User.TVPortal.stena_youtube_channelID)
		end
		j = j + 1
		end
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_search_youtube = t

		if prev_pg == nil then m_simpleTV.User.TVPortal.stena_search_youtube_page = 1 end
		m_simpleTV.User.TVPortal.stena_search_youtube_title = (m_simpleTV.User.TVPortal.stena_search_youtube_title_playlist or 'Youtube video') .. ' playlist: стр. ' .. m_simpleTV.User.TVPortal.stena_search_youtube_page .. ' из ' .. all_pg
		if next_pg then
		m_simpleTV.User.TVPortal.stena_youtube_next = {pll_id, next_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_next = nil
		end
		if prev_pg then
		m_simpleTV.User.TVPortal.stena_youtube_prev = {pll_id, prev_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil
		end

	if stena_search_youtube_content then return stena_search_youtube_content() end
end

function get_playlists_for_channel(ch_id, pageToken)
	if ch_id:match('YOUTUBE_STENA_') then ch_id = m_simpleTV.User.TVPortal.stena_youtube_channelID pageToken = '' end
	if pageToken == '' then get_info_for_video_channel(ch_id) get_info_for_playlist_channel(ch_id) get_info_for_online_channel(ch_id) end
--	debug_in_file(ch_id .. '\n','c://1/testyoutube_chid.txt')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local url = 'https://youtube.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=' .. ch_id .. '&maxResults=28&key=' .. m_simpleTV.User.YT.apiKey .. '&pageToken=' .. pageToken

	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
--	debug_in_file(answer .. '\n','c://1/testyoutube_pl.txt')
	require 'json'
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\n',''))
	if not tab then return end
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'playlist'
	local t, i, j = {}, 1, 2

	t[1] = {}
	t[1].InfoPanelName, t[1].InfoPanelTitle, t[1].InfoPanelLogo = get_info_for_channel(ch_id)
	t[1].Address = 'https://www.youtube.com/playlist?list=UU' .. ch_id:gsub('^%S%S','')
	t[1].Name = 'Все видео канала'
	t[1].InfoPanelName = t[1].InfoPanelName .. ' | ' .. m_simpleTV.User.TVPortal.stena_youtube_video_count .. ' видео'

	local prev_pg = tab.prevPageToken
	local next_pg = tab.nextPageToken
	local all = tab.pageInfo.totalResults
	local all_pg = math.ceil((tonumber(all)+1)/28)
	if tonumber(all_pg) == 0 then all_pg = 1 end
	while true do
		if not tab.items[i] then break end
		if tab.items[i].snippet.thumbnails and tab.items[i].snippet.thumbnails.medium and not tab.items[i].snippet.thumbnails.medium.url:match('no_thumbnail%.jpg') then
			t[j] = {}
			t[j].Name = tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&')
			t[j].Address = 'https://www.youtube.com/playlist?list=' .. tab.items[i].id
			t[j].InfoPanelLogo = tab.items[i].snippet.thumbnails.medium.url
			t[j].InfoPanelName = tab.items[i].snippet.channelTitle .. ' | ' .. tab.items[i].snippet.title:gsub('%&quot%;','"'):gsub('%&amp%;','&') .. ' | ' .. tab.items[i].contentDetails.itemCount .. ' видео'
			t[j].InfoPanelTitle = tab.items[i].snippet.description:gsub('%-%-',''):gsub('%=%=',''):gsub('__','')
			j = j + 1
		end
		i = i + 1
	end
	m_simpleTV.User.TVPortal.stena_search_youtube = t

		if prev_pg == nil then m_simpleTV.User.TVPortal.stena_search_youtube_page = 1 end
		m_simpleTV.User.TVPortal.stena_search_youtube_title = 'Youtube playlist: стр. ' .. m_simpleTV.User.TVPortal.stena_search_youtube_page .. ' из ' .. all_pg
		if next_pg then
		m_simpleTV.User.TVPortal.stena_youtube_next = {ch_id, next_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_next = nil
		end
		if prev_pg then
		m_simpleTV.User.TVPortal.stena_youtube_prev = {ch_id, prev_pg}
		else
		m_simpleTV.User.TVPortal.stena_youtube_prev = nil
		end

	if stena_search_youtube_content then return stena_search_youtube_content() end
end

function info_youtube_content()

end

function stena_search_youtube_content()
--	if m_simpleTV.User.TVPortal.stena_search == nil then return end
	m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = true
	m_simpleTV.User.TVPortal.stena_tvportal_use = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
				m_simpleTV.OSD.RemoveElement('ID_DIV_1')
				m_simpleTV.OSD.RemoveElement('ID_DIV_2')
				if m_simpleTV.User.TVPortal.stena == nil then m_simpleTV.User.TVPortal.stena = {} end
				if m_simpleTV.User.TVPortal.stena_search_youtube == nil then m_simpleTV.User.TVPortal.stena_search_youtube = {} end
	local  t, AddElement = {}, m_simpleTV.OSD.AddElement

				 t = {}
				 t.id = 'ID_DIV_STENA_1'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=-70 / m_simpleTV.Interface.GetScale()*1.5
				 t.once=1
				 t.zorder=1
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_STENA_2'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=0
				 t.once=1
				 t.zorder=0
				 t.background = 1
				 t.backcolor0 = 0x440000FF
--				 t.backcolor1 = 0x77FFFFFF
				 AddElement(t)

				 t = {}
				 t.id = 'FON_STENA_ID'
				 t.cx= -100
				 t.cy= -100
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="150" delay="60" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/cerberus/cerberus%1.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=0
				 t.top=0
				 t.transparency = 255
				 t.zorder=1
				 AddElement(t,'ID_DIV_STENA_2')

				 t = {}
				 t.id = 'GLOBUS_STENA_ID'
				 t.cx= 60
				 t.cy= 60
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d/d%0.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0103
				 t.left=15
				 t.top=110
				 t.transparency = 255
				 t.zorder=2
				 t.isInteractive = true
				 t.cursorShape = 13
				 t.mousePressEventFunction = 'start_page_mediaportal'
				 AddElement(t,'ID_DIV_STENA_1')

				 t={}
				 t.id = 'TEXT_STENA_YOUTUBE_TITLE_ID'
				 t.cx=-66
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0102
				 t.text = m_simpleTV.User.TVPortal.stena_search_youtube_title
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = m_simpleTV.User.TVPortal.stena_exfs_title_font or 'Segoe UI Black'
				 t.textparam = 0x00000001
				 t.boundWidth = 15 -- bound to screen
				 t.row_limit=1 -- row limit
				 t.scrollTime = 40 --for ticker (auto scrolling text)
				 t.scrollFactor = 2
				 t.scrollWaitStart = 70
				 t.scrollWaitEnd = 100
				 t.left = 0
				 t.top  = 100
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'video' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'playlist' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'online' then

				t = {}
				t.id = 'STENA_YOUTUBE_CHANNEL_IMG_ID'
				t.cx=70
				t.cy=70
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_youtube_channel_logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 76
			    t.top  = 80
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_YOUTUBE_CHANNEL_TXT_ID'
				t.cy=0
				t.class="TEXT"
				t.text = (m_simpleTV.User.TVPortal.stena_youtube_channel_name or 'Channel') .. '\n' .. (m_simpleTV.User.TVPortal.stena_youtube_channel_desc or '') .. '\n\n\n\n\n\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = 8 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.cx = 230
				t.left = 210
			    t.top  = 80
				t.row_limit=6
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'YOUTUBE_STENA_VIDEO_IMG_ID'
					t.cx= 140 / 1*1.25
					t.cy= 30 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 25
					t.top  = 160
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_video_for_channel'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'YOUTUBE_STENA_VIDEO_TEXT_ID'
					t.cx=120 / 1*1.25
					t.cy=0
					t.class="TEXT"
					t.text = 'video (' .. m_simpleTV.User.TVPortal.stena_youtube_video_count .. ')'
					t.align = 0x0101
					if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'video' then
					 t.color = ARGB(255, 255, 215, 0)
					else
					 t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 35
					t.top  = 160
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'get_video_for_channel'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'YOUTUBE_STENA_PLAYLIST_IMG_ID'
					t.cx= 140 / 1*1.25
					t.cy= 30 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 25
					t.top  = 200
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_playlists_for_channel'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'YOUTUBE_STENA_PLAYLIST_TEXT_ID'
					t.cx=120 / 1*1.25
					t.cy=0
					t.class="TEXT"
					t.text = 'playlist (' .. (tonumber(m_simpleTV.User.TVPortal.stena_youtube_playlist_count) + 1) .. ')'
					t.align = 0x0101
					if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'playlist' then
					 t.color = ARGB(255, 255, 215, 0)
					else
					 t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 35
					t.top  = 200
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'get_playlists_for_channel'
					AddElement(t,'ID_DIV_STENA_2')

					if tonumber(m_simpleTV.User.TVPortal.stena_youtube_online_count) > 0 then

					t = {}
					t.id = 'YOUTUBE_STENA_ONLINE_IMG_ID'
					t.cx= 40
					t.cy= 70
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 25
					t.top  = 80
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_online_for_channel'
					AddElement(t,'ID_DIV_STENA_2')

				 t = {}
				 t.id = 'YOUTUBE_STENA_ONLINE_ANI_ID'
				 t.cx= 40
				 t.cy= 40
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="3" delay="240" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/online/record%0.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=155
				 t.top=95
				 t.transparency = 255
				 t.zorder=2
				 AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'YOUTUBE_STENA_ONLINE_TEXT_ID'
					t.cx=30
					t.cy=70
					t.class="TEXT"
					t.text = m_simpleTV.User.TVPortal.stena_youtube_online_count
					t.align = 0x0101
					if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'online' then
					 t.color = ARGB(255, 255, 215, 0)
					else
					 t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 30
					t.top  = 80
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'get_online_for_channel'
					AddElement(t,'ID_DIV_STENA_2')

					end

			end

			if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'video_playlist' then

					t = {}
					t.id = 'YOUTUBE_STENA_BANNER1_BACK_IMG_ID'
					t.cx= 220
					t.cy= 60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 90
					t.top  = 250
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_playlists_for_channel'
					AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER1_IMG_ID'
				t.cx=50
				t.cy=50
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_youtube_channel_logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 95
			    t.top  = 255
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER1_TXT_ID'
				t.cy=60
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_youtube_channel_name
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 135
				t.left = 155
			    t.top  = 255
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER1_TXT1_ID'
				t.cy=0
				t.class="TEXT"
				t.text = 'канал плейлиста'
				t.color = ARGB(255 ,0, 250, 154)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 210
				t.left = 95
			    t.top  = 310
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')
			end

			if (m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') or
				m_simpleTV.User.TVPortal.stena_search_youtube_type:match('video') or
				m_simpleTV.User.TVPortal.stena_search_youtube_type:match('online')or
				m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_history'))

			and m_simpleTV.User.TVPortal.stena_youtube_get_channelID then

					t = {}
					t.id = 'YOUTUBE_STENA_BANNER2_BACK_IMG_ID'
					t.cx= 220
					t.cy= 60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 330
					t.top  = 250
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_video_for_channel'
					AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER2_IMG_ID'
				t.cx=50
				t.cy=50
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_youtube_get_channel_logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 335
			    t.top  = 255
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER2_TXT_ID'
				t.cy=60
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_youtube_get_channel_name
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 135
				t.left = 395
			    t.top  = 255
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER2_TXT1_ID'
				t.cy=0
				t.class="TEXT"
				t.text = 'канал видео'
				t.color = ARGB(255 ,0, 250, 154)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 210
				t.left = 335
			    t.top  = 310
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

			end

			if m_simpleTV.User.TVPortal.stena_youtube_get_channel_type and tonumber(m_simpleTV.User.TVPortal.stena_youtube_get_channel_type) == 10 then

					t = {}
					t.id = 'YOUTUBE_STENA_BANNER3_BACK_IMG_ID'
					t.cx= 220
					t.cy= 60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 570
					t.top  = 250
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_video_for_playlist'
					AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER3_IMG_ID'
				t.cx=50
				t.cy=50
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/menuYT.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 575
			    t.top  = 255
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER3_TXT_ID'
				t.cy=60
				t.class="TEXT"
				t.text = 'сборник youtube'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 135
				t.left = 635
			    t.top  = 255
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'YOUTUBE_STENA_BANNER3_TXT1_ID'
				t.cy=0
				t.class="TEXT"
				t.text = 'джем плейлист'
				t.color = ARGB(255 ,0, 250, 154)
				t.font_height = 9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
--				t.boundWidth = 1000
				t.cx = 210
				t.left = 575
			    t.top  = 310
				t.row_limit=2
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

			end

			local t1 = {
			{'Поиск видео: ','search youtube video',},
			{'Поиск плейлистов: ','search youtube playlist',},
			{'Поиск каналов: ','search youtube channel',},
			{'Поиск эфиров: ','search youtube online',},
			}

			if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('search') then

				for j = 1,4 do

					t = {}
					t.id = 'SEARCH_YOUTUBE_STENA_' .. j .. '_IMG_ID'
					t.cx= 300 / 1*1.25
					t.cy= 30 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 25
					t.top  = 80 + (j-1)*40
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'search_stena_youtube'
					AddElement(t,'ID_DIV_STENA_2')

					t = {}
					t.id = 'SEARCH_YOUTUBE_STENA_' .. j .. '_TEXT_ID'
					t.cx=280 / 1*1.25
					t.cy=0
					t.class="TEXT"
					t.text = t1[j][1]
					t.align = 0x0101
					if m_simpleTV.User.TVPortal.stena_search_youtube_type == t1[j][2] then
					 t.color = ARGB(255, 255, 215, 0)
					else
					 t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 35
					t.top  = 80 + (j-1)*40
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'search_stena_youtube'
					AddElement(t,'ID_DIV_STENA_2')

				end
			end

			local t_vid_cat_id = {
							{"25", "Новости и политика",},
							{"17", "Спорт",},
							{"10", "Музыка",},
							{"1", "Фильмы и анимация",},
							{"0", "Прямой эфир"},
	                     }

			if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') then

				for j = 1,5 do

					t = {}
					t.id = 'START_YOUTUBE_STENA_' .. j .. '_IMG_ID'
					t.cx= 200 / 1*1.25
					t.cy= 30 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 25
					t.top  = 80 + (j-1)*40
					if j == 5 then
					 t.cx= 62 / 1*1.25
					 t.cy= 62 / 1*1.25
					 t.left = 223 / 1*1.25
					 t.top  = 80 + 40
					end
					t.transparency = 40
					t.zorder=0
					t.borderwidth = 2
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 2
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0x774169E1
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 2*2
					t.borderround = 2
					t.mousePressEventFunction = 'get_answer_start'
					AddElement(t,'ID_DIV_STENA_2')

					if j == 5 then

					 t = {}
					 t.id = 'START_YOUTUBE_STENA__ONLINE_ANI_ID'
					 t.cx= 51.5
					 t.cy= 51.5
					 t.class="IMAGE"
					 if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'youtube_start0' then
					  t.animation = true
					  t.imagepath = 'type="dir" count="3" delay="240" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/online/record%0.png"'
					 else
					  t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/online/record0.png'
					 end
					 t.minresx=-1
					 t.minresy=-1
					 t.align = 0x0101
					 t.left = 232 / 1*1.25
					 t.top = 133
					 t.transparency = 255
					 t.zorder=2
					 AddElement(t,'ID_DIV_STENA_2')

					else
					t = {}
					t.id = 'START_YOUTUBE_STENA_' .. j .. '_TEXT_ID'
					t.cx=180 / 1*1.25
					t.cy=0
					t.class="TEXT"
					t.text = t_vid_cat_id[j][2]
					t.align = 0x0101
					if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'youtube_start' .. t_vid_cat_id[j][1] then
					 t.color = ARGB(255, 255, 215, 0)
					else
					 t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000020
					t.boundWidth = 15
					t.left = 35
					t.top  = 80 + (j-1)*40
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'get_answer_start'
					AddElement(t,'ID_DIV_STENA_2')
					end
				end
			end

				t = {}
				t.id = 'STENA_YT_Start_Back_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 730
			    t.top  = 170
				t.transparency = 0
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20

				t.mousePressEventFunction = 'get_answer_start'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_YT_Start_IMG_ID'
				t.cx=80
				t.cy=80
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/YT_Tube.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 720
			    t.top  = 160
				t.transparency = 220
				t.zorder=2

				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_YT_Subs_Back_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 650
			    t.top  = 170
				t.transparency = 0
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'youtube_channels' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20

				t.mousePressEventFunction = 'get_answer_channels'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_YT_Subs_IMG_ID'
				t.cx=80
				t.cy=80
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/YT_Subs.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 640
			    t.top  = 160
				t.transparency = 220
				t.zorder=2

				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_YT_Hist_Back_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 570
			    t.top  = 170
				t.transparency = 0
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'youtube_history' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20

				t.mousePressEventFunction = 'get_answer_history'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_YT_Hist_IMG_ID'
				t.cx=80
				t.cy=80
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/YT_Hist.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 560
			    t.top  = 160
				t.transparency = 220
				t.zorder=2
				t.backroundcorner = 20*20
				t.borderround = 20

				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_HOME_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/home.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 490
			    t.top  = 170
				t.transparency = 220
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_search_youtube_type == 'home' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20

				t.mousePressEventFunction = 'run_youtube_portal'
--				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 410
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_YOUTUBE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search_History.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 330
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
--				t.background = 0
--			    t.backcolor0 = 0x66999999
--			    t.backcolor1 = 0
--				t.backcenterpoint_x = 30
--                t.backcenterpoint_y = 30
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('search') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'get_history_of_search'
				AddElement(t,'ID_DIV_STENA_1')

				if m_simpleTV.User.TVPortal.stena_youtube_prev then
				t = {}
				t.id = 'STENA_SEARCH_PREV_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 250
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_youtube_prev'
				AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.TVPortal.stena_youtube_next then
				t = {}
				t.id = 'STENA_SEARCH_NEXT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 170
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_youtube_next'
				AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_CLEAR_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Clear.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 90
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mousePressEventFunction = 'stena_clear'
				AddElement(t,'ID_DIV_STENA_1')

			if not m_simpleTV.User.TVPortal.stena_search_youtube then m_simpleTV.User.TVPortal.stena_search_youtube = {} end

			for j = 1,#m_simpleTV.User.TVPortal.stena_search_youtube do

			    local dx = 1920/7
				local dy = 800/4
				local nx = j - (math.ceil(j/7) - 1)*7
				local ny = math.ceil(j/7)
				t = {}
				t.id = 'STENA_YOUTUBE_' .. j .. '_IMG_ID'
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('channel') then
				 t.left = nx*dx - 265 + 56
				 t.cx=144
				 t.cy=144
				else
				t.left = nx*dx - 265
				t.cx=256
				t.cy=144
				end
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.stena_search_youtube[j].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
			    t.top  = ny*dy + 155
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
--				t.bordercolor = -6250336
				t.backroundcorner = 3*3
				t.borderround = 3
				if m_simpleTV.User.TVPortal.stena_search_youtube_current and m_simpleTV.User.TVPortal.stena_search_youtube_current:gsub('%&.-$','') == m_simpleTV.User.TVPortal.stena_search_youtube[j].Address:gsub('%&.-$','') then
				m_simpleTV.User.TVPortal.stena_search_youtube.cur_content_adr = nil
				get_info_for_current(t.id)
				 t.borderwidth = 3
				 t.bordercolor = ARGB(255, 255, 215, 0)
				else
				 t.bordercolor = -6250336
				end
				t.enterEventFunction = 'get_info_for_current'
				t.mousePressEventFunction = 'content_youtube'

				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_YOUTUBE_' .. j .. '_TEXT_ID'
				t.cx=256
				t.cy=0
				t.class="TEXT"
				t.text = '\n\n\n\n' .. m_simpleTV.User.TVPortal.stena_search_youtube[j].Name .. '\n\n\n\n'
				t.align = 0x0101
				if m_simpleTV.User.TVPortal.stena_search_youtube_current and m_simpleTV.User.TVPortal.stena_search_youtube_current:gsub('%&.-$','') == m_simpleTV.User.TVPortal.stena_search_youtube[j].Address:gsub('%&.-$','') then
				 t.color = ARGB(255, 255, 215, 0)
				else
				 t.color = ARGB(255 ,192, 192, 192)
				end
				t.font_height = 8 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = nx*dx - 265
			    t.top  = ny*dy + 220
				t.row_limit=2
				t.text_elidemode = 2
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'content_youtube'
				AddElement(t,'ID_DIV_STENA_1')
			end
end

function content_youtube(id_cur)
	local id = id_cur:match('(%d+)')
	m_simpleTV.User.filmix.CurAddress = nil
	m_simpleTV.User.rezka.CurAddress = nil
	m_simpleTV.User.TVPortal.get = nil
	m_simpleTV.User.TVPortal.Channel_Of_Group = nil
	m_simpleTV.User.TVPortal.stena_filmix_info = false
	m_simpleTV.User.TVPortal.stena_filmix_use = false
	m_simpleTV.User.TVPortal.stena_use = false
	m_simpleTV.User.TVPortal.stena_info = false
	m_simpleTV.User.TVPortal.stena_home = false
	m_simpleTV.User.TVPortal.stena_genres = false
	m_simpleTV.User.TVPortal.stena_search_use = false
	m_simpleTV.User.TVPortal.stena_search_youtube_use = true
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
	if m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Address:match('/channel/') then
		local id = m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Address:match('/channel/(.-)$')
		return get_video_for_channel(id,'')
--		get_playlist_for_channel(id)
	elseif m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Address:match('/playlist%?list%=') then
		m_simpleTV.User.TVPortal.stena_search_youtube_title_playlist = m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Name
		local id = m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Address:match('/playlist%?list%=(.-)$')
		return get_video_for_playlist(id,'')
	end
	m_simpleTV.User.westSide.PortalTable = true
	m_simpleTV.User.TVPortal.stena_search_youtube_current = m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Address
	if not m_simpleTV.User.TVPortal.stena_search_youtube_current:match('list%=') and not m_simpleTV.User.TVPortal.stena_search_youtube_current:match('%&isPlst') then
	stena_clear()
	end

	m_simpleTV.Control.PlayAddressT({address=m_simpleTV.User.TVPortal.stena_search_youtube[tonumber(id)].Address})
end

function search_stena_youtube(id_cur)
	local id = id_cur:match('(%d+)')
	local tt = {
	{'video','watch?v=','','видео','search youtube video'},
	{'playlist','playlist?list=','','плейлист','search youtube playlist'},
	{'channel','channel/','','канал','search youtube channels'},
	{'video','watch?v=','&eventType=live','прямой эфир','search youtube online'},
	}
	m_simpleTV.User.TVPortal.stena_search_youtube_type = tt[tonumber(id)][5]
	search_youtube_item(tt[tonumber(id)][1], tt[tonumber(id)][2], tt[tonumber(id)][3], tt[tonumber(id)][4], 1)
end

function get_answer_start(id_cur)
	local id = id_cur:match('(%d+)') or 1
	if id_cur:match('MEDIAPOISK') then id = 1 end -- start page for t_vid_cat_id
	local t_vid_cat_id = {
	{"25", "Новости и политика"},
	{"17", "Спорт"},
	{"10", "Музыка"},
	{"1", "Фильмы и анимация"},
	{"0", "Прямой эфир"},
	}
	m_simpleTV.User.TVPortal.stena_search_youtube_type = 'youtube_start' .. t_vid_cat_id[tonumber(id)][1]
	getstart(t_vid_cat_id[tonumber(id)][1], '')
end

function stena_youtube_prev()
	if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('search') then
		search_youtube_item(m_simpleTV.User.TVPortal.stena_youtube_prev[1],m_simpleTV.User.TVPortal.stena_youtube_prev[2],m_simpleTV.User.TVPortal.stena_youtube_prev[3],m_simpleTV.User.TVPortal.stena_youtube_prev[4],m_simpleTV.User.TVPortal.stena_youtube_prev[5])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') then
		getstart(m_simpleTV.User.TVPortal.stena_youtube_prev[1],m_simpleTV.User.TVPortal.stena_youtube_prev[2])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('channel') then
		get_answer_channels(m_simpleTV.User.TVPortal.stena_youtube_prev[1])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type =='video_playlist' then
		m_simpleTV.User.TVPortal.stena_search_youtube_page = tonumber(m_simpleTV.User.TVPortal.stena_search_youtube_page) - 1
		get_video_for_playlist(m_simpleTV.User.TVPortal.stena_youtube_prev[1],m_simpleTV.User.TVPortal.stena_youtube_prev[2])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('video') then
		m_simpleTV.User.TVPortal.stena_search_youtube_page = tonumber(m_simpleTV.User.TVPortal.stena_search_youtube_page) - 1
		get_video_for_channel(m_simpleTV.User.TVPortal.stena_youtube_prev[1],m_simpleTV.User.TVPortal.stena_youtube_prev[2])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('playlist') then
		m_simpleTV.User.TVPortal.stena_search_youtube_page = tonumber(m_simpleTV.User.TVPortal.stena_search_youtube_page) - 1
		get_playlists_for_channel(m_simpleTV.User.TVPortal.stena_youtube_prev[1],m_simpleTV.User.TVPortal.stena_youtube_prev[2])
	else
		get_answer_history(m_simpleTV.User.TVPortal.stena_youtube_prev[1])
	end
end

function stena_youtube_next()
	if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('search') then
		search_youtube_item(m_simpleTV.User.TVPortal.stena_youtube_next[1],m_simpleTV.User.TVPortal.stena_youtube_next[2],m_simpleTV.User.TVPortal.stena_youtube_next[3],m_simpleTV.User.TVPortal.stena_youtube_next[4],m_simpleTV.User.TVPortal.stena_youtube_next[5])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') then
		getstart(m_simpleTV.User.TVPortal.stena_youtube_next[1],m_simpleTV.User.TVPortal.stena_youtube_next[2])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('channel') then
		get_answer_channels(m_simpleTV.User.TVPortal.stena_youtube_next[1])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type =='video_playlist' then
		m_simpleTV.User.TVPortal.stena_search_youtube_page = tonumber(m_simpleTV.User.TVPortal.stena_search_youtube_page) + 1
		get_video_for_playlist(m_simpleTV.User.TVPortal.stena_youtube_next[1],m_simpleTV.User.TVPortal.stena_youtube_next[2])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('video') then
		m_simpleTV.User.TVPortal.stena_search_youtube_page = tonumber(m_simpleTV.User.TVPortal.stena_search_youtube_page) + 1
		get_video_for_channel(m_simpleTV.User.TVPortal.stena_youtube_next[1],m_simpleTV.User.TVPortal.stena_youtube_next[2])
	elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('playlist') then
		m_simpleTV.User.TVPortal.stena_search_youtube_page = tonumber(m_simpleTV.User.TVPortal.stena_search_youtube_page) + 1
		get_playlists_for_channel(m_simpleTV.User.TVPortal.stena_youtube_next[1],m_simpleTV.User.TVPortal.stena_youtube_next[2])
	else
		get_answer_history(m_simpleTV.User.TVPortal.stena_youtube_next[1])
	end
end

function get_info_for_current(id_cur)
	local id = id_cur:match('(%d+)')
	local t, AddElement = {}, m_simpleTV.OSD.AddElement
	local t1 = m_simpleTV.User.TVPortal.stena_search_youtube
		if m_simpleTV.User.TVPortal.stena_search_youtube.cur_content_adr == nil or
			t1[tonumber(id)].Address ~= m_simpleTV.User.TVPortal.stena_search_youtube.cur_content_adr then
			m_simpleTV.User.TVPortal.stena_search_youtube.cur_content_adr = t1[tonumber(id)].Address

				t = {}
				t.id = 'STENA_YOUTUBE_CONTENT_IMG_ID'
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('channel') then
				 t.cx=90
				 t.cy=90
				else
				 t.cx=160
				 t.cy=90
				end
				t.class="IMAGE"
				t.imagepath = t1[tonumber(id)].InfoPanelLogo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'video' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'playlist' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'online' or 				m_simpleTV.User.TVPortal.stena_search_youtube_type:match('search') then
				 t.left = 450
			     t.top  = 80
				else
				 t.left = 50
			     t.top  = 80
				end
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_YOUTUBE_CONTENT_TXT_ID'
				t.cy=0
				t.class="TEXT"
				t.text = t1[tonumber(id)].InfoPanelName .. '\n' .. t1[tonumber(id)].InfoPanelTitle .. '\n\n\n\n\n\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = 8 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'video' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'playlist' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'online' or 				m_simpleTV.User.TVPortal.stena_search_youtube_type:match('search') then
				 t.cx=700
				 t.left = 450
			     t.top  = 180
				elseif m_simpleTV.User.TVPortal.stena_search_youtube_type:match('channel') then
				 t.cx=900
				 t.left = 180
			     t.top  = 80
				else
				 t.cx=800
				 t.left = 280
			     t.top  = 80
				end
				if m_simpleTV.User.TVPortal.stena_search_youtube_type:match('youtube_start') or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'video' or m_simpleTV.User.TVPortal.stena_search_youtube_type == 'playlist' or 				m_simpleTV.User.TVPortal.stena_search_youtube_type == 'online' then
				 t.row_limit=3
				else
				 t.row_limit=6
				end
				t.text_elidemode = 1
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

		end
end