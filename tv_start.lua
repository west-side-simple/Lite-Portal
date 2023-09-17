-- Плагин для TV Portal 16.09.23
-- author west_side
	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	AddFileToExecute('getaddress', m_simpleTV.MainScriptDir .. 'user/portaltvWS/portalTV.lua')
	AddFileToExecute('onconfig',m_simpleTV.MainScriptDir .. "user/portaltvWS/initconfig.lua")

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end

	local value= getConfigVal("PortalTV_1_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_1 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_1 = 1
	end

	value = getConfigVal('PortalTV_1_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_1 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 1')


	value = getConfigVal('PortalTV_1_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_1 = value
	end

	value= getConfigVal("PortalTV_2_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_2 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_2 = 1
	end

	value = getConfigVal('PortalTV_2_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_2 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 2')

	value = getConfigVal('PortalTV_2_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_2 = value
	end

	value= getConfigVal("PortalTV_3_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_3 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_3 = 1
	end

	value = getConfigVal('PortalTV_3_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_3 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 3')

	value = getConfigVal('PortalTV_3_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_3 = value
	end

	value= getConfigVal("PortalTV_4_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_4 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_4 = 1
	end

	value = getConfigVal('PortalTV_4_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_4 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 4')

	value = getConfigVal('PortalTV_4_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_4 = value
	end

	value= getConfigVal("PortalTV_5_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_5 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_5 = 1
	end

	value = getConfigVal('PortalTV_5_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_5 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 5')

	value = getConfigVal('PortalTV_5_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_5 = value
	end

	value= getConfigVal("PortalTV_6_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_6 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_6 = 1
	end

	value = getConfigVal('PortalTV_6_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_6 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 6')

	value = getConfigVal('PortalTV_6_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_6 = value
	end

	value= getConfigVal("PortalTV_7_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_7 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_7 = 1
	end

	value = getConfigVal('PortalTV_7_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_7 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 7')

	value = getConfigVal('PortalTV_7_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_7 = value
	end

	value= getConfigVal("PortalTV_8_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_8 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_8 = 1
	end

	value = getConfigVal('PortalTV_8_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_8 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 8')

	value = getConfigVal('PortalTV_8_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_8 = value
	end

	value= getConfigVal("PortalTV_9_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_9 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_9 = 1
	end

	value = getConfigVal('PortalTV_9_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_9 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 9')

	value = getConfigVal('PortalTV_9_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_9 = value
	end

	value= getConfigVal("PortalTV_10_Enable") or 0
	m_simpleTV.User.TVPortal.Use_PortalTV_10 = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use_PortalTV_10 = 1
	end

	value = getConfigVal('PortalTV_10_Name')
	m_simpleTV.User.TVPortal.Name_PortalTV_10 = value or m_simpleTV.Common.UTF8ToMultiByte('Слот 10')

	value = getConfigVal('PortalTV_10_Address')
	if value ~= nil then
		m_simpleTV.User.TVPortal.Address_PortalTV_10 = value
	end
--------------- блок создания фильтра и канала PortalTV
	local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
	if is_portal == nil or is_portal[1] == nil then
		is_portal = m_simpleTV.Database.GetTable('SELECT (MAX(ExtFilter.Id))+1 AS NewId FROM ExtFilter;')

		local Filter_ID = is_portal[1].NewId
		if is_portal == nil or is_portal[1] == nil or Filter_ID == '' then
			Filter_ID =  1
		end

		if m_simpleTV.Database.ExecuteSql('INSERT INTO ExtFilter ([Id],[Name],[TypeMedia],[Pressed],[Logo],[Comment]) VALUES (' .. Filter_ID .. ',"PortalTV",' .. 0 .. ',' .. 0 ..',"https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png","Вспомогательный фильтр для PortalTV");') then
			m_simpleTV.PlayList.Refresh()
		end
	end

	m_simpleTV.User.TVPortal.Id = getConfigVal('PortalTV_ID')

	if m_simpleTV.User.TVPortal.Id then
		is_portal = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE Id==' .. m_simpleTV.User.TVPortal.Id .. ';')
		if is_portal == nil or is_portal[1] == nil or is_portal[1] and not is_portal[1].Address:match('portalTV=%d+%&channel=%d+') then
			m_simpleTV.User.TVPortal.Id = nil
			setConfigVal('PortalTV_ID',0)
		end
	end

	if m_simpleTV.User.TVPortal.Id == nil or m_simpleTV.User.TVPortal.Id == '' then
		is_portal = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
		local Filter_ID = is_portal[1].NewId
		if is_portal == nil or is_portal[1] == nil or Filter_ID == '' then
			Filter_ID =  1
		end
		m_simpleTV.User.TVPortal.Id = Filter_ID
		setConfigVal('PortalTV_ID',m_simpleTV.User.TVPortal.Id)
		is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')

		if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Logo],[Group],[ExtFilter],[TypeMedia],[LastPosition]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"PortalTV","portalTV=1&channel=1","https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png",' .. 0 .. ',' .. is_portal[1].Id ..',' .. 0 .. ',' .. 0 .. ');') then
			m_simpleTV.PlayList.Refresh()
		end
	end
---------------------------
local function GetEPG_Id(name)
	if not m_simpleTV.User.TVPortal.EPG then
		local epg = m_simpleTV.Database.GetTable('SELECT * FROM ChannelsEpg')
		if epg == nil or epg[1] == nil then
			return false, false
		end
		local t,j = {},1
		for i = 1,#epg do
			local all_names = epg[i].ChName .. ';'
			for w in all_names:gmatch('.-%;') do
				local title = w:gsub('%;','')
				t[j] = {}
				t[j].Name_EPG = title
				t[j].Id_EPG = epg[i].Id
				t[j].Logo_EPG = epg[i].Logo
				j = j + 1
			end
			i = i + 1
		end
		if j == 1 then return false, false end
		m_simpleTV.User.TVPortal.EPG = t -- база EPG с t[j].Name_EPG, t[j].Id_EPG, t[j].Logo_EPG
	end
	for i = 1,#m_simpleTV.User.TVPortal.EPG do
		if m_simpleTV.User.TVPortal.EPG[i].Name_EPG == name then

			return m_simpleTV.User.TVPortal.EPG[i].Id_EPG, m_simpleTV.User.TVPortal.EPG[i].Logo_EPG
		end
	end
	return false, false
end

local function QueryToIs(adr)
	if m_simpleTV.User.TVPortal.Address_PortalTV_1 and m_simpleTV.User.TVPortal.Address_PortalTV_1 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_2 and m_simpleTV.User.TVPortal.Address_PortalTV_2 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_3 and m_simpleTV.User.TVPortal.Address_PortalTV_3 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_4 and m_simpleTV.User.TVPortal.Address_PortalTV_4 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_5 and m_simpleTV.User.TVPortal.Address_PortalTV_5 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_6 and m_simpleTV.User.TVPortal.Address_PortalTV_6 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_7 and m_simpleTV.User.TVPortal.Address_PortalTV_7 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_8 and m_simpleTV.User.TVPortal.Address_PortalTV_8 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_9 and m_simpleTV.User.TVPortal.Address_PortalTV_9 == adr then
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_10 and m_simpleTV.User.TVPortal.Address_PortalTV_10 == adr then
		return true
	end
	return false
end

local function QueryToUse(adr)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	if not session then return true end
	m_simpleTV.Http.SetTimeout(session, 16000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.multiByteToUTF8(adr,1251)})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return true end
	if not answer or answer and not answer:match('%#EXTINF:') then return true end
	return false
end


local function QueryToAdd(adr)
	if m_simpleTV.User.TVPortal.Address_PortalTV_1 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_1 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_1 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_1 = m_simpleTV.Common.UTF8ToMultiByte('Слот 1')
		m_simpleTV.User.TVPortal.Use_PortalTV_1 = 1
		setConfigVal("PortalTV_1_Enable",1)
		setConfigVal("PortalTV_1_Name",m_simpleTV.User.TVPortal.Name_PortalTV_1)
		setConfigVal("PortalTV_1_Address",m_simpleTV.User.TVPortal.Address_PortalTV_1)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_2 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_2 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_2 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_2 = m_simpleTV.Common.UTF8ToMultiByte('Слот 2')
		m_simpleTV.User.TVPortal.Use_PortalTV_2 = 1
		setConfigVal("PortalTV_2_Enable",1)
		setConfigVal("PortalTV_2_Name",m_simpleTV.User.TVPortal.Name_PortalTV_2)
		setConfigVal("PortalTV_2_Address",m_simpleTV.User.TVPortal.Address_PortalTV_2)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_3 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_3 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_3 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_3 = m_simpleTV.Common.UTF8ToMultiByte('Слот 3')
		m_simpleTV.User.TVPortal.Use_PortalTV_3 = 1
		setConfigVal("PortalTV_3_Enable",1)
		setConfigVal("PortalTV_3_Name",m_simpleTV.User.TVPortal.Name_PortalTV_3)
		setConfigVal("PortalTV_3_Address",m_simpleTV.User.TVPortal.Address_PortalTV_3)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_4 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_4 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_4 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_4 = m_simpleTV.Common.UTF8ToMultiByte('Слот 4')
		m_simpleTV.User.TVPortal.Use_PortalTV_4 = 1
		setConfigVal("PortalTV_4_Enable",1)
		setConfigVal("PortalTV_4_Name",m_simpleTV.User.TVPortal.Name_PortalTV_4)
		setConfigVal("PortalTV_4_Address",m_simpleTV.User.TVPortal.Address_PortalTV_4)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_5 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_5 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_5 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_5 = m_simpleTV.Common.UTF8ToMultiByte('Слот 5')
		m_simpleTV.User.TVPortal.Use_PortalTV_5 = 1
		setConfigVal("PortalTV_5_Enable",1)
		setConfigVal("PortalTV_5_Name",m_simpleTV.User.TVPortal.Name_PortalTV_5)
		setConfigVal("PortalTV_5_Address",m_simpleTV.User.TVPortal.Address_PortalTV_5)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_6 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_6 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_6 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_6 = m_simpleTV.Common.UTF8ToMultiByte('Слот 6')
		m_simpleTV.User.TVPortal.Use_PortalTV_6 = 1
		setConfigVal("PortalTV_6_Enable",1)
		setConfigVal("PortalTV_6_Name",m_simpleTV.User.TVPortal.Name_PortalTV_6)
		setConfigVal("PortalTV_6_Address",m_simpleTV.User.TVPortal.Address_PortalTV_6)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_7 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_7 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_7 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_7 = m_simpleTV.Common.UTF8ToMultiByte('Слот 7')
		m_simpleTV.User.TVPortal.Use_PortalTV_7 = 1
		setConfigVal("PortalTV_7_Enable",1)
		setConfigVal("PortalTV_7_Name",m_simpleTV.User.TVPortal.Name_PortalTV_7)
		setConfigVal("PortalTV_7_Address",m_simpleTV.User.TVPortal.Address_PortalTV_7)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_8 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_8 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_8 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_8 = m_simpleTV.Common.UTF8ToMultiByte('Слот 8')
		m_simpleTV.User.TVPortal.Use_PortalTV_8 = 1
		setConfigVal("PortalTV_8_Enable",1)
		setConfigVal("PortalTV_8_Name",m_simpleTV.User.TVPortal.Name_PortalTV_8)
		setConfigVal("PortalTV_8_Address",m_simpleTV.User.TVPortal.Address_PortalTV_8)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_9 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_9 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_9 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_9 = m_simpleTV.Common.UTF8ToMultiByte('Слот 9')
		m_simpleTV.User.TVPortal.Use_PortalTV_9 = 1
		setConfigVal("PortalTV_9_Enable",1)
		setConfigVal("PortalTV_9_Name",m_simpleTV.User.TVPortal.Name_PortalTV_9)
		setConfigVal("PortalTV_9_Address",m_simpleTV.User.TVPortal.Address_PortalTV_9)
		return true
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_10 == nil or m_simpleTV.User.TVPortal.Address_PortalTV_10 == '' then
		m_simpleTV.User.TVPortal.Address_PortalTV_10 = adr
		m_simpleTV.User.TVPortal.Name_PortalTV_10 = m_simpleTV.Common.UTF8ToMultiByte('Слот 10')
		m_simpleTV.User.TVPortal.Use_PortalTV_10 = 1
		setConfigVal("PortalTV_10_Enable",1)
		setConfigVal("PortalTV_10_Name",m_simpleTV.User.TVPortal.Name_PortalTV_10)
		setConfigVal("PortalTV_10_Address",m_simpleTV.User.TVPortal.Address_PortalTV_10)
		return true
	end
	return false
end

local function GetChannel(url)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	if m_simpleTV.User.TVPortal.Channel then return true end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 16000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.multiByteToUTF8(url,1251)})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return false end
	answer = answer:gsub('domen_name','http://domen_name') .. '\n'
	local t2, i = {}, 1
	for w in answer:gmatch('%#EXTINF:.-\nhttp.-\n') do
		local name = w:match('%,(.-)\n')
		local adr = w:match('\n(http.-)\n')
		local grp = w:match('%#EXTGRP:(.-)\n') or w:match('group%-title="(.-)"') or name:match('(.-):') or 'NEW'
		local logo = w:match('tvg%-logo="(.-)"')
		if not logo or logo == '' then
			logo = ''
		end
		local RawM3UString = w:match('tvg%-rec="(%d)') or w:match('catchup%-days="(%d)')
		if RawM3UString and tonumber(RawM3UString) > 0 then
			RawM3UString = w:match('#EXTINF:.-\n')
			if not RawM3UString:match('catchup=".-"') then
			RawM3UString = RawM3UString .. ' ' .. 'catchup="shift"'
			end
		end
		if not adr or not name then break end
		if not name:match('^Плейлист от') and not name:match('https://t%.me') and not name:match('Много плейлистов') and not name:match('Мой телеграмм') then
			t2[i] = {}
			t2[i].NameCh = name
			t2[i].AddressCh = adr:gsub('http://domen_name','domen_name')
			t2[i].GroupCh = grp
			t2[i].LogoCh = logo
			if RawM3UString then
				t2[i].M3UCh = RawM3UString
				t2[i].StateCh = 2
			else
				t2[i].StateCh = 1
			end
			i = i + 1
		end
	end
	if i == 1 then return false end
	m_simpleTV.User.TVPortal.Channel = t2
	return true
end

local function start_group(grp)
	local t, i = {}, 1
	for j = 1, #m_simpleTV.User.TVPortal.Channel do
		if m_simpleTV.User.TVPortal.Channel[j].GroupCh == grp then
			local flag
			if m_simpleTV.User.TVPortal.Channel[j].M3UCh then
				flag = m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('catchup%-days="(%d+)') or m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('tvg%-rec="(%d+)')
				if flag then flag = ' ' .. '⟲' .. ' ' .. flag .. 'd' else flag = '' end
			end
			t[i] = {}
			t[i].Id = i
			t[i].Name = m_simpleTV.User.TVPortal.Channel[j].NameCh .. (flag or '')
			t[i].Address = 'portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. i
			t[i].Address1 = m_simpleTV.User.TVPortal.Channel[j].AddressCh
			t[i].InfoPanelName = m_simpleTV.User.TVPortal.Channel[j].NameCh:gsub('^.-: ',''):gsub('^.-: ','')
			t[i].InfoPanelLogo = m_simpleTV.User.TVPortal.Channel[j].LogoCh
			t[i].RawM3UString = m_simpleTV.User.TVPortal.Channel[j].M3UCh
			t[i].State = m_simpleTV.User.TVPortal.Channel[j].StateCh
			i = i + 1
		end
		j = j + 1
	end
	return t
end

function start_tv_new()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end

	local url = getConfigVal('tvportal') or ''

	local t = {}
	t[1] = {}
	t[1].Id = 1
	t[1].Name = 'Добавить из буфера'

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: update',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			url = m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard())
			m_simpleTV.User.TVPortal.Address_PortalTV_1 = url
			m_simpleTV.User.TVPortal.Name_PortalTV_1 = m_simpleTV.Common.UTF8ToMultiByte('Слот 1')
			m_simpleTV.User.TVPortal.Use_PortalTV_1 = 1
			setConfigVal("PortalTV_1_Enable",1)
			setConfigVal("PortalTV_1_Name",m_simpleTV.User.TVPortal.Name_PortalTV_1)
			setConfigVal("PortalTV_1_Address",m_simpleTV.User.TVPortal.Address_PortalTV_1)
			setConfigVal('tvportal',url)
			start_tv()
		end
		if ret == 2 then
			run_westSide_portal()
		end
end

function start_tv()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end

	local url = getConfigVal('tvportal') or ''
	local is_tvportal = GetChannel(url)
	if not is_tvportal then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return SelectTVPortal()
	end
	local hash, t = {}, {}
	for i = 1,#m_simpleTV.User.TVPortal.Channel do
		if not hash[m_simpleTV.User.TVPortal.Channel[i].GroupCh]
		then
			t[#t + 1] = m_simpleTV.User.TVPortal.Channel[i]
			hash[m_simpleTV.User.TVPortal.Channel[i].GroupCh] = true
		end
	end
	for i = 1, #t do
		t[i].Id = i
		t[i].Name = t[i].GroupCh
	end
	local current_id_group = m_simpleTV.User.TVPortal.Group_id or 1
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' TVPortal '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' From Buffer '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: ' .. #t .. ' gr. (' .. #m_simpleTV.User.TVPortal.Channel .. ' ch.)' ,tonumber(current_id_group) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.TVPortal.Group_id = id
			m_simpleTV.User.TVPortal.Group_name = t[id].Name
			m_simpleTV.User.TVPortal.Channel_Of_Group = start_group(t[id].Name)
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
			local Filter_ID = is_portal[1].Id
			local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[1].InfoPanelName:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''))
			local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[1].InfoPanelLogo
			if epg_logo and m_simpleTV.User.TVPortal.Channel_Of_Group[1].InfoPanelLogo == '' then
				logo = epg_logo
			end
			m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[1].InfoPanelName:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r','') .. '","portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. 1 .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. (epg_id or 'not epg') .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. logo .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[1].State .. ');') then
				m_simpleTV.PlayList.Refresh()
			end
			m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. m_simpleTV.User.TVPortal.Id})
			if m_simpleTV.PlayList.SetFocusItem then
				m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			end
		end
		if ret == 2 then
			SelectTVPortal()
		end
		if ret == 3 then
			local check = QueryToUse(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			check = QueryToIs(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Плейлист уже присутствует в TV портале', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			check = QueryToAdd(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if not check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Все слоты TV портала заняты.\n Освободите слот TV портала в\n диалоговом окне настроек аддона', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			setConfigVal('tvportal',m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			m_simpleTV.User.TVPortal.Channel = nil
			m_simpleTV.User.TVPortal.Group_id = nil
			return start_tv()
		end
end

function SelectTVPortal()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end
	local current_adr = getConfigVal('tvportal') or ''
	local t,i,current_id = {},1,1
	if m_simpleTV.User.TVPortal.Use_PortalTV_1 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_1 and m_simpleTV.User.TVPortal.Address_PortalTV_1 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name = m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_1)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_1
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_2 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_2 and m_simpleTV.User.TVPortal.Address_PortalTV_2 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_2)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_2
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_3 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_3 and m_simpleTV.User.TVPortal.Address_PortalTV_3 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_3)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_3
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_4 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_4 and m_simpleTV.User.TVPortal.Address_PortalTV_4 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_4)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_4
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_5 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_5 and m_simpleTV.User.TVPortal.Address_PortalTV_5 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_5)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_5
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_6 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_6 and m_simpleTV.User.TVPortal.Address_PortalTV_6 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_6)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_6
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_7 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_7 and m_simpleTV.User.TVPortal.Address_PortalTV_7 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_7)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_7
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_8 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_8 and m_simpleTV.User.TVPortal.Address_PortalTV_8 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_8)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_8
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_9 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_9 and m_simpleTV.User.TVPortal.Address_PortalTV_9 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_9)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_9
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.Use_PortalTV_10 == 1 and m_simpleTV.User.TVPortal.Address_PortalTV_10 and m_simpleTV.User.TVPortal.Address_PortalTV_10 ~= '' then
		t[i] = {}
		t[i].Id = i
		t[i].Name =  m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_10)
		t[i].Action = m_simpleTV.User.TVPortal.Address_PortalTV_10
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
	if #t == 0 then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Названия и адреса плейлистов вносятся в настройках аддона.\n Есть возможность добавления нового плейлиста из буфера обмена.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return start_tv_new()
	end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' From Buffer '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: select playlist' ,tonumber(current_id) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if current_adr == t[id].Action then
				start_tv()
			else
				setConfigVal('tvportal',t[id].Action)
				m_simpleTV.User.TVPortal.Channel = nil
				m_simpleTV.User.TVPortal.Group_id = nil
				start_tv()
			end
		end
		if ret == 2 then
			run_westSide_portal()
		end
		if ret == 3 then
			local check = QueryToUse(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			check = QueryToIs(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Плейлист уже присутствует в TV портале', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			check = QueryToAdd(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if not check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Все слоты TV портала заняты.\n Освободите слот TV портала в\n диалоговом окне настроек аддона', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			setConfigVal('tvportal',m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			m_simpleTV.User.TVPortal.Channel = nil
			m_simpleTV.User.TVPortal.Group_id = nil
			return start_tv()
		end
end

function GetPortalTableForTVPortal()
	local t = m_simpleTV.User.TVPortal.Channel_Of_Group
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Group ', ButtonScript = 'start_tv()'}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' TVPortal ', ButtonScript = 'SelectTVPortal()'}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2', StopOnError = 0, StopAfterPlay = 0, PlayMode = 2}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.TVPortal.Group_name .. ' - ' .. #t .. ' ch.', tonumber(m_simpleTV.User.TVPortal.Channel_id)-1, t, 10000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
			local Filter_ID = is_portal[1].Id
			local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[id].InfoPanelName:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''))
			local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[id].InfoPanelLogo
			if epg_logo and m_simpleTV.User.TVPortal.Channel_Of_Group[id].InfoPanelLogo == 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png' then
				logo = epg_logo
			end
			m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].InfoPanelName:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r','') .. '","portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. id .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. (epg_id or 'not epg') .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. (m_simpleTV.User.TVPortal.Channel_Of_Group[id].RawM3UString or '') .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].State .. ');') then
				m_simpleTV.PlayList.Refresh()
			end
			m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. m_simpleTV.User.TVPortal.Id})
			if m_simpleTV.PlayList.SetFocusItem then
				m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			end
		end
		if ret == 2 then
			start_tv()
		end
		if ret == 3 then
			SelectTVPortal()
		end
end

	local t2={}
	t2.utf8 = true
	t2.name = 'TVPortal WS'
	t2.luastring = 'SelectTVPortal()'
	t2.lua_as_scr = true
	t2.key = string.byte('I')
	t2.ctrlkey = 4
	t2.location = 0
	t2.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'
	m_simpleTV.Interface.AddExtMenuT(t2)