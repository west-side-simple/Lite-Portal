-- видеоскрипт для балансера ashdi (25/04/23) author - westSide
-- необходим скрипт kino4ua.lua author - westSide
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
	m_simpleTV.User.hdua.seria_title = nil
	m_simpleTV.User.hdua.seria_id = nil
	m_simpleTV.User.hdua.seria_id = inAdr:match('%&seriaua=(.-)$')
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
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('ashdi ошибка[3]-' .. rc, 255, 5)
		 return
		end
	local title = answer:match('<h1 itemprop="name">(.-)</h1>') or answer:match('<title>(.-)</title>')
	title = title:gsub(' дивитися онлайн.-$', ''):gsub('%&#039%;','`'):gsub('%&quot%;','"')
	local poster = answer:match('<meta property="og:image" content="(.-)"')
	if poster and not poster:match('^http') then
	poster = 'https://kino4ua.com/uploads/posts/' .. poster
	end
	local desc = answer:match('<meta name="description" content="(.-)"')
return title, poster, desc
end

	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('%&seriaua=.-$','')})
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('ashdi ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local kino4ua = inAdr:match('%&kino4ua=(.-)$')
    local title1,logo,desc = GetInfo(kino4ua:gsub('%&seriaua=.-$',''))
	local poster = answer:match('poster:"(.-)"') or logo
	local background = poster
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local function hduaIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('hdua_qlty') or 5000)
		local index = #t
			for i = 1, #t do
				if t[i].qlty >= lastQuality then
					index = i
				 break
				end
			end
		if index > 1 then
			if t[index].qlty > lastQuality then
				index = index - 1
			end
		end
	 return index
	end

	local function GethduaAdr(url)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('%$OPT.-$','')})
			if rc ~= 200 then return end
		local subt = url:match('(%$OPT.-)$') or ''
		local t = {}
			for w, adr in answer:gmatch('EXT%-X%-STREAM%-INF(.-)\n(.-)\n') do
				local qlty = w:match('RESOLUTION=%d+x(%d+)')
				if adr and qlty then
					t[#t + 1] = {}
					t[#t].Address = adr
					t[#t].qlty = tonumber(qlty)
				end
			end
			if #t == 0 then return end
			for _, v in pairs(t) do
				v.qlty = tonumber(v.qlty)
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 240 then
					v.qlty = 240
				elseif v.qlty > 240 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 480 then
					v.qlty = 480
				elseif v.qlty > 480 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1200 then
					v.qlty = 1080
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1444
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				else
					v.qlty = 4320
				end
				v.Name = v.qlty .. 'p'
			end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)

			for i = 1, #t do
				t[i].Id = i
				t[i].Address = t[i].Address .. subt
			end
		m_simpleTV.User.hdua.Tab = t
		local index = hduaIndex(t)
	 return t[index].Address
	end

	function Qlty_ashdi()
		local t = m_simpleTV.User.hdua.Tab
			if not t or #t == 0 then return end
		m_simpleTV.Control.ExecuteAction(37)
		local index = hduaIndex(t)
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'ua_info(\'' .. m_simpleTV.User.collaps.ua .. '\')'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 10000, 1 + 4)
		if ret == 1 then
			local retAdr = t[id].Address
			m_simpleTV.Control.SetNewAddress(retAdr, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('hdua_qlty', t[id].qlty)
		end
		if ret == 2 then
		ua_info(m_simpleTV.User.collaps.ua)
		end
	end

	local retAdr = answer:match('file:"(.-)"')
	local subt = answer:match('subtitle:"(.-)"') or ''
	if retAdr then
	retAdr = GethduaAdr(retAdr) or retAdr
	if subt ~= '' then
		retAdr = retAdr .. '$OPT:sub-track=0$OPT:input-slave=' .. subt:gsub('%[.-%]', ''):gsub('://', '/webvtt://')
	end
	end
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title1
		t1[1].Address = retAdr
		t1[1].InfoPanelName = title1
		t1[1].InfoPanelTitle = desc
		t1[1].InfoPanelLogo = background

				t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'ua_info(\'' .. m_simpleTV.User.collaps.ua .. '\')'}
				t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ashdi()'}
				m_simpleTV.OSD.ShowSelect_UTF8('UA HD', 0, t1, 5000, 32 + 64 + 128)

	local function ua_seria_adr()
		for i = 1,#m_simpleTV.User.hdua.serial do
		if m_simpleTV.User.hdua.seria_id and m_simpleTV.User.hdua.seria_id == m_simpleTV.User.hdua.serial[i].Address2 then
		return m_simpleTV.User.hdua.serial[i].Address1
		end
		i=i+1
		end
		return m_simpleTV.User.hdua.serial[1].Address1
	end

		if not retAdr then
			retAdr = answer:match('file:\'(.-)\'')
			require('json')
			local tab = json.decode(retAdr)
			local t, p, i, id_seria = {}, 1, 1, 1
			while true do
			if not tab[p]
				then
				break
				end
			local trans = tab[p].title
			local j = 1
			while true do
			if not tab[p].folder[j]
				then
				break
				end
			local se,k=tab[p].folder[j].title,1
			while true do
			if not tab[p].folder[j].folder[k]
				then
				break
				end
			t[i]={}
			t[i].Id = i
			t[i].subtitle = tab[p].folder[j].folder[k].subtitle or ''
			if t[i].subtitle ~= '' then
			t[i].Address1 = tab[p].folder[j].folder[k].file .. '$OPT:sub-track=0$OPT:input-slave=' .. t[i].subtitle:gsub('://', '/webvtt://')
			else
			t[i].Address1 = tab[p].folder[j].folder[k].file
			end
			t[i].Address2 = tab[p].folder[j].folder[k].id
			t[i].Address = inAdr:gsub('%&seriaua=.-$','') .. '&seriaua=' .. tab[p].folder[j].folder[k].id
			t[i].Name = se .. ', ' .. tab[p].folder[j].folder[k].title .. ' - ' .. trans
			if i==1 then m_simpleTV.User.hdua.seria_title = t[1].Name end
			t[i].InfoPanelLogo = tab[p].folder[j].folder[k].poster or ''
			t[i].InfoPanelName = title1:gsub(' %(.-$', '') .. ' - ' .. se .. ', ' .. tab[p].folder[j].folder[k].title .. ' - ' .. trans
			t[i].InfoPanelTitle = desc
			if m_simpleTV.User.hdua.seria_id and m_simpleTV.User.hdua.seria_id == t[i].Address2 then
			id_seria = i
			m_simpleTV.User.hdua.seria_title = t[i].Name
			end
			i=i+1
			k=k+1
			end
			j=j+1
			end
			p=p+1
			end
			m_simpleTV.User.hdua.serial = t
			if m_simpleTV.User.collaps.ua then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info ', ButtonScript = 'ua_info(\'' .. m_simpleTV.User.collaps.ua .. '\')'}
			end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_ashdi()'}
			t.ExtParams = {FilterType = 2, StopOnError = 1, StopAfterPlay = 0, PlayMode = 1}
			local __,id = m_simpleTV.OSD.ShowSelect_UTF8(title1, id_seria-1, t, 10000, 2 + 64 + 32)
			id = id or 1
		 	retAdr = ua_seria_adr(t[id].Address2)
			retAdr = GethduaAdr(retAdr) or retAdr
			title1 = title1:gsub(' %(.-$', '') .. ' - ' .. m_simpleTV.User.hdua.seria_title
		end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.SetTitle(title1)
	m_simpleTV.Control.CurrentTitle_UTF8 = title1
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')