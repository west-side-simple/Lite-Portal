-- Плагин для TV Portal 02.04.25
-- author west_side
-- ===============================================================================================================

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
	if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end
	AddFileToExecute('getaddress', m_simpleTV.MainScriptDir .. 'user/portaltvWS/portalTV.lua')
	AddFileToExecute('getaddress', m_simpleTV.MainScriptDir .. 'user/portaltvWS/stalkerTV.lua')
	AddFileToExecute('events', m_simpleTV.MainScriptDir .. "user/portaltvWS/events.lua")
	AddFileToExecute('onconfig',m_simpleTV.MainScriptDir .. "user/portaltvWS/initconfig.lua")

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end

	local value= getConfigVal("Portal_TV_WS_Enable") or 1
	m_simpleTV.User.TVPortal.Use = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.TVPortal.Use = 1
	end

	value=getConfigVal('Portal_TV_WS_desc_Enable') or 0
	m_simpleTV.User.TVPortal.UseDesc = 1
	if tonumber(value) == 0 then
		m_simpleTV.User.TVPortal.UseDesc = 0
	end

	value=getConfigVal('Portal_TV_WS_mes_Enable') or 0
	m_simpleTV.User.TVPortal.UseMes = 1
	if tonumber(value) == 0 then
		m_simpleTV.User.TVPortal.UseMes = 0
	end

	value= getConfigVal("PortalTV_1_Enable") or 0
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
	if m_simpleTV.User.TVPortal.Use == 0 then return end
--------------- блок создания фильтров и канала PortalTV
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
		if is_portal == nil or is_portal[1] == nil or is_portal[1] and not is_portal[1].Address:match('portalTV=%d+%&channel=%d+') and not is_portal[1].Address:match('portalTV_search=%d+%&channel=%d+') then
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

	is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalPLL";')
	if is_portal == nil or is_portal[1] == nil then
		is_portal = m_simpleTV.Database.GetTable('SELECT (MAX(ExtFilter.Id))+1 AS NewId FROM ExtFilter;')

		local Filter_ID = is_portal[1].NewId
		if is_portal == nil or is_portal[1] == nil or Filter_ID == '' then
			Filter_ID =  1
		end

		if m_simpleTV.Database.ExecuteSql('INSERT INTO ExtFilter ([Id],[Name],[TypeMedia],[Pressed],[Logo],[Comment]) VALUES (' .. Filter_ID .. ',"PortalPLL",' .. 2 .. ',' .. 0 ..',"https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png","Вспомогательный фильтр для PortalPLL");') then
			m_simpleTV.PlayList.Refresh()
		end
	end

	local is_stalker = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="StalkerPLL";')
	if is_stalker == nil or is_stalker[1] == nil then
		is_stalker = m_simpleTV.Database.GetTable('SELECT (MAX(ExtFilter.Id))+1 AS NewId FROM ExtFilter;')

		local Filter_ID = is_stalker[1].NewId
		if is_stalker == nil or is_stalker[1] == nil or Filter_ID == '' then
			Filter_ID =  1
		end

		if m_simpleTV.Database.ExecuteSql('INSERT INTO ExtFilter ([Id],[Name],[TypeMedia],[Pressed],[Logo],[Comment]) VALUES (' .. Filter_ID .. ',"StalkerPLL",' .. 2 .. ',' .. 0 ..',"https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png","Вспомогательный фильтр для StalkerPLL");') then
			m_simpleTV.PlayList.Refresh()
		end
	end
---------------------------
--[[
--------------------------- блок создания EPG заглушки
if m_simpleTV.Database.ExecuteSql('INSERT INTO ChannelsEpg ([Id],[ChName],[Source],[Logo]) VALUES ("WS_PortalTV","WS_PortalTV","WS PortalTV","");') then
m_simpleTV.EPG.Refresh()
end
m_simpleTV.Database.ExecuteSql('DELETE FROM ChProg WHERE (IdChannel="WS_PortalTV");', true)
local start_EPG = os.time() - (os.date("%H",os.time())*60*60 + os.date("%M",os.time())*60 + os.date("%S",os.time())) - os.date("%w",os.time())*24*60*60 - 6*24*60*60
local EPG = {
{0,6,"ночное вещание"},
{6,12,"утреннее вещание"},
{12,18,"дневное вещание"},
{18,24,"вечернее вещание"},
}
m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*ChProg*/')
for i = 1,14 do
	local start_time = tonumber(start_EPG) + (i - 1)*24*60*60
	for j = 1,4 do
		local StartPr = tonumber(start_time) + tonumber(EPG[j][1])*60*60
		local EndPr = tonumber(start_time) + tonumber(EPG[j][2])*60*60
		StartPr = os.date('%Y-%m-%d %X', StartPr)
		EndPr = os.date('%Y-%m-%d %X', EndPr)
		local Title = EPG[j][3]
		m_simpleTV.Database.ExecuteSql('INSERT  INTO ChProg (IdChannel, StartPr, EndPr, Title, Desc, HaveDesc, Category, IconUrl) VALUES ("WS_PortalTV","' .. StartPr .. '","' .. EndPr .. '","' .. Title .. '","","0","NOT EPG","");', true)
		j = j + 1
	end
	i = i + 1
end
m_simpleTV.Database.ExecuteSql('COMMIT;/*ChProg*/')
m_simpleTV.EPG.Refresh()
---------------------------
--]]

