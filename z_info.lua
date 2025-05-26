----------- отображение инфы premium accounts hdrezka and filmix и доступа к Vibix 09.05.25 WS

function ShowInfoPremiumAccount()

local function CheckVibix()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return '🔴' end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = 'https://vibix.org/api/v1/catalog/data?draw=1&columns[0][data]=uploaded_at&columns[0][name]=&columns[0][searchable]=true&columns[0][orderable]=true&columns[0][search][value]=&columns[0][search][regex]=false&columns[1][data]=id&columns[1][name]=&columns[1][searchable]=true&columns[1][orderable]=true&columns[1][search][value]=&columns[1][search][regex]=false&columns[2][data]=name&columns[2][name]=&columns[2][searchable]=true&columns[2][orderable]=true&columns[2][search][value]=&columns[2][search][regex]=false&columns[3][data]=info&columns[3][name]=&columns[3][searchable]=true&columns[3][orderable]=true&columns[3][search][value]=&columns[3][search][regex]=false&columns[4][data]=genre&columns[4][name]=&columns[4][searchable]=true&columns[4][orderable]=true&columns[4][search][value]=&columns[4][search][regex]=false&columns[5][data]=year&columns[5][name]=&columns[5][searchable]=true&columns[5][orderable]=true&columns[5][search][value]=&columns[5][search][regex]=false&columns[6][data]=country&columns[6][name]=&columns[6][searchable]=true&columns[6][orderable]=true&columns[6][search][value]=&columns[6][search][regex]=false&columns[7][data]=imdb_rating&columns[7][name]=&columns[7][searchable]=true&columns[7][orderable]=true&columns[7][search][value]=&columns[7][search][regex]=false&columns[8][data]=kp_rating&columns[8][name]=&columns[8][searchable]=true&columns[8][orderable]=true&columns[8][search][value]=&columns[8][search][regex]=false&columns[9][data]=kp_votes&columns[9][name]=&columns[9][searchable]=true&columns[9][orderable]=true&columns[9][search][value]=&columns[9][search][regex]=false&columns[10][data]=10&columns[10][name]=&columns[10][searchable]=true&columns[10][orderable]=true&columns[10][search][value]=&columns[10][search][regex]=false&columns[11][data]=11&columns[11][name]=&columns[11][searchable]=true&columns[11][orderable]=true&columns[11][search][value]=&columns[11][search][regex]=false&columns[12][data]=12&columns[12][name]=&columns[12][searchable]=true&columns[12][orderable]=true&columns[12][search][value]=&columns[12][search][regex]=false&order[0][column]=0&order[0][dir]=desc&start=0&length=100&search[value]=&search[regex]=false&filter[type][]=movie&filter[activity][]=1'
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'post', headers = m_simpleTV.User.VF.headers})
	if rc == 200 then
		return '🟢'
	end
	return '🔴'
end

	local q = {}
	local mas = 0.5 -- масштаб

		q = {}
		q.id = 'ID_WS_INFO'
		q.cx=400*mas
		q.cy=600*mas
		q.class="DIV"
		q.minresx=0
		q.minresy=0
		q.align = 0x0103
		q.left=0
		q.top=0
		q.once=1
		q.zorder=0
		q.background = 2
		q.backcolor0 = 0x440000FF
		q.backcolor1 = 0x77000000
		q.borderwidth = 2
		q.bordercolor = -6250336
		q.backroundcorner = 4*4
		q.borderround = 4
		q.isInteractive = true
		q.color_UnderMouse = ARGB(255 ,255, 192, 63)
		q.background_UnderMouse = 2
		q.backcolor0_UnderMouse = 0xEE4169E1
		q.backcolor1_UnderMouse = 0xEE00008B
		q.bordercolor_UnderMouse = 0xEE4169E1
		q.cursorShape = 13
		m_simpleTV.OSD.AddElement(q)


		q = {}
		q.once = 1
		q.zorder = 0
		q.id = 'WS_REZKA_BANNER'
		q.class = 'IMAGE'
		if m_simpleTV.User.rezka.account then
		q.cx = 354*mas
		q.cy = 80*mas
		q.imagepath = 'https://rezka-ua.org/templates/hdrezka/images/hd_prem_logo.png'
		q.top = 40*mas
		else
		q.cx = 264*mas
		q.cy = 160*mas
		q.imagepath = 'https://rezka-ua.org/templates/hdrezka/images/hdrezka-logo.png'
		q.top = 80*mas
		end
		q.minresx=-1
		q.minresy=-1
		q.align = 0x0102
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

		q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 0
		q.cy = 0
		q.id = 'WS_REZKA_INFO'
		q.class = 'TEXT'
		q.align = 0x0102
		q.top = 120*mas
		q.font_name = "Segoe UI"
		q.font_italic = 0
		q.textparam = 1 + 4
		q.color = 0xFFBBBBBB
		q.font_weight = 300*mas
		q.font_height = -30*mas
		q.glow = 1*mas -- коэффициент glow эффекта
		q.glowcolor = 0xFF777777 -- цвет glow эффекта
		if m_simpleTV.User.rezka.account then
		q.text = '🟢'
		else
		q.text = '🟡'
		end
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

		q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 95*mas
		q.cy = 95*mas
		q.id = 'WS_FILMIX_BANNER'
		q.class = 'IMAGE'
--		q.imagepath = m_simpleTV.User.filmix.avatar
		q.imagepath = 'https://filmix.dog/templates/Filmix/media/img/filmix.png'
		q.minresx=-1
		q.minresy=-1
		q.align = 0x0101
		q.top = 230*mas
		q.left = 25*mas
		q.borderwidth = 2
		q.bordercolor = -6250336
		q.backroundcorner = 20*20
		q.borderround = 20
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

		q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 240*mas
		q.cy = 72*mas
		q.id = 'WS_FILMIX_BANNER1'
		q.class = 'IMAGE'
		q.imagepath = 'https://filmix.dog/templates/Filmix/media/img/svg/filmix-logo-new.svg'
		q.minresx=-1
		q.minresy=-1
		q.align = 0x0103
		q.top = 230*mas
		q.left = 25*mas
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

		q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 0
		q.cy = 0
		q.id = 'WS_FILMIX_INFO'
		q.class = 'TEXT'
		q.align = 0x0102
		q.top = 310*mas
		q.color = 0xFFBBBBBB
		q.font_weight = 300*mas
		q.font_height = -30*mas
		q.font_name = "Segoe UI"
		q.font_italic = 0
		q.glow = 1*mas -- коэффициент glow эффекта
		q.glowcolor = 0xFF777777 -- цвет glow эффекта
--		if not m_simpleTV.User.filmix.pro or not m_simpleTV.User.filmix.pro:match('%d+') then
--		q.font_height = -24*mas
--		end
		q.textparam = 1 + 4
		if m_simpleTV.User.filmix.pro and m_simpleTV.User.filmix.pro:match('%d+') and tonumber(m_simpleTV.User.filmix.pro:match('(%d+)')) > 0 then
		q.text = '🟢'
		else
		q.text = '🟡'
		end
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

		q = {}
		q.once = 1
		q.zorder = 0
		q.id = 'WS_VF_BANNER'
		q.class = 'IMAGE'

		q.cx = 200*mas
		q.cy = 200*mas
		q.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Vibix.png'
		q.top = 350*mas

		q.minresx=-1
		q.minresy=-1
		q.align = 0x0102
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

		q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 0
		q.cy = 0
		q.id = 'WS_VF_INFO'
		q.class = 'TEXT'
		q.align = 0x0102
		q.top = 490*mas
		q.font_name = "Segoe UI"
		q.font_italic = 0
		q.textparam = 1 + 4
		q.color = 0xFFBBBBBB
		q.font_weight = 300*mas
		q.font_height = -30*mas
		q.glow = 1*mas -- коэффициент glow эффекта
		q.glowcolor = 0xFF777777 -- цвет glow эффекта
		q.text = CheckVibix()
		m_simpleTV.OSD.AddElement(q,'ID_WS_INFO')

	if m_simpleTV.Common.WaitUserInput(2000) == 1 then
		m_simpleTV.OSD.RemoveElement('ID_WS_INFO')
	end
	if m_simpleTV.Common.WaitUserInput(2000) == 1 then
		m_simpleTV.OSD.RemoveElement('ID_WS_INFO')
	end
	if m_simpleTV.Common.WaitUserInput(2000) == 1 then
		m_simpleTV.OSD.RemoveElement('ID_WS_INFO')
	end

	m_simpleTV.OSD.RemoveElement('ID_WS_INFO')
end

--ShowInfoPremiumAccount() --start - on or off

local t={}
t.utf8 = true
t.name = 'Premium Accounts'
t.luastring = 'ShowInfoPremiumAccount()'
t.lua_as_scr = true
t.key = string.byte('2')
t.ctrlkey = 2
t.location = 0
t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-off'
m_simpleTV.Interface.AddExtMenuT(t)