--TV Portal events 19.02.25

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
----------------------------for debug
local function Get_tracks()
	local active = m_simpleTV.Control.GetTracksInfo()
	if not active then return false end
	local minimum_id = 1000
	if active["subtitle"] then
		debug_in_file('active["subtitle"]["currentID"] = ' .. active["subtitle"]["currentID"] .. '\n','c://1/track.txt')
		local i = 1
		while active["subtitle"]["list"][i] do
			if tonumber(active["subtitle"]["list"][i]["id"]) < tonumber(minimum_id) then
				minimum_id = active["subtitle"]["list"][i]["id"]
			end
			debug_in_file(active["subtitle"]["list"][i]["id"] .. ' / ' .. active["subtitle"]["list"][i]["title"] .. '\n','c://1/track.txt')
			i=i+1
		end
	end
	if active["audio"] then
		debug_in_file('active["audio"]["currentID"] = ' .. active["audio"]["currentID"] .. '\n','c://1/track.txt')
		local i = 1
		while active["audio"]["list"][i] do
			if tonumber(active["audio"]["list"][i]["id"]) < tonumber(minimum_id) then
				minimum_id = active["audio"]["list"][i]["id"]
			end
			debug_in_file(active["audio"]["list"][i]["id"] .. ' / ' .. active["audio"]["list"][i]["title"] .. '\n','c://1/track.txt')
			i=i+1
		end
	end
	if active["video"] then
		debug_in_file('active["video"]["currentID"] = ' .. active["video"]["currentID"] .. '\n','c://1/track.txt')
		local i = 1
		while active["video"]["list"][i] do
			if tonumber(active["video"]["list"][i]["id"]) < tonumber(minimum_id) then
				minimum_id = active["video"]["list"][i]["id"]
			end
			debug_in_file(active["video"]["list"][i]["id"] .. ' / ' .. active["video"]["list"][i]["title"] .. '\n','c://1/track.txt')
			i=i+1
		end
	end
	return minimum_id
end
----------------------------------end debug
----------------------------------get color
local function ARGB(A,R,G,B)
   local a = A*256*256*256+R*256*256+G*256+B
   if A<128 then return a end
   return a - 4294967296
end
----------------------------------
function stena_pause_clear()
	m_simpleTV.User.TVPortal.isPause = false
	m_simpleTV.OSD.RemoveElement('ID_DIV_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_2')
end

local function Get_length(str)
	return m_simpleTV.Common.lenUTF8(str)
end

local function Get_isactiv(id)
	if id == nil then return end
	local verNumber, verString = m_simpleTV.Common.GetVersion()
	if verNumber < 1100 then return '' end
	local active = m_simpleTV.Control.GetTracksInfo()
	if active == nil then return end
	if active["video"] and active["video"]["currentID"] == -1 then
		m_simpleTV.User.TVPortal.res_video = nil
		m_simpleTV.User.TVPortal.codec_video = nil
	end
	if active["audio"] and active["audio"]["currentID"] == -1 then
		m_simpleTV.User.TVPortal.codec_audio = nil
		m_simpleTV.User.TVPortal.res_audio = nil
	end
	if active["subtitle"] and active["subtitle"]["currentID"] == -1 then
		m_simpleTV.User.TVPortal.lang_sub = nil
	end
	if active and
	(active["video"] and active["video"]["currentID"] and tonumber(id) == tonumber(active["video"]["currentID"]) or
		active["audio"] and active["audio"]["currentID"] and tonumber(id) == tonumber(active["audio"]["currentID"]) or
		active["subtitle"] and active["subtitle"]["currentID"] and tonumber(id) == tonumber(active["subtitle"]["currentID"]))
	then
		return '● '
	end
	return ''
end

local function Get_rating(rating)
	if rating == nil or rating == '' then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

local function Get_lang(lang)
	local t = {
	{'Russian','ru'},
	{'English','en'},
	{'Ukrainian','ua'},
	{'French','fr'},
	{'German','de'},
	{'Italian','it'},
	{'Spanish','es'},
	}
	for i = 1,#t do
		if lang == t[i][1] then return t[i][2] end
	end
	return '-'
end

local function Get_res_audio(res)
	local t = {
	{'Mono','1'},
	{'Stereo','2.0'},
	{'3F2M','5.0'},
	{'3F2R','5.0'},
	{'3F2M/LFE','5.1'},
	{'3F2R/LFE','5.1'},
	{'3F2M1R/LFE','7.1'},
	{'3F2M2R/LFE','7.1'},
	}
	for i = 1,#t do
		if res == t[i][1] then return t[i][2] end
	end
	return 'na'
end

local function Get_res(res)
	if res==nil then return end
	res = res:match('(%d+)')
	if tonumber(res) >= 3800 then
		return '4kbis'
	end
	if tonumber(res) >= 1400 then
		return '1080'
	end
	if tonumber(res) >= 1200 then
		return '720'
	end
	if tonumber(res) >= 800 then
		return '480'
	end
	return 'sd'
end

local function Get_codec(codec)
	codec = codec:match('%(.-%) %((.-)%)$') or codec:match('%((.-)%)$') or codec
	if codec then
		return codec:gsub(' $','')
	end
	return 'na'
end

function GetPortalTableForTVPortal_()
	if stena_desc_tvportal_content then
		if m_simpleTV.User.TVPortal.is_stena == false then
			m_simpleTV.User.TVPortal.is_stena = true
			return GetPortalTableForTVPortal()
		else
			return stena_clear()
		end
	end
end

if m_simpleTV.Control.Reason=='addressready' then
	if m_simpleTV.User.TVPortal.PortalShowWindowId then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowWindowId)
	end
	if m_simpleTV.User.TVPortal.PortalShowAdd then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowAdd)
	end
	if m_simpleTV.User.TVPortal.PortalShowMess then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowMess)
	end
	if m_simpleTV.User.TVPortal.PortalShowNext then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowNext)
	end
	m_simpleTV.User.TVPortal.is_stena = false
	if m_simpleTV.User.TVPortal.PortalTable~=nil then
		local t={}
		t.utf8 = true
		t.name = '-'
		t.luastring = ''
		t.lua_as_scr = false
		t.submenu = 'TVPortal WS'
		t.imageSubmenu = ''
		--t.key = string.byte('I')
		t.ctrlkey = 0
		t.location = 0
		t.image=''
		m_simpleTV.User.TVPortal.PortalSeparatorId = m_simpleTV.Interface.AddExtMenuT(t)
		local t={}
		t.utf8 = true
		t.name = 'TVPortal Info Window'
		t.luastring = 'GetPortalTableForTVPortal_()'
		t.lua_as_scr = true
		t.submenu = 'TVPortal WS'
		t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'
		t.key = string.byte('I')
		t.ctrlkey = 0
		t.location = 0
		t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/fw_box_t3.png'
		m_simpleTV.User.TVPortal.PortalShowWindowId = m_simpleTV.Interface.AddExtMenuT(t)
		local t={}
		t.utf8 = true
		t.name = 'Add to FAV Playlist'
		t.luastring = 'AddPortalTVAddressToPlaylist()'
		t.lua_as_scr = true
		t.submenu = 'TVPortal WS'
		t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'
		t.key = string.byte('I')
		t.ctrlkey = 1
		t.location = 0
		t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/fw_box_t2.png'
		m_simpleTV.User.TVPortal.PortalShowAdd = m_simpleTV.Interface.AddExtMenuT(t)
	end
		local t={}
		t.utf8 = true
		t.name = '-'
		t.luastring = ''
		t.lua_as_scr = false
		t.submenu = 'TVPortal WS'
		t.imageSubmenu = ''
		--t.key = string.byte('I')
		t.ctrlkey = 0
		t.location = 0
		t.image=''
		m_simpleTV.User.TVPortal.PortalSeparatorId = m_simpleTV.Interface.AddExtMenuT(t)
		local t={}
		t.utf8 = true
		t.name = 'Show Message'
		t.luastring = 'Show_Message()'
		t.lua_as_scr = true
		t.submenu = 'TVPortal WS'
		t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'
		t.key = string.byte('Z')
		t.ctrlkey = 0
		t.location = 0
		t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/fw_box_t.png'
		m_simpleTV.User.TVPortal.PortalShowMess = m_simpleTV.Interface.AddExtMenuT(t)
		local t={}
		t.utf8 = true
		t.name = 'Show Next Window'
		t.luastring = 'Show_Next_Window()'
		t.lua_as_scr = true
		t.submenu = 'TVPortal WS'
		t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'
		t.key = string.byte('X')
		t.ctrlkey = 0
		t.location = 0
		t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/fw_box_t.png'
		m_simpleTV.User.TVPortal.PortalShowNext = m_simpleTV.Interface.AddExtMenuT(t)
end

-------------------------
		if m_simpleTV.Control.GetState() == 3 and m_simpleTV.User.TVPortal.UseDesc and m_simpleTV.User.TVPortal.UseDesc == 1 then
			m_simpleTV.User.TVPortal.isPause = true
			m_simpleTV.OSD.RemoveElement('USER_LOGO_IMG_1_ID')
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('BALANSER_IMG_ID')
			m_simpleTV.OSD.RemoveElement('TEXT_0_ID')
			m_simpleTV.OSD.RemoveElement('TEXT_1_ID')
			m_simpleTV.OSD.RemoveElement('TEXT_2_ID')
			m_simpleTV.OSD.RemoveElement('TEXT_3_ID')
			m_simpleTV.OSD.RemoveElement('TEXT_4_ID')
			m_simpleTV.OSD.RemoveElement('TEXT_5_ID')
			m_simpleTV.OSD.RemoveElement('RIMDB_IMG_ID')
			m_simpleTV.OSD.RemoveElement('R_IMDB_IMG_ID')
			m_simpleTV.OSD.RemoveElement('RKP_IMG_ID')
			m_simpleTV.OSD.RemoveElement('R_KP_IMG_ID')
			m_simpleTV.OSD.RemoveElement('RTMDB_IMG_ID')
			m_simpleTV.OSD.RemoveElement('R_TMDB_IMG_ID')
			m_simpleTV.OSD.RemoveElement('VIDEO_IMG_ID')
			m_simpleTV.OSD.RemoveElement('CVIDEO_IMG_ID')
			m_simpleTV.OSD.RemoveElement('AUDIO_IMG_ID')
			m_simpleTV.OSD.RemoveElement('CAUDIO_IMG_ID')
			m_simpleTV.OSD.RemoveElement('CCB_IMG_ID')
			m_simpleTV.OSD.RemoveElement('CC_IMG_ID')
			m_simpleTV.OSD.RemoveElement('CCL_IMG_ID')
			m_simpleTV.OSD.RemoveElement('AUDIOB_IMG_ID')
			m_simpleTV.OSD.RemoveElement('AUDIOI_IMG_ID')
			m_simpleTV.OSD.RemoveElement('AUDIOL_IMG_ID')

		end

		if m_simpleTV.Control.GetState() == 4 and
			m_simpleTV.User.TVPortal.isPause == true and
			m_simpleTV.User.TVPortal.mess and
			m_simpleTV.User.TVPortal.logo and
			m_simpleTV.User.TVPortal.logo ~= '' and
			m_simpleTV.User.TVPortal.title then

			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')

			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			local add = 0

			 t = {}
			 t.id = 'ID_DIV_1'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=-80 / m_simpleTV.Interface.GetScale()*1.5
			 t.once=1
			 t.zorder=1
			 t.background = -1
			 t.backcolor0 = 0xff000000
			 AddElement(t)

			 t = {}
			 t.id = 'ID_DIV_2'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0 / m_simpleTV.Interface.GetScale()*1.5
			 t.top=0 / m_simpleTV.Interface.GetScale()*1.5
			 t.once=1
			 t.zorder=0
			 t.background = 1
			 t.backcolor0 = 0x440000FF
--			 t.backcolor1 = 0x77FFFFFF
			 AddElement(t)

			 t = {}
			 t.id = 'FON_ID'
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
			 AddElement(t,'ID_DIV_2')

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
				t.top=130
				t.transparency = 255
				t.zorder=2
				t.isInteractive = true
				t.cursorShape = 13
				t.mousePressEventFunction = 'stena_pause_clear'
				AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'USER_LOGO_IMG_1_ID'
			 t.cx= 300 / 1*1.25
			 t.cy= 450 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.TVPortal.logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=250 / 1*1.25
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'BALANSER_IMG_ID'
			 t.cx= 122 / 1*1.25
			 t.cy= 116 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/' .. (m_simpleTV.User.TVPortal.balanser or 'Unknown') .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left= 20 / 1*1.25
			 t.top= 142 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'RIMDB_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/imdb.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'R_IMDB_IMG_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.ret_imdb) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=25 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'RKP_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/kinopoisk.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=125 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'R_KP_IMG_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.ret_KP) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=130 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'RTMDB_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tmdb.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=230 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'R_TMDB_IMG_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.ret_tmdb) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=235 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			if m_simpleTV.User.TVPortal.res_video and m_simpleTV.User.TVPortal.codec_video then
			 add = 200
			 t = {}
			 t.id = 'VIDEO_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/video/' .. m_simpleTV.User.TVPortal.res_video .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(155+add) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'CVIDEO_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/video/' .. m_simpleTV.User.TVPortal.codec_video .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+add) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')
			end

			if m_simpleTV.User.TVPortal.lang_audio then
			 add = add+100
			 t = {}
			 t.id = 'AUDIOB_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+add) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'AUDIOI_IMG_ID'
			 t.cx= 36 / 1*1.25
			 t.cy= 36 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/audio.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(265+add) / 1*1.25
			 t.top=182 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'AUDIOL_IMG_ID'
			 t.cx= 27 / 1*1.25
			 t.cy= 18 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/flags/' .. m_simpleTV.User.TVPortal.lang_audio .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(305+add) / 1*1.25
			 t.top=190 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')
			end

			if m_simpleTV.User.TVPortal.res_audio then
			 add = add+100
			 t = {}
			 t.id = 'AUDIO_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/audio/' .. m_simpleTV.User.TVPortal.res_audio .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+add) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')
			end

			if m_simpleTV.User.TVPortal.codec_audio then
			add = add+100
			 t = {}
			 t.id = 'CAUDIO_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/audio/' .. m_simpleTV.User.TVPortal.codec_audio .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+add) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')
			end

			if m_simpleTV.User.TVPortal.lang_sub then
			 add = add+100
			 t = {}
			 t.id = 'CCB_IMG_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+add) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'CC_IMG_ID'
			 t.cx= 36 / 1*1.25
			 t.cy= 36 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/subtitle_cc.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(265+add) / 1*1.25
			 t.top=182 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')

			 t = {}
			 t.id = 'CCL_IMG_ID'
			 t.cx= 27 / 1*1.25
			 t.cy= 18 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/flags/' .. m_simpleTV.User.TVPortal.lang_sub .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(305+add) / 1*1.25
			 t.top=190 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_1')
			end

			 t={}
			 t.id = 'TEXT_0_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.slogan
			 t.color = -9113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_italic = 1
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 195 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_1')

			 t={}
			 t.id = 'TEXT_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.title
			 t.color = -2123993
			 t.font_height = -35 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_underline = 1
			 t.font_name = "Segoe UI Black"
			 t.textparam = 1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 210 / 1*1.5
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.color_UnderMouse = ARGB(255, 65, 105, 225)
					t.glowcolor_UnderMouse = 0xFFFFFFFF
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.mousePressEventFunction = 'show_info_tmdb'
			 AddElement(t,'ID_DIV_1')

			 t={}
			 t.id = 'TEXT_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.title_en
			 t.color = -2113993
			 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 265 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_1')

			 t={}
			 t.id = 'TEXT_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.year .. ' ● ' .. m_simpleTV.User.TVPortal.country .. (m_simpleTV.User.TVPortal.age or '') ..  (m_simpleTV.User.TVPortal.time_all or '')
			 t.color = -2113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15
			 t.left = 355 / 1*1.25
			 t.top  = 315 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_1')

			local delta = 0
			if m_simpleTV.User.TVPortal.genres and #m_simpleTV.User.TVPortal.genres then
			 for j=1,#m_simpleTV.User.TVPortal.genres do

			 t={}
			 t.id = 'TEXT_GENRES_' .. j .. '_ID'
			 t.cx=0
			 t.cy=0
			 t.once = 0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = ' ● ' .. m_simpleTV.User.TVPortal.genres[j].Name .. ' '
			 t.color = -2113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 425 + delta
			 delta = delta + Get_length(t.text)*18
			 t.top  = 340 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 t.borderwidth = 1
			 t.backroundcorner = 3*3
			 if movie_genres28 then
				 t.isInteractive = true
				 t.background_UnderMouse = 0
				 t.backcolor0_UnderMouse = 0xEE4169E1
				 t.backcolor1_UnderMouse = 0
				 t.bordercolor_UnderMouse = ARGB(255, 0, 0, 205)
				 t.cursorShape = 13
				 if m_simpleTV.User.TVPortal.genres[j].Type == 0 then
				  t.mousePressEventFunction = 'movie_genres' .. m_simpleTV.User.TVPortal.genres[j].Id
				 elseif m_simpleTV.User.TVPortal.genres[j].Type == 1 then
				  t.mousePressEventFunction = 'tv_genres' .. m_simpleTV.User.TVPortal.genres[j].Id
				 end
			 end
			 AddElement(t,'ID_DIV_1')

			end
			end

			 t={}
			 t.id = 'TEXT_5_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = -2113993
			 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 if m_simpleTV.User.TVPortal.UseWindow and m_simpleTV.User.TVPortal.UseWindow == 1 then
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.TVPortal.overview .. '\n\n\n'
			 t.boundWidth = 50
			 t.row_limit=4
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 else
			 t.glow = 1.6 -- коэффициент glow эффекта
			 t.text = m_simpleTV.User.TVPortal.mess .. '\n\n\n\n\n\n\n\n'
			 end
			 t.color_UnderMouse = ARGB(255, 65, 105, 225)
--			 t.glowcolor_UnderMouse = 0xFFFFFFFF
			 t.glow_samples_UnderMouse = 4
			 t.isInteractive = true
			 t.cursorShape = 13
			 t.textparam = 0--1+4
			 t.left = 380 / 1*1.25
			 t.top  = 380 / 1*1.5
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 t.mousePressEventFunction = 'Show_Next_Window'
			 AddElement(t,'ID_DIV_1')

			if m_simpleTV.User.TVPortal.UseWindow and
				m_simpleTV.User.TVPortal.UseWindow == 1 and
				m_simpleTV.User.TVPortal.persons and
				m_simpleTV.User.TVPortal.persons[1]
				then
				for j = 1,#m_simpleTV.User.TVPortal.persons do
				t = {}
				t.id = 'PERSON_' .. j .. '_IMG_ID'
				t.cx=125
				t.cy=125
				t.class="IMAGE"
				t.imagepath = m_simpleTV.User.TVPortal.persons[j].logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 425 + (j-1)*150
			    t.top  = 750
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				if personWork1 then
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.mousePressEventFunction = 'personWork' .. j
				end
				AddElement(t,'ID_DIV_1')
				end
				for j = 1,#m_simpleTV.User.TVPortal.persons do
				t = {}
				t.id = 'PERSON_' .. j .. '_TEXT_ID'
				t.cx=125
				t.cy=0
				t.class="TEXT"
				t.text = '\n\n\n\n' .. m_simpleTV.User.TVPortal.persons[j].name .. '\n\n\n'
				t.align = 0x0101
				t.color = -2113993
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 425 + (j-1)*150
			    t.top  = 760
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				if personWork1 then
					t.color_UnderMouse = ARGB(255, 65, 105, 225)
					t.glowcolor_UnderMouse = 0xFFFFFFFF
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.mousePressEventFunction = 'personWork' .. j
				end
				AddElement(t,'ID_DIV_1')
				end
			end

			 m_simpleTV.User.TVPortal.isPause = nil
		 end

-------------------------
if m_simpleTV.Control.Reason=='Error' then
--	m_simpleTV.OSD.ShowMessage('r - ' .. m_simpleTV.Control.Reason .. ',addr= ' .. m_simpleTV.Control.CurrentAddress .. ',radr=' .. m_simpleTV.Control.RealAddress ,255,1)
--	m_simpleTV.Control.PlayAddressT({address = 'wait'})
	show_portal_window()
end


if m_simpleTV.Control.Reason=='Stopped' or
--	m_simpleTV.Control.Reason=='Error' or
	m_simpleTV.Control.Reason == 'EndReached' then

	m_simpleTV.User.TVPortal.PortalTable=nil
	m_simpleTV.User.TVPortal.logo=nil
	m_simpleTV.User.TVPortal.mess=nil
	m_simpleTV.User.TVPortal.age=nil
	m_simpleTV.User.TVPortal.time_all=nil
	m_simpleTV.User.TVPortal.ret_imdb=nil
	m_simpleTV.User.TVPortal.ret_KP=nil
	m_simpleTV.User.TVPortal.ret_tmdb=nil
	m_simpleTV.User.TVPortal.lang_sub=nil
    m_simpleTV.User.TVPortal.res_video=nil
	m_simpleTV.User.TVPortal.res_audio=nil
    m_simpleTV.User.TVPortal.codec_video=nil
    m_simpleTV.User.TVPortal.codec_audio=nil
	m_simpleTV.User.TVPortal.lang_audio=nil
	m_simpleTV.User.TVPortal.balanser=nil
	m_simpleTV.User.TVPortal.active=nil
	m_simpleTV.User.TVPortal.persons=nil
	m_simpleTV.User.TVPortal.is_stena = nil
	if m_simpleTV.User.TVPortal.PortalShowWindowId then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowWindowId)
	end
	if m_simpleTV.User.TVPortal.PortalShowAdd then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowAdd)
	end
	if m_simpleTV.User.TVPortal.PortalShowMess then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowMess)
	end
	if m_simpleTV.User.TVPortal.PortalShowNext then
		m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.PortalShowNext)
	end
	m_simpleTV.OSD.RemoveElement('USER_LOGO_IMG_1_ID')
	m_simpleTV.OSD.RemoveElement('ID_DIV_1')
	m_simpleTV.OSD.RemoveElement('ID_DIV_2')
	m_simpleTV.OSD.RemoveElement('BALANSER_IMG_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_0_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_1_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_2_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_3_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_4_ID')
	m_simpleTV.OSD.RemoveElement('TEXT_5_ID')
	m_simpleTV.OSD.RemoveElement('RIMDB_IMG_ID')
	m_simpleTV.OSD.RemoveElement('R_IMDB_IMG_ID')
	m_simpleTV.OSD.RemoveElement('RKP_IMG_ID')
	m_simpleTV.OSD.RemoveElement('R_KP_IMG_ID')
	m_simpleTV.OSD.RemoveElement('RTMDB_IMG_ID')
	m_simpleTV.OSD.RemoveElement('R_TMDB_IMG_ID')
	m_simpleTV.OSD.RemoveElement('VIDEO_IMG_ID')
	m_simpleTV.OSD.RemoveElement('CVIDEO_IMG_ID')
	m_simpleTV.OSD.RemoveElement('AUDIO_IMG_ID')
	m_simpleTV.OSD.RemoveElement('CAUDIO_IMG_ID')
	m_simpleTV.OSD.RemoveElement('CCB_IMG_ID')
	m_simpleTV.OSD.RemoveElement('CC_IMG_ID')
	m_simpleTV.OSD.RemoveElement('CCL_IMG_ID')
	m_simpleTV.OSD.RemoveElement('AUDIOB_IMG_ID')
	m_simpleTV.OSD.RemoveElement('AUDIOI_IMG_ID')
	m_simpleTV.OSD.RemoveElement('AUDIOL_IMG_ID')
	m_simpleTV.OSD.ShowMessage_UTF8('')
end

if m_simpleTV.Control.Reason == 'Playing' then
   m_simpleTV.Control.EventPlayingInterval=2000
   if m_simpleTV.Control.RealAddress:match('ost%.etvs%.') then m_simpleTV.User.TVPortal.balanser = 'FoxMedia' end
   local cur_full = m_simpleTV.Interface.GetFullScreenMode()
   if not m_simpleTV.User.TVPortal.cur_full and cur_full or m_simpleTV.User.TVPortal.cur_full and not cur_full then
    m_simpleTV.User.TVPortal.isPause = true
   end
   m_simpleTV.User.TVPortal.cur_full = cur_full
   if m_simpleTV.User.TVPortal.IsFoxRoom == true then
	local name_for_media = m_simpleTV.Control.GetMetaInfo(0)
	name_for_media = name_for_media:gsub('%(',''):gsub('%)',''):gsub('%.',' '):gsub('_','')
	local title, year = name_for_media:match('(.-) (%d%d%d%d)')
	if title and year then
	 m_simpleTV.OSD.ShowMessage_UTF8(title .. ' (' .. year .. ')',0x0000FF00,10 )
	 info_fox(title,year,'')
	 m_simpleTV.User.TVPortal.IsFoxRoom = false
	end
   end
--   local minimum_id = Get_tracks()
--   if minimum_id == false then return end
   local mess=''
   local ss = m_simpleTV.Control.GetCodecInfo()
   local i,act,j=1,{},1
	while ss and ss[i] and type(ss[i])=='table' do
     if ss[i]["Type"]~=nil and ss[i]["Codec"]~=nil then
--[[
	 if ss[i]["EsMetaId"] then
	  debug_in_file('["EsMetaId"] = ' .. ss[i]["EsMetaId"] .. ' or ' .. (ss[i]["Original ID"] or (minimum_id + i - 1) or i-1) .. '\n','c://1/track.txt')
	 end
	 local original_id = ss[i]["Original ID"] or (minimum_id + i - 1) or i-1
--]]
	 local original_id = ss[i]["Original ID"] or ss[i]["EsMetaId"]
	 local lang, desc, btr = '', '', ''
	  if (ss[i]["Type"] == 'Audio' or ss[i]["Type"] == 'Subtitle') and ss[i]["Language"] or
	  ss[i]["Type"] == 'Video' and ss[i]["Video resolution"] and ss[i]["Video resolution"] ~= '' then
	   if ss[i]["Type"] == 'Video' then lang = ' | ' .. ss[i]["Video resolution"]
	    else lang = ' | ' .. ss[i]["Language"]
	   end
	  end
	  if ss[i]["Description"] then desc = ' | ' .. ss[i]["Description"] end
	  if ss[i]["Channels"] then desc = ' | ' .. ss[i]["Channels"] end
	  local isactive = Get_isactiv(original_id)
	  if isactive and isactive ~= '' then
	   if ss[i]["Type"] == 'Video' then
		m_simpleTV.User.TVPortal.res_video = Get_res(ss[i]["Video resolution"])
		m_simpleTV.User.TVPortal.codec_video = Get_codec(ss[i]["Codec"])
		if ss[i]["Frame rate"] then
		 btr = ' | ' .. ss[i]["Frame rate"] .. ' fps'
	    end
	   end
	   if ss[i]["Type"] == 'Audio' then
		m_simpleTV.User.TVPortal.codec_audio = Get_codec(ss[i]["Codec"])
		if ss[i]["Channels"] then
		 m_simpleTV.User.TVPortal.res_audio = Get_res_audio(ss[i]["Channels"])
		end
		if ss[i]["Language"] then
		 m_simpleTV.User.TVPortal.lang_audio = Get_lang(ss[i]["Language"])
	    end
		if ss[i]["Sample rate"] then
		 btr = ' | ' .. ss[i]["Sample rate"]
	    end
	   end
	   if ss[i]["Type"] == 'Subtitle' then
		m_simpleTV.User.TVPortal.lang_sub = Get_lang(ss[i]["Language"])
	   end
	  end
      mess = mess .. (isactive or '') .. ss[i]["Type"] .. lang .. desc .. ' | ' .. ss[i]["Codec"] .. btr .. '\n'
	  act[j] = isactive
	  j=j+1
     end
	i = i + 1
   end
   if m_simpleTV.User.TVPortal.active and act then
	for j=1,#act do
	 if act[j] ~= m_simpleTV.User.TVPortal.active[j] then
	  m_simpleTV.User.TVPortal.isPause = true
	 end
	end
   end
   m_simpleTV.User.TVPortal.active = act
   if mess ~= '' then
    if m_simpleTV.User.TVPortal.UseMes and m_simpleTV.User.TVPortal.UseMes == 1 then
     m_simpleTV.OSD.ShowMessage_UTF8(mess,0x0000FF00,10 )
	end
	m_simpleTV.User.TVPortal.mess = mess
   end
end

--[[
if m_simpleTV.Control.Reason == 'Stopped' or m_simpleTV.Control.Reason == 'EndReached' then
   m_simpleTV.OSD.ShowMessage_UTF8('')
end
--]]