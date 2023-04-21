-- видеоскрипт для сайта https://kino4ua.com/ (04/08/22)
-- необходимы скрипты: ashdi (autor - westSide), collaps (autor - nexterr)
-- открывает подобные ссылки:
-- https://kino4ua.com/749-titank.html

		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://kino4ua%.com')
		then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 30000)
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end
local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('%&seriaua=.-$','')})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('kino4ua ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local title = answer:match('<h1 itemprop="name">(.-)</h1>') or answer:match('<title>(.-)</title>')
	title = title:gsub(' дивитися онлайн.-$', ''):gsub('%&#039%;','`'):gsub('%&quot%;','"')
	local poster = answer:match('<meta property="og:image" content="(.-)"')
	poster = 'https://kino4ua.com/uploads/posts/' .. poster
	local desc = answer:match('<meta name="description" content="(.-)"')
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	local background = poster
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
	end
	local retAdr
	local t,i = {},1
	for w in answer:gmatch('<iframe.-src=.-</iframe>') do
		adr = w:match('<iframe.-src="(.-)"')
		if not adr then break end
		t[i] = {}
		t[i].Address = adr
		t[i].InfoPanelTitle = desc
		t[i].InfoPanelName = title
		t[i].InfoPanelShowTime = 8000
		t[i].InfoPanelLogo = poster
		if adr:match('/api%.tobaco%.ws') or adr:match('/api%.getcodes%.ws') or adr:match('/api%.strvid%.ws') then t[i].Name = 'Collaps' elseif adr:match('/ashdi') then t[i].Name = 'HD' elseif adr:match('youtube%.com') then t[i].Name = 'Trailer' end
		i=i+1
	end
		local hash, res = {}, {}
		for i = 1, #t do
		t[i].Address = tostring(t[i].Address)
			if not hash[t[i].Address] then
				res[#res + 1] = t[i]
				hash[t[i].Address] = true
			end
		end
		for i = 1, #res do
			res[i].Id = i
		end
	if #res and #res > 1 and not res[1].Address:match('/ashdi') then
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🎞 ' .. title, 0, res, 8000, 1 + 2)
		id = id or 1
		retAdr = res[id].Address
	else
		retAdr = res[1].Address
	end
		if not retAdr then
			m_simpleTV.OSD.ShowMessage_UTF8('<kino4ua ошибка[2]', 255, 5)
		 return
		end

	setConfigVal('info/kino4ua',inAdr:gsub('%&seriaua=.-$',''))

	m_simpleTV.Control.ChangeAdress = 'No'

	m_simpleTV.Control.CurrentAdress = retAdr .. '&kino4ua=' .. inAdr

	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	m_simpleTV.User.westSide.PortalTable,m_simpleTV.User.TMDB.tv,m_simpleTV.User.TMDB.Id=nil,nil,nil

	dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
-- debug_in_file(retAdr .. '\n')