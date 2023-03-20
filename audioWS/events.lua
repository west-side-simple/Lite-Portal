-- events for Audio plugin
-- author west_side 19.03.23

	if m_simpleTV.Control.CurrentAddress==nil then return end
	if m_simpleTV.Control.IsVideo() then return end
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
	if m_simpleTV.User.AudioWS.Use and m_simpleTV.User.AudioWS.Use == 0 then return end
	if m_simpleTV.User.AudioWS.images==nil then m_simpleTV.User.AudioWS.images={} end
	if m_simpleTV.User.AudioWS.logos==nil then m_simpleTV.User.AudioWS.logos={} end

local function get_img(s)
	local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'https://www.google.com/search?as_st=y&tbm=isch&hl=ru&as_epq=&as_oq=&as_eq=&cr=&as_sitesearch=&safe=images&tbs=iar:w&as_q='
	url = url .. m_simpleTV.Common.toPercentEncoding(s)
	local t={}
	t.url = url
	t.headers = 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\nauthority: https://www.google.com/\nsec-fetch-mode: navigate\nsec-fetch-site: same-origin\nuser-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36\ncookie: ' .. "'" .. m_simpleTV.User.AudioWS.Cookies .. "'"
	local rc, answer =  m_simpleTV.Http.Request(session, t)
--	debug_in_file(url .. '\n' .. (answer or 'not') .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	if rc~=200 then
	m_simpleTV.Http.Close(session)
	return
	end
--	debug_in_file('-- прямоугольные ------------\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	local t1, i = {}, 1
	for w in answer:gmatch('%["https://encrypted.-%[".-"') do

		local img = w:match('encrypted.-%["(.-)"')
		if not img then break end
		if img:match('%.jpg') and not img:match('notado%.ru') and not img:match('webkind%.ru') and not img:match('cdvpodarok%.ru') then
			t1[i] = {}
			t1[i].image = img:gsub('%.jpg.-$','.jpg')
--			debug_in_file(t1[i].image .. ' - ' .. i .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
			i = i + 1
		end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.User.AudioWS.images=t1
end

local function get_img1(s)
	local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'https://www.google.com/search?as_st=y&tbm=isch&hl=ru&as_epq=&as_oq=&as_eq=&cr=&as_sitesearch=&safe=images&tbs=iar:s&as_q='
	url = url .. m_simpleTV.Common.toPercentEncoding(s)
	local t={}
	t.url = url
	t.headers = 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\nauthority: https://www.google.com/\nsec-fetch-mode: navigate\nsec-fetch-site: same-origin\nuser-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36\ncookie: ' .. "'" .. m_simpleTV.User.AudioWS.Cookies .. "'"
	local rc, answer =  m_simpleTV.Http.Request(session, t)
--	debug_in_file(url .. '\n' .. (answer or 'not') .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	if rc~=200 then
	m_simpleTV.Http.Close(session)
	return
	end
--	debug_in_file('-- квадратные ---------------\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
	local t1, i = {}, 1
	for w in answer:gmatch('%["https://encrypted.-%[".-"') do

		local img = w:match('encrypted.-%["(.-)"')
		if not img then break end
		if img:match('%.jpg') and not img:match('notado%.ru') and not img:match('webkind%.ru') and not img:match('cdvpodarok%.ru') then
			t1[i] = {}
			t1[i].image = img:gsub('%.jpg.-$','.jpg')
--			debug_in_file(t1[i].image .. ' - ' .. i .. '\n',m_simpleTV.MainScriptDir .. 'user/audioWS/getmeta.txt')
			i = i + 1
		end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.User.AudioWS.logos=t1
end

local title, track, typerad
local inAdr = m_simpleTV.Control.CurrentAddress
if inAdr:match('https?://213%.141%..-:8000/.+')
	or inAdr:match('https?://79%.111%..-:8000/.+')
	or inAdr:match('https?://79%.120%..-:8000/.+') then
	typerad = 'radcap'
	local host = inAdr:gsub(':8000/.-$', '')
	local sid = inAdr:gsub('^.-//.-/', '')
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

	if m_simpleTV.Control.Reason == 'Playing' then

		m_simpleTV.Control.EventPlayingInterval=10000
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
		track = title:gsub('^.-%- ','')
		title = title:gsub('A %- HA','A-HA'):gsub(' %-.-$','')

		if title and title~='' and title~=m_simpleTV.User.AudioWS.title or title and title==m_simpleTV.User.AudioWS.title and m_simpleTV.User.AudioWS.images == nil then
			get_img(title .. ' музыка песни')
			get_img1(title .. ' музыка песни')
		end
		if m_simpleTV.User.AudioWS.images and m_simpleTV.User.AudioWS.images[1] and m_simpleTV.User.AudioWS.images[1].image then
			m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		else
			get_img(title .. ' музыка песни')
		end
		if m_simpleTV.User.AudioWS.logos and m_simpleTV.User.AudioWS.logos[1] and m_simpleTV.User.AudioWS.logos[1].image then
			m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		else
			get_img1(title .. ' музыка песни')
		end

		local session = m_simpleTV.Http.New()
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.img})
		if rc~=200 then
		m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.logo})
		if rc~=200 then
		m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.img})
		if rc~=200 then
		m_simpleTV.User.AudioWS.img = m_simpleTV.User.AudioWS.images[math.random(#m_simpleTV.User.AudioWS.images)].image
		end
		rc = m_simpleTV.Http.Request(session, {url= m_simpleTV.User.AudioWS.logo})
		if rc~=200 then
		m_simpleTV.User.AudioWS.logo = m_simpleTV.User.AudioWS.logos[math.random(#m_simpleTV.User.AudioWS.logos)].image
		end
		m_simpleTV.Http.Close(session)

		m_simpleTV.User.AudioWS.title = title

		if m_simpleTV.Control.MainMode == 0 and m_simpleTV.User.AudioWS.logo then

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
			 t.id = 'ID_DIV1'
			 t.cx=-100
			 t.cy=-50
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0201
			 t.left=0
			 t.top=30
			 t.once=1
			 t.zorder=0
			 t.background = -1
			 t.backcolor0 = 0xff0000000
			 AddElement(t)

			 t = {}
			 t.id = 'ID_DIV5'
			 t.cx=700
			 t.cy=-95
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=20
			 t.top=20
			 t.once=1
			 t.zorder=0
			 t.background = -1
			 t.backcolor0 = 0x7fFFFF00
			 AddElement(t,'ID_DIV1')

			 t = {}
			 t.id = 'USER_LOGO1_IMG_ID'
			 t.cx=180
			 t.cy=180
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.AudioWS.logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20
			 t.top=0
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 20*20
			 t.borderround = 20
			 AddElement(t,'ID_DIV1')

			 t={}
			 t.id = 'TEXT2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.AudioWS.Name
			 t.color = -2113993
			 t.font_height = -40
			 t.font_weight = 400
			 t.font_underline = 1
			 t.font_name = "Impact"
			 t.textparam = 0--1+4
			 t.left = 200
			 t.top  = 0
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO1_IMG_ID')

			 t={}
			 t.id = 'TEXT23_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = title:gsub('%&amp%;','&')
			 t.color = -2113993
			 t.font_height = -30
			 t.font_weight = 300
			 t.font_name = "Impact"
			 t.textparam = 0--1+4
			 t.left = 200
			 t.top  = 70
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO1_IMG_ID')

			 t={}
			 t.id = 'TEXT3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = track:gsub('%&amp%;','&')
			 t.color = -2113993
			 t.font_height = -20
			 t.font_weight = 300
			 t.font_name = "Impact"
			 t.textparam = 0--1+4
			 t.left = 200
			 t.top  = 120
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO1_IMG_ID')

			m_simpleTV.User.AudioWS.img = nil
			m_simpleTV.User.AudioWS.logo = nil
		end
	end

	if m_simpleTV.Control.Reason == 'Stopped' or m_simpleTV.Control.Reason=='EndReached' then
		m_simpleTV.Interface.RestoreBackground()
		m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(255, 255, 255, 255), showTime = 1000 * 1})
		m_simpleTV.OSD.RemoveElement('USER_LOGO1_IMG_ID')
		m_simpleTV.OSD.RemoveElement('ID_DIV1')
		m_simpleTV.OSD.RemoveElement('ID_DIV5')
		m_simpleTV.OSD.RemoveElement('TEXT2_ID')
		m_simpleTV.OSD.RemoveElement('TEXT3_ID')
		m_simpleTV.OSD.RemoveElement('TEXT23_ID')
		m_simpleTV.User.AudioWS.title = nil
		m_simpleTV.User.AudioWS.logo = nil
		m_simpleTV.User.AudioWS.Name = nil
		m_simpleTV.User.AudioWS.img = nil
		m_simpleTV.User.AudioWS.images = nil
		m_simpleTV.User.AudioWS.logos = nil
	end