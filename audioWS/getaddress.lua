-- getaddress for Audio plugin
-- author west_side 19.03.23

	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if tonumber(m_simpleTV.User.AudioWS.Use) ~= 1 then return end
	if tonumber(m_simpleTV.User.AudioWS.Use) == 1 then m_simpleTV.Control.EventPlayingInterval=10000 end
	if not m_simpleTV.Control.CurrentAddress:match('^http://23%.111%.104%.132') and
	not m_simpleTV.Control.CurrentAddress:match('%.hostingradio%.ru') and
	not m_simpleTV.Control.CurrentAddress:match('pcradio%.ru') and
	not m_simpleTV.Control.CurrentAddress:match('^http://.-8000/.+')
	then return end
	m_simpleTV.User.AudioWS.Name = nil
	m_simpleTV.User.AudioWS.logo = nil
	m_simpleTV.User.AudioWS.logos = nil
	m_simpleTV.User.AudioWS.img = nil
	m_simpleTV.User.AudioWS.images = nil
	local t1 = m_simpleTV.Control.GetCurrentChannelInfo()
	m_simpleTV.User.AudioWS.Name = t1.Name:gsub('%&amp%;','&')
	m_simpleTV.User.AudioWS.logo = t1.Logo
	m_simpleTV.User.AudioWS.img = m_simpleTV.MainScriptDir .. 'user/audioWS/img/music.jpg'

	local inAdr = m_simpleTV.Control.CurrentAddress

		if m_simpleTV.Control.MainMode == 0 then

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
			 t.glowcolor = 0xFF770077 -- цвет glow эффекта
			 AddElement(t,'USER_LOGO1_IMG_ID')

			m_simpleTV.User.AudioWS.img = nil
			m_simpleTV.User.AudioWS.logo = nil
		end