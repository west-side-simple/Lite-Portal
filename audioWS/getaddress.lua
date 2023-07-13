-- getaddress for Audio plugin
-- author west_side 13.07.23

	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if tonumber(m_simpleTV.User.AudioWS.Use) ~= 1 then return end
	if tonumber(m_simpleTV.User.AudioWS.Use) == 1 then m_simpleTV.Control.EventPlayingInterval=10000 end
	if not m_simpleTV.Control.CurrentAddress:match('^http://23%.111%.104%.132') and
	not m_simpleTV.Control.CurrentAddress:match('%.hostingradio%.ru') and
	not m_simpleTV.Control.CurrentAddress:match('pcradio%.ru') and
	not m_simpleTV.Control.CurrentAddress:match('^http://.-8000/.+') and
	not m_simpleTV.Control.CurrentAddress:match('^https://.-playernostalgie.+')	and
	not m_simpleTV.Control.CurrentAddress:match('^webradio_network_id=.+')
	then return end
	m_simpleTV.User.AudioWS.Name = nil
	m_simpleTV.User.AudioWS.logo = nil
	m_simpleTV.User.AudioWS.logos = nil
	m_simpleTV.User.AudioWS.img = nil
	m_simpleTV.User.AudioWS.images = nil
	local t1 = m_simpleTV.Control.GetCurrentChannelInfo()
	m_simpleTV.User.AudioWS.Name = t1.Name:gsub('%&amp%;','&')
	m_simpleTV.User.AudioWS.logo1 = t1.Logo
	m_simpleTV.User.AudioWS.img1 = m_simpleTV.MainScriptDir .. 'user/audioWS/img/music.jpg'

	local inAdr = m_simpleTV.Control.CurrentAddress
	local network_id = inAdr:match('webradio_network_id=(%d+)')
	local id = inAdr:match('%&id=(%d+)')
	if m_simpleTV.User.AudioWS.webradio_network_id and m_simpleTV.User.AudioWS.webradio_id and
	(m_simpleTV.User.AudioWS.webradio_network_id ~= network_id or m_simpleTV.User.AudioWS.webradio_network_id == network_id and m_simpleTV.User.AudioWS.webradio_id ~= id)
	then
		m_simpleTV.User.AudioWS.tracks = nil
	end
	m_simpleTV.User.AudioWS.webradio_network_id = network_id
	m_simpleTV.User.AudioWS.webradio_id = id

	local track = inAdr:match('%&track=(%d+)')
	local retAdr = inAdr:gsub('webradio_network_id=.-%&',''):gsub('id=.-%&',''):gsub('track=.-%&','')

		if m_simpleTV.Control.MainMode == 0 then

			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			 t.BackColor = 0
			 t.BackColorEnd = 255
			 t.PictFileName = m_simpleTV.User.AudioWS.img1
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
			 t.imagepath = m_simpleTV.User.AudioWS.logo1
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
			 t.glowcolor = 0xFF770077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO1_IMG_ID')

			m_simpleTV.User.AudioWS.img = nil
			m_simpleTV.User.AudioWS.logo = nil
		end


	local function GetAdrName(number)
		local tab = {
					{"DI.FM","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/di-8cf523ebe8d26478fc652ebce3b3a664e7b123b7bddc44297b4fa48d4160b634.png","https://www.di.fm/",1,"di"},
					{"ZenRadio.com","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/zenradio-af07a05b99ddcb1866bd02818101d100d87cc2d819ad43138b7a79f44f2e14dd.png","https://www.zenradio.com/",16,"zenradio"},
					{"RadioTunes","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/radiotunes-ed9fd41b62f6b11c1bae26f1b04dd5a7c338bd3cfca7be070529a41ad5b95bff.png","https://www.radiotunes.com/",2,"radiotunes"},
					{"ROCKRADIO.com","https://cdn.audioaddict.com/rockradio.com/assets/logo-sm@1x-ca7f1c479be6d367be3ec8a655540eda6137f5ed92bcdd3a2387158aa3589b60.png","https://www.rockradio.com/",13,"rockradio"},
					{"JAZZRADIO.com","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/jazzradio-a504eebc30c18ae4adddf491043b3c7cd9b931ef3dea61fcb5cd72b4478bb109.png","https://www.jazzradio.com/",12,"jazzradio"},
					{"ClassicalRadio.com","https://cdn.audioaddict.com/rockradio.com/assets/network_site_logos/classicalradio-63494e32ee7162b7e9a7be21ebfe5964a927f164c46a01faa9645aa71ba87212.png","https://www.classicalradio.com/",15,"classicalradio"},
					}
		for i = 1,#tab do
			if tonumber(number) == tab[i][4] then
				return tab[i][5]
			end
			i = i + 1
		end
		return false
	end

	local function GetAdrAll()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 30000)
		local i, t0, current_track =1, {}, 1
		local url = 'https://api.audioaddict.com/v1/' .. GetAdrName(network_id) .. '/routines/channel/' .. id .. '?tune_in=true&audio_token=03c6587600d0ee27d7598212bb27f161'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		m_simpleTV.Http.Close(session)
			require('json')
			if not answer then return end
			answer = answer:gsub('(%[%])', '""')
			local tt = json.decode(answer)
			if not tt
				or not tt.tracks
				or not tt.tracks[1]
				or not tt.tracks[1].content
				or not tt.tracks[1].content.assets
				or not tt.tracks[1].content.assets[1]
				or not tt.tracks[1].content.assets[1].url then
				return
			end
			while true do
				if not tt.tracks[i]
					or not tt.tracks[i].content
					or not tt.tracks[i].content.assets
					or not tt.tracks[i].content.assets[1]
					or not tt.tracks[i].content.assets[1].url then
					break
				end
				t0[i] = {}
				t0[i].Name = tt.tracks[i].track
				t0[i].Address1 = 'http:' .. tt.tracks[i].content.assets[1].url
--				t0[i].Address = 'webradio_network_id=' .. network_id .. '&id=' .. id .. '&track=' .. i .. '&' .. t0[i].Address1
				t0[i].Logo = 'http:' .. tt.tracks[i].asset_url
				t0[i].InfoPanelLogo = 'http:' .. tt.tracks[i].asset_url
				t0[i].InfoPanelName = tt.tracks[i].track
				t0[i].InfoPanelTitle = '👍 ' .. (tt.tracks[i].votes.up or 0) .. ' 👎 ' .. (tt.tracks[i].votes.down or 0)
				if i == tonumber(track) then
				current_track = i
				m_simpleTV.User.AudioWS.track = i
				m_simpleTV.User.AudioWS.title_track = tt.tracks[i].track
				m_simpleTV.User.AudioWS.logo1 = 'http:' .. tt.tracks[i].asset_url
				m_simpleTV.User.AudioWS.img1 = 'http:' .. tt.tracks[i].asset_url
				end
				i=i+1
			end
			local t, i = {}, 1
		if m_simpleTV.User.AudioWS.tracks then
			for j = 1, #m_simpleTV.User.AudioWS.tracks do
				t[i] = {}
				t[i].Name = m_simpleTV.User.AudioWS.tracks[j].Name
				t[i].Address1 = m_simpleTV.User.AudioWS.tracks[j].Address1
				t[i].Address = 'webradio_network_id=' .. network_id .. '&id=' .. id .. '&track=' .. i .. '&' .. m_simpleTV.User.AudioWS.tracks[j].Address1
				t[i].Logo = m_simpleTV.User.AudioWS.tracks[j].Logo
				t[i].InfoPanelLogo = m_simpleTV.User.AudioWS.tracks[j].Logo
				t[i].InfoPanelName = m_simpleTV.User.AudioWS.tracks[j].InfoPanelName
				t[i].InfoPanelTitle = m_simpleTV.User.AudioWS.tracks[j].InfoPanelTitle
				j = j + 1
				i = i + 1
			end
		end
			for k = 1, #t0 do
				t[i] = {}
				t[i].Name = t0[k].Name
				t[i].Address1 = t0[k].Address1
				t[i].Address = 'webradio_network_id=' .. network_id .. '&id=' .. id .. '&track=' .. i .. '&' .. t0[k].Address1
				t[i].Logo = t0[k].Logo
				t[i].InfoPanelLogo = t0[k].Logo
				t[i].InfoPanelName = t0[k].InfoPanelName
				t[i].InfoPanelTitle = t0[k].InfoPanelTitle
				k = k + 1
				i = i + 1
			end
			for i = 1, #t do
				t[i].Id = i
				if i == tonumber(track) then
					current_track = i
					m_simpleTV.User.AudioWS.track = i
					m_simpleTV.User.AudioWS.title_track = t[i].Name
					m_simpleTV.User.AudioWS.logo1 = t[i].Logo
					m_simpleTV.User.AudioWS.img1 = t[i].Logo
				end
--				t[i].InfoPanelName = i .. '. ' .. t[i].Name
				i = i + 1
			end
		m_simpleTV.User.AudioWS.tracks = t
	end

	local function GetTrackAdr()
		for i = 1,# m_simpleTV.User.AudioWS.tracks do
		if m_simpleTV.User.AudioWS.track and m_simpleTV.User.AudioWS.track == m_simpleTV.User.AudioWS.tracks[i].Id then
		return m_simpleTV.User.AudioWS.tracks[i].Address1
		end
		i=i+1
		end
		return m_simpleTV.User.AudioWS.tracks[1].Address1
	end

	if network_id and id then
		if track == nil then track = 1 end
		GetAdrAll()
		local t2 = m_simpleTV.User.AudioWS.tracks
		t2.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2', StopOnError = 1, StopAfterPlay = 0, PlayMode = 1}
		local __,id2 = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.AudioWS.Name, m_simpleTV.User.AudioWS.track - 1, t2, 10000, 32)
		id2 = id2 or 1
		retAdr = GetTrackAdr()
		m_simpleTV.Control.CurrentTitle_UTF8 = m_simpleTV.User.AudioWS.Name .. ': ' .. m_simpleTV.User.AudioWS.title_track
		m_simpleTV.Control.SetTitle(m_simpleTV.User.AudioWS.Name .. ': ' .. m_simpleTV.User.AudioWS.title_track)
		m_simpleTV.Control.ChangeAddress = 'No'
		m_simpleTV.Control.CurrentAddress = retAdr .. '$OPT:POSITIONTOCONTINUE=0' .. '$OPT:NO-POSITION-UPDATE'
		m_simpleTV.Control.SetNewAddress(retAdr .. '$OPT:POSITIONTOCONTINUE=0' .. '$OPT:NO-POSITION-UPDATE')
	end
