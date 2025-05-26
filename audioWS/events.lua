-- events for Audio plugin
-- author west_side 14.07.24

	if m_simpleTV.Control.CurrentAddress==nil then return end
	if m_simpleTV.User.AudioWS == nil then m_simpleTV.User.AudioWS = {} end
	if m_simpleTV.User.AudioWS and m_simpleTV.User.AudioWS.Use and tonumber(m_simpleTV.User.AudioWS.Use) ~= 1 then return end
	if not m_simpleTV.Control.CurrentAddress:match('^http://radiorecord%.hostingradio%.ru/') and
	not m_simpleTV.Control.CurrentAddress:match('%.hostingradio%.ru') and
	not m_simpleTV.Control.CurrentAddress:match('pcradio%.ru') and
	not m_simpleTV.Control.CurrentAddress:match('^http://.-8000/.+') and
	not m_simpleTV.Control.CurrentAddress:match('^http://harddanceradio.+') and
	not m_simpleTV.Control.CurrentAddress:match('^http://dancewave.+') and
	not m_simpleTV.Control.CurrentAddress:match('^http://retro%.dancewave.+') and
	not m_simpleTV.Control.CurrentAddress:match('^https://.-playernostalgie.+')	and
	not m_simpleTV.Control.CurrentAddress:match('^webradio_network_id=.+') and
	not m_simpleTV.Control.CurrentAddress:match('somafm%.com') and
	not m_simpleTV.Control.CurrentAddress:match('^https://www%.maxradio%.ca') and
	not m_simpleTV.Control.CurrentAddress:match('^http://stream%.radioparadise%.com') and
	not m_simpleTV.Control.CurrentAddress:match('^https://frequence3%.net%-radio%.fr') and
	not m_simpleTV.Control.CurrentAddress:match('^http://secure%.live%-streams%.nl') and
	not m_simpleTV.Control.CurrentAddress:match('^https://chillout%.zone') and
	not m_simpleTV.Control.CurrentAddress:match('^http://content%.audioaddict%.com') and
	not m_simpleTV.Control.CurrentAddress:match('^https://casseta%-disco')
	then return end
	if m_simpleTV.Control.IsVideo() then
		m_simpleTV.Interface.RestoreBackground()
		m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
		m_simpleTV.OSD.RemoveElement('USER_LOGO_AUDIO_IMG_ID')
		m_simpleTV.OSD.RemoveElement('ID_DIV_AUDIO_1')
		m_simpleTV.OSD.RemoveElement('ID_DIV_AUDIO_2')
		m_simpleTV.OSD.RemoveElement('TEXT_AUDIO_1_ID')
		m_simpleTV.OSD.RemoveElement('TEXT_AUDIO_2_ID')
		m_simpleTV.OSD.RemoveElement('TEXT_AUDIO_3_ID')
		m_simpleTV.User.AudioWS.title = nil
		m_simpleTV.User.AudioWS.logo = nil
		m_simpleTV.User.AudioWS.Name = nil
		m_simpleTV.User.AudioWS.img = nil
		m_simpleTV.User.AudioWS.images = nil
		m_simpleTV.User.AudioWS.logos = nil
		m_simpleTV.User.AudioWS.TrackCash = nil
	return
	end
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
	if m_simpleTV.User.AudioWS.Use and m_simpleTV.User.AudioWS.Use == 0 then return end
	if m_simpleTV.User.AudioWS.images==nil then m_simpleTV.User.AudioWS.images={} end
	if m_simpleTV.User.AudioWS.logos==nil then m_simpleTV.User.AudioWS.logos={} end

local function check_img(adr)
	local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 1000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = adr, method = 'head'})
	m_simpleTV.Http.Close(session)
		if rc == 200 then
			return true
		end
	return false
end

local function get_img(s)
--	local timer1, timer2
--	timer1 = os.time()
	local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://www.google.com/search?as_st=y&tbm=isch&hl=ru&as_epq=&as_oq=&as_eq=&cr=&as_sitesearch=&safe=images&tbs=iar:w&as_q='
	url = url .. m_simpleTV.Common.toPercentEncoding(s)
	local t={}
	t.url = url
	t.headers = 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\nauthority: https://www.google.com/\nsec-fetch-mode: navigate\nsec-fetch-site: same-origin\nuser-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36\ncookie: ' .. "'" .. (m_simpleTV.User.AudioWS.Cookies or '') .. "'"
	local rc, answer =  m_simpleTV.Http.Request(session, t)
--	debug_in_file(url .. '\n' .. (answer or 'not') .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	if rc~=200 then
	m_simpleTV.Http.Close(session)
	return
	end
--	debug_in_file('-- прямоугольные ------------\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	local slide = 1
	if m_simpleTV.User.AudioWS.Slide and tonumber(m_simpleTV.User.AudioWS.Slide) == 1 then slide = 5 end
	local t1, i = {}, 1
	for w in answer:gmatch('%["https://encrypted.-%[".-"') do

		local img = w:match('encrypted.-%["(.-)"')
		if not img then break end
		if (img:match('%.jpg') or img:match('%.jpeg')) and not img:match('notado%.ru') and not img:match('webkind%.ru') and not img:match('cdvpodarok%.ru') and check_img(img:gsub('%.jpg.-$','.jpg'):gsub('%.jpeg.-$','.jpeg')) then
		if i > slide then break end
			t1[i] = {}
			t1[i].image = img:gsub('%.jpg.-$','.jpg')
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/audioWS/img/audioWS.png"', text = ' Background: ' .. i, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
--			debug_in_file(t1[i].image .. ' - ' .. i .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
			i = i + 1
		end
	end
--	timer2 = os.time() - timer1
--	debug_in_file(timer2 .. ' -- прямоугольные\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	m_simpleTV.Http.Close(session)
	m_simpleTV.User.AudioWS.images=t1
	if m_simpleTV.User.AudioWS.images and #m_simpleTV.User.AudioWS.images ~= 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
end

local function get_img1(s)
	local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
	local url = 'https://www.google.com/search?as_st=y&tbm=isch&hl=ru&as_epq=&as_oq=&as_eq=&cr=&as_sitesearch=&safe=images&tbs=iar:s&as_q='
	url = url .. m_simpleTV.Common.toPercentEncoding(s)
	local t={}
	t.url = url
	t.headers = 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\nauthority: https://www.google.com/\nsec-fetch-mode: navigate\nsec-fetch-site: same-origin\nuser-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36\ncookie: ' .. "'" .. (m_simpleTV.User.AudioWS.Cookies or '') .. "'"
	local rc, answer =  m_simpleTV.Http.Request(session, t)
--	debug_in_file(url .. '\n' .. (answer or 'not') .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	if rc~=200 then
	m_simpleTV.Http.Close(session)
	return
	end
--	debug_in_file('-- квадратные ---------------\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	local slide = 1
	if m_simpleTV.User.AudioWS.Slide and tonumber(m_simpleTV.User.AudioWS.Slide) == 1 then slide = 5 end
	local t1, i = {}, 1
	for w in answer:gmatch('%["https://encrypted.-%[".-"') do

		local img = w:match('encrypted.-%["(.-)"')
		if not img then break end
		if (img:match('%.jpg') or img:match('%.jpeg')) and not img:match('notado%.ru') and not img:match('webkind%.ru') and not img:match('cdvpodarok%.ru') and check_img(img:gsub('%.jpg.-$','.jpg'):gsub('%.jpeg.-$','.jpeg')) then
		if i > slide then break end
			t1[i] = {}
			t1[i].image = img:gsub('%.jpg.-$','.jpg')
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/audioWS/img/audioWS.png"', text = ' Logo: ' .. i, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
--			debug_in_file(t1[i].image .. ' - ' .. i .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
			i = i + 1
		end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.User.AudioWS.logos=t1
end

	local tab = {
	{"NOSTALGIE","https://www.nostalgie.fr/uploads/assets/nostalgie/icons/android-icon-192x192.png","https://www.nostalgie.fr/onair"},
	{"NRJ","https://www.nrj.fr/uploads/assets/nrj/icons/android-icon-192x192.png","https://www.nrj.fr/onair"},
	{"RIRE","https://www.rireetchansons.fr/uploads/assets/rire/icons/android-icon-192x192.png","https://www.rireetchansons.fr/onair"},
	{"CHERIE","https://www.cheriefm.fr/uploads/assets/cherie/icons/android-icon-192x192.png","https://www.cheriefm.fr/onair"},
	}

local function getadr(name)
	local adr = ''
	for i=1,#tab do
--	debug_in_file(tab[i][1] .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
		if string.find(name, tab[i][1],1,true) then
		adr = tab[i][3]
		break
		end
	end
	return adr .. '.json'
	end

local title, track, typerad
local inAdr = m_simpleTV.Control.CurrentAddress

if inAdr:match('https?://213%.141%..-:8000/.+')
	or inAdr:match('https?://79%.111%..-:8000/.+')
	or inAdr:match('https?://79%.120%..-:8000/.+') then
	typerad = 'radcap'
	local host = inAdr:gsub(':8000/.-$', '')
	local sid = inAdr:gsub('%$.-$', ''):gsub('^.-//.-/', '')
	local userAgent = ('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	local session = m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	url = host .. ':8000/status.xsl?mount=/' .. sid .. '&_=' .. os.time()
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
	title = answer:match('>Current Song.-streamdata">(.-)<')
	-- debug_in_file(title .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
end

if inAdr:match('https?://casseta%-disco.+') then
	typerad = 'discobonus'
	local id = inAdr:match('/discobonus/(%d+)')
	local s_id
	if id == 1 then s_id = 1 else s_id = id - 1 end
	local userAgent = ('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	local session = m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	url = 'https://casseta-disco.ru:1030/api/v2/djs/?server=' .. s_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
	title = answer:match('"metadata".-"(.-)"')
--	 debug_in_file(answer .. '\n' .. title .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
end

if inAdr:match('^https://.-playernostalgie.+') then
	typerad = 'NRJ'
	local userAgent = ('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	local session = m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local name
	if m_simpleTV.User.AudioWS.Name then
		name = m_simpleTV.User.AudioWS.Name
	else
		local t1 = m_simpleTV.Control.GetCurrentChannelInfo()
		name = t1.Name:gsub('%&amp%;','&')
	end

	url = getadr(name:gsub(' .-$',''))
--	debug_in_file(name .. ': ' .. url .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
		require('json')
		if not answer then return end
		answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '""')

		local tt = json.decode(answer)
		local k = 1
		if not tt or not tt[1] or not tt[1].name then return end
		while true do
			if not tt[k] or not tt[k].name then break end
--			debug_in_file(tt[k].name .. ': ' .. tt[k].playlist[1].song.artist .. ' - ' .. tt[k].playlist[1].song.title:gsub('\\u0027',"'") .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
			if tt[k].name == name then
			title = tt[k].playlist[1].song.artist:gsub('\\u0027',"'"):gsub('\\u0026','&'):gsub('\\u00e0','u'):gsub('\\u00f9','a'):gsub('\\u00c9',"'") .. ' - ' .. tt[k].playlist[1].song.title:gsub('\\u0027',"'"):gsub('\\u0026','&'):gsub('\\u00e0','u'):gsub('\\u00f9','a'):gsub('\\u00c9',"'")
			m_simpleTV.User.AudioWS.logo1 = tt[k].playlist[1].song.img_url
			m_simpleTV.User.AudioWS.img1 = tt[k].playlist[1].song.img_url
			end
			k=k+1
		end
end

if inAdr:match('^https://frequence3%.net%-radio%.fr') then
	typerad = 'Frequense 3'
	local userAgent = ('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	local session = m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local name
	if m_simpleTV.User.AudioWS.Name then
		name = m_simpleTV.User.AudioWS.Name
	else
		local t1 = m_simpleTV.Control.GetCurrentChannelInfo()
		name = t1.Name:gsub('%&amp%;','&')
	end

	url = 'https://api2.frequence3.net/v2/mobile/getCurrentTracks'
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
		require('json')
		if not answer then return end
		answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '""')

		local tt = json.decode(answer)
		local k = 1
		if not tt or not tt[1] or not tt[1].name then return end
		while true do
			if not tt[k] or not tt[k].name then break end
--			debug_in_file(name:gsub('é','e') .. ' = ' .. tt[k].name:gsub('\\u00e9','e') .. ': ' .. tt[k].track.track .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
			if tt[k].name:gsub('\\u00e9','e'):gsub('%-','') == name:gsub('é','e'):gsub('%-','') then
			title = tt[k].track.track:gsub('\\u00e9','e'):gsub('\\u00eu','u')
			m_simpleTV.User.AudioWS.logo1 = tt[k].track.cover300
			m_simpleTV.User.AudioWS.img1 = tt[k].track.coverbig
			end
			k=k+1
		end
end

if inAdr:match('www%.maxradio%.ca') then
	typerad = 'MaxRadio'
	local userAgent = ('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	local session = m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local name
	if m_simpleTV.User.AudioWS.Name then
		name = m_simpleTV.User.AudioWS.Name
	else
		local t1 = m_simpleTV.Control.GetCurrentChannelInfo()
		name = t1.Name:gsub('%&amp%;','&')
	end

	url = 'https://www.' .. inAdr:match('/UHD/(.-)/FLAC/') .. '.ca/nowplaying/'
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if not answer then return end
	title = answer:match('"playing_track"><strong>(.-)<')
	if title then title = title:gsub('%&%#039%;',"'"):gsub(' %[.-$','') end
end

if inAdr:match('^http://content%.audioaddict%.com.+') then
	typerad = 'WWW'
	title = m_simpleTV.User.AudioWS.title_track
end

if inAdr == 'https://hls.somafm.com/hls/groovesalad/FLAC/program.m3u8' then
	typerad = 'Groove Salad'
	local userAgent = ('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	local session = m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	url = 'https://somafm.com/groovesalad/songhistory.html'
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return end
	local title1,title2 = answer:match('%(Now%).-title=".-" >(.-)</a></td><td>(.-)</td>')
	title = title1 .. ' - ' .. title2
end

	if m_simpleTV.Control.Reason == 'Playing' then

		m_simpleTV.Control.EventPlayingInterval=20000
--[[		for i =0,12 do
		debug_in_file(m_simpleTV.Control.GetMetaInfo(i) .. ' - ' .. i .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
		end--]]
		if typerad==nil then
			title = m_simpleTV.Control.GetMetaInfo(12)
		end
--[[		if typerad == 'radcap' then
			m_simpleTV.OSD.ShowMessageT({text = title:gsub('%&amp%;','&'), showTime = 1000 * 30})
		end--]]
		typerad = nil

		if title and title == '' or title == nil then title = m_simpleTV.Control.GetMetaInfo(1) or '' end
--		debug_in_file(title .. ' - \n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
		if title and title == '' or title == nil then return end

		if title then
			m_simpleTV.User.AudioWS.TrackCash = title
			m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.AudioWS.TrackCash
		end

		track = title:gsub('^.-%- ',''):gsub('^.-%| ','')
		title = title:gsub('A %- HA','A-HA'):gsub(' %-.-$',''):gsub('^.-%| ','')

		if title and title~='' and title~=m_simpleTV.User.AudioWS.title or title and title==m_simpleTV.User.AudioWS.title and m_simpleTV.User.AudioWS.images == nil then

			if m_simpleTV.Control.MainMode == 0 then

				local  t, AddElement = {}, m_simpleTV.OSD.AddElement
				 t.BackColor = 0
				 t.BackColorEnd = 255
				 t.PictFileName = m_simpleTV.User.AudioWS.img1
				 t.TypeBackColor = 0
				 t.UseLogo = 4
				 t.Once = 1
				 t.Blur = 5
				 m_simpleTV.Interface.SetBackground(t)

				 t = {}
				 t.id = 'ID_DIV_AUDIO_1'
				 t.cx=-100 * m_simpleTV.Interface.GetScale()
				 t.cy=-50 * m_simpleTV.Interface.GetScale()
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0201
				 t.left=0
				 t.top=30 * m_simpleTV.Interface.GetScale()
				 t.once=1
				 t.zorder=0
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_AUDIO_2'
				 t.cx=700 * m_simpleTV.Interface.GetScale()
				 t.cy=-95 * m_simpleTV.Interface.GetScale()
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=20 * m_simpleTV.Interface.GetScale()
				 t.top=20 * m_simpleTV.Interface.GetScale()
				 t.once=1
				 t.zorder=0
				 t.background = -1
				 t.backcolor0 = 0x7fFFFF00
				 AddElement(t,'ID_DIV_AUDIO_1')

				 t = {}
				 t.id = 'USER_LOGO_AUDIO_IMG_ID'
				 t.cx=180 * m_simpleTV.Interface.GetScale()
				 t.cy=180 * m_simpleTV.Interface.GetScale()
				 t.class="IMAGE"
				 t.imagepath = m_simpleTV.User.AudioWS.logo1
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=20 * m_simpleTV.Interface.GetScale()
				 t.top=0
				 t.transparency = 200
				 t.zorder=0
				 t.borderwidth = 2
				 t.bordercolor = -6250336
				 t.backroundcorner = 20*20
				 t.borderround = 20
				 AddElement(t,'ID_DIV_AUDIO_1')

				 t={}
				 t.id = 'TEXT_AUDIO_1_ID'
				 t.cx=0
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = m_simpleTV.User.AudioWS.Name
				 t.color = -2113993
				 t.font_height = -35 * m_simpleTV.Interface.GetScale()
				 t.font_weight = 400 * m_simpleTV.Interface.GetScale()
				 t.font_underline = 1
				 t.font_name = "Impact"
				 t.textparam = 0--1+4
				 t.left = 200 * m_simpleTV.Interface.GetScale()
				 t.top  = 0
				 t.glow = 3 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'USER_LOGO_AUDIO_IMG_ID')

				 t={}
				 t.id = 'TEXT_AUDIO_3_ID'
				 t.cx=0
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = title:gsub('%&amp%;','&')
				 t.color = -2113993
				 t.font_height = -25 * m_simpleTV.Interface.GetScale()
				 t.font_weight = 300 * m_simpleTV.Interface.GetScale()
				 t.font_name = "Impact"
				 t.textparam = 0--1+4
				 t.left = 200 * m_simpleTV.Interface.GetScale()
				 t.top  = 70 * m_simpleTV.Interface.GetScale()
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'USER_LOGO_AUDIO_IMG_ID')

				 t={}
				 t.id = 'TEXT_AUDIO_2_ID'
				 t.cx=0
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0101
				 t.text = track:gsub('%&amp%;','&')
				 t.color = -2113993
				 t.font_height = -15 * m_simpleTV.Interface.GetScale()
				 t.font_weight = 200 * m_simpleTV.Interface.GetScale()
				 t.font_name = "Impact"
				 t.textparam = 0--1+4
				 t.left = 200 * m_simpleTV.Interface.GetScale()
				 t.top  = 120 * m_simpleTV.Interface.GetScale()
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'USER_LOGO_AUDIO_IMG_ID')
			end
			get_img(title .. '+музыка+песни')
			get_img1(title .. '+музыка+песни')
		end
		if m_simpleTV.User.AudioWS.images and m_simpleTV.User.AudioWS.images[1] and m_simpleTV.User.AudioWS.images[1].image then
			m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		else
			get_img(title .. '+музыка+песни')
		end
		if m_simpleTV.User.AudioWS.logos and m_simpleTV.User.AudioWS.logos[1] and m_simpleTV.User.AudioWS.logos[1].image then
			m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		else
			get_img1(title .. '+музыка+песни')
		end

		local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.img})
		if rc~=200 and m_simpleTV.User.AudioWS.images and m_simpleTV.User.AudioWS.images[1] and m_simpleTV.User.AudioWS.images[1].image then
		m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.logo})
		if rc~=200 and m_simpleTV.User.AudioWS.logos and m_simpleTV.User.AudioWS.logos[1] and m_simpleTV.User.AudioWS.logos[1].image then
		m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.img})
		if rc~=200 and m_simpleTV.User.AudioWS.images and m_simpleTV.User.AudioWS.images[1] and m_simpleTV.User.AudioWS.images[1].image then
		m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.logo})
		if rc~=200 and m_simpleTV.User.AudioWS.logos and m_simpleTV.User.AudioWS.logos[1] and m_simpleTV.User.AudioWS.logos[1].image then
		m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.img})
		if rc~=200 and m_simpleTV.User.AudioWS.images and m_simpleTV.User.AudioWS.images[1] and m_simpleTV.User.AudioWS.images[1].image then
		m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.logo})
		if rc~=200 and m_simpleTV.User.AudioWS.logos and m_simpleTV.User.AudioWS.logos[1] and m_simpleTV.User.AudioWS.logos[1].image then
		m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		end
		m_simpleTV.Http.Close(session)

		m_simpleTV.User.AudioWS.title = title

		if m_simpleTV.Control.MainMode == 0 and m_simpleTV.User.AudioWS.logo and (m_simpleTV.User.AudioWS.cur_img == nil or m_simpleTV.User.AudioWS.cur_img and m_simpleTV.User.AudioWS.cur_img ~= m_simpleTV.User.AudioWS.img ) or m_simpleTV.User.AudioWS.stena == false then
			m_simpleTV.User.AudioWS.stena = true
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			 t.BackColor = 0
			 t.BackColorEnd = 255
			 t.PictFileName = m_simpleTV.User.AudioWS.img
			 t.TypeBackColor = 0
			 t.UseLogo = 3
			 t.Once = 1
			 t.Blur = 0
			 m_simpleTV.Interface.SetBackground(t)

			 t = {}
			 t.id = 'ID_DIV_AUDIO_1'
			 t.cx=-100 * m_simpleTV.Interface.GetScale()
			 t.cy=-50 * m_simpleTV.Interface.GetScale()
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0201
			 t.left=0
			 t.top=30 * m_simpleTV.Interface.GetScale()
			 t.once=1
			 t.zorder=0
			 t.background = -1
			 t.backcolor0 = 0xff0000000
			 AddElement(t)

			 t = {}
			 t.id = 'ID_DIV_AUDIO_2'
			 t.cx=700 * m_simpleTV.Interface.GetScale()
			 t.cy=-95 * m_simpleTV.Interface.GetScale()
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=20 * m_simpleTV.Interface.GetScale()
			 t.top=20 * m_simpleTV.Interface.GetScale()
			 t.once=1
			 t.zorder=0
			 t.background = -1
			 t.backcolor0 = 0x7fFFFF00
			 AddElement(t,'ID_DIV_AUDIO_1')

			 t = {}
			 t.id = 'USER_LOGO_AUDIO_IMG_ID'
			 t.cx=180 * m_simpleTV.Interface.GetScale()
			 t.cy=180 * m_simpleTV.Interface.GetScale()
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.AudioWS.logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 * m_simpleTV.Interface.GetScale()
			 t.top=0
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 20*20
			 t.borderround = 20
			 AddElement(t,'ID_DIV_AUDIO_1')

			 t={}
			 t.id = 'TEXT_AUDIO_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.AudioWS.Name
			 t.color = -2113993
			 t.font_height = -35 * m_simpleTV.Interface.GetScale()
			 t.font_weight = 400 * m_simpleTV.Interface.GetScale()
			 t.font_underline = 1
			 t.font_name = "Impact"
			 t.textparam = 0--1+4
			 t.left = 200 * m_simpleTV.Interface.GetScale()
			 t.top  = 0
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO_AUDIO_IMG_ID')

			 t={}
			 t.id = 'TEXT_AUDIO_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = title:gsub('%&amp%;','&')
			 t.color = -2113993
			 t.font_height = -25 * m_simpleTV.Interface.GetScale()
			 t.font_weight = 300 * m_simpleTV.Interface.GetScale()
			 t.font_name = "Impact"
			 t.textparam = 0--1+4
			 t.left = 200 * m_simpleTV.Interface.GetScale()
			 t.top  = 70 * m_simpleTV.Interface.GetScale()
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO_AUDIO_IMG_ID')

			 t={}
			 t.id = 'TEXT_AUDIO_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = track:gsub('%&amp%;','&')
			 t.color = -2113993
			 t.font_height = -15 * m_simpleTV.Interface.GetScale()
			 t.font_weight = 300 * m_simpleTV.Interface.GetScale()
			 t.font_name = "Impact"
			 t.textparam = 0--1+4
			 t.left = 200 * m_simpleTV.Interface.GetScale()
			 t.top  = 120 * m_simpleTV.Interface.GetScale()
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO_AUDIO_IMG_ID')

			m_simpleTV.User.AudioWS.cur_img = m_simpleTV.User.AudioWS.img
			m_simpleTV.User.AudioWS.img = nil
			m_simpleTV.User.AudioWS.logo = nil
		end
	end

--[[	if m_simpleTV.Control.Reason=='EndReached' and inAdr:match('^http://content%.audioaddict%.com.+') then
		m_simpleTV.Control.Action = 'repeat'
	end--]]

	if m_simpleTV.Control.Reason == 'Stopped' or m_simpleTV.Control.Reason=='EndReached' and not inAdr:match('^http://content%.audioaddict%.com.+') then
		m_simpleTV.Interface.RestoreBackground()
		m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
		m_simpleTV.OSD.RemoveElement('USER_LOGO_AUDIO_IMG_ID')
		m_simpleTV.OSD.RemoveElement('ID_DIV_AUDIO_1')
		m_simpleTV.OSD.RemoveElement('ID_DIV_AUDIO_2')
		m_simpleTV.OSD.RemoveElement('TEXT_AUDIO_1_ID')
		m_simpleTV.OSD.RemoveElement('TEXT_AUDIO_2_ID')
		m_simpleTV.OSD.RemoveElement('TEXT_AUDIO_3_ID')
		m_simpleTV.User.AudioWS.title = nil
		m_simpleTV.User.AudioWS.logo = nil
		m_simpleTV.User.AudioWS.Name = nil
		m_simpleTV.User.AudioWS.img = nil
		m_simpleTV.User.AudioWS.images = nil
		m_simpleTV.User.AudioWS.logos = nil
		m_simpleTV.User.AudioWS.TrackCash = nil
		m_simpleTV.User.AudioWS.stena = false
	end