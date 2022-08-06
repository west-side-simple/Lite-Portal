-- видеоскрипт для балансера ashdi (04/08/22) author - westSide
-- необходим plugin: videotrack (author - wafee)
-- открывает подобные ссылки:
-- https://ashdi.vip/vod/396?geoblock=ru

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^https?://ashdi%.vip') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.hdua then
		m_simpleTV.User.hdua = {}
	end
	if not m_simpleTV.User.collaps then
		m_simpleTV.User.collaps = {}
	end
	m_simpleTV.User.collaps.kinogo = nil
	m_simpleTV.User.collaps.ua = nil
	m_simpleTV.User.collaps.ua = inAdr:match('%&kino4ua=(.-)$'):gsub('%&seriaua=.-$','')
	if m_simpleTV.User.collaps.ua then
		m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.collaps.ua
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end
local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
local function GetInfo(Adr)
	local rc, answer = m_simpleTV.Http.Request(session, {url = Adr:gsub('&kino4ua=.-$', '')})
--	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('ashdi ошибка[3]-' .. rc, 255, 5)
		 return
		end
	local title = answer:match('<h1 itemprop="name">(.-)</h1>') or answer:match('<title>(.-)</title>')
	title = title:gsub(' дивитися онлайн.-$', ''):gsub('%&#039%;','`'):gsub('%&quot%;','"')
	local poster = answer:match('<meta property="og:image" content="(.-)"')
	poster = 'https://kino4ua.com/uploads/posts/' .. poster
	local desc = answer:match('<meta name="description" content="(.-)"')
return title, poster, desc
end

	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('%&seriaua=.-$','')})
--	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('ashdi ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local kino4ua = inAdr:match('%&kino4ua=(.-)$')
	local seriaua = 1
	if kino4ua:match('%&seriaua=') then seriaua = getConfigVal('ua/seria') end
    local title1,logo,desc = GetInfo(kino4ua:gsub('%&seriaua=.-$',''))
	local poster = answer:match('poster:"(.-)"') or logo
	local background = poster
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end
	local retAdr = answer:match('file:"(.-)"')

	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

function ua_serial()

local t = m_simpleTV.User.hdua.serial
local kino4ua = getConfigVal('info/kino4ua')
local seriaua = getConfigVal('ua/seria') or 1
		if not t then return end
		for i=1,#t do
		t[i].Address = kino4ua:gsub('%&seriaua=.-$','') .. '&seriaua=' .. i
		end
		if #t > 0 then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'ua_info(\'' .. kino4ua .. '\')'}
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal ', ButtonScript = 'run_westSide_portal()'}
			t.ExtParams = {FilterType = 2, StopOnError = 1, StopAfterPlay = 0, PlayMode = 1}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Серії', tonumber(seriaua)-1, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
                setConfigVal('ua/seria',t[id].Address:match('%d+$'))
				m_simpleTV.Control.PlayAddress(t[id].Address)
			end
			if ret == 2 then
				ua_info(kino4ua)
			end
			if ret == 3 then
				run_westSide_portal()
			end
		end
end

		if not retAdr then
			retAdr = answer:match('file:\'(.-)\'')
			require('json')
			local tab = json.decode(retAdr)
			local trans = tab[1].title
			local t, i, j = {}, 1, 1
			while true do
			if not tab[1].folder[j]
				then
				break
				end
			local se,k=tab[1].folder[j].title,1
			while true do
			if not tab[1].folder[j].folder[k]
				then
				break
				end
			t[i]={}
			t[i].Id = i
			t[i].Address = tab[1].folder[j].folder[k].file
			t[i].Name = se .. ', ' .. tab[1].folder[j].folder[k].title
			i=i+1
			k=k+1
			end
			j=j+1
		end
		if seriaua and tonumber(seriaua) > #t then
			m_simpleTV.OSD.ShowMessageT({text = 'Просмотрен последний эпизод', color = ARGB(255, 255, 100, 0), showTime = 1000 * 10, id = 'channelName'})
			ua_info(kino4ua:gsub('%&seriaua=.-$',''))
			return
		end
		if not kino4ua:match('%&seriaua=') then
			t.ExtParams = {FilterType = 2, StopOnError = 1, StopAfterPlay = 0, PlayMode = 1}
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title1 .. ', ' .. trans, tonumber(seriaua)-1 or 0, t, 10000, 1 + 4 + 8 + 2)
			id = id or tonumber(seriaua) or 1
		 	retAdr = t[id].Address
			setConfigVal('ua/seria',id)
			title1 = title1:gsub(' %(.-$', '') .. ' - ' .. trans .. ' (' .. t[id].Name .. ')'
			else
			retAdr = t[tonumber(seriaua)].Address
			setConfigVal('ua/seria',tonumber(seriaua))
			title1 = title1:gsub(' %(.-$', '') .. ' - ' .. trans .. ' (' .. t[tonumber(seriaua)].Name .. ')'
			end
			m_simpleTV.User.hdua.serial = t
			m_simpleTV.User.collaps.ua = nil
			m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.hdua.serial
			m_simpleTV.User.hdua.title = title1
		end
	m_simpleTV.Control.SetTitle(title1)
	m_simpleTV.Control.CurrentTitle_UTF8 = title1
	m_simpleTV.Control.ChangeAdress = 'Yes'

	m_simpleTV.Control.CurrentAdress = retAdr

-- debug_in_file(retAdr .. '\n')