--westSide events 17.01.24

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


local function get_info_for_channel(ch_id)
	if not m_simpleTV.User.YT.apiKey then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not ch_id then return end
	local url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=' .. ch_id .. '&type=channel&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	m_simpleTV.User.TVPortal.stena_youtube_get_channel_name, m_simpleTV.User.TVPortal.stena_youtube_get_channel_logo = answer:match('"title": "(.-)".-"medium".-"url": "(.-)"')
end

local function get_channel_for_video(video_id)
	if not m_simpleTV.User.YT.apiKey then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://youtube.googleapis.com/youtube/v3/videos?part=snippet&id=' .. video_id .. '&key=' .. m_simpleTV.User.YT.apiKey
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
	m_simpleTV.Http.Close(session)
--	debug_in_file(url .. '\n' .. rc .. '\n' .. answer .. '\n','c://1/testyoutube_get.txt')
	if rc ~= 200 then return end
	m_simpleTV.User.TVPortal.stena_youtube_get_channelID, m_simpleTV.User.TVPortal.stena_youtube_get_channel_type = answer:match('"channelId".-"(.-)".-"categoryId".-"(.-)"')
	get_info_for_channel(m_simpleTV.User.TVPortal.stena_youtube_get_channelID)
end

if m_simpleTV.Control.CurrentAddress and m_simpleTV.Control.CurrentAddress:match('www%.youtube%.com/') then
	m_simpleTV.User.westSide.PortalTable = true
	m_simpleTV.User.TVPortal.stena_search_youtube_current = m_simpleTV.Control.CurrentAddress
	local inAdr = m_simpleTV.Control.CurrentAdress
	inAdr = inAdr .. '&'
	local video_id, playlist_id, isPls
	video_id = inAdr:match('v=(.-)%&')
	playlist_id = inAdr:match('list=(.-)%&')
	isPls = inAdr:match('%&isPlst=')
	if video_id then
		get_channel_for_video(video_id)
	end
	if playlist_id then
		m_simpleTV.User.TVPortal.stena_youtube_get_playlistID = playlist_id
	end
	if not playlist_id and not isPls then
		m_simpleTV.User.TVPortal.stena_youtube_get_playlistID = nil
	end
end

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
end

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
	m_simpleTV.User.westSide.PortalTable=nil
	m_simpleTV.User.filmix.TabSimilar=nil
	m_simpleTV.User.torrent.content=nil
	m_simpleTV.User.hevc.content=nil
	m_simpleTV.User.collaps=nil
--	m_simpleTV.User.AudioWS=nil
	m_simpleTV.User.TVPortal.get=nil
	m_simpleTV.User.TVPortal.stena_youtube_get_channel_type=nil
	m_simpleTV.User.TVPortal.stena_youtube_get_channelID=nil
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