local function Get_title_pll()
	local title, i = 'PLL ', 1
	while true do
		local ch = m_simpleTV.Database.GetTable('SELECT Channels.Id FROM Channels WHERE Channels.Name="PLL ' .. i .. '" AND Channels.Id<268435455;')
		if ch and ch[1] and ch[1].Id then
			i = i + 1
		else
			return 'PLL ' .. i
		end
	end
end

local function findChannelIdByAddress(adr)
	if adr then
		local t = m_simpleTV.Database.GetTable('SELECT Channels.Id,Channels.Name FROM Channels WHERE Channels.Address="' .. adr .. '" AND Channels.Id<268435455;')
--		debug_in_file('SELECT Channels.Id,Channels.Name FROM Channels WHERE Channels.Address="' .. adr .. '" AND Channels.Id<268435455;'.. '\n' .. t[1].Id .. '\n','c://1/group.txt')
			if t and t[1] and t[1].Id and t[1].Name then return t[1].Id,t[1].Name end
	end
 return nil
end

local function xren(s) -- Nexterr Code +
	if not s then
		return ''
	end
	s = s:lower()
	s = s:gsub('*', '')
	s = s:gsub('%s+', ' ')
	s = s:gsub('^%s*(.-)%s*$', '%1')
	local a = {
			{'А', 'а'}, {'Б', 'б'}, {'В', 'в'}, {'Г', 'г'}, {'Д', 'д'}, {'Е', 'е'}, {'Ж', 'ж'}, {'З', 'з'},
			{'И', 'и'},	{'Й', 'й'}, {'К', 'к'}, {'Л', 'л'}, {'М', 'м'}, {'Н', 'н'}, {'О', 'о'}, {'П', 'п'},
			{'Р', 'р'}, {'С', 'с'},	{'Т', 'т'}, {'Ч', 'ч'}, {'Ш', 'ш'}, {'Щ', 'щ'}, {'Х', 'х'}, {'Э', 'э'},
			{'Ю', 'ю'}, {'Я', 'я'}, {'Ь', 'ь'},	{'Ъ', 'ъ'}, {'Ё', 'е'},	{'ё', 'е'}, {'Ф', 'ф'}, {'Ц', 'ц'},
			{'У', 'у'}, {'Ы', 'ы'}, -- russian
			{'A', 'a'}, {'B', 'b'}, {'C', 'c'}, {'D', 'd'}, {'E', 'e'}, {'F', 'f'}, {'G', 'g'}, {'H', 'h'},
			{'I', 'i'},	{'J', 'j'}, {'K', 'k'}, {'L', 'l'}, {'M', 'm'}, {'N', 'n'}, {'O', 'o'}, {'P', 'p'},
			{'Q', 'q'}, {'R', 'r'},	{'S', 's'}, {'T', 't'}, {'U', 'u'}, {'V', 'v'}, {'W', 'w'}, {'X', 'x'},
			{'Y', 'y'}, {'Z', 'z'},	-- english
			}
	for _, v in pairs(a) do
		s = s:gsub(v[1], v[2])
	end
	return s
end
--[[
local function GetEPG_Id(name)
	name = xren(name:gsub('%-','%-'):gsub('%+','%+'):gsub('%.','%.'))
	if not m_simpleTV.User.TVPortal.EPG then
		local epg = m_simpleTV.Database.GetTable('SELECT * FROM ChannelsEpg ORDER BY Id')
		if epg == nil or epg[1] == nil then
			return false, false
		end
		local t,j = {},1
		for i = 1,#epg do
			local all_names = xren(epg[i].ChName:gsub('%-','%-'):gsub('%+','%+'):gsub('%.','%.')) .. ';'
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
--]]
local function GetEPG_Id(name)

	local epg = m_simpleTV.Database.GetTable('SELECT * FROM ChannelsEpg WHERE ((ChannelsEpg.ChName LIKE "' .. name .. ';%" OR ChannelsEpg.ChName LIKE "%;' .. name .. ';%" OR ChannelsEpg.ChName LIKE "%;' .. name .. '" OR ChannelsEpg.ChName LIKE "' .. name .. '" ))')

	if epg == nil or epg[1] == nil then
		return false, false
	else
		return epg[1].Id,epg[1].Logo:gsub('https://picon%.pp%.ua/','https://epgx.site/p/')
	end

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
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.multiByteToUTF8(adr,1251)})
--	debug_in_file(rc .. ' ' .. m_simpleTV.Common.multiByteToUTF8(adr,1251) .. '\n' .. answer .. '\n')
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	if not answer or answer and not answer:match('%#EXTINF:') then return end
	return answer
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

function Show_Message()
	if m_simpleTV.User.TVPortal.UseMes and m_simpleTV.User.TVPortal.UseMes == 1 then
		m_simpleTV.User.TVPortal.UseMes = 0
		setConfigVal("Portal_TV_WS_mes_Enable",0)
		m_simpleTV.OSD.ShowMessage_UTF8('')
	else
		m_simpleTV.User.TVPortal.UseMes = 1
		setConfigVal("Portal_TV_WS_mes_Enable",1)
		m_simpleTV.OSD.ShowMessage_UTF8('Message "ON"')
	end
end

function Show_Next_Window()
	if m_simpleTV.User.TVPortal.UseWindow and m_simpleTV.User.TVPortal.UseWindow == 1 then
		m_simpleTV.User.TVPortal.UseWindow = 0
		setConfigVal("Portal_TV_WS_UseWindow",0)
		m_simpleTV.User.TVPortal.isPause = true
	else
		m_simpleTV.User.TVPortal.UseWindow = 1
		setConfigVal("Portal_TV_WS_UseWindow",1)
		m_simpleTV.User.TVPortal.isPause = true
	end
end

function GetChannel(answ)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	local url = getConfigVal('tvportal') or ''
	if m_simpleTV.User.TVPortal.Channel then return true end
	local rc, answer
	if answ then
		answer = answ
	else
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 60000)
		rc, answer = m_simpleTV.Http.Request(session, {url = m_simpleTV.Common.multiByteToUTF8(url,1251)})
		m_simpleTV.Http.Close(session)
		if rc ~= 200 then return false end
	end
	answer = answer:gsub('domen_name','http://domen_name'):gsub('torrent://INFOHASH','http://torrent://INFOHASH'):gsub('file:///','http://file:///') .. '\n' .. '\n'
	local fav_ch_str = getConfigVal("Portal_TV_FavCh") or ''
	local fav_gr_str = getConfigVal("Portal_TV_FavGr") or ''
	local is_in_fav_ch_str, is_in_fav_gr_str = 0, 0
	local t2, i = {}, 1
	for w in answer:gmatch('%#EXTINF:.-\nhttp.-\n') do
		local name = w:match('(%#EXTINF:.-)\n'):gsub('".-"',''):gsub('^.-%d+:',''):gsub('^.-%,','')
		local adr = w:match('\n(http.-)\n')
		local tv = name:gsub('\r',''):match(' e%d+$') or name:gsub('\r',''):match(' E%d+$')
		if tv then tv = 'Series: ' .. name:gsub(' e%d+',''):gsub(' E%d+',''):gsub(' s%d+',''):gsub(' S%d+','') end
		local movie = name:gsub('\r',''):match('%(%d%d%d%d%)$')
		if movie then movie = name:match('%(%d%d%d%d%)') end
		local grp = tv or w:match('%#EXTGRP:(.-)\n') or w:match('group%-title="(.-)"') or movie or name:match('(.-)|') or 'NEW'
		local logo = w:match('tvg%-logo="(.-)"')
		if not logo or logo == ' ' then
			logo = ''
		end
		local RawM3UString = w:match('#EXTINF:.-\n')
		local days = RawM3UString:match('tvg%-rec="(%d)') or RawM3UString:match('catchup%-days="(%d)') or RawM3UString:match('timeshift="(%d)')
		if days and tonumber(days) > 0 then
			if not RawM3UString:match('catchup=".-"') then
				RawM3UString = RawM3UString .. ' ' .. 'catchup="shift"'
			end
		end
		local is_fav_ch = 0
		local is_fav_gr = 0

--		if adr:match('spr24%.net') then
--			RawM3UString = 'catchup="append" catchup-days="10" catchup-source="?utc=${start}&lutc=${timestamp}"'
--		end
		if not adr or not name then break end
		if not name:match('^Плейлист от') and not name:match('https://t%.me') and not name:match('Много плейлистов') and not name:match('Мой телеграмм') then
			for w in fav_ch_str:gmatch('%,(.-)%,') do
				if name:match(w) then is_fav_ch = 1 is_in_fav_ch_str = 1 end
			end
			for w in fav_gr_str:gmatch('%,(.-)%,') do
				if grp:match(w) then is_fav_gr = 1 is_in_fav_gr_str = 1 end
			end
			t2[i] = {}
			t2[i].NameCh = name:gsub('^.-| ','')
			t2[i].AddressCh = adr:gsub('http://domen_name','domen_name'):gsub('http://torrent://INFOHASH','torrent://INFOHASH'):gsub('http://file:///','file:///')
			t2[i].GroupCh = grp:gsub('^%d%. ',''):gsub('^%d%d%. ','')
			t2[i].LogoCh = logo:gsub('\\','')
			t2[i].M3UCh = RawM3UString:gsub('duration', 'offset')
			if days and tonumber(days) > 0 then
				t2[i].StateCh = 2
			else
				t2[i].StateCh = 0
			end
			t2[i].fav_ch = is_fav_ch
			t2[i].fav_gr = is_fav_gr
--			debug_in_file(name:gsub('^.-| ','') .. ' ' .. is_fav_ch .. ' ' .. is_fav_gr .. '\n')
			i = i + 1
		end
	end
	if i == 1 then return false end
	table.sort(t2, function(a, b) return tostring(a.GroupCh) < tostring(b.GroupCh) end)
	m_simpleTV.User.TVPortal.Channel = t2
	m_simpleTV.User.TVPortal.in_fav_ch_str = is_in_fav_ch_str
	m_simpleTV.User.TVPortal.in_fav_gr_str = is_in_fav_gr_str
	return true
end

function start_group(grp, filter_type)
	filter_type = filter_type or m_simpleTV.User.TVPortal.Filter_type
	if not filter_type or filter_type and tonumber(filter_type) and (tonumber(filter_type) == 1 and tonumber(m_simpleTV.User.TVPortal.in_fav_ch_str) == 0 or tonumber(filter_type) == 2 and tonumber(m_simpleTV.User.TVPortal.in_fav_gr_str)==0) then filter_type = 0 end
	local t, i = {}, 1
	for j = 1, #m_simpleTV.User.TVPortal.Channel do
		if tonumber(filter_type) == 1 and tonumber(m_simpleTV.User.TVPortal.Channel[j].fav_ch) == 1 or
		tonumber(filter_type) == 2 and tonumber(m_simpleTV.User.TVPortal.Channel[j].fav_gr) == 1 or
		tonumber(filter_type) == 0 then
		if m_simpleTV.User.TVPortal.Channel[j].GroupCh == grp and grp~='🆒 All' or grp == '🆒 All' then
			local flag
			if m_simpleTV.User.TVPortal.Channel[j].M3UCh then
				flag = m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('catchup%-days="(%d+)') or m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('tvg%-rec="(%d+)') or m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('timeshift="(%d+)')
				if flag and tonumber(flag) > 0 then flag = ' ' .. '⟲' .. ' ' .. flag .. 'd' else flag = '' end
			end
			t[i] = {}
			t[i].Name = m_simpleTV.User.TVPortal.Channel[j].NameCh .. (flag or '')
			t[i].Address1 = m_simpleTV.User.TVPortal.Channel[j].AddressCh
--			t[i].InfoPanelName = m_simpleTV.User.TVPortal.Channel[j].NameCh:gsub('^.-: ',''):gsub('^.-: ','')
			t[i].Logo = m_simpleTV.User.TVPortal.Channel[j].LogoCh
			t[i].RawM3UString = m_simpleTV.User.TVPortal.Channel[j].M3UCh:gsub("'",'´')
			t[i].State = m_simpleTV.User.TVPortal.Channel[j].StateCh
			i = i + 1
		end
		end
		j = j + 1
	end
	table.sort(t, function(a, b) return a.Name:gsub(' (%d)$',' 0%1'):gsub(' (%d) ',' 0%1 ') < b.Name:gsub(' (%d)$',' 0%1'):gsub(' (%d) ',' 0%1 ')end)
	for i = 1,#t do
		t[i].Id = i
		t[i].Address = 'portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. i
		i = i + 1
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

	local t = {}
	t[1] = {}
	t[1].Id = 1
	t[1].Name = 'Добавить из буфера'

	if run_westSide_portal then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
	end

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: update',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			local url = m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard())
			local check = QueryToUse(url)
			if not check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			m_simpleTV.User.TVPortal.Address_PortalTV_1 = url
			m_simpleTV.User.TVPortal.Name_PortalTV_1 = m_simpleTV.Common.UTF8ToMultiByte('Слот 1')
			m_simpleTV.User.TVPortal.Use_PortalTV_1 = 1
			setConfigVal("PortalTV_1_Enable",1)
			setConfigVal("PortalTV_1_Name",m_simpleTV.User.TVPortal.Name_PortalTV_1)
			setConfigVal("PortalTV_1_Address",m_simpleTV.User.TVPortal.Address_PortalTV_1)
			setConfigVal('tvportal',url)
			start_tv(check)
		end
		if ret == 2 then
			run_westSide_portal()
		end
end

function get_group_with_filter()
	local filter_type = m_simpleTV.User.TVPortal.Filter_type or 0
	local current_id_filter = 1
	local t, i = {}, 1
	t[i] = {}
	t[i].Id = i
	t[i].Name = 'All channels and groups'
	t[i].Action = 0
	if tonumber(filter_type) == tonumber(t[i].Action) then
		current_id_filter = t[i].Id
	end
	i = i + 1
	if m_simpleTV.User.TVPortal.in_fav_ch_str == 1 then
		t[i] = {}
		t[i].Id = i
		t[i].Name = 'Favorite channels'
		t[i].Action = 1
		if tonumber(filter_type) == tonumber(t[i].Action) then
			current_id_filter = t[i].Id
		end
		i = i + 1
	end
	if m_simpleTV.User.TVPortal.in_fav_gr_str == 1 then
		t[i] = {}
		t[i].Id = i
		t[i].Name = 'Favorite groups'
		t[i].Action = 2
		if tonumber(filter_type) == tonumber(t[i].Action) then
			current_id_filter = t[i].Id
		end
		i = i + 1
	end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' TVPortal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: Filters' ,tonumber(current_id_filter) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.TVPortal.Group_id = nil
			m_simpleTV.User.TVPortal.Filter_type = t[id].Action
			m_simpleTV.Config.SetValue("tvportal_filters",t[id].Action,"PortalTV.ini")
			return start_tv(false, true, t[id].Action)
		end
		if ret == 2 then
			return start_tv()
		end
		if ret == 3 then
			return SelectTVPortal()
		end
end

function start_tv(answ, play, filter_type)

	filter_type = filter_type or m_simpleTV.User.TVPortal.Filter_type
--	debug_in_file((filter_type and m_simpleTV.User.TVPortal.in_fav_gr_str or 'NOT') .. '\n----\n')
	if not filter_type or filter_type and tonumber(filter_type) and (tonumber(filter_type) == 1 and tonumber(m_simpleTV.User.TVPortal.in_fav_ch_str) == 0 or tonumber(filter_type) == 2 and tonumber(m_simpleTV.User.TVPortal.in_fav_gr_str)==0) then filter_type = 0 end
--	debug_in_file(filter_type .. '\n----\n')
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end

	if not m_simpleTV.User.TVPortal.Channel then
		local url = getConfigVal('tvportal') or ''
		local is_tvportal = GetChannel(answ)
		if not is_tvportal then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			return SelectTVPortal()
		end
	end
	local j = 0
	local hash, t = {}, {}
	for i = 1,#m_simpleTV.User.TVPortal.Channel do
		if tonumber(filter_type) == 1 and tonumber(m_simpleTV.User.TVPortal.Channel[i].fav_ch) == 1 or
		tonumber(filter_type) == 2 and tonumber(m_simpleTV.User.TVPortal.Channel[i].fav_gr) == 1 or
		tonumber(filter_type) == 0 then
			j = j + 1
			if not hash[m_simpleTV.User.TVPortal.Channel[i].GroupCh]
			then
				t[#t + 1] = m_simpleTV.User.TVPortal.Channel[i]
				hash[m_simpleTV.User.TVPortal.Channel[i].GroupCh] = true
			end
		end
	end
	local k	= 1
	for i = 1, #t do
		t[k].Id = i
		t[k].Name = t[i].GroupCh
		k=k+1
	end
		t[k] = {}
		t[k].Id = k
		t[k].Name = '🆒 All'
	if play and m_simpleTV.User.TVPortal.Group_id then
		m_simpleTV.User.TVPortal.Group_name = t[m_simpleTV.User.TVPortal.Group_id].Name
		m_simpleTV.User.TVPortal.Channel_Of_Group = start_group(t[m_simpleTV.User.TVPortal.Group_id].Name, filter_type)
		return
	end
	local current_id_group = m_simpleTV.User.TVPortal.Group_id or 1
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' TVPortal '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Filters '}
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: ' .. #t .. ' gr. (' .. j .. ' ch.)' ,tonumber(current_id_group) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.TVPortal.Group_id = id
			m_simpleTV.User.TVPortal.Group_name = t[id].Name
			m_simpleTV.User.TVPortal.Channel_Of_Group = start_group(t[id].Name, filter_type)
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
			local Filter_ID = is_portal[1].Id
			local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[1].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub("'",'´'):gsub(' ⟲.-$',''):gsub('^ ',''))
			if epg_id == false then epg_id = "simpleTVFakeEpgId" end
			local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[1].Logo
			if epg_logo and m_simpleTV.User.TVPortal.Channel_Of_Group[1].Logo == '' then
				logo = epg_logo
			end
			if logo == '' or logo == nil then
				logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
			end
			m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[1].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub("'",'´'):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$','') .. '","portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. 1 .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. '' .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. logo .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[1].State .. ');') then
				m_simpleTV.PlayList.Refresh()
			end
			m_simpleTV.PlayList.VerifyItem(m_simpleTV.User.TVPortal.Id, false)
			m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			m_simpleTV.Control.SetPosition(0.0)
			m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. m_simpleTV.User.TVPortal.Id})
		end
		if ret == 2 then
			SelectTVPortal()
		end
		if ret == 3 then
			get_group_with_filter()
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

		t[i] = {}
		t[i].Id = i
		t[i].Name = 'Локальный плейлист'
		t[i].Action = ''
		if current_adr == t[i].Action then current_id = i end
		i = i + 1

	local playlists = m_simpleTV.Database.GetTable("SELECT * FROM ExtFilter WHERE Name <> 'PortalTV' AND Name <> 'FAV TV' AND Name <> 'FAV Media' AND Name <> 'PortalPLL' AND Name <> 'StalkerPLL';")
	if get_all_playlists and playlists and playlists[1] then
		t[i] = {}
		t[i].Id = i
		t[i].Name = 'Плейлисты'
		t[i].Action = ''
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end

	local playlists = m_simpleTV.Database.GetTable("SELECT * FROM ExtFilter WHERE Name == 'PortalPLL' ;")
	if get_all_playlists and playlists and playlists[1] then
		t[i] = {}
		t[i].Id = i
		t[i].Name = 'PortalPLL'
		t[i].Action = playlists[1].Id
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end

	local playlists = m_simpleTV.Database.GetTable("SELECT * FROM ExtFilter WHERE Name  == 'StalkerPLL';")
	if get_all_playlists and playlists and playlists[1] then
		t[i] = {}
		t[i].Id = i
		t[i].Name = 'StalkerPLL'
		t[i].Action = playlists[1].Id
		if current_adr == t[i].Action then current_id = i end
		i = i + 1
	end
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
	if search_all then
		t[i] = {}
		t[i].Id = i
		t[i].Name = 'ПОИСК'
		t[i].Action = ''
	end
	if #t == 0 or search_all and #t == 1 then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Названия и адреса плейлистов вносятся в настройках аддона.\n Есть возможность добавления нового плейлиста из буфера обмена.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return start_tv_new()
	end
	m_simpleTV.User.TVPortal.Use_PortalTV = t
	if run_westSide_portal then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
	end
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' From Buffer '}
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: select playlist' ,tonumber(current_id) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if search_all and t[id].Name == 'ПОИСК' then
				return search_all()
			end
			if t[id].Name == 'Локальный плейлист' then
			local param = {}
			param.name = 'Файл плейлиста' -- title, string  (optional)
			param.startFolder = 'c://'-- string   (optional)
			param.filters = '*.m3u; *.m3u8' -- string   (optional)
--			param.selectFile = -- string   (optional)
--			param.options =    -- int or string (optional) https://doc.qt.io/qt-5/qfiledialog.html#Option-enum
			param.fileMode = 1 -- int or string (optional) https://doc.qt.io/qt-5/qfiledialog.html#FileMode-enum
			param.acceptMode = 0 -- int or string (optional) https://doc.qt.io/qt-5/qfiledialog.html#AcceptMode-enum
			local picker = m_simpleTV.Interface.FilePicker(param)
--			debug_in_file(picker or 'NOT' .. '\n','c://1/picker.txt')
			if picker == nil then return SelectTVPortal() end
			local check = QueryToUse(m_simpleTV.Common.UTF8ToMultiByte('file:///' .. picker))
			if not check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			local check1 = QueryToIs(m_simpleTV.Common.UTF8ToMultiByte('file:///' .. picker))
			if check1 then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Плейлист уже присутствует в TV портале', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			setConfigVal('tvportal',m_simpleTV.Common.UTF8ToMultiByte('file:///' .. picker))
			m_simpleTV.User.TVPortal.Channel = nil
			m_simpleTV.User.TVPortal.Group_id = nil

			local adr = 'portalTV_playlist=' .. m_simpleTV.Common.UTF8ToMultiByte('file:///' .. picker)
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalPLL";')
			local extFilter = is_portal[1].Id
			local channelId,channelName = findChannelIdByAddress(adr)
			if channelId then
				m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = channelName
				m_simpleTV.OSD.ShowMessageT({text = 'Плейлист есть в базе', color = ARGB(255, 155, 155, 255)})
			else
				local t = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
				if not t or not t[1] or not t[1].NewId then return start_tv() end
				channelId = t[1].NewId
				local title = Get_title_pll()
				if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Logo],[Address],[ExtFilter],[TypeMedia]) VALUES (' .. channelId .. ',' .. channelId .. ',"' .. title .. '","' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Unknown.png' .. '","' .. m_simpleTV.Common.multiByteToUTF8(adr,1251) .. '",' .. extFilter ..',' .. 2 .. ');') then
					m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = title
					m_simpleTV.PlayList.Refresh()
					m_simpleTV.OSD.ShowMessageT({text = 'Плейлист добавлен', color = ARGB(255, 155, 155, 255)})
				end
			end

			return start_tv(check)
			end
			if t[id].Name == 'Плейлисты' then
				return get_all_playlists()
			end
			if t[id].Name == 'PortalPLL' or t[id].Name == 'StalkerPLL' then
				return select_playlist_PLL(t[id].Action, t[id].Name)
			end
			m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = t[id].Name
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
			if not check then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			local check1 = QueryToIs(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if check1 then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Плейлист уже присутствует в TV портале', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			local check2 = QueryToAdd(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			if not check2 then
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Все слоты TV портала заняты.\n Освободите слот TV портала в\n диалоговом окне настроек аддона', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				return SelectTVPortal()
			end
			setConfigVal('tvportal',m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
			m_simpleTV.User.TVPortal.Channel = nil
			m_simpleTV.User.TVPortal.Group_id = nil
			return start_tv(check)
		end
end

function add_to_portal_playlist()
	local check = QueryToUse(m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
	if not check then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return SelectTVPortal()
	end
	setConfigVal('tvportal',m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Interface.CopyFromClipboard()))
	m_simpleTV.User.TVPortal.Channel = nil
	m_simpleTV.User.TVPortal.Group_id = nil
	local adr = 'portalTV_playlist=' .. m_simpleTV.Interface.CopyFromClipboard()
	local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalPLL";')
	local extFilter = is_portal[1].Id
	local channelId,channelName = findChannelIdByAddress(adr)
	if channelId then
		m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = channelName
		m_simpleTV.OSD.ShowMessageT({text = 'Плейлист есть в базе', color = ARGB(255, 155, 155, 255)})
	else
		local t = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
		if not t or not t[1] or not t[1].NewId then return start_tv() end
		channelId = t[1].NewId
		local title = Get_title_pll()
		if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Logo],[Address],[ExtFilter],[TypeMedia]) VALUES (' .. channelId .. ',' .. channelId .. ',"' .. title .. '","' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Unknown.png' .. '","' .. adr .. '",' .. extFilter ..',' .. 2 .. ');') then
			m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = title
			m_simpleTV.PlayList.Refresh()
			m_simpleTV.OSD.ShowMessageT({text = 'Плейлист добавлен', color = ARGB(255, 155, 155, 255)})
		end
	end
	return start_tv(check)
end
---------------------------------------------------------------------------------------block search
function start_search()

	local t, i = {}, 1
	local search_ini = m_simpleTV.Config.GetValue('search/media',"LiteConf.ini") or ''
	local current_id = getConfigVal('tvportal_search_id') or 1
	m_simpleTV.User.TVPortal.Group_id = current_id
	search_ini = m_simpleTV.Common.fromPercentEncoding(search_ini)
	for j = 1, #m_simpleTV.User.TVPortal.Channel do
		if xren(m_simpleTV.User.TVPortal.Channel[j].NameCh):match(xren(search_ini)) then
			local flag
			if m_simpleTV.User.TVPortal.Channel[j].M3UCh then
				flag = m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('catchup%-days="(%d+)') or m_simpleTV.User.TVPortal.Channel[j].M3UCh:match('tvg%-rec="(%d+)')
				if flag and tonumber(flag) > 0 then flag = ' ' .. '⟲' .. ' ' .. flag .. 'd' else flag = '' end
			end
			t[i] = {}
			t[i].Name = m_simpleTV.User.TVPortal.Channel[j].NameCh .. (flag or '')
			t[i].Address1 = m_simpleTV.User.TVPortal.Channel[j].AddressCh
--			if m_simpleTV.User.TVPortal.Channel[j].LogoCh ~= '' then
--			t[i].InfoPanelName = m_simpleTV.User.TVPortal.Channel[j].NameCh:gsub('^.-: ',''):gsub('^.-: ','')
--			t[i].InfoPanelLogo = m_simpleTV.User.TVPortal.Channel[j].LogoCh
--			end
			t[i].Logo = m_simpleTV.User.TVPortal.Channel[j].LogoCh
			t[i].RawM3UString = m_simpleTV.User.TVPortal.Channel[j].M3UCh
			t[i].State = m_simpleTV.User.TVPortal.Channel[j].StateCh
			i = i + 1
		end
		j = j + 1
	end
	table.sort(t, function(a, b) return tostring(a.Name) < tostring(b.Name) end)
	for i = 1,#t do
		t[i].Id = i
		t[i].Address = 'portalTV_search=' .. current_id .. '&channel=' .. i
		i = i + 1
	end
	return t
end

function start_tv_search()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end
	local search_ini = m_simpleTV.Config.GetValue('search/media',"LiteConf.ini") or ''
	search_ini = m_simpleTV.Common.fromPercentEncoding(search_ini)
	local name_slot = getConfigVal('tvportal_search_name')
	local is_tvportal = GetChannel()
	if not is_tvportal then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.MainScriptDir .. 'user/portaltvWS/img/portaltv.png"', text = ' Невозможно загрузить плейлист\n (возможно нужен ВПН)\n или это не файл плейлиста.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return SelectTVPortal_search()
	end
	local t = start_search()
	if #t == 0 then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'TVPortal: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		return SelectTVPortal_search()
	end
	local current_id_group = m_simpleTV.User.TVPortal.Group_id or 1
	local current_id_channel = m_simpleTV.User.TVPortal.Channel_id or 1
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Search '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' TVPortal '}
	m_simpleTV.User.TVPortal.Group_name = 'Search: ' .. search_ini .. ' (from ' .. name_slot .. ')'
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.TVPortal.Group_name .. ' - ' .. #t .. 'ch.' ,tonumber(current_id_channel)-1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.TVPortal.Channel_id = id
			m_simpleTV.User.TVPortal.Channel_Of_Group = start_search()
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
			local Filter_ID = is_portal[1].Id
			local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[1].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub('^ ',''))
			if epg_id == false then epg_id = "simpleTVFakeEpgId" end
			local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[1].Logo
			if epg_logo and m_simpleTV.User.TVPortal.Channel_Of_Group[1].Logo == '' then
				logo = epg_logo
			end
			m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$','') .. '","portalTV_search=' .. current_id_group .. '&channel=' .. id .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. '' .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. logo .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[1].State .. ');') then
				m_simpleTV.PlayList.Refresh()
			end
			m_simpleTV.PlayList.VerifyItem(m_simpleTV.User.TVPortal.Id, false)
			m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			m_simpleTV.Control.SetPosition(0.0)
			m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. m_simpleTV.User.TVPortal.Id})
		end
		if ret == 2 then
			SelectTVPortal_search()
		end
		if ret == 3 then
			SelectTVPortal()
		end
end

function SelectTVPortal_search()

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

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' TVPortal '}
	if run_westSide_portal then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	end
	local search_ini = m_simpleTV.Config.GetValue('search/media',"LiteConf.ini") or ''
	search_ini = m_simpleTV.Common.fromPercentEncoding(search_ini)
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Поиск: ' .. search_ini .. ' (TVPortal playlists)' ,tonumber(current_id) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if id ~= current_id then
				m_simpleTV.User.TVPortal.Channel = nil
				m_simpleTV.User.TVPortal.Group_id = nil
				m_simpleTV.User.TVPortal.Channel_id = nil
			end
			setConfigVal('tvportal',t[id].Action)
			setConfigVal('tvportal_search_id',id)
			setConfigVal('tvportal_search_name',t[id].Name)
			start_tv_search()
		end
		if ret == 3 then
			run_westSide_portal()
		end
		if ret == 2 then
			SelectTVPortal()
		end
end

function add_stalker()
	local playlists = m_simpleTV.Database.GetTable("SELECT * FROM ExtFilter WHERE Name == 'StalkerPLL';")
	if not playlists or not playlists[1] or not playlists[1].Id then return end
	local t = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
	if not t or not t[1] or not t[1].NewId then return start_tv() end
	local channelId = t[1].NewId
	local name = 'Name'
	local adr = 'portalTV_stalker_playlist=Address'
	local logo = ''
	if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Logo],[Address],[ExtFilter],[TypeMedia],[Desc],[Title]) VALUES (' .. channelId .. ',' .. channelId .. ',"' .. name .. '","' .. logo .. '","' .. adr .. '",' .. playlists[1].Id ..',' .. 2 .. ',"[]","' .. adr .. '");') then
		m_simpleTV.PlayList.Refresh()
		m_simpleTV.PlayList.VerifyItem(channelId, false)
		m_simpleTV.PlayList.SetFocusItem(channelId, m_simpleTV.Interface.GetFullScreenMode())
	end
end

----------------------------------------------------------------------------------------------------
	local t2={}
	t2.utf8 = true
	t2.name = 'TVPortal меню'
	t2.luastring = 'SelectTVPortal()'
	t2.lua_as_scr = true
	t2.submenu = 'TVPortal WS'
    t2.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'
	t2.key = string.byte('I')
	t2.ctrlkey = 4
	t2.location = 0
	t2.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/MediaPortal_Logo.png'
	m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
	m_simpleTV.Interface.AddExtMenuT(t2)
	m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
----------------------------------------------------------------------------------------------------
	local t = {}
    t.utf8 = true -- string coding
    t.name = "Play in PortalTV"
    t.lua_as_scr = false
    t.luastring = 'user/westSidePortal/startup/stena_logo.lua'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t.location = 'LOCATION_EXTFILTER_MENU'
    t.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/tv_portal.png'
    m_simpleTV.Interface.AddExtMenuT(t)

	local t1 = {}
    t1.utf8 = true -- string coding
    t1.name = "Play in PortalTV"
    t1.lua_as_scr = true
    t1.luastring = 'select_stena_logo_for_selected()'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t1.location = 'LOCATION_PLAYLIST_MENU'
    t1.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/tv_portal.png'
    m_simpleTV.Interface.AddExtMenuT(t1)

	local t4 = {}
    t4.utf8 = true -- string coding
    t4.name = "Play in PortalTV"
    t4.lua_as_scr = true
    t4.luastring = 'add_to_portal_playlist()'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t4.location = 'LOCATION_MAIN_MENU'
    t4.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/tv_portal.png'
    m_simpleTV.Interface.AddExtMenuT(t4)

	local t3 = {}
    t3.utf8 = true -- string coding
    t3.name = "Play selected in PortalTV"
    t3.lua_as_scr = false
    t3.luastring = 'user/westSidePortal/startup/stena_logo_test_EXT.lua'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t3.location = 'LOCATION_EXTFILTER_MENU'
    t3.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/tv_portal.png'
    m_simpleTV.Interface.AddExtMenuT(t3)

	local t5 = {}
    t5.utf8 = true -- string coding
    t5.name = "Add Stalker"
    t5.lua_as_scr = true
    t5.luastring = 'add_stalker()'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t5.location = 'LOCATION_PLAYLIST_MENU'
    t5.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menu/tv_portal.png'
    m_simpleTV.Interface.AddExtMenuT(t5)