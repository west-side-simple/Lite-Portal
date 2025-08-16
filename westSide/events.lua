--westSide events 10.08.25

if m_simpleTV.User.TVPortal.stena_use == true then
	local t ={}
	t.type = 1
	t.callback = 'stena_callback'
	local id = m_simpleTV.OSD.AddEventListener(t)
end

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

local function check_musjam(video_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36')
	if not session then return '' end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://www.youtube.com/watch?v=' .. video_id .. '&list=RD' .. video_id
	m_simpleTV.Http.SetCookies(session, url, m_simpleTV.User.YT.cookies, '')
	local ss, sss = m_simpleTV.Http.Request(session, {url = url, method = 'get'})
	m_simpleTV.Http.Close(session)
	if ss ~= 200 then return '' end
	sss = sss:gsub('\\n',' ')
--	debug_in_file(sss..'\njjjjjjjjjjjjjjj\n')
	if sss:match('"playlistPanelVideoRenderer"') then return 10 end
	return ''
end

local function get_info_for_channel(ch_id)
	if not m_simpleTV.User.YT.apiKey then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not ch_id then return end
	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&type=channel&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	m_simpleTV.User.TVPortal.stena_youtube_get_channel_name, m_simpleTV.User.TVPortal.stena_youtube_get_channel_logo = answer:match('"title": "(.-)".-"description": ".-".-"medium".-"url": "(.-)"')
--[[
debug_in_file(
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_title: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_video_title .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_duration: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_video_duration .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_desc: ' ..  m_simpleTV.User.TVPortal.stena_youtube_get_video_desc .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_logo: '..m_simpleTV.User.TVPortal.stena_youtube_get_video_logo .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_channel_logo: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_channel_logo .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_channel_name: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_channel_name .. '\n' ..
		'\n~~~end video~~~\n','c://1/testyoutube_get1.txt')--]]
end

local function get_channel_for_video(video_id)
	if not m_simpleTV.User.YT.apiKey then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/videos?part=snippet&part=contentDetails&id=' .. video_id .. '&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
--	debug_in_file(url .. '\n' .. rc .. '\n' .. answer .. '\n~~~end video~~~\n','c://1/testyoutube_get.txt')
	m_simpleTV.User.TVPortal.stena_youtube_get_channelID, m_simpleTV.User.TVPortal.stena_youtube_get_channel_type = answer:match('"channelId".-"(.-)".-"categoryId".-"(.-)"')
	m_simpleTV.User.TVPortal.stena_youtube_get_video_title, m_simpleTV.User.TVPortal.stena_youtube_get_video_desc, m_simpleTV.User.TVPortal.stena_youtube_get_video_logo, m_simpleTV.User.TVPortal.stena_youtube_get_video_duration = answer:gsub('\\"','*****'):match('"title".-"(.-)".-"description".-"(.-)".-"medium".-"url".-"(.-)".-"duration".-"(.-)"')
	get_info_for_channel(m_simpleTV.User.TVPortal.stena_youtube_get_channelID)
end

	local function GetVideoInfoIOS(video_id)
		local sessionIOS = m_simpleTV.Http.New('com.google.ios.youtube/20.10.4 (iPhone16,2; U; CPU iOS 18_3_2 like Mac OS X;)')
			if not sessionIOS then return end
		m_simpleTV.Http.SetTimeout(sessionIOS, 8000)
		local url = 'https://www.youtube.com/sw.js_data'
		local rc, answer = m_simpleTV.Http.Request(sessionIOS, {url = url})
			if rc ~= 200 then return end
		local visitorData = answer:match('"iPhone","([^"]+)')
			if not visitorData then return end
		local headers = 'Content-Type:application/json'
		local body ='{"context":{"client":{"clientName":"5","clientVersion":"20.10.4","deviceMake":"Apple","deviceModel":"iPhone16,2","hl":"' .. m_simpleTV.User.YT.Lng.lang .. '","osName":"iPhone","osVersion":"18.3.2.22D82","visitorData":"' .. visitorData .. '"}},"racyCheckOk":true,"contentCheckOk":true,"videoId":"' .. video_id ..'"}'
		url = 'https://m.youtube.com/youtubei/v1/player'
		rc, answer = m_simpleTV.Http.Request(sessionIOS, {url = url, method = 'post', body = body, headers = headers})
		m_simpleTV.Http.Close(sessionIOS)
--		debug_in_file(rc .. '\n' .. answer .. '\n~~~end video~~~\n','c://1/testyoutube_get.txt')
		m_simpleTV.User.TVPortal.stena_youtube_get_video_title, m_simpleTV.User.TVPortal.stena_youtube_get_video_duration, m_simpleTV.User.TVPortal.stena_youtube_get_video_desc, m_simpleTV.User.TVPortal.stena_youtube_get_video_logo = answer:gsub('\\"','*****'):match('"videoDetails".-"title".-"(.-)".-"lengthSeconds".-"(.-)".-"shortDescription".-"(.-)".-"thumbnails".-"url".-"(.-)"')
		m_simpleTV.User.TVPortal.stena_youtube_get_video_title = m_simpleTV.User.TVPortal.stena_youtube_get_video_title or ''
		m_simpleTV.User.TVPortal.stena_youtube_get_video_duration = m_simpleTV.User.TVPortal.stena_youtube_get_video_duration or 0
		m_simpleTV.User.TVPortal.stena_youtube_get_video_desc = m_simpleTV.User.TVPortal.stena_youtube_get_video_desc or ''
		
		m_simpleTV.User.TVPortal.stena_youtube_get_video_logo = m_simpleTV.User.TVPortal.stena_youtube_get_video_logo or ''
		m_simpleTV.User.TVPortal.stena_youtube_get_video_logo = m_simpleTV.User.TVPortal.stena_youtube_get_video_logo:gsub('/hqdefault%.jpg','/mqdefault.jpg'):gsub('/default%.jpg','/mqdefault.jpg')
		m_simpleTV.User.TVPortal.stena_youtube_get_channelID = answer:match('"channelId".-"(.-)"')
		m_simpleTV.User.TVPortal.stena_youtube_get_video_viewCount = answer:match('"viewCount".-"(.-)"')
		m_simpleTV.User.TVPortal.stena_youtube_get_channel_type = check_musjam(video_id)
		if answer:match('"endscreen"') then
		m_simpleTV.User.TVPortal.stena_youtube_get_channel_logo, m_simpleTV.User.TVPortal.stena_youtube_get_channel_name  = answer:match('"endscreen".-"thumbnails".-"url": "(.-)".-"text": "(.-)"')
--[[
		debug_in_file(
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_title: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_video_title .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_duration: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_video_duration .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_desc: ' ..  m_simpleTV.User.TVPortal.stena_youtube_get_video_desc .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_video_logo: '..m_simpleTV.User.TVPortal.stena_youtube_get_video_logo .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_channel_logo: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_channel_logo .. '\n' ..
		'm_simpleTV.User.TVPortal.stena_youtube_get_channel_name: ' .. m_simpleTV.User.TVPortal.stena_youtube_get_channel_name .. '\n' ..
		'\n~~~end video~~~\n','c://1/testyoutube_get1.txt')--]]
		else
		get_info_for_channel(answer:match('"channelId".-"(.-)"'))
		end

--	 return rc, answer
	end

if m_simpleTV.Control.Reason=='addressready' and m_simpleTV.Control.CurrentAddress and m_simpleTV.Control.CurrentAddress:match('www%.youtube%.com/') then
	m_simpleTV.User.EXFS.CurAddress = nil
	m_simpleTV.User.filmix.CurAddress = nil
	m_simpleTV.User.rezka.CurAddress = nil
	m_simpleTV.User.westSide.PortalTable = true
	m_simpleTV.User.TVPortal.stena_search_youtube_current = m_simpleTV.Control.CurrentAddress
	local inAdr = m_simpleTV.Control.CurrentAdress
	inAdr = inAdr .. '&'
	local video_id, playlist_id, isPls
	video_id = inAdr:match('v=(.-)%&')
	playlist_id = inAdr:match('list=(.-)%&')
	isPls = inAdr:match('%&isPlst=')
	if video_id then
		GetVideoInfoIOS(video_id)
		m_simpleTV.User.TVPortal.stena_youtube_get_channel_name = m_simpleTV.User.TVPortal.stena_youtube_get_channel_name or 'Youtube'
		if m_simpleTV.User.TVPortal.stena_youtube_get_video_title and
		m_simpleTV.User.TVPortal.stena_youtube_get_video_logo and
		m_simpleTV.User.TVPortal.stena_youtube_get_channel_name and
		m_simpleTV.User.TVPortal.stena_youtube_get_video_duration and
		m_simpleTV.User.TVPortal.stena_youtube_get_video_viewCount then
		add_to_history_youtube(
		'https://www.youtube.com/watch?v=' .. video_id,
		m_simpleTV.User.TVPortal.stena_youtube_get_video_title:gsub('%|','@@@@@'),
		m_simpleTV.User.TVPortal.stena_youtube_get_video_logo,
		m_simpleTV.User.TVPortal.stena_youtube_get_channel_name:gsub('%|','@@@@@'),
		m_simpleTV.User.TVPortal.stena_youtube_get_video_duration,
		m_simpleTV.User.TVPortal.stena_youtube_get_video_viewCount
		)
		end
--		get_channel_for_video(video_id)
	end
	if playlist_id then
		m_simpleTV.User.TVPortal.stena_youtube_get_playlistID = playlist_id
		if m_simpleTV.User.TVPortal.stena_youtube_get_playlistID:match('^RD') then
			get_video_jam(m_simpleTV.User.TVPortal.stena_youtube_get_playlistID)
		else
			get_video_for_playlist(m_simpleTV.User.TVPortal.stena_youtube_get_playlistID, '')
		end
	end
	if not playlist_id and not isPls then
		m_simpleTV.User.TVPortal.stena_youtube_get_playlistID = nil
	end
end
--[[
if m_simpleTV.Control.Reason=='addressready' and
	m_simpleTV.Control.CurrentAddress:match('www%.youtube%.com/') and
	(m_simpleTV.Control.CurrentAddress:match('list=') or m_simpleTV.Control.CurrentAddress:match('%&isPlst')) then

	local inAdr = m_simpleTV.Control.CurrentAdress
	inAdr = inAdr .. '&'
	local video_id = inAdr:match('v=(.-)%&')
	local playlist_id = inAdr:match('list=(.-)%&')
	if video_id then
		get_channel_for_video(video_id)
	end
	if playlist_id then
		m_simpleTV.User.TVPortal.stena_youtube_get_playlistID = playlist_id
		if m_simpleTV.User.TVPortal.stena_youtube_get_playlistID:match('^RD') then
			get_video_jam(m_simpleTV.User.TVPortal.stena_youtube_get_playlistID)
		else
			get_video_for_playlist(m_simpleTV.User.TVPortal.stena_youtube_get_playlistID, '')
		end
	end
	m_simpleTV.User.westSide.PortalTable = true
	stena_callback(1)
end--]]

if m_simpleTV.Control.Reason=='addressready'  then
  if m_simpleTV.User.westSide.PortalShowWindowId then
    m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.westSide.PortalShowWindowId)
  end
  if m_simpleTV.User.westSide.PortalTable~=nil then
    local t={}
    t.utf8 = true
    t.name = '-'
    t.luastring = ''
    t.lua_as_scr = false
    t.submenu = 'westSide Portal'
    t.imageSubmenu = ''
    --t.key = string.byte('I')
    t.ctrlkey = 0
    t.location = 0
    t.image=''
    m_simpleTV.User.westSide.PortalSeparatorId = m_simpleTV.Interface.AddExtMenuT(t)
    local t={}
    t.utf8 = true
    t.name = 'Portal Info Window'
    t.luastring = 'show_portal_window()'
    t.lua_as_scr = true
    t.submenu = 'westSide Portal'
    t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide/icons/portal.png'
    t.key = string.byte('I')
    t.ctrlkey = 0
    t.location = 0
    t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/fw_box_t3.png'
    m_simpleTV.User.westSide.PortalShowWindowId = m_simpleTV.Interface.AddExtMenuT(t)
  end
end

if m_simpleTV.Control.Reason=='Stopped' or m_simpleTV.Control.Reason=='Error' or m_simpleTV.Control.Reason=='EndReached' then
	m_simpleTV.User.EXFS.CurAddress = nil
	m_simpleTV.User.filmix.CurAddress = nil
	m_simpleTV.User.rezka.CurAddress = nil
	m_simpleTV.User.westSide.PortalTable=nil
	m_simpleTV.User.filmix.TabSimilar=nil
	m_simpleTV.User.torrent.content=nil
	m_simpleTV.User.hevc.content=nil
	m_simpleTV.User.collaps=nil
--	m_simpleTV.User.AudioWS=nil
	m_simpleTV.User.TVPortal.get=nil
	m_simpleTV.User.TVPortal.stena_youtube_get_channel_type=nil
	m_simpleTV.User.TVPortal.stena_youtube_get_channelID=nil
	m_simpleTV.User.TVPortal.stena_youtube_get_video_desc=nil
	m_simpleTV.User.TVPortal.is_stena = nil
	if m_simpleTV.User.rezka and m_simpleTV.User.rezka.ThumbsInfo then m_simpleTV.User.rezka.ThumbsInfo = nil end
	if m_simpleTV.User.westSide.PortalShowWindowId then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.westSide.PortalShowWindowId)
	end
end

if m_simpleTV.Control.Reason=='addressready' and (m_simpleTV.Control.CurrentAddress:match('/main/video%d+%.mp4') or m_simpleTV.Control.CurrentAddress:match('/SimpleTVupd/news%d+%.mp4')) and m_simpleTV.User.westSide.UP and m_simpleTV.User.westSide.UP == true then
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/SimpleTVupd/beckgr.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.Control.Action = 'stop'
end

if m_simpleTV.Control.Reason=='EndReached' and (m_simpleTV.Control.CurrentAddress:match('/main/video%d+%.mp4') or m_simpleTV.Control.CurrentAddress:match('/SimpleTVupd/news%d+%.mp4')) then
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/SimpleTVupd/beckgr.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.Control.Action = 'stop'
end
if (m_simpleTV.Control.Reason=='Stopped' or m_simpleTV.Control.Reason=='Error' or m_simpleTV.Control.GetPosition() and m_simpleTV.Control.GetPosition()>=0.9)
	and (m_simpleTV.User.westSide.UP==nil or m_simpleTV.User.westSide.UP~=true)
	and (m_simpleTV.Control.CurrentAddress:match('/main/video%d+%.mp4') or m_simpleTV.Control.CurrentAddress:match('/SimpleTVupd/news%d+%.mp4')) then
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/SimpleTVupd/beckgr.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
	end
	m_simpleTV.Control.Action = 'stop'
	local params = {}
	params.message = 'Для обновления сборки нажмите кнопку ДА.'
	params.caption = 'Update'
	params.buttons = 'Yes|No'
	params.icon = 'Question'
	params.defButton = 'Yes'
	m_simpleTV.User.westSide.UP = true
	if m_simpleTV.Interface.MessageBoxT(params) == 'Yes' then
		m_simpleTV.Control.ExecuteAction(11)
		setConfigVal("need",0) -- флаг текущего обновления и готовности к новому
		os.execute('tv-update.exe')
	end
	m_simpleTV.Control.ExecuteAction(11)
end

function ShowInfoCheckInfo()
if not m_simpleTV.User.westSide.CheckInfo then return end
local is = 'false'
if m_simpleTV.User.TVPortal.is_stena then is = 'true' end
m_simpleTV.OSD.ShowMessage('m_simpleTV.User.TVPortal.is_stena - ' .. is .. '\nm_simpleTV.User.filmix.CurAddress - ' .. (m_simpleTV.User.filmix.CurAddress or 'NOT') .. '\nm_simpleTV.User.rezka.CurAddress - ' .. (m_simpleTV.User.rezka.CurAddress or 'NOT') .. '\nm_simpleTV.User.EXFS.CurAddress - ' .. (m_simpleTV.User.EXFS.CurAddress or 'NOT') .. '\nm_simpleTV.User.TVPortal.stena_youtube_get_playlistID - ' .. (m_simpleTV.User.TVPortal.stena_youtube_get_playlistID or 'NOT') .. '\nm_simpleTV.User.TVPortal.stena_youtube_get_video_desc - ' .. (m_simpleTV.Common.UTF8ToMultiByte(tostring(m_simpleTV.User.TVPortal.stena_youtube_get_video_desc)) or 'NOT'),255,1)
end

ShowInfoCheckInfo